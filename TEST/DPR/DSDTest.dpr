program DSDTest;
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
  DropCreateDatabaseTestUnit in '..\SOURCE\DropCreateDatabaseTestUnit.pas',
  DataBaseStructureTestUnit in '..\SOURCE\DataBaseStructureTestUnit.pas',
  DataBaseUnit in '..\SOURCE\DataBaseUnit.pas' {Form1};

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

