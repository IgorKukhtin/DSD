program LoadingDataFarmacy;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\LoadingDataFarmacy\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
