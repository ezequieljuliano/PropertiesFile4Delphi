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

  PropertiesFile4D,
  PropertiesFile4D.Impl;

type

  TTestPropertiesFile = class(TTestCase)
  strict private
    fPropertiesFile: IPropertiesFile;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSaveFile;
    procedure TestLoadFile;
  end;

implementation

{ TTestPropertiesFile }

procedure TTestPropertiesFile.SetUp;
begin
  inherited;
  fPropertiesFile := TPropertiesFile.New;
end;

procedure TTestPropertiesFile.TearDown;
begin
  inherited;
end;

procedure TTestPropertiesFile.TestLoadFile;
begin
  fPropertiesFile.Properties.Clear;
  fPropertiesFile.LoadFromFile('file.properties');
  CheckTrue(fPropertiesFile.PropertyItem['Test1'] = 'Test1');
  CheckTrue(fPropertiesFile.PropertyItem['Test2'] = 'Test_2' + sLineBreak + 'Test_2');
  CheckTrue(fPropertiesFile.PropertyItem['Test3'] = 'Test3');
  CheckTrue(fPropertiesFile.PropertyItem['Test4'] = 'Test_4' + sLineBreak + 'Test_4' + sLineBreak + 'Test_4');
  CheckTrue(fPropertiesFile.PropertyItem['Test5'] = 'Test5');
end;

procedure TTestPropertiesFile.TestSaveFile;
begin
  fPropertiesFile.Properties.Clear;
  fPropertiesFile.PropertyItem['Test1'] := 'Test1';
  fPropertiesFile.PropertyItem['Test2'] := 'Test_2' + sLineBreak + '&Test_2';
  fPropertiesFile.PropertyItem['Test3'] := 'Test3';
  fPropertiesFile.PropertyItem['Test4'] := 'Test_4' + sLineBreak + '&Test_4' + sLineBreak + '&Test_4';
  fPropertiesFile.PropertyItem['Test5'] := 'Test5';
  fPropertiesFile.SaveToFile('file.properties');
  CheckTrue(FileExists('file.properties'));
end;

initialization

RegisterTest(TTestPropertiesFile.Suite);

end.
