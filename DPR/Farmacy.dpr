program Farmacy;

uses
  Vcl.Forms,
  Controls,
  SysUtils,
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
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
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Document in '..\SOURCE\COMPONENT\Document.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  Log in '..\SOURCE\Log.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  VKDBFDataSet in '..\SOURCE\DBF\VKDBFDataSet.pas',
  VKDBFPrx in '..\SOURCE\DBF\VKDBFPrx.pas',
  VKDBFUtil in '..\SOURCE\DBF\VKDBFUtil.pas',
  VKDBFMemMgr in '..\SOURCE\DBF\VKDBFMemMgr.pas',
  VKDBFCrypt in '..\SOURCE\DBF\VKDBFCrypt.pas',
  VKDBFGostCrypt in '..\SOURCE\DBF\VKDBFGostCrypt.pas',
  VKDBFCDX in '..\SOURCE\DBF\VKDBFCDX.pas',
  VKDBFIndex in '..\SOURCE\DBF\VKDBFIndex.pas',
  VKDBFSorters in '..\SOURCE\DBF\VKDBFSorters.pas',
  VKDBFCollate in '..\SOURCE\DBF\VKDBFCollate.pas',
  VKDBFParser in '..\SOURCE\DBF\VKDBFParser.pas',
  VKDBFNTX in '..\SOURCE\DBF\VKDBFNTX.pas',
  VKDBFSortedList in '..\SOURCE\DBF\VKDBFSortedList.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  AboutBoxUnit in '..\SOURCE\AboutBoxUnit.pas' {AboutBox},
  MainForm in '..\FormsFarmacy\MainForm.pas' {MainForm},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  UploadUnloadData in '..\FormsFarmacy\ConnectWithOld\UploadUnloadData.pas' {dmUnloadUploadData: TDataModule},
  LookAndFillSettings in '..\SOURCE\LookAndFillSettings.pas' {LookAndFillSettingsForm},
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  AncestorMain in '..\Forms\Ancestor\AncestorMain.pas' {AncestorMainForm};

{$R *.res}
{$R DevExpressRus.res}


begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';

  with TLoginForm.Create(Application) do
  //≈сли все хорошо создаем главную форму Application.CreateForm();
  if ShowModal = mrOk then
  begin
     TUpdater.AutomaticUpdateProgram;
     Application.CreateForm(TMainForm, MainFormInstance);
     Application.CreateForm(TdmMain, dmMain);
  end;
  Application.Run;
end.
