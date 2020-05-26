program SendData_WMS;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  UData in 'UData.pas' {dmData: TDataModule},
  USettings in 'USettings.pas',
  UConstants in 'UConstants.pas',
  ULog in 'ULog.pas',
  UImportWMS in 'UImportWMS.pas',
  UDefinitions in 'UDefinitions.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmData, dmData);
  Application.Run;
end.
