program SendingSendDriverVIP;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\SendingSendDriverVIP\MainUnit.pas' {MainForm},
  uTelegram in '..\SOURCE\uTelegram.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
