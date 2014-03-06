(*
  Copyright 2013 Ezequiel Juliano Müller - ezequieljuliano@gmail.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*)

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
