program Replicator;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {frmMain},
  UData in 'UData.pas' {dmData: TDataModule},
  ULog in 'ULog.pas',
  USettings in 'USettings.pas',
  UConstants in 'UConstants.pas',
  UDefinitions in 'UDefinitions.pas',
  UCommandData in 'UCommandData.pas',
  UCommon in 'UCommon.pas',
  UScriptFiles in 'UScriptFiles.pas',
  UFileVersion in 'UFileVersion.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
