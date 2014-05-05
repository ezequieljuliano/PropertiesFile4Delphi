unit PropertiesFile4D;

interface

uses
  System.Classes,
  System.SysUtils;

type

  EPropertiesFileException = class(Exception);
  EPropertiesFileNotFound = class(EPropertiesFileException);

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
  private
  {$HINTS OFF}
    constructor Create();
  {$HINTS ON}
  public
    class function GetInstance(): IPropertiesFile; static;
  end;

implementation

uses
  PropertiesFile4D.Impl;

{ TPropertiesFileManager }

constructor TPropertiesFileFactory.Create;
begin
  raise EPropertiesFileException.Create('Method not used!');
end;

class function TPropertiesFileFactory.GetInstance: IPropertiesFile;
begin
  Result := TPropertiesFile.Create;
end;

end.
