unit PropertiesFile4D.Mapping;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.Generics.Collections,
  PropertiesFile4D;

type

  PropertiesFileAttribute = class(TCustomAttribute)
  strict private
    FFileName: string;
    FPrefix: string;
  public
    constructor Create(const pFileName: string; const pPrefix: string = '');

    property FileName: string read FFileName;
    property Prefix: string read FPrefix;
  end;

  PropertyItemAttribute = class(TCustomAttribute)
  strict private
    FName: string;
  public
    constructor Create(const pName: string);

    property Name: string read FName;
  end;

  NotNullAttribute = class(TCustomAttribute)

  end;

  IgnoreAttribute = class(TCustomAttribute)

  end;

  ReadOnlyAttribute = class(TCustomAttribute)

  end;

  TMappedPropertiesFile = class
  strict private
    [Ignore]
    FPropFile: IPropertiesFile;
    [Ignore]
    FRttiCtx: TRttiContext;
    [Ignore]
    FRttiType: TRttiType;
    [Ignore]
    FFieldList: TDictionary<string, TRttiField>;
    [Ignore]
    FFileName: string;
    [Ignore]
    FPrefix: string;
    procedure Load();
    procedure Unload();
    procedure SetFileNameAndPrefix();
    function IsReadOnly(): Boolean;
    function IsIgnoreField(const pField: TRttiField): Boolean;
    function IsNotNullField(const pField: TRttiField): Boolean;
    function GetFieldName(const pField: TRttiField): string;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{ ConfigurationAttribute }

constructor PropertiesFileAttribute.Create(const pFileName: string; const pPrefix: string = '');
begin
  FFileName := pFileName;
  FPrefix := pPrefix;
end;

{ NameAttribute }

constructor PropertyItemAttribute.Create(const pName: string);
begin
  FName := pName;
end;

{ TMappedPropertiesFile }

procedure TMappedPropertiesFile.AfterConstruction;
begin
  inherited AfterConstruction;
  FPropFile := TPropertiesFileFactory.Build();
  FRttiCtx := TRttiContext.Create();
  FRttiType := FRttiCtx.GetType(Self.ClassType);
  FFieldList := TDictionary<string, TRttiField>.Create();
  FFileName := EmptyStr;
  FPrefix := EmptyStr;
  Load();
end;

procedure TMappedPropertiesFile.BeforeDestruction;
begin
  Unload();
  FreeAndNil(FFieldList);
  FRttiCtx.Free;
  inherited BeforeDestruction;
end;

function TMappedPropertiesFile.GetFieldName(const pField: TRttiField): string;
var
  vAttr: TCustomAttribute;
begin
  Result := EmptyStr;
  for vAttr in pField.GetAttributes() do
    if (vAttr is PropertyItemAttribute) then
    begin
      if not PropertyItemAttribute(vAttr).Name.IsEmpty then
        if FPrefix.IsEmpty then
          Result := PropertyItemAttribute(vAttr).Name
        else
          Result := FPrefix + '.' + PropertyItemAttribute(vAttr).Name;
      Break;
    end;
  if Result.IsEmpty then
    if FPrefix.IsEmpty then
      Result := pField.Name
    else
      Result := FPrefix + '.' + pField.Name;
end;

function TMappedPropertiesFile.IsIgnoreField(const pField: TRttiField): Boolean;
var
  vAttr: TCustomAttribute;
begin
  Result := False;
  for vAttr in pField.GetAttributes() do
    if (vAttr is IgnoreAttribute) then
      Exit(True);
end;

function TMappedPropertiesFile.IsNotNullField(const pField: TRttiField): Boolean;
var
  vAttr: TCustomAttribute;
begin
  Result := False;
  for vAttr in pField.GetAttributes() do
    if (vAttr is NotNullAttribute) then
      Exit(True);
end;

function TMappedPropertiesFile.IsReadOnly: Boolean;
var
  vAttr: TCustomAttribute;
begin
  Result := False;
  for vAttr in FRttiType.GetAttributes() do
    if vAttr is ReadOnlyAttribute then
      Exit(True);
end;

procedure TMappedPropertiesFile.Load;
var
  vField: TRttiField;
  vFieldName: string;
  vEnumValue: TValue;
begin
  SetFileNameAndPrefix();

  if FFileName.IsEmpty then
    raise EPropertiesFileException.Create('FileName of ' + Self.ClassName + ' not defined!');

  if FileExists(FFileName) then
    FPropFile.LoadFromFile(FFileName);

  for vField in FRttiType.GetFields do
    if not IsIgnoreField(vField) then
    begin
      vFieldName := GetFieldName(vField);

      if IsReadOnly() and IsNotNullField(vField) then
        if FPropFile.PropertyItem[vFieldName].IsEmpty then
          raise EPropertyItemIsNull.Create('Property Item ' + vFieldName + ' is null!');

      case vField.FieldType.TypeKind of
        tkUnknown, tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          begin
            if not FPropFile.PropertyItem[vFieldName].IsEmpty then
              vField.SetValue(Self, FPropFile.PropertyItem[vFieldName]);
            FFieldList.AddOrSetValue(vFieldName, vField);
          end;
        tkInteger, tkInt64:
          begin
            if not FPropFile.PropertyItem[vFieldName].IsEmpty then
              vField.SetValue(Self, StrToIntDef(FPropFile.PropertyItem[vFieldName], 0));
            FFieldList.AddOrSetValue(vFieldName, vField);
          end;
        tkFloat:
          begin
            if not FPropFile.PropertyItem[vFieldName].IsEmpty then
              vField.SetValue(Self, StrToFloatDef(FPropFile.PropertyItem[vFieldName], 0));
            FFieldList.AddOrSetValue(vFieldName, vField);
          end;
        tkEnumeration:
          begin
            if not FPropFile.PropertyItem[vFieldName].IsEmpty then
            begin
              vEnumValue := vField.GetValue(Self);
              vEnumValue := TValue.FromOrdinal(vEnumValue.TypeInfo, GetEnumValue(vEnumValue.TypeInfo, FPropFile.PropertyItem[vFieldName]));
              vField.SetValue(Self, vEnumValue);
            end;
            FFieldList.AddOrSetValue(vFieldName, vField);
          end;
      end;
    end;
end;

procedure TMappedPropertiesFile.SetFileNameAndPrefix;
var
  vAttr: TCustomAttribute;
begin
  for vAttr in FRttiType.GetAttributes() do
    if vAttr is PropertiesFileAttribute then
    begin
      FFileName := ExtractFilePath(ParamStr(0)) + PropertiesFileAttribute(vAttr).FileName;
      FPrefix := PropertiesFileAttribute(vAttr).Prefix;
      Break;
    end;
end;

procedure TMappedPropertiesFile.Unload;
var
  vFld: TPair<string, TRttiField>;
begin
  if not IsReadOnly() then
  begin
    for vFld in FFieldList do
      FPropFile.PropertyItem[vFld.Key] := vFld.Value.GetValue(Self).ToString;
    FPropFile.SaveToFile(FFileName);
  end;
end;

end.
