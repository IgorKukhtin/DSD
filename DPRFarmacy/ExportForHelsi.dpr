program ExportForHelsi;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\ExportForHelsi\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
