unit PropertiesFile4D.Mapping;

interface

{$INCLUDE PropertiesFile4D.inc}

uses

  {$IFDEF USE_SYSTEM_NAMESPACE}

  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.Generics.Collections,

  {$ELSE USE_SYSTEM_NAMESPACE}

  Classes,
  SysUtils,
  Rtti,
  TypInfo,
  Generics.Collections,

  {$ENDIF USE_SYSTEM_NAMESPACE}

  PropertiesFile4D,
  PropertiesFile4D.Impl;

type

  PropertiesFileAttribute = class(TCustomAttribute)
  private
    fFileName: string;
    fPrefix: string;
  protected
    { protected declarations }
  public
    constructor Create(const fileName: string; const prefix: string = '');

    property FileName: string read fFileName;
    property Prefix: string read fPrefix;
  end;

  PropertyItemAttribute = class(TCustomAttribute)
  private
    fName: string;
  protected
    { protected declarations }
  public
    constructor Create(const name: string);

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

  TMappedPropertiesFile = class
  private
    [Ignore]
    fPropFile: IPropertiesFile;
    [Ignore]
    fRttiCtx: TRttiContext;
    [Ignore]
    fRttiType: TRttiType;
    [Ignore]
    fFieldList: TDictionary<string, TRttiField>;
    [Ignore]
    fFileName: string;
    [Ignore]
    fPrefix: string;
    procedure Load;
    procedure Unload;
    procedure ConfigureFileNameAndPrefix;
    function IsReadOnly: Boolean;
    function IsIgnoreField(field: TRttiField): Boolean;
    function IsNotNullField(field: TRttiField): Boolean;
    function GetFieldName(field: TRttiField): string;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure Reload;
    procedure Save;
  end;

implementation

function IsEmpty(const value: string): Boolean;
begin

  {$IFDEF USE_STRING_CLASS}

  Result := value.IsEmpty;

  {$ELSE USE_STRING_CLASS}

  Result := value = '';

  {$ENDIF USE_STRING_CLASS}

end;

function IsEquals(const leftValue, RightValue: string): Boolean;
begin

  {$IFDEF USE_STRING_CLASS}

  Result := leftValue.Equals(RightValue);

  {$ELSE USE_STRING_CLASS}

  Result := leftValue = RightValue;

  {$ENDIF USE_STRING_CLASS}

end;

{ PropertiesFileAttribute }

constructor PropertiesFileAttribute.Create(const fileName: string; const prefix: string = '');
begin
  inherited Create;
  fFileName := fileName;
  fPrefix := prefix;
end;

{ PropertyItemAttribute }

constructor PropertyItemAttribute.Create(const name: string);
begin
  inherited Create;
  fName := name;
end;

{ TMappedPropertiesFile }

procedure TMappedPropertiesFile.AfterConstruction;
begin
  inherited AfterConstruction;
  fPropFile := TPropertiesFile.New;
  fRttiCtx := TRttiContext.Create;
  fRttiType := fRttiCtx.GetType(Self.ClassType);
  fFieldList := TDictionary<string, TRttiField>.Create;
  fFileName := EmptyStr;
  fPrefix := EmptyStr;
  Load;
end;

procedure TMappedPropertiesFile.BeforeDestruction;
begin
  Unload;
  fFieldList.Free;
  fRttiCtx.Free;
  inherited BeforeDestruction;
end;

function TMappedPropertiesFile.GetFieldName(field: TRttiField): string;
var
  attr: TCustomAttribute;
begin
  Result := EmptyStr;
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

function TMappedPropertiesFile.IsIgnoreField(field: TRttiField): Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in field.GetAttributes do
    if (attr is IgnoreAttribute) then
      Exit(True);
end;

function TMappedPropertiesFile.IsNotNullField(field: TRttiField): Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in field.GetAttributes do
    if (attr is NotNullAttribute) then
      Exit(True);
end;

function TMappedPropertiesFile.IsReadOnly: Boolean;
var
  attr: TCustomAttribute;
begin
  Result := False;
  for attr in fRttiType.GetAttributes do
    if attr is ReadOnlyAttribute then
      Exit(True);
end;

procedure TMappedPropertiesFile.Load;
var
  field: TRttiField;
  fieldName: string;
  enumValue: TValue;
begin
  ConfigureFileNameAndPrefix;

  if IsEmpty(fFileName) then
    raise EPropertiesFileException.Create('FileName of ' + Self.ClassName + ' not defined!');

  if FileExists(fFileName) then
    fPropFile.LoadFromFile(fFileName);

  for field in fRttiType.GetFields do
    if not IsIgnoreField(field) then
    begin
      fieldName := GetFieldName(field);

      if IsReadOnly and IsNotNullField(field) then
        if IsEmpty(fPropFile.PropertyItem[fieldName]) then
          raise EPropertyItemIsNullException.Create('Property Item ' + fieldName + ' is null!');

      case field.FieldType.TypeKind of
        tkUnknown, tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          begin
            if not IsEmpty(fPropFile.PropertyItem[fieldName]) then
              field.SetValue(Self, fPropFile.PropertyItem[fieldName]);
            fFieldList.AddOrSetValue(fieldName, field);
          end;
        tkInteger, tkInt64:
          begin
            if not IsEmpty(fPropFile.PropertyItem[fieldName]) then
              field.SetValue(Self, StrToIntDef(fPropFile.PropertyItem[fieldName], 0));
            fFieldList.AddOrSetValue(fieldName, field);
          end;
        tkFloat:
          begin
            if not IsEmpty(fPropFile.PropertyItem[fieldName]) then
              field.SetValue(Self, StrToFloatDef(fPropFile.PropertyItem[fieldName], 0));
            fFieldList.AddOrSetValue(fieldName, field);
          end;
        tkEnumeration:
          begin
            if not IsEmpty(fPropFile.PropertyItem[fieldName]) then
              if not IsEquals(field.FieldType.Name, 'Boolean') then
              begin
                enumValue := field.GetValue(Self);
                enumValue := TValue.FromOrdinal(enumValue.TypeInfo, GetEnumValue(enumValue.TypeInfo, fPropFile.PropertyItem[fieldName]));
                field.SetValue(Self, enumValue);
              end
              else
                field.SetValue(Self, StrToBoolDef(fPropFile.PropertyItem[fieldName], False));
            fFieldList.AddOrSetValue(fieldName, field);
          end;
      end;
    end;
end;

procedure TMappedPropertiesFile.Reload;
begin
  Load;
end;

procedure TMappedPropertiesFile.Save;
begin
  if IsReadOnly then
    raise EPropertyItemIsNullException.Create('The class properties are read-only impossible to save!');
  Unload;
end;

procedure TMappedPropertiesFile.ConfigureFileNameAndPrefix;
var
  attr: TCustomAttribute;
begin
  for attr in fRttiType.GetAttributes() do
    if attr is PropertiesFileAttribute then
    begin
      fFileName := ExtractFilePath(ParamStr(0)) + PropertiesFileAttribute(attr).FileName;
      fPrefix := PropertiesFileAttribute(attr).Prefix;
      Break;
    end;
end;

procedure TMappedPropertiesFile.Unload;
var
  field: TPair<string, TRttiField>;
begin
  if not IsReadOnly then
  begin
    for field in fFieldList do
      fPropFile.PropertyItem[field.Key] := field.Value.GetValue(Self).ToString;
    fPropFile.SaveToFile(fFileName);
  end;
end;

end.
