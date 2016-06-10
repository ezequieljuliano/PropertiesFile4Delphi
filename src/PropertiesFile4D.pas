unit PropertiesFile4D;

{$INCLUDE PropertiesFile4D.inc}

interface

uses

  {$IFDEF USE_SYSTEM_NAMESPACE}

  System.Classes,
  System.SysUtils;

  {$ELSE USE_SYSTEM_NAMESPACE}

  System.Classes,
  SysUtils;

  {$ENDIF USE_SYSTEM_NAMESPACE}

type

  EPropertiesFileException = class(Exception);
  EPropertiesFileNotFoundException = class(EPropertiesFileException);
  EPropertyItemIsNullException = class(EPropertiesFileException);

  IPropertiesFile = interface
    ['{025B98DE-BC20-4C4A-B800-864E0C1B3090}']
    function GetProperties: TStrings;

    function GetPropertyItem(const name: string): string;
    procedure SetPropertyItem(const name, value: string);

    function LoadFromFile(const fileName: string): IPropertiesFile;
    procedure SaveToFile(const fileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[const name: string]: string read GetPropertyItem write SetPropertyItem;
  end;

implementation

end.
