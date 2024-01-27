program SendingReportForEmployees;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\SendingReportForEmployees\MainUnit.pas' {MainForm},
  UtilTelegram in '..\SOURCE\UtilTelegram.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
