unit PropertiesFile4D.Impl;

interface

uses
  System.Classes,
  System.SysUtils,
  PropertiesFile4D;

type

  TPropertiesFile = class(TInterfacedObject, IPropertiesFile)
  strict private
    FProperties: TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    function GetProperties: TStrings;

    function GetPropertyItem(const pName: string): string;
    procedure SetPropertyItem(const pName: string; const Value: string);

    procedure LoadFromFile(const pFileName: string);
    procedure SaveToFile(const pFileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[const pName: string]: string read GetPropertyItem write SetPropertyItem;
  end;

implementation

uses
  System.StrUtils;

{ TPropertiesFile }

constructor TPropertiesFile.Create;
begin
  FProperties := TStringList.Create;
end;

destructor TPropertiesFile.Destroy;
begin
  FreeAndNil(FProperties);
  inherited Destroy;
end;

function TPropertiesFile.GetProperties: TStrings;
begin
  Result := FProperties;
end;

function TPropertiesFile.GetPropertyItem(const pName: string): string;

  function ContainsComment(const pText: string): Boolean;
  begin
    Result := (Copy(pText, 0, 2) = '//');
  end;

  function ContainsSeparate(const pText: string): Boolean;
  begin
    Result := AnsiContainsStr(pText, '=');
  end;

var
  vIndex: Integer;
  I: Integer;
begin
  Result := FProperties.Values[pName];

  vIndex := FProperties.IndexOfName(pName);
  Inc(vIndex);

  for I := vIndex to Pred(FProperties.Count) do
    if (ContainsComment(FProperties[I])) or (ContainsSeparate(FProperties[I])) then
      Exit(Result)
    else
      Result := Result + sLineBreak + FProperties[I];
end;

procedure TPropertiesFile.LoadFromFile(const pFileName: string);
begin
  if FileExists(pFileName) then
  begin
    FProperties.Clear;
    FProperties.LoadFromFile(pFileName);
  end
  else
    raise EPropertiesFileNotFound.Create('File ' + pFileName + ' not found!');
end;

procedure TPropertiesFile.SaveToFile(const pFileName: string);
begin
  if (pFileName = EmptyStr) then
    raise EPropertiesFileException.Create('FileName not defined!');

  if FileExists(pFileName) then
    DeleteFile(pFileName);

  FProperties.SaveToFile(pFileName);
end;

procedure TPropertiesFile.SetPropertyItem(const pName, Value: string);
begin
  FProperties.Values[pName] := Value;
end;

end.
