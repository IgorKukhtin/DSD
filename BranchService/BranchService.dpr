program BranchService;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  UnitSettings in 'UnitSettings.pas',
  UnitConst in 'UnitConst.pas',
  ThreadSnapshotUnit in 'ThreadSnapshotUnit.pas' {ThreadSnapshotForm},
  ThreadFunctionUnit in 'ThreadFunctionUnit.pas' {ThreadFunctionForm},
  ThreadIndexUnit in 'ThreadIndexUnit.pas' {ThreadIndexForm},
  ThreadbtnEqualizationUnit in 'ThreadbtnEqualizationUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
