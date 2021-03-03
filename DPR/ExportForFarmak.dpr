program ExportForFarmak;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForFarmak\MainUnit.pas' {MainForm},
  Farmak_CRMPharmacyXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMPharmacyXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
