program Boutique;

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
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  LookAndFillSettings in '..\SOURCE\LookAndFillSettings.pas' {LookAndFillSettingsForm},
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  AncestorMain in '..\Forms\Ancestor\AncestorMain.pas' {AncestorMainForm},
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  dsdXMLTransform in '..\SOURCE\COMPONENT\dsdXMLTransform.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  RoleUnion in '..\Forms\RoleUnion.pas' {RoleUnionForm: TParentForm},
  Movement_PeriodDialog in '..\FormsBoutique\Document\Movement_PeriodDialog.pas' {Movement_PeriodDialogForm: TParentForm},
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  dsdOlap in '..\SOURCE\COMPONENT\dsdOlap.pas',
  dsdOLAPXMLBind in '..\SOURCE\COMPONENT\dsdOLAPXMLBind.pas',
  GridGroupCalculate in '..\SOURCE\GridGroupCalculate.pas',
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  MainForm in '..\FormsBoutique\MainForm.pas' {MainForm},
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  Medoc_J1201011 in '..\SOURCE\MeDOC\Medoc_J1201011.pas',
  Medoc_J1201211 in '..\SOURCE\MeDOC\Medoc_J1201211.pas',
  Medoc_J1201012 in '..\SOURCE\MeDOC\Medoc_J1201012.pas',
  Medoc_J1201212 in '..\SOURCE\MeDOC\Medoc_J1201212.pas',
  DialogPswSms in '..\SOURCE\DialogPswSms.pas' {DialogPswSmsForm},
  DOCUMENTINVOICE_PRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_PRN_XML.pas',
  DOCUMENTINVOICE_TN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_TN_XML.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  StorageSQLite in '..\SOURCE\StorageSQLite.pas',
  GoogleOTP in '..\SOURCE\GoogleOTP.pas',
  GoogleOTPDialogPsw in '..\SOURCE\GoogleOTPDialogPsw.pas' {GoogleOTPDialogPswForm},
  GoogleOTPRegistration in '..\SOURCE\GoogleOTPRegistration.pas' {GoogleOTPRegistrationForm},
  PriorityPause in '..\SOURCE\PriorityPause.pas' {PriorityPauseForm},
  dsdCommon in '..\SOURCE\COMPONENT\dsdCommon.pas',
  PdfiumCore in '..\SOURCE\Pdfium\PdfiumCore.pas',
  PdfiumCtrl in '..\SOURCE\Pdfium\PdfiumCtrl.pas',
  PdfiumLib in '..\SOURCE\Pdfium\PdfiumLib.pas',
  DOCUMENTINVOICE_DRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_DRN_XML.pas',
  UAECMRXML in '..\SOURCE\EDI\UAECMRXML.pas',
  EUSignCP in '..\SOURCE\EUSignCP\EUSignCP.pas',
  EUSignCPOwnUI in '..\SOURCE\EUSignCP\EUSignCPOwnUI.pas';

{$R *.res}

begin
  Application.Initialize;
  ConnectionPath := '..\INIT\boutique_init.php';
  Logger.Enabled := FindCmdLineSwitch('log');
  gc_ProgramName := 'Boutique.exe';
  // !!! DEMO
  //ConnectionPath := 'Demo.php';
  //gc_ProgramName := 'Boutique_Demo.exe';

  TdsdApplication.Create;

  // ������� ��������������
  if gc_ProgramName = 'Boutique_Demo.exe' then
  begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'demo', 'demo', gc_User);
     TUpdater.AutomaticUpdateProgram;
     TUpdater.AutomaticCheckConnect;
     Application.CreateForm(TdmMain, dmMain);
     Application.CreateForm(TMainForm, MainFormInstance);
  end
  else

  with TLoginForm.Create(Application) do
    // ���� ��� ������ ������� ������� ����� Application.CreateForm();
    if ShowModal = mrOk then
    begin
      TUpdater.AutomaticUpdateProgram;
      TUpdater.AutomaticCheckConnect;
      Application.CreateForm(TdmMain, dmMain);
      Application.CreateForm(TMainForm, MainFormInstance);
  end;
  Application.Run;

end.
