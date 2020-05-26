program SendingSendDriverVIP;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\SendingSendDriverVIP\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
