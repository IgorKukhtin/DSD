program ProjectMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Dialogs,
  uIntf in 'uIntf.pas',
  uConstants in 'uConstants.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  uNetwork in 'uNetwork.pas',
  uExec in 'uExec.pas',
  uCache in 'uCache.pas',
  uMain in 'uMain.pas' {frmMain},
  FMX.UtilConst in '..\SOURCE FMX\COMPONENT\FMX.UtilConst.pas';

{$R *.res}

begin
  dsdHTTPCharSet := csUTF_8;

  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
