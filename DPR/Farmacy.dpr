program Farmacy;

uses
  Vcl.Forms,
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  FarmacyMainForm in '..\SOURCE\FarmacyMainForm.pas' {MainForm},
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  Storage in '..\SOURCE\Storage.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  UnilWin in '..\SOURCE\UnilWin.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  ClientBankLoad in '..\SOURCE\COMPONENT\ClientBankLoad.pas',
  MemDBFTable in '..\SOURCE\MemDBFTable.pas',
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Document in '..\SOURCE\COMPONENT\Document.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  Log in '..\SOURCE\Log.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ConnectionPath := '..\INIT\farmacy_init.php';

  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
  Application.CreateForm(TMainForm, MainFormInstance);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
