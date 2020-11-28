unit PropertiesFile.Mapping.Test;

interface

uses

  TestFramework,
  System.Classes,
  System.SysUtils,
  PropertiesFile,
  PropertiesFile.Storage,
  PropertiesFile.Mapping;

type

  TTestPropertiesFileMapping = class(TTestCase)
  private
    procedure ApplicationConfigCreate;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMapping;
    procedure TestMappingPrefix;
    procedure TestMappingReadOnly;
  end;

  TApplicationStatus = (appActive, appInactive);

  [PropertiesFile('application-config.properties')]
  TApplicationConfig = class(TPropertiesFileObject)
  private
    [NotNull]
    [PropertyItem('code')]
    fCode: Integer;

    [NotNull]
    [PropertyItem('name')]
    fName: string;

    [PropertyItem('status')]
    fStatus: TApplicationStatus;

    [PropertyItem('maxconnections')]
    fMaxConnections: Double;

    [PropertyItem('created')]
    fCreated: TDate;

    [PropertyItem('service')]
    fService: Boolean;

    [Ignore]
    fIgnoredProperty: string;

    [ReadOnly]
    [PropertyItem('readonlyproperty')]
    fReadOnlyProperty: string;
  public
    property Code: Integer read fCode write fCode;
    property Name: string read fName write fName;
    property Status: TApplicationStatus read fStatus write fStatus;
    property MaxConnections: Double read fMaxConnections write fMaxConnections;
    property Created: TDate read fCreated write fCreated;
    property Service: Boolean read fService write fService;
    property IgnoredProperty: string read fIgnoredProperty write fIgnoredProperty;
    property ReadOnlyProperty: string read fReadOnlyProperty write fReadOnlyProperty;
  end;

  [PropertiesFile('application-config-prefix.properties', 'app')]
  TApplicationConfigPrefix = class(TPropertiesFileObject)
  private
    [PropertyItem('code')]
    fCode: Integer;
  public
    property Code: Integer read fCode write fCode;
  end;

  [ReadOnly]
  [PropertiesFile('application-config-readonly.properties', 'app')]
  TApplicationConfigReadOnly = class(TPropertiesFileObject)
  private
    [PropertyItem('code')]
    fCode: Integer;
  public
    property Code: Integer read fCode write fCode;
  end;

implementation

{ TTestPropertiesFileMapping }

procedure TTestPropertiesFileMapping.ApplicationConfigCreate;
begin
  TApplicationConfig.Create;
end;

procedure TTestPropertiesFileMapping.SetUp;
begin
  inherited;
end;

procedure TTestPropertiesFileMapping.TearDown;
begin
  inherited;
end;

procedure TTestPropertiesFileMapping.TestMapping;
var
  propertiesFile: IPropertiesFile;
  applicationConfig: TApplicationConfig;
begin
  // Create a settings file based on the mapping
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['code'] := '1';
  propertiesFile.PropertyItem['name'] := 'PropertiesFileApp';
  propertiesFile.PropertyItem['status'] := 'appActive';
  propertiesFile.PropertyItem['maxconnections'] := '100';
  propertiesFile.PropertyItem['created'] := '25/11/2020';
  propertiesFile.PropertyItem['service'] := 'True';
  propertiesFile.PropertyItem['readonlyproperty'] := 'Yes';
  propertiesFile.SaveToFile('application-config.properties');

  // Instantiate the class by loading data from the file
  applicationConfig := TApplicationConfig.Create;
  try
    CheckTrue(applicationConfig.Code = 1);
    CheckTrue(applicationConfig.Name = 'PropertiesFileApp');
    CheckTrue(applicationConfig.Status = appActive);
    CheckTrue(applicationConfig.MaxConnections = 100);
    CheckTrue(applicationConfig.Created = StrToDate('25/11/2020'));
    CheckTrue(applicationConfig.Service = True);
    CheckTrue(applicationConfig.IgnoredProperty = '');
    CheckTrue(applicationConfig.ReadOnlyProperty = 'Yes');

    // Modifies the configuration data that is saved when destroying the class
    applicationConfig.Code := 2;
    applicationConfig.Name := 'PropertiesFileApp2';
    applicationConfig.Status := appInactive;
    applicationConfig.MaxConnections := 200;
    applicationConfig.Created := StrToDate('20/11/2020');
    applicationConfig.Service := False;
    applicationConfig.IgnoredProperty := 'Yes';
    applicationConfig.ReadOnlyProperty := 'No';
  finally
    applicationConfig.Free;
  end;

  // Checks whether all data has been successfully modified
  applicationConfig := TApplicationConfig.Create;
  try
    CheckTrue(applicationConfig.Code = 2);
    CheckTrue(applicationConfig.Name = 'PropertiesFileApp2');
    CheckTrue(applicationConfig.Status = appInactive);
    CheckTrue(applicationConfig.MaxConnections = 200);
    CheckTrue(applicationConfig.Created = StrToDate('20/11/2020'));
    CheckTrue(applicationConfig.Service = False);
    CheckTrue(applicationConfig.IgnoredProperty = '');
    CheckTrue(applicationConfig.ReadOnlyProperty = 'Yes');
  finally
    applicationConfig.Free;
  end;

  // Validates the load with fields not null
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['code'] := '';
  propertiesFile.PropertyItem['name'] := '';
  propertiesFile.SaveToFile('application-config.properties');
  CheckException(ApplicationConfigCreate, EPropertyItemIsNullException);
end;

procedure TTestPropertiesFileMapping.TestMappingPrefix;
var
  propertiesFile: IPropertiesFile;
  applicationConfig: TApplicationConfigPrefix;
begin
  // Create a settings file based on the mapping
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['app.code'] := '1';
  propertiesFile.SaveToFile('application-config-prefix.properties');

  applicationConfig := TApplicationConfigPrefix.Create;
  try
    CheckTrue(applicationConfig.Code = 1);
  finally
    applicationConfig.Free;
  end;
end;

procedure TTestPropertiesFileMapping.TestMappingReadOnly;
var
  propertiesFile: IPropertiesFile;
  applicationConfig: TApplicationConfigReadOnly;
begin
  // Create a settings file based on the mapping
  propertiesFile := TPropertiesFileStorage.Create;
  propertiesFile.PropertyItem['app.code'] := '1';
  propertiesFile.SaveToFile('application-config-readonly.properties');

  applicationConfig := TApplicationConfigReadOnly.Create;
  try
    CheckTrue(applicationConfig.Code = 1);
    applicationConfig.Code := 200;
  finally
    applicationConfig.Free;
  end;

  applicationConfig := TApplicationConfigReadOnly.Create;
  try
    CheckTrue(applicationConfig.Code = 1);
  finally
    applicationConfig.Free;
  end;
end;

initialization

RegisterTest(TTestPropertiesFileMapping.Suite);

end.
