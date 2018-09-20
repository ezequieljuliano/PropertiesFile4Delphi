unit PropertiesFile4D.UnitTest.Mapping;

interface

{$INCLUDE ..\src\PropertiesFile4D.inc}

uses
  TestFramework,

  {$IFDEF USE_SYSTEM_NAMESPACE}

  System.Classes,
  System.SysUtils,

  {$ELSE USE_SYSTEM_NAMESPACE}

  Classes,
  SysUtils,

  {$ENDIF USE_SYSTEM_NAMESPACE}

  PropertiesFile4D.Mapping,
  PropertiesFile4D.Impl,
  PropertiesFile4D;

type

  [PropertiesFile('ConfigFilePrefixReadOnly.properties', 'Config')]
  [ReadOnly]
  TConfigFilePrefixReadOnly = class(TMappedPropertiesFile)
  private
    [PropertyItem('Cod')]
    [NotNull]
    fCod: Integer;

    [PropertyItem('Name')]
    [NotNull]
    fName: string;

    [PropertyItem('Value')]
    fValue: Double;

    [PropertyItem('Date')]
    fDate: string;

    [PropertyItem('Valid')]
    fValid: Boolean;

    [Ignore]
    fTransient: string;
  public
    constructor Create;

    property Cod: Integer read fCod;
    property Name: string read fName;
    property Value: Double read fValue;
    property Date: string read fDate;
    property Valid: Boolean read fValid;
    property Transient: string read fTransient;
  end;

  [PropertiesFile('ConfigFileReadOnly.properties')]
  [ReadOnly]
  TConfigFileReadOnly = class(TMappedPropertiesFile)
  private
    [PropertyItem('Cod')]
    [NotNull]
    fCod: Integer;

    [PropertyItem('Name')]
    [NotNull]
    fName: string;

    [PropertyItem('Value')]
    fValue: Double;

    [PropertyItem('Date')]
    fDate: string;

    [PropertyItem('Valid')]
    fValid: Boolean;

    [Ignore]
    fTransient: string;
  public
    constructor Create;

    property Cod: Integer read fCod;
    property Name: string read fName;
    property Value: Double read fValue;
    property Date: string read fDate;
    property Valid: Boolean read fValid;
    property Transient: string read fTransient;
  end;

  [PropertiesFile('ConfigFile.properties')]
  TConfigFile = class(TMappedPropertiesFile)
  private
    [PropertyItem('Cod')]
    [NotNull]
    fCod: Integer;

    [PropertyItem('Name')]
    [NotNull]
    fName: string;

    [PropertyItem('Value')]
    fValue: Double;

    [PropertyItem('Date')]
    fDate: string;

    [PropertyItem('Valid')]
    fValid: Boolean;

    [Ignore]
    fTransient: string;
  public
    constructor Create;

    property Cod: Integer read fCod write fCod;
    property Name: string read fName write fName;
    property Value: Double read fValue write fValue;
    property Date: string read fDate write fDate;
    property Valid: Boolean read fValid write fValid;
    property Transient: string read fTransient;
  end;

  TTestPropertiesFileMapping = class(TTestCase)
  private
    { private declarations }
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConfigFilePrefixReadOnly;
    procedure TestConfigFileReadOnly;
    procedure TestConfigFile;
  end;

implementation

{ TTestPropertiesFileMapping }

procedure TTestPropertiesFileMapping.SetUp;
var
  propertiesFile: IPropertiesFile;
