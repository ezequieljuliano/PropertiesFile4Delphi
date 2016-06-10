unit PropertiesFile4D.Impl;

{$INCLUDE PropertiesFile4D.inc}

interface

uses

  {$IFDEF USE_SYSTEM_NAMESPACE}

  System.Classes,
  System.SysUtils,

  {$ELSE USE_SYSTEM_NAMESPACE}

  Classes,
  SysUtils,

  {$ENDIF USE_SYSTEM_NAMESPACE}

  PropertiesFile4D;

type

  TPropertiesFile = class(TInterfacedObject, IPropertiesFile)
  private
    fProperties: TStrings;
  protected
    function GetProperties: TStrings;

    function GetPropertyItem(const name: string): string;
    procedure SetPropertyItem(const name, value: string);

    function LoadFromFile(const fileName: string): IPropertiesFile;
    procedure SaveToFile(const fileName: string);
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IPropertiesFile; static;
  end;

implementation

{ TPropertiesFile }

constructor TPropertiesFile.Create;
begin
  inherited Create;
  fProperties := TStringList.Create;
end;

destructor TPropertiesFile.Destroy;
begin
  fProperties.Free;
  inherited Destroy;
end;

function TPropertiesFile.GetProperties: TStrings;
begin
  Result := fProperties;
end;

function TPropertiesFile.GetPropertyItem(const name: string): string;

  function ContainsComment(const text: string): Boolean;
  begin
    Result := Copy(Trim(text), 0, 2) = '//';
  end;

  function IsContinued(const text: string): Boolean;
  begin
    Result := Copy(Trim(text), 0, 1) = '&';
  end;

var
  index: Integer;
  i: Integer;
begin
  Result := fProperties.Values[name];

  index := fProperties.IndexOfName(name);
  Inc(index);

  for i := index to Pred(fProperties.Count) do
    if (ContainsComment(fProperties[i])) or (not IsContinued(fProperties[i])) then
      Exit(Result)
    else
      Result := Result + sLineBreak + Copy(fProperties[i], Pos('&', fProperties[i]) + 1, Length(fProperties[i]));
end;

function TPropertiesFile.LoadFromFile(const fileName: string): IPropertiesFile;
begin
  if FileExists(fileName) then
  begin
    fProperties.Clear;
    fProperties.LoadFromFile(fileName);
  end
  else
    raise EPropertiesFileNotFoundException.Create('File ' + fileName + ' not found!');
  Result := Self;
end;

class function TPropertiesFile.New: IPropertiesFile;
begin
  Result := TPropertiesFile.Create;
end;

procedure TPropertiesFile.SaveToFile(const fileName: string);
begin
  if (fileName = EmptyStr) then
    raise EPropertiesFileException.Create('FileName not defined!');

  if FileExists(fileName) then
    DeleteFile(fileName);

  fProperties.SaveToFile(fileName);
end;

procedure TPropertiesFile.SetPropertyItem(const name, value: string);
begin
  fProperties.Values[name] := value;
end;

end.
