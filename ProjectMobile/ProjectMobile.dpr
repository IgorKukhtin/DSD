program ProjectMobile;



uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Dialogs,
  uMain in 'uMain.pas' {frmMain},
  uConstants in 'uConstants.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  Authentication in 'Common\Authentication.pas',
  uNetwork in 'uNetwork.pas',
  uExec in 'uExec.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

