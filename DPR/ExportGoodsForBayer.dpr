program ExportGoodsForBayer;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\ExportGoodsForBayer\MainUnit.pas' {MainForm},
  uBayer in '..\FormsFarmacy\MainUnitService\ExportGoodsForBayer\uBayer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
