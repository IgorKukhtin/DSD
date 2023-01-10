program Project;

uses
  Windows,
  Vcl.Forms,
  Controls,
  Classes,
  SysUtils,
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  Storage in '..\SOURCE\Storage.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  AboutBoxUnit in '..\SOURCE\AboutBoxUnit.pas' {AboutBox},
  UnilWin in '..\SOURCE\UnilWin.pas',
  UtilTimeLogger in '..\SOURCE\UtilTimeLogger.pas',
  ClientBankLoad in '..\SOURCE\COMPONENT\ClientBankLoad.pas',
  SimpleGauge in '..\SOURCE\SimpleGauge.pas',
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  dialogs,
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  Log in '..\SOURCE\Log.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
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
  LookAndFillSettings in '..\SOURCE\LookAndFillSettings.pas' {LookAndFillSettingsForm},
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  dsdOlap in '..\SOURCE\COMPONENT\dsdOlap.pas',
  dsdOLAPXMLBind in '..\SOURCE\COMPONENT\dsdOLAPXMLBind.pas',
  dsdOLAPSetup in '..\SOURCE\COMPONENT\dsdOLAPSetup.pas' {OLAPSetupForm},
  OLAPSales in '..\FormsMeat\Report\OLAP\OLAPSales.pas' {OLAPSalesForm},
  GridGroupCalculate in '..\SOURCE\GridGroupCalculate.pas',
  MainForm in '..\FormsMeat\MainForm.pas' {MainForm},
  AncestorMain in '..\Forms\Ancestor\AncestorMain.pas' {AncestorMainForm},
  Scales in '..\SOURCE\Scale\Scales.pas',
  SysScalesLib_TLB in '..\Scale\Util\SysScalesLib_TLB.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  dsdXMLTransform in '..\SOURCE\COMPONENT\dsdXMLTransform.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  MeDocCOM in '..\SOURCE\MeDOC\MeDocCOM.pas',
  MEDOC_TLB in '..\SOURCE\MeDOC\MEDOC_TLB.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  RunScript in '..\SOURCE\AutoMode\RunScript.pas',
  ScriptXML in '..\SOURCE\AutoMode\ScriptXML.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  BarCodeBoxEdit in '..\Forms\Guides\BarCodeBoxEdit.pas' {BarCodeBoxEditForm: TParentForm},
  BarCodeBox in '..\Forms\Guides\BarCodeBox.pas' {BarCodeBoxForm: TParentForm},
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  LabMarkEdit in '..\Forms\Guides\LabMarkEdit.pas' {LabMarkEditForm: TParentForm},
  LabMark in '..\Forms\Guides\LabMark.pas' {LabMarkForm: TParentForm},
  LabProduct in '..\Forms\Guides\LabProduct.pas' {LabProductForm: TParentForm},
  LabProductEdit in '..\Forms\Guides\LabProductEdit.pas' {LabProductEditForm: TParentForm},
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  Medoc_J1201011 in '..\SOURCE\MeDOC\Medoc_J1201011.pas',
  Medoc_J1201211 in '..\SOURCE\MeDOC\Medoc_J1201211.pas',
  Medoc_J1201012 in '..\SOURCE\MeDOC\Medoc_J1201012.pas',
  Medoc_J1201112 in '..\SOURCE\MeDOC\Medoc_J1201112.pas',
  Medoc_J1201212 in '..\SOURCE\MeDOC\Medoc_J1201212.pas',
  DOCUMENTINVOICE_PRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_PRN_XML.pas',
  DOCUMENTINVOICE_TN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_TN_XML.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  GoogleOTP in '..\SOURCE\GoogleOTP.pas',
  GoogleOTPDialogPsw in '..\SOURCE\GoogleOTPDialogPsw.pas' {GoogleOTPDialogPswForm},
  GoogleOTPRegistration in '..\SOURCE\GoogleOTPRegistration.pas' {GoogleOTPRegistrationForm};

{$R *.res}
{$R DevExpressRus.res}

var i: integer;

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');

  if FindCmdLineSwitch('autosrcipt', true) then begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw11', gc_User);
     i := 0;
     while ParamStr(i) <> '/autosrcipt' do
           inc(i);
     TRunScript.RunScript(ParamStr(i + 1));
     exit;
  end;

  TdsdApplication.Create;
  // Процесс аутентификации
  if FindCmdLineSwitch('autologin', true) then begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Климентьев К.И.', 'qsxqsxw1', gc_User);
     TUpdater.AutomaticUpdateProgram;
     TUpdater.AutomaticCheckConnect;
     Application.CreateForm(TdmMain, dmMain);
     Application.CreateForm(TMainForm, MainFormInstance);
  end
  else
    with TLoginForm.Create(Application) do
      //Если все хорошо создаем главную форму Application.CreateForm();
      if ShowModal = mrOk then
      begin
         TUpdater.AutomaticUpdateProgram;
         TUpdater.AutomaticCheckConnect;
         Application.ProcessMessages;
         Application.CreateForm(TdmMain, dmMain);
         Application.CreateForm(TMainForm, MainFormInstance);
      end;
  Application.Run;
end.
