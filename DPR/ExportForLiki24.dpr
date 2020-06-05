program ExportForLiki24;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForLiki24\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
