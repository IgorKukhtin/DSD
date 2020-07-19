program Replicator;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {frmMain},
  UData in 'UData.pas' {dmData: TDataModule},
  ULog in 'ULog.pas',
  USettings in 'USettings.pas',
  UConstants in 'UConstants.pas',
  UDefinitions in 'UDefinitions.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
