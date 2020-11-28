unit PropertiesFile.Storage.Test;

interface

uses

  TestFramework,
  System.Classes,
  System.SysUtils,
  PropertiesFile,
  PropertiesFile.Storage;

type

  TTestPropertiesFileStorage = class(TTestCase)
  private const
    APPLICATION_PROPERTIES_FILE_NAME = 'application.properties';
  private
    fPropertiesFile: IPropertiesFile;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSaveAndLoadFromFile;
  end;

implementation

{ TTestPropertiesFileStorage }

procedure TTestPropertiesFileStorage.SetUp;
begin
  inherited;
  fPropertiesFile := TPropertiesFileStorage.Create;
end;

procedure TTestPropertiesFileStorage.TearDown;
begin
  inherited;
  fPropertiesFile := nil;
end;

procedure TTestPropertiesFileStorage.TestSaveAndLoadFromFile;
begin
  if FileExists(APPLICATION_PROPERTIES_FILE_NAME) then
    DeleteFile(APPLICATION_PROPERTIES_FILE_NAME);

  fPropertiesFile.PropertyItem['Test1'] := 'Test1';
  fPropertiesFile.PropertyItem['Test2'] := 'Test_2' + sLineBreak + '&Test_2';
  fPropertiesFile.PropertyItem['Test3'] := 'Test3';
  fPropertiesFile.PropertyItem['Test4'] := 'Test_4' + sLineBreak + '&Test_4' + sLineBreak + '&Test_4';
  fPropertiesFile.PropertyItem['Test5'] := 'Test5';
  fPropertiesFile.SaveToFile(APPLICATION_PROPERTIES_FILE_NAME);
  CheckTrue(FileExists(APPLICATION_PROPERTIES_FILE_NAME));

  fPropertiesFile.LoadFromFile(APPLICATION_PROPERTIES_FILE_NAME);
  CheckTrue(fPropertiesFile.PropertyItem['Test1'] = 'Test1');
  CheckTrue(fPropertiesFile.PropertyItem['Test2'] = 'Test_2' + sLineBreak + 'Test_2');
  CheckTrue(fPropertiesFile.PropertyItem['Test3'] = 'Test3');
  CheckTrue(fPropertiesFile.PropertyItem['Test4'] = 'Test_4' + sLineBreak + 'Test_4' + sLineBreak + 'Test_4');
  CheckTrue(fPropertiesFile.PropertyItem['Test5'] = 'Test5');
end;

initialization

RegisterTest(TTestPropertiesFileStorage.Suite);

end.
