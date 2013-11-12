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

unit PropertiesFile4D.Impl;

interface

uses
  System.Classes,
  System.SysUtils,
  PropertiesFile4D;

type

  TPropertiesFile = class(TInterfacedObject, IPropertiesFile)
  strict private
    FProperties: TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    function GetProperties: TStrings;

    function GetPropertyItem(const pName: string): string;
    procedure SetPropertyItem(const pName: string; const Value: string);

    procedure LoadFromFile(const pFileName: string);
    procedure SaveToFile(const pFileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[const pName: string]: string read GetPropertyItem write SetPropertyItem;
  end;

implementation

{ TPropertiesFile }

constructor TPropertiesFile.Create;
begin
  FProperties := TStringList.Create;
end;

destructor TPropertiesFile.Destroy;
begin
  FreeAndNil(FProperties);
  inherited Destroy;
end;

function TPropertiesFile.GetProperties: TStrings;
begin
  Result := FProperties;
end;

function TPropertiesFile.GetPropertyItem(const pName: string): string;
begin
  Result := FProperties.Values[pName]
end;

procedure TPropertiesFile.LoadFromFile(const pFileName: string);
begin
  if FileExists(pFileName) then
  begin
    FProperties.Clear;
    FProperties.LoadFromFile(pFileName);
  end
  else
    raise EPropertiesFileNotFound.Create('File ' + pFileName + ' not found!');
end;

procedure TPropertiesFile.SaveToFile(const pFileName: string);
begin
  if (pFileName = EmptyStr) then
    raise EPropertiesFileException.Create('FileName not defined!');

  if FileExists(pFileName) then
    DeleteFile(pFileName);

  FProperties.SaveToFile(pFileName);
end;

procedure TPropertiesFile.SetPropertyItem(const pName, Value: string);
begin
  FProperties.Values[pName] := Value;
end;

end.
