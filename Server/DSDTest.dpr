program DSDTest;

{$IFNDEF TESTINSIGHT}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  DunitTestRunner,
  MidasLib,
  uDSDTestModule in 'uDSDTestModule.pas',
  dmDSD in 'dmDSD.pas',
  uFillDataSet in 'uFillDataSet.pas';

begin
  ReportMemoryLeaksOnShutdown  := true;
  DUnitTestRunner.RunRegisteredTests;
end.
