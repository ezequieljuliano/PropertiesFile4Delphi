program PropertiesFile4DTestsMapping;
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
  PropertiesFile4D.UnitTest.Mapping in 'PropertiesFile4D.UnitTest.Mapping.pas',
  PropertiesFile4D in '..\src\PropertiesFile4D.pas',
  PropertiesFile4D.Mapping in '..\src\PropertiesFile4D.Mapping.pas',
  PropertiesFile4D.Impl in '..\src\PropertiesFile4D.Impl.pas';

{ R *.RES }

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
