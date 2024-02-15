program GetEmailBoat;

uses
  MidasLib,
  Vcl.Forms,
  SysUtils,
  Main in '..\FormsFarmacy\MainUnitService\GetEmail\Main.pas' {MainForm},
  Authentication in '..\SOURCE\Authentication.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Log in '..\SOURCE\Log.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  Storage in '..\SOURCE\Storage.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  UnilWin in '..\SOURCE\UnilWin.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  DialogPswSms in '..\SOURCE\DialogPswSms.pas' {DialogPswSmsForm};

{$R *.res}

begin
  dsdProject := prBoat;
  ConnectionPath := '..\INIT\Boat_init.php';
  gc_ProgramName := 'Boat.exe';

  if FindCmdLineSwitch('realboat', true)
  then gc_AdminPassword := 'АдминАдмин'
  else gc_AdminPassword := 'Админ';

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
