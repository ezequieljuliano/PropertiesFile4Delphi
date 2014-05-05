unit PropertiesFile4D.UnitTest;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  PropertiesFile4D;

type

  TTestPropertiesFile = class(TTestCase)
  strict private
    FFile: IPropertiesFile;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSaveFile();
    procedure TestLoadFile();
  end;

implementation

{ TTestPropertiesFile }

procedure TTestPropertiesFile.SetUp;
begin
  inherited;
  FFile := TPropertiesFileFactory.GetInstance;
end;

procedure TTestPropertiesFile.TearDown;
begin
  inherited;

end;

procedure TTestPropertiesFile.TestLoadFile;
begin
  FFile.Properties.Clear;
  FFile.LoadFromFile('file.infra');
  CheckTrue(FFile.PropertyItem['Test'] = 'Test');
end;

procedure TTestPropertiesFile.TestSaveFile;
begin
  FFile.Properties.Clear;
  FFile.PropertyItem['Test'] := 'Test';
  FFile.SaveToFile('file.infra');
  CheckTrue(FileExists('file.infra'));
end;

initialization

RegisterTest(TTestPropertiesFile.Suite);

end.
