unit PropertiesFile.Mapping;

interface

uses

  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.Generics.Collections,
  PropertiesFile,
  PropertiesFile.Storage;

type

  PropertiesFileAttribute = class(TCustomAttribute)
  private
    fFileName: string;
    fPrefix: string;
  protected
    { protected declarations }
  public
    constructor Create(fileName: string; prefix: string = '');

    property FileName: string read fFileName;
    property Prefix: string read fPrefix;
  end;

  PropertyItemAttribute = class(TCustomAttribute)
  private
    fName: string;
  protected
    { protected declarations }
  public
    constructor Create(name: string);

    property Name: string read fName;
  end;

  NotNullAttribute = class(TCustomAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  IgnoreAttribute = class(TCustomAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  ReadOnlyAttribute = class(TCustomAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TPropertiesFileObject = class abstract
  private
    [Ignore]
    fPropertiesFile: IPropertiesFile;
    [Ignore]
    fRttiContext: TRttiContext;
    [Ignore]
    fRttiType: TRttiType;
    [Ignore]
    fFields: TDictionary<string, TRttiField>;
    [Ignore]
    fFileName: string;
    [Ignore]
    fPrefix: string;
    function GetFieldName(field: TRttiField): string;
    function IsEquals(leftValue, RightValue: string): Boolean;
    function IsEmpty(value: string): Boolean;
    function IsReadOnly: Boolean; overload;
    function IsReadOnly(field: TRttiField): Boolean; overload;
    function IsIgnoreField(field: TRttiField): Boolean;
    function IsNotNullField(field: TRttiField): Boolean;
    procedure LoadFromFile;
    procedure SaveToFile;
    procedure Configure;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure Refresh;
    procedure Save;
  end;

implementation

{ PropertiesFileAttribute }

constructor PropertiesFileAttribute.Create(fileName: string; prefix: string);
begin
  inherited Create;
  fFileName := fileName;
  fPrefix := prefix;
end;

{ PropertyItemAttribute }

constructor PropertyItemAttribute.Create(name: string);
begin
  inherited Create;
  fName := name;
end;

{ TPropertiesFileObject }

procedure TPropertiesFileObject.AfterConstruction;
begin
  inherited AfterConstruction;
  fPropertiesFile := TPropertiesFileStorage.Create;
  fRttiContext := TRttiContext.Create;
  fRttiType := fRttiContext.GetType(Self.ClassType);
  fFields := TDictionary<string, TRttiField>.Create;
  fFileName := '';
  fPrefix := '';
  Configure;
  LoadFromFile;
end;

procedure TPropertiesFileObject.BeforeDestruction;
begin
  SaveToFile;
  fFields.Free;
  fRttiContext.Free;
  inherited BeforeDestruction;
end;

procedure TPropertiesFileObject.Configure;
var
  attr: TCustomAttribute;
begin
  for attr in fRttiType.GetAttributes do
    if attr is PropertiesFileAttribute then
    begin
      fFileName := PropertiesFileAttribute(attr).FileName;
      fPrefix := PropertiesFileAttribute(attr).Prefix;
      Break;
    end;
end;

function TPropertiesFileObject.GetFieldName(field: TRttiField): string;
var
  attr: TCustomAttribute;
begin
  Result := '';
  for attr in field.GetAttributes do
    if (attr is PropertyItemAttribute) then
    begin
      if not IsEmpty(PropertyItemAttribute(attr).Name) then
        if IsEmpty(fPrefix) then
          Result := PropertyItemAttribute(attr).Name
        else
          Result := fPrefix + '.' + PropertyItemAttribute(attr).Name;
      Break;
    end;
  if IsEmpty(Result) then
    if IsEmpty(fPrefix) then
      Result := field.Name
    else
      Result := fPrefix + '.' + field.Name;
end;

function TPropertiesFileObject.IsEmpty(value: string): Boolean;
begin
  Result := (Trim(value) = '');
end;

function TPropertiesFileObject.IsEquals(leftValue, RightValue: string): Boolean;
begin
  Result := Trim(leftValue) = Trim(RightValue);
end;

function TPropertiesFileObject.IsIgnoreField(field: TRttiField): Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in field.GetAttributes do
    if (attr is IgnoreAttribute) then
      Exit(True);
end;

function TPropertiesFileObject.IsNotNullField(field: TRttiField): Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in field.GetAttributes do
    if (attr is NotNullAttribute) then
      Exit(True);
end;

function TPropertiesFileObject.IsReadOnly(field: TRttiField): Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in field.GetAttributes do
    if (attr is ReadOnlyAttribute) then
      Exit(True);
end;

function TPropertiesFileObject.IsReadOnly: Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in fRttiType.GetAttributes do
    if attr is ReadOnlyAttribute then
      Exit(True);
end;

procedure TPropertiesFileObject.LoadFromFile;
var
  field: TRttiField;
  fieldName: string;
  enumValue: TValue;
begin
  if IsEmpty(fFileName) then
    raise EPropertiesFileException.CreateFmt('File name of %s not defined!', [Self.ClassName]);

  if FileExists(fFileName) then
    fPropertiesFile.LoadFromFile(fFileName);

  for field in fRttiType.GetFields do
    if not IsIgnoreField(field) then
    begin
      fieldName := GetFieldName(field);

      if IsNotNullField(field) then
        if IsEmpty(fPropertiesFile.PropertyItem[fieldName]) then
          raise EPropertyItemIsNullException.CreateFmt('Property %s is null on %s!', [fieldName, Self.ClassName]);

      case field.FieldType.TypeKind of
        tkUnknown, tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          begin
            if not IsEmpty(fPropertiesFile.PropertyItem[fieldName]) then
              field.SetValue(Self, fPropertiesFile.PropertyItem[fieldName]);
            fFields.AddOrSetValue(fieldName, field);
          end;
        tkInteger, tkInt64:
          begin
            if not IsEmpty(fPropertiesFile.PropertyItem[fieldName]) then
              field.SetValue(Self, StrToIntDef(fPropertiesFile.PropertyItem[fieldName], 0));
            fFields.AddOrSetValue(fieldName, field);
          end;
        tkFloat:
          begin
            if not IsEmpty(fPropertiesFile.PropertyItem[fieldName]) then
              if IsEquals(field.FieldType.Name, 'TDate') then
                field.SetValue(Self, StrToDate(fPropertiesFile.PropertyItem[fieldName]))
              else if IsEquals(field.FieldType.Name, 'TDateTime') then
                field.SetValue(Self, StrToDateTime(fPropertiesFile.PropertyItem[fieldName]))
              else
                field.SetValue(Self, StrToFloatDef(fPropertiesFile.PropertyItem[fieldName], 0));
            fFields.AddOrSetValue(fieldName, field);
          end;
        tkEnumeration:
          begin
            if not IsEmpty(fPropertiesFile.PropertyItem[fieldName]) then
              if IsEquals(field.FieldType.Name, 'Boolean') then
                field.SetValue(Self, StrToBoolDef(fPropertiesFile.PropertyItem[fieldName], False))
              else
              begin
                enumValue := TValue.FromOrdinal(field.GetValue(Self).TypeInfo, GetEnumValue(field.GetValue(Self).TypeInfo, fPropertiesFile.PropertyItem[fieldName]));
                field.SetValue(Self, enumValue);
              end;
            fFields.AddOrSetValue(fieldName, field);
          end;
      end;
    end;
end;

procedure TPropertiesFileObject.Refresh;
begin
  LoadFromFile;
end;

procedure TPropertiesFileObject.Save;
begin
  if IsReadOnly then
    raise EPropertyItemIsNullException.CreateFmt('The class properties %s are read-only impossible to save!', [Self.ClassName]);
  SaveToFile;
end;

procedure TPropertiesFileObject.SaveToFile;
var
  field: TPair<string, TRttiField>;
begin
  if not IsReadOnly then
  begin
    for field in fFields do
      if not IsReadOnly(field.Value) then
        fPropertiesFile.PropertyItem[field.Key] := field.Value.GetValue(Self).ToString;
    fPropertiesFile.SaveToFile(fFileName);
  end;
end;

end.
