program ExportFor2gis;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\ExportFor2gis\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
