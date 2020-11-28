program PropertiesFileTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses

  DUnitTestRunner,
  PropertiesFile.Mapping in '..\src\PropertiesFile.Mapping.pas',
  PropertiesFile in '..\src\PropertiesFile.pas',
  PropertiesFile.Storage in '..\src\PropertiesFile.Storage.pas',
  PropertiesFile.Storage.Test in 'PropertiesFile.Storage.Test.pas',
  PropertiesFile.Mapping.Test in 'PropertiesFile.Mapping.Test.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
