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
  CheckTrue(FFile.PropertyItem['Test1'] = 'Test1');
  CheckTrue(FFile.PropertyItem['Test2'] = 'Test_2' + sLineBreak + ' Test_2');
  CheckTrue(FFile.PropertyItem['Test3'] = 'Test3');
  CheckTrue(FFile.PropertyItem['Test4'] = 'Test_4' + sLineBreak + ' Test_4' + sLineBreak + ' Test_4');
  CheckTrue(FFile.PropertyItem['Test5'] = 'Test5');
end;

procedure TTestPropertiesFile.TestSaveFile;
begin
  FFile.Properties.Clear;
  FFile.PropertyItem['Test1'] := 'Test1';
  FFile.PropertyItem['Test2'] := 'Test_2' + sLineBreak + ' Test_2';
  FFile.PropertyItem['Test3'] := 'Test3';
  FFile.PropertyItem['Test4'] := 'Test_4' + sLineBreak + ' Test_4' + sLineBreak + ' Test_4';
  FFile.PropertyItem['Test5'] := 'Test5';
  FFile.SaveToFile('file.infra');
  CheckTrue(FileExists('file.infra'));
end;

initialization

RegisterTest(TTestPropertiesFile.Suite);

end.
