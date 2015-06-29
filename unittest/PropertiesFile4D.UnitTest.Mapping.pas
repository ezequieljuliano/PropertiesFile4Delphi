unit PropertiesFile4D.UnitTest.Mapping;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  PropertiesFile4D.Mapping,
  PropertiesFile4D;

type

  [PropertiesFile('ConfigFilePrefixReadOnly.properties', 'Config')]
  [ReadOnly]
  TConfigFilePrefixReadOnly = class(TMappedPropertiesFile)
  strict private
  [PropertyItem('Cod')]
  [NotNull]
    FCod: Integer;
    [PropertyItem('Name')]
    [NotNull]
    FName: string;
    [PropertyItem('Value')]
    FValue: Double;
    [PropertyItem('Date')]
    FDate: string;
    [PropertyItem('Valid')]
    FValid: Boolean;
    [Ignore]
    FTransient: string;
  public
    constructor Create();

    property Cod: Integer read FCod;
    property Name: string read FName;
    property Value: Double read FValue;
    property Date: string read FDate;
    property Valid: Boolean read FValid;
    property Transient: string read FTransient;
  end;

  [PropertiesFile('ConfigFileReadOnly.properties')]
  [ReadOnly]
  TConfigFileReadOnly = class(TMappedPropertiesFile)
  strict private
  [PropertyItem('Cod')]
  [NotNull]
    FCod: Integer;
    [PropertyItem('Name')]
    [NotNull]
    FName: string;
    [PropertyItem('Value')]
    FValue: Double;
    [PropertyItem('Date')]
    FDate: string;
    [PropertyItem('Valid')]
    FValid: Boolean;
    [Ignore]
    FTransient: string;
  public
    constructor Create();

    property Cod: Integer read FCod;
    property Name: string read FName;
    property Value: Double read FValue;
    property Date: string read FDate;
    property Valid: Boolean read FValid;
    property Transient: string read FTransient;
  end;

  [PropertiesFile('ConfigFile.properties')]
  TConfigFile= class(TMappedPropertiesFile)
  strict private
  [PropertyItem('Cod')]
  [NotNull]
    FCod: Integer;
    [PropertyItem('Name')]
    [NotNull]
    FName: string;
    [PropertyItem('Value')]
    FValue: Double;
    [PropertyItem('Date')]
    FDate: string;
    [PropertyItem('Valid')]
    FValid: Boolean;
    [Ignore]
    FTransient: string;
  public
    constructor Create();

    property Cod: Integer read FCod write FCod;
    property Name: string read FName write FName;
    property Value: Double read FValue write FValue;
    property Date: string read FDate write FDate;
    property Valid: Boolean read FValid write FValid;
    property Transient: string read FTransient;
  end;

  TTestPropertiesFileMapping = class(TTestCase)
  strict private

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConfigFilePrefixReadOnly();
    procedure TestConfigFileReadOnly();
    procedure TestConfigFile();
  end;

implementation

{ TTestPropertiesFileMapping }

procedure TTestPropertiesFileMapping.SetUp;
var
  vFile: IPropertiesFile;
begin
  inherited;
  vFile := TPropertiesFileFactory.Build();
  vFile.PropertyItem['Config.Cod'] := '1';
  vFile.PropertyItem['Config.Name'] := 'Test';
  vFile.PropertyItem['Config.Value'] := '100';
  vFile.PropertyItem['Config.Date'] := '21/01/2015';
  vFile.PropertyItem['Config.Valid'] := '0';
  vFile.SaveToFile('ConfigFilePrefixReadOnly.properties');

  vFile := TPropertiesFileFactory.Build();
  vFile.PropertyItem['Cod'] := '1';
  vFile.PropertyItem['Name'] := 'Test';
  vFile.PropertyItem['Value'] := '100';
  vFile.PropertyItem['Date'] := '21/01/2015';
  vFile.PropertyItem['Valid'] := '0';
  vFile.SaveToFile('ConfigFileReadOnly.properties');
