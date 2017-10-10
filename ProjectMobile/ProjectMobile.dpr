program ProjectMobile;



uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Dialogs,
  uIntf in 'uIntf.pas',
  uMain in 'uMain.pas' {frmMain},
  uConstants in 'uConstants.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  Authentication in 'Common\Authentication.pas',
  uNetwork in 'uNetwork.pas',
  uExec in 'uExec.pas',
  uCache in 'uCache.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

