program PropertiesFile4DTests;
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
  PropertiesFile4D in '..\src\PropertiesFile4D.pas',
  PropertiesFile4D.Impl in '..\src\PropertiesFile4D.Impl.pas',
  PropertiesFile4D.UnitTest in 'PropertiesFile4D.UnitTest.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
