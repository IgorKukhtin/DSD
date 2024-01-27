program ExportForFarmak;

uses
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportForFarmak\MainUnit.pas' {MainForm},
  Farmak_CRMPharmacyXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMPharmacyXML.pas',
  Farmak_CRMWareXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMWareXML.pas',
  Farmak_CRMWhBalanceXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMWhBalanceXML.pas',
  Farmak_CRMDespatchXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMDespatchXML.pas',
  Farmak_CRMWhReceiptXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMWhReceiptXML.pas',
  Farmak_CRMClientXML in '..\FormsFarmacy\MainUnitService\ExportForFarmak\Farmak\Farmak_CRMClientXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
