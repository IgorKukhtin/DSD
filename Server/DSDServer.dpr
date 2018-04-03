program DSDServer;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  dmDSD in 'dmDSD.pas' {DM: TDataModule},
  uFillDataSet in 'uFillDataSet.pas',
  NativeXml in 'NativeXml\NativeXml.pas',
  sdDebug in 'NativeXml\sdDebug.pas',
  sdStreams in 'NativeXml\sdStreams.pas',
  sdStringTable in 'NativeXml\sdStringTable.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
