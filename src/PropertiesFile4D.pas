unit PropertiesFile4D;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils;

type

  EPropertiesFileException = class(Exception);
  EPropertiesFileNotFound = class(EPropertiesFileException);
  EPropertyItemIsNull = class(EPropertiesFileException);

  IPropertiesFile = interface
    ['{025B98DE-BC20-4C4A-B800-864E0C1B3090}']
    function GetProperties: TStrings;

    function GetPropertyItem(const pName: string): string;
    procedure SetPropertyItem(const pName: string; const Value: string);

    procedure LoadFromFile(const pFileName: string);
    procedure SaveToFile(const pFileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[const pName: string]: string read GetPropertyItem write SetPropertyItem;
  end;

  TPropertiesFileFactory = class sealed
  strict private
  const
    CanNotBeInstantiatedException = 'This class can not be instantiated!';
  strict private

    {$HINTS OFF}

    constructor Create;

    {$HINTS ON}

  public
    class function Build(): IPropertiesFile; static;
  end;

implementation

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
    Result := Copy(Trim(pText), 0, 2) = '//';
  end;

  function IsContinued(const pText: string): Boolean;
  begin
    Result := Copy(Trim(pText), 0, 1) = '&';
  end;

var
  vIndex: Integer;
  I: Integer;
begin
  Result := FProperties.Values[pName];

  vIndex := FProperties.IndexOfName(pName);
  Inc(vIndex);

  for I := vIndex to Pred(FProperties.Count) do
  begin
    if (ContainsComment(FProperties[I])) or (not IsContinued(FProperties[I])) then
      Exit(Result)
    else
      Result := Result + sLineBreak + Copy(FProperties[I], Pos('&', FProperties[I]) + 1, Length(FProperties[I]));
  end;
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

{ TPropertiesFileFactory }

class function TPropertiesFileFactory.Build: IPropertiesFile;
begin
  Result := TPropertiesFile.Create;
end;

constructor TPropertiesFileFactory.Create;
begin
  raise EPropertiesFileException.Create(CanNotBeInstantiatedException);
end;

end.
