program BookingsForLiki24;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\BookingsForLiki24\MainUnit.pas' {MainForm},
  UnitLiki24 in '..\FormsFarmacy\MainUnitService\BookingsForLiki24\UnitLiki24.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
