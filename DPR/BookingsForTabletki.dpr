program BookingsForTabletki;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\BookingsForTabletki\MainUnit.pas' {MainForm},
  UnitTabletki in '..\FormsFarmacy\MainUnitService\BookingsForTabletki\UnitTabletki.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