end;

procedure TTestPropertiesFileMapping.TearDown;
begin
  inherited;

end;

procedure TTestPropertiesFileMapping.TestConfigFile;
var
  vConfig, vConfig2: TConfigFile;
begin
  vConfig := TConfigFile.Create;
  try
    vConfig.Cod := 1;
    vConfig.Name := 'Test';
    vConfig.Value := 100;
    vConfig.Date := '21/01/2015';
    vConfig.Valid := True;
  finally
    FreeAndNil(vConfig);
  end;

  CheckTrue(FileExists('ConfigFile.properties'));

  vConfig := TConfigFile.Create;
  vConfig2 := TConfigFile.Create;
  try
    vConfig.Cod := 1;
    vConfig.Name := 'Test';
    vConfig.Value := 100;
    vConfig.Date := '21/01/2015';
    vConfig.Valid := True;

    vConfig.Save;

    vConfig2.Reload;

    CheckTrue(vConfig2.Cod = 1);
    CheckTrue(vConfig2.Name = 'Test');
    CheckTrue(vConfig2.Value = 100);
    CheckTrue(vConfig2.Date = '21/01/2015');
    CheckTrue(vConfig2.Valid = False);
    CheckTrue(vConfig2.Transient = 'Transient');
  finally
    FreeAndNil(vConfig);
    FreeAndNil(vConfig2);
  end;

  vConfig := TConfigFile.Create;
  try
    vConfig.Cod := 1;
    vConfig.Name := 'Test';
    vConfig.Value := 100;
    vConfig.Date := '21/01/2015';
    vConfig.Valid := True;
  finally
    FreeAndNil(vConfig);
  end;

  CheckTrue(FileExists('ConfigFile.properties'));

  vConfig := TConfigFile.Create;
  try
    CheckTrue(vConfig.Cod = 1);
    CheckTrue(vConfig.Name = 'Test');
    CheckTrue(vConfig.Value = 100);
    CheckTrue(vConfig.Date = '21/01/2015');
    CheckTrue(vConfig.Valid = False);
    CheckTrue(vConfig.Transient = 'Transient');
  finally
    FreeAndNil(vConfig);
  end;
end;

procedure TTestPropertiesFileMapping.TestConfigFilePrefixReadOnly;
var
  vConfig: TConfigFilePrefixReadOnly;
begin
  vConfig := TConfigFilePrefixReadOnly.Create;
  try
    CheckTrue(vConfig.Cod = 1);
    CheckTrue(vConfig.Name = 'Test');
    CheckTrue(vConfig.Value = 100);
    CheckTrue(vConfig.Date = '21/01/2015');
    CheckTrue(vConfig.Valid = False);
    CheckTrue(vConfig.Transient = 'Transient');
  finally
    FreeAndNil(vConfig);
  end;
end;

procedure TTestPropertiesFileMapping.TestConfigFileReadOnly;
var
  vConfig: TConfigFileReadOnly;
begin
  vConfig := TConfigFileReadOnly.Create;
  try
    CheckTrue(vConfig.Cod = 1);
    CheckTrue(vConfig.Name = 'Test');
    CheckTrue(vConfig.Value = 100);
    CheckTrue(vConfig.Date = '21/01/2015');
    CheckTrue(vConfig.Valid = False);
    CheckTrue(vConfig.Transient = 'Transient');
  finally
    FreeAndNil(vConfig);
  end;
end;

{ TConfigFileReadOnly }

constructor TConfigFilePrefixReadOnly.Create;
begin
  FTransient := 'Transient';
end;

{ TConfigFileReadOnly }

constructor TConfigFileReadOnly.Create;
begin
  FTransient := 'Transient';
end;

{ TConfigFile }

constructor TConfigFile.Create;
begin
  FTransient := 'Transient';
end;

initialization

RegisterTest(TTestPropertiesFileMapping.Suite);

end.
