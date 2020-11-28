unit PropertiesFile.Storage;

interface

uses

  System.Classes,
  System.SysUtils,
  PropertiesFile;

type

  TPropertiesFileStorage = class(TInterfacedObject, IPropertiesFile)
  private
    fProperties: TStrings;
    function ContainsComment(text: string): Boolean;
    function IsContinuation(text: string): Boolean;
  protected
    function GetProperties: TStrings;

    function GetPropertyItem(name: string): string;
    procedure SetPropertyItem(name, value: string);

    function LoadFromFile(fileName: string): IPropertiesFile;
    procedure SaveToFile(fileName: string);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPropertiesFileStorage }

function TPropertiesFileStorage.ContainsComment(text: string): Boolean;
begin
  Result := Copy(Trim(text), 0, 2) = '//';
end;

constructor TPropertiesFileStorage.Create;
begin
  inherited Create;
  fProperties := TStringList.Create;
end;

destructor TPropertiesFileStorage.Destroy;
begin
  fProperties.Free;
  inherited Destroy;
end;

function TPropertiesFileStorage.GetProperties: TStrings;
begin
  Result := fProperties;
end;

function TPropertiesFileStorage.GetPropertyItem(name: string): string;
var
  index: Integer;
  i: Integer;
begin
  Result := fProperties.Values[name];

  index := fProperties.IndexOfName(name);
  Inc(index);

  for i := index to Pred(fProperties.Count) do
    if (ContainsComment(fProperties[i])) or (not IsContinuation(fProperties[i])) then
      Exit(Result)
    else
      Result := Result + sLineBreak + Copy(fProperties[i], Pos('&', fProperties[i]) + 1, Length(fProperties[i]));
end;

function TPropertiesFileStorage.IsContinuation(text: string): Boolean;
begin
  Result := Copy(Trim(text), 0, 1) = '&';
end;

function TPropertiesFileStorage.LoadFromFile(fileName: string): IPropertiesFile;
begin
  if FileExists(fileName) then
  begin
    fProperties.Clear;
    fProperties.LoadFromFile(fileName);
  end
  else
    raise EPropertiesFileNotFoundException.CreateFmt('File %s not found!', [fileName]);
  Result := Self;
end;

procedure TPropertiesFileStorage.SaveToFile(fileName: string);
begin
  if (fileName = EmptyStr) then
    raise EPropertiesFileException.Create('File name not defined!');

  if FileExists(fileName) then
    DeleteFile(fileName);

  fProperties.SaveToFile(fileName);
end;

procedure TPropertiesFileStorage.SetPropertyItem(name, value: string);
begin
  fProperties.Values[name] := value;
end;

end.
