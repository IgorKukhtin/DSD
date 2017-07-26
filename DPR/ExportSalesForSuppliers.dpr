program ExportSalesForSuppliers;

uses
  Vcl.Forms,
  ExportSalesForSupp in '..\ExportSalesForSuppliers\ExportSalesForSupp.pas' {ExportSalesForSuppForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TExportSalesForSuppForm, ExportSalesForSuppForm);
  Application.Run;
end.
