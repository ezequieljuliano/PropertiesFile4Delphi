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

unit PropertiesFile4D;

interface

uses
  System.Classes,
  System.SysUtils;

type

  EPropertiesFileException = class(Exception);
  EPropertiesFileNotFound = class(EPropertiesFileException);

  IPropertiesFile = interface
    ['{025B98DE-BC20-4C4A-B800-864E0C1B3090}']
    function GetProperties: TStrings;

    function GetPropertyItem(const pName: string): string;
    procedure SetPropertyItem(const pName: string; const Value: string);

    procedure LoadFromFile(const pFileName: string);
    procedure SaveToFile(const pFileName: string);

    property Properties: TStrings read GetProperties;
    property PropertyItem[const pName: string]: string read GetPropertyItem write SetPropertyItem;
  end;

  TPropertiesFileFactory = class sealed
  private
  {$HINTS OFF}
    constructor Create();
  {$HINTS ON}
  public
    class function GetInstance(): IPropertiesFile; static;
  end;

implementation

uses
  PropertiesFile4D.Impl;

{ TPropertiesFileManager }

constructor TPropertiesFileFactory.Create;
begin
  raise EPropertiesFileException.Create('Method not used!');
end;

class function TPropertiesFileFactory.GetInstance: IPropertiesFile;
begin
  Result := TPropertiesFile.Create;
end;

end.
