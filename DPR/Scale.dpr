program Scale;

uses
  Vcl.Forms,
  Controls,
  Classes,
  SysUtils,
  Main in '..\Scale\Main.pas' {MainForm},
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  Storage in '..\SOURCE\Storage.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Log in '..\SOURCE\Log.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  ClientBankLoad in '..\SOURCE\COMPONENT\ClientBankLoad.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  UnilWin in '..\SOURCE\UnilWin.pas',
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  AncestorDialogScale in '..\Scale\Ancestor\AncestorDialogScale.pas' {AncestorDialogScaleForm},
  UtilScale in '..\Scale\Util\UtilScale.pas',
  dmMainScale in '..\Scale\Util\dmMainScale.pas' {DMMainScaleForm: TDataModule},
  GuideGoodsSticker in '..\Scale\GuideGoodsSticker.pas' {GuideGoodsStickerForm},
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
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  UtilPrint in '..\Scale\Util\UtilPrint.pas' {UtilPrintForm},
  SysScalesLib_TLB in '..\Scale\Util\SysScalesLib_TLB.pas',
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  GuidePartner in '..\Scale\GuidePartner.pas' {GuidePartnerForm},
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  GuideMovementReturnIn in '..\Scale\GuideMovementReturnIn.pas' {GuideMovementReturnInForm},
  DialogWeight in '..\Scale\DialogWeight.pas' {DialogWeightForm},
  DialogDateReport in '..\Scale\DialogDateReport.pas' {DialogDateReportForm: TParentForm},
  DialogPersonalComplete in '..\Scale\DialogPersonalComplete.pas' {DialogPersonalCompleteForm},
  DialogMovementDesc in '..\Scale\DialogMovementDesc.pas' {DialogMovementDescForm},
  GuidePersonal in '..\Scale\GuidePersonal.pas' {GuidePersonalForm},
  DialogPrint in '..\Scale\DialogPrint.pas' {DialogPrintForm},
  AxLibLib_TLB in '..\Scale\Util\AxLibLib_TLB.pas',
  DialogStickerTare in '..\Scale\DialogStickerTare.pas' {DialogStickerTareForm},
  GuideGoodsMovement in '..\Scale\GuideGoodsMovement.pas' {GuideGoodsMovementForm},
  GuideMovement in '..\Scale\GuideMovement.pas' {GuideMovementForm},
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  GuideGoodsPartner in '..\Scale\GuideGoodsPartner.pas' {GuideGoodsPartnerForm},
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  LookAndFillSettings in '..\SOURCE\LookAndFillSettings.pas' {LookAndFillSettingsForm},
  GuideGoods in '..\Scale\GuideGoods.pas' {GuideGoodsForm},
  DialogStringValue in '..\Scale\DialogStringValue.pas' {DialogStringValueForm},
  DialogNumberValue in '..\Scale\DialogNumberValue.pas' {DialogNumberValueForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  DialogDateValue in '..\Scale\DialogDateValue.pas' {DialogDateValueForm},
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  GuideSubjectDoc in '..\Scale\GuideSubjectDoc.pas' {GuideSubjectDocForm},
  GuideUnit in '..\Scale\GuideUnit.pas' {GuideUnitForm},
  dmMainScaleCeh in '..\Scale\Util\dmMainScaleCeh.pas',
  APScale_TLB in '..\Scale\Util\APScale_TLB.pas',
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  Medoc_J1201011 in '..\SOURCE\MeDOC\Medoc_J1201011.pas',
  Medoc_J1201211 in '..\SOURCE\MeDOC\Medoc_J1201211.pas',
  Medoc_J1201012 in '..\SOURCE\MeDOC\Medoc_J1201012.pas',
  Medoc_J1201212 in '..\SOURCE\MeDOC\Medoc_J1201212.pas',
  DialogPswSms in '..\SOURCE\DialogPswSms.pas' {DialogPswSmsForm},
  GuideGoodsRemains in '..\Scale\GuideGoodsRemains.pas' {GuideGoodsRemainsForm},
  DOCUMENTINVOICE_PRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_PRN_XML.pas',
  DOCUMENTINVOICE_TN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_TN_XML.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  GuideReason in '..\Scale\GuideReason.pas' {GuideReasonForm},
  GuideAsset in '..\Scale\GuideAsset.pas' {GuideAssetForm},
  GuideMovementTransport in '..\Scale\GuideMovementTransport.pas' {GuideMovementTransportForm};

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');

  TdsdApplication.Create;
  //
  //global Initialize
  gpInitialize_Ini;

  if FindCmdLineSwitch('autologin', true) then
  begin
         TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw1', gc_User);
         TUpdater.AutomaticUpdateProgram;
         TUpdater.AutomaticCheckConnect;
         //
         if gpCheck_BranchCode = FALSE then exit;
         //
         Application.CreateForm(TdmMain, dmMain);
         Application.CreateForm(TDMMainScaleForm, DMMainScaleForm);
         //
         // !!!важно первым!!!
         Application.CreateForm(TMainForm, MainForm);
         //
         Application.CreateForm(TDialogMovementDescForm, DialogMovementDescForm);
         if SettingMain.isSticker = TRUE
         then
             Application.CreateForm(TGuideGoodsStickerForm, GuideGoodsStickerForm)
         else begin
             Application.CreateForm(TGuideGoodsForm, GuideGoodsForm);
             Application.CreateForm(TGuideGoodsMovementForm, GuideGoodsMovementForm);
             Application.CreateForm(TGuideGoodsPartnerForm, GuideGoodsPartnerForm);
             Application.CreateForm(TGuidePartnerForm, GuidePartnerForm);
         end;
         Application.CreateForm(TUtilPrintForm, UtilPrintForm);
         Application.CreateForm(TGuideMovementForm, GuideMovementForm);
         Application.CreateForm(TGuideMovementTransportForm, GuideMovementTransportForm);
         Application.CreateForm(TGuideMovementReturnInForm, GuideMovementReturnInForm);
         Application.CreateForm(TDialogWeightForm, DialogWeightForm);
         Application.CreateForm(TDialogNumberValueForm, DialogNumberValueForm);
         Application.CreateForm(TDialogStringValueForm, DialogStringValueForm);
         Application.CreateForm(TDialogDateValueForm, DialogDateValueForm);
         Application.CreateForm(TGuidePersonalForm, GuidePersonalForm);
         Application.CreateForm(TDialogPersonalCompleteForm, DialogPersonalCompleteForm);
         Application.CreateForm(TDialogPrintForm, DialogPrintForm);
         Application.CreateForm(TDialogStickerTareForm, DialogStickerTareForm);
         Application.CreateForm(TGuideSubjectDocForm, GuideSubjectDocForm);
         Application.CreateForm(TGuideReasonForm, GuideReasonForm);
         Application.CreateForm(TGuideUnitForm, GuideUnitForm);
         Application.CreateForm(TGuideGoodsRemainsForm, GuideGoodsRemainsForm);
         Application.CreateForm(TGuideReasonForm, GuideReasonForm);
         Application.CreateForm(TGuideAssetForm, GuideAssetForm);
  end
  else

  // Процесс аутентификации
  with TLoginForm.Create(Application)
  do
    //Если все хорошо создаем главную форму Application.CreateForm();
    if ShowModal = mrOk then
    begin
         TUpdater.AutomaticUpdateProgram;
         TUpdater.AutomaticCheckConnect;
         //
         if gpCheck_BranchCode = FALSE then exit;
         //
         Application.CreateForm(TdmMain, dmMain);
         Application.CreateForm(TDMMainScaleForm, DMMainScaleForm);
         //
         // !!!важно первым!!!
         Application.CreateForm(TMainForm, MainForm);
         //
         Application.CreateForm(TDialogMovementDescForm, DialogMovementDescForm);
         if SettingMain.isSticker = TRUE
         then
             Application.CreateForm(TGuideGoodsStickerForm, GuideGoodsStickerForm)
         else begin
             Application.CreateForm(TGuideGoodsForm, GuideGoodsForm);
             Application.CreateForm(TGuideGoodsMovementForm, GuideGoodsMovementForm);
             Application.CreateForm(TGuideGoodsPartnerForm, GuideGoodsPartnerForm);
             Application.CreateForm(TGuidePartnerForm, GuidePartnerForm);
         end;
         Application.CreateForm(TUtilPrintForm, UtilPrintForm);
         Application.CreateForm(TGuideMovementForm, GuideMovementForm);
         Application.CreateForm(TGuideMovementTransportForm, GuideMovementTransportForm);
         Application.CreateForm(TGuideMovementReturnInForm, GuideMovementReturnInForm);
         Application.CreateForm(TDialogWeightForm, DialogWeightForm);
         Application.CreateForm(TDialogNumberValueForm, DialogNumberValueForm);
         Application.CreateForm(TDialogStringValueForm, DialogStringValueForm);
         Application.CreateForm(TDialogDateValueForm, DialogDateValueForm);
         Application.CreateForm(TGuidePersonalForm, GuidePersonalForm);
         Application.CreateForm(TDialogPersonalCompleteForm, DialogPersonalCompleteForm);
         Application.CreateForm(TDialogPrintForm, DialogPrintForm);
         Application.CreateForm(TDialogStickerTareForm, DialogStickerTareForm);
         Application.CreateForm(TGuideSubjectDocForm, GuideSubjectDocForm);
         Application.CreateForm(TGuideReasonForm, GuideReasonForm);
         Application.CreateForm(TGuideUnitForm, GuideUnitForm);
         Application.CreateForm(TGuideGoodsRemainsForm, GuideGoodsRemainsForm);
         Application.CreateForm(TGuideReasonForm, GuideReasonForm);
         Application.CreateForm(TGuideAssetForm, GuideAssetForm);
  end;
  //
  Application.Run;

end.