begin
  inherited;
  propertiesFile := TPropertiesFile.New;
  propertiesFile.PropertyItem['Config.Cod'] := '1';
  propertiesFile.PropertyItem['Config.Name'] := 'Test';
  propertiesFile.PropertyItem['Config.Value'] := '100';
  propertiesFile.PropertyItem['Config.Date'] := '21/01/2015';
  propertiesFile.PropertyItem['Config.Valid'] := 'True';
  propertiesFile.SaveToFile('ConfigFilePrefixReadOnly.properties');

  propertiesFile := TPropertiesFile.New;
  propertiesFile.PropertyItem['Cod'] := '1';
  propertiesFile.PropertyItem['Name'] := 'Test';
  propertiesFile.PropertyItem['Value'] := '100';
  propertiesFile.PropertyItem['Date'] := '21/01/2015';
  propertiesFile.PropertyItem['Valid'] := 'True';
  propertiesFile.SaveToFile('ConfigFileReadOnly.properties');
end;

procedure TTestPropertiesFileMapping.TearDown;
begin
  inherited;
end;

procedure TTestPropertiesFileMapping.TestConfigFile;
var
  config, config2: TConfigFile;
begin
  config := TConfigFile.Create;
  try
    config.Cod := 1;
    config.Name := 'Test';
    config.Value := 100;
    config.Date := '21/01/2015';
    config.Valid := True;
  finally
    FreeAndNil(config);
  end;

  CheckTrue(FileExists('ConfigFile.properties'));

  config := TConfigFile.Create;
  config2 := TConfigFile.Create;
  try
    config.Cod := 1;
    config.Name := 'Test';
    config.Value := 100;
    config.Date := '21/01/2015';
    config.Valid := True;

    config.Save;

    config2.Reload;

    CheckTrue(config2.Cod = 1);
    CheckTrue(config2.Name = 'Test');
    CheckTrue(config2.Value = 100);
    CheckTrue(config2.Date = '21/01/2015');
    CheckTrue(config2.Valid = True);
    CheckTrue(config2.Transient = 'Transient');
  finally
    FreeAndNil(config);
    FreeAndNil(config2);
  end;

  config := TConfigFile.Create;
  try
    config.Cod := 1;
    config.Name := 'Test';
    config.Value := 100;
    config.Date := '21/01/2015';
    config.Valid := True;
  finally
    FreeAndNil(config);
  end;

  CheckTrue(FileExists('ConfigFile.properties'));

  config := TConfigFile.Create;
  try
    CheckTrue(config.Cod = 1);
    CheckTrue(config.Name = 'Test');
    CheckTrue(config.Value = 100);
    CheckTrue(config.Date = '21/01/2015');
    CheckTrue(config.Valid = True);
    CheckTrue(config.Transient = 'Transient');
  finally
    FreeAndNil(config);
  end;
end;

procedure TTestPropertiesFileMapping.TestConfigFilePrefixReadOnly;
var
  config: TConfigFilePrefixReadOnly;
begin
  config := TConfigFilePrefixReadOnly.Create;
  try
    CheckTrue(config.Cod = 1);
    CheckTrue(config.Name = 'Test');
    CheckTrue(config.Value = 100);
    CheckTrue(config.Date = '21/01/2015');
    CheckTrue(config.Valid = True);
    CheckTrue(config.Transient = 'Transient');
  finally
    FreeAndNil(config);
  end;
end;

procedure TTestPropertiesFileMapping.TestConfigFileReadOnly;
var
  config: TConfigFileReadOnly;
begin
  config := TConfigFileReadOnly.Create;
  try
    CheckTrue(config.Cod = 1);
    CheckTrue(config.Name = 'Test');
    CheckTrue(config.Value = 100);
    CheckTrue(config.Date = '21/01/2015');
    CheckTrue(config.Valid = True);
    CheckTrue(config.Transient = 'Transient');
  finally
    FreeAndNil(config);
  end;
end;

{ TConfigFileReadOnly }

constructor TConfigFilePrefixReadOnly.Create;
begin
  fTransient := 'Transient';
end;

{ TConfigFileReadOnly }

constructor TConfigFileReadOnly.Create;
begin
  fTransient := 'Transient';
end;

{ TConfigFile }

constructor TConfigFile.Create;
begin
  fTransient := 'Transient';
end;

initialization

RegisterTest(TTestPropertiesFileMapping.Suite);

end.
