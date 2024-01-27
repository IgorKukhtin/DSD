program PfizerSend;

uses
  MidasLib,
  Vcl.Forms,
  MainUnit in '..\FormsFarmacy\MainUnitService\PfizerSend\MainUnit.pas' {MainForm},
  UtilConst in 'D:\SOURCE\UtilConst.pas',
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  Storage in '..\SOURCE\Storage.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  DiscountService in '..\FormsFarmacy\DiscountService\DiscountService.pas' {DiscountServiceForm},
  uCardService in '..\FormsFarmacy\DiscountService\uCardService.pas',
  MainCash2 in '..\FormsFarmacy\MainUnitService\PfizerSend\MainCash2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'Farmacy.exe';
  dsdProject := prFarmacy;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDiscountServiceForm, DiscountServiceForm);
  Application.Run;
end.
