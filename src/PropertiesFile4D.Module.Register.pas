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

unit PropertiesFile4D.Module.Register;

interface

implementation

uses
  Spring,
  Spring.Container,
  PropertiesFile4D.Impl,
  PropertiesFile4D;

procedure RegisterClasses();
begin
  GlobalContainer.RegisterType<TPropertiesFile>.Implements<IPropertiesFile>.AsTransient;

  GlobalContainer.Build;
end;

initialization

RegisterClasses();

end.
