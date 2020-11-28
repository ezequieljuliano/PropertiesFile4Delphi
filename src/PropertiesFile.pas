unit PropertiesFile;

interface

uses

  System.SysUtils,
  System.Classes;

type

  IPropertiesFile = interface
    ['{025B98DE-BC20-4C4A-B800-864E0C1B3090}']
    function GetProperties: TStrings;

    function GetPropertyItem(name: string): string;
    procedure SetPropertyItem(name, value: string);

    function LoadFromFile(fileName: string): IPropertiesFile;
    procedure SaveToFile(fileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[name: string]: string read GetPropertyItem write SetPropertyItem;
  end;

  EPropertiesFileException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EPropertiesFileNotFoundException = class(EPropertiesFileException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EPropertyItemIsNullException = class(EPropertiesFileException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

implementation

end.
