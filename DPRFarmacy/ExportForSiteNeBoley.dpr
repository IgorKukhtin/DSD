program ExportForSiteNeBoley;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForSiteNeBoley\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
