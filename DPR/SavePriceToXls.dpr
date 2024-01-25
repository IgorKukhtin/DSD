program SavePriceToXls;

uses
  Vcl.Forms,
  SaveToXlsUnit in '..\FormsFarmacy\MainUnitService\SavePriceToXls\SaveToXlsUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
