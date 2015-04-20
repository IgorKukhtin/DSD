program FarmacyCash;

uses
  Vcl.Forms,
  SysUtils,
  Controls,
  UtilConst in '..\SOURCE\UtilConst.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  Log in '..\SOURCE\Log.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  Storage in '..\SOURCE\Storage.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  UnilWin in '..\SOURCE\UnilWin.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  VKDBFCDX in '..\SOURCE\DBF\VKDBFCDX.pas',
  VKDBFCollate in '..\SOURCE\DBF\VKDBFCollate.pas',
  VKDBFCrypt in '..\SOURCE\DBF\VKDBFCrypt.pas',
  VKDBFDataSet in '..\SOURCE\DBF\VKDBFDataSet.pas',
  VKDBFGostCrypt in '..\SOURCE\DBF\VKDBFGostCrypt.pas',
  VKDBFIndex in '..\SOURCE\DBF\VKDBFIndex.pas',
  VKDBFMemMgr in '..\SOURCE\DBF\VKDBFMemMgr.pas',
  VKDBFNTX in '..\SOURCE\DBF\VKDBFNTX.pas',
  VKDBFParser in '..\SOURCE\DBF\VKDBFParser.pas',
  VKDBFPrx in '..\SOURCE\DBF\VKDBFPrx.pas',
  VKDBFSortedList in '..\SOURCE\DBF\VKDBFSortedList.pas',
  VKDBFSorters in '..\SOURCE\DBF\VKDBFSorters.pas',
  VKDBFUtil in '..\SOURCE\DBF\VKDBFUtil.pas',
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  Updater in '..\SOURCE\COMPONENT\Updater.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';

  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  //≈сли все хорошо создаем главную форму Application.CreateForm();
  if ShowModal = mrOk then
  begin
     TUpdater.AutomaticUpdateProgram;
     TUpdater.AutomaticCheckConnect;
     Application.CreateForm(TdmMain, dmMain);
     TParentForm(TdsdFormStorageFactory.GetStorage.Load('TMainCashForm')).Execute(nil, nil);
  end;
  Application.Run;
end.
