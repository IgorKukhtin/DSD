program ScaleCeh;

uses
  Vcl.Forms,
  Controls,
  Classes,
  SysUtils,
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
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  DialogDateValue in '..\Scale\DialogDateValue.pas' {DialogDateValueForm: TParentForm},
  DialogPrint in '..\Scale\DialogPrint.pas' {DialogPrintForm},
  AxLibLib_TLB in '..\Scale\Util\AxLibLib_TLB.pas',
  dmMainScaleCeh in '..\ScaleCeh\Util\dmMainScaleCeh.pas' {DMMainScaleCehForm: TDataModule},
  GuideMovementCeh in '..\ScaleCeh\GuideMovementCeh.pas' {GuideMovementCehForm},
  MainCeh in '..\ScaleCeh\MainCeh.pas' {MainCehForm},
  DialogMovementDesc in '..\Scale\DialogMovementDesc.pas' {DialogMovementDescForm},
  dmMainScale in '..\ScaleCeh\Util\dmMainScale.pas',
  GuidePartner in '..\Scale\GuidePartner.pas' {GuidePartnerForm},
  DialogMessage in '..\ScaleCeh\DialogMessage.pas' {DialogMessageForm},
  DialogNumberValue in '..\Scale\DialogNumberValue.pas' {DialogNumberValueForm},
  DialogStringValue in '..\Scale\DialogStringValue.pas' {DialogStringValueForm},
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas';

{$R *.res}

begin
  Application.Initialize;

  TdsdApplication.Create;
  //global Initialize
  gpInitialize_Ini;


  if FindCmdLineSwitch('autologin', true) then
  begin
         TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'qsxqsxw1', gc_User);
         TUpdater.AutomaticUpdateProgram;
         TUpdater.AutomaticCheckConnect;
         //
         if gpCheck_BranchCode = FALSE then exit;
         //
         Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TDMMainScaleCehForm, DMMainScaleCehForm);
  // !!!����� ������!!!
  Application.CreateForm(TMainCehForm, MainCehForm);
         Application.CreateForm(TDialogMovementDescForm, DialogMovementDescForm);
         MainCehForm.InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);//!!!����� TDialogMovementDescForm, �.�. ��� GoodsKindWeighingGroupId!!!!
         Application.CreateForm(TUtilPrintForm, UtilPrintForm);
         Application.CreateForm(TGuideMovementCehForm, GuideMovementCehForm);
         Application.CreateForm(TDialogNumberValueForm, DialogNumberValueForm);
         Application.CreateForm(TDialogStringValueForm, DialogStringValueForm);
         Application.CreateForm(TDialogDateValueForm, DialogDateValueForm);
         Application.CreateForm(TDialogPrintForm, DialogPrintForm);
         Application.CreateForm(TDialogMessageForm, DialogMessageForm);
  end
  else

  // ������� ��������������
  with TLoginForm.Create(Application)
  do
    //���� ��� ������ ������� ������� ����� Application.CreateForm();
    if ShowModal = mrOk then
    begin
         TUpdater.AutomaticUpdateProgram;
         TUpdater.AutomaticCheckConnect;
         //
         if gpCheck_BranchCode = FALSE then exit;
         //
         Application.CreateForm(TdmMain, dmMain);
         Application.CreateForm(TDMMainScaleCehForm, DMMainScaleCehForm);
  // !!!����� ������!!!
  Application.CreateForm(TMainCehForm, MainCehForm);
         Application.CreateForm(TDialogMovementDescForm, DialogMovementDescForm);
         MainCehForm.InitializeGoodsKind(ParamsMovement.ParamByName('GoodsKindWeighingGroupId').AsInteger);//!!!����� TDialogMovementDescForm, �.�. ��� GoodsKindWeighingGroupId!!!!
         Application.CreateForm(TUtilPrintForm, UtilPrintForm);
         Application.CreateForm(TGuideMovementCehForm, GuideMovementCehForm);
         Application.CreateForm(TDialogNumberValueForm, DialogNumberValueForm);
         Application.CreateForm(TDialogStringValueForm, DialogStringValueForm);
         Application.CreateForm(TDialogDateValueForm, DialogDateValueForm);
         Application.CreateForm(TDialogPrintForm, DialogPrintForm);
         Application.CreateForm(TDialogMessageForm, DialogMessageForm);
  end;
  //
  Application.Run;

end.
