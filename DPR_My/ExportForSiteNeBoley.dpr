program ExportForSiteNeBoley;

uses
  Vcl.Forms,
  MainUnit in '..\ExportForSiteNeBoley\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
