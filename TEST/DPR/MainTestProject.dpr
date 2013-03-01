program MainTestProject;

uses
  Vcl.Forms,
  MainTest in '..\SOURCE\MainTest.pas' {MainForm},
  StorageUnit in '..\..\SOURCE\StorageUnit.pas',
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  UtilConvert in '..\..\SOURCE\UtilConvert.pas',
  UtilType in '..\..\SOURCE\UtilType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
