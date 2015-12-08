unit PropertiesFile4D.UnitTest;

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
  FFile := TPropertiesFileFactory.Build;
end;

procedure TTestPropertiesFile.TearDown;
begin
  inherited;

end;

procedure TTestPropertiesFile.TestLoadFile;
begin
  FFile.Properties.Clear;
  FFile.LoadFromFile('file.properties');
  CheckTrue(FFile.PropertyItem['Test1'] = 'Test1');
  CheckTrue(FFile.PropertyItem['Test2'] = 'Test_2' + sLineBreak + 'Test_2');
  CheckTrue(FFile.PropertyItem['Test3'] = 'Test3');
  CheckTrue(FFile.PropertyItem['Test4'] = 'Test_4' + sLineBreak + 'Test_4' + sLineBreak + 'Test_4');
  CheckTrue(FFile.PropertyItem['Test5'] = 'Test5');
end;

procedure TTestPropertiesFile.TestSaveFile;
begin
  FFile.Properties.Clear;
  FFile.PropertyItem['Test1'] := 'Test1';
  FFile.PropertyItem['Test2'] := 'Test_2' + sLineBreak + '&Test_2';
  FFile.PropertyItem['Test3'] := 'Test3';
  FFile.PropertyItem['Test4'] := 'Test_4' + sLineBreak + '&Test_4' + sLineBreak + '&Test_4';
  FFile.PropertyItem['Test5'] := 'Test5';
  FFile.SaveToFile('file.properties');
  CheckTrue(FileExists('file.properties'));
end;

initialization

RegisterTest(TTestPropertiesFile.Suite);

end.
