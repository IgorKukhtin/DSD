program FarmacyCash;

uses
  Vcl.Forms,
  SysUtils,
  Controls,
  UtilConst in '..\SOURCE\UtilConst.pas',
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
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  MainCash in '..\FormsFarmacy\Cash\MainCash.pas' {MainCashForm: TParentForm},
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  CashInterface in '..\FormsFarmacy\Cash\CashInterface.pas',
  CashFactory in '..\FormsFarmacy\Cash\CashFactory.pas',
  Cash_FP3530T in '..\FormsFarmacy\Cash\Cash_FP3530T.pas',
  Cash_FP3530T_NEW in '..\FormsFarmacy\Cash\Cash_FP3530T_NEW.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  FP3141_TLB in '..\FormsFarmacy\Cash\FP3141_TLB.pas',
  CashCloseDialog in '..\FormsFarmacy\Cash\CashCloseDialog.pas' {CashCloseDialogForm: TParentForm},
  CashWork in '..\FormsFarmacy\Cash\CashWork.pas' {CashWorkForm},
  AncestorDialog in '..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  Cash_FP320 in '..\FormsFarmacy\Cash\Cash_FP320.pas',
  OposFiscalPrinter_1_11_Lib_TLB in '..\FormsFarmacy\Cash\OposFiscalPrinter_1_11_Lib_TLB.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  Splash in '..\FormsFarmacy\Cash\Splash.pas' {frmSplash},
  DiscountDialog in '..\FormsFarmacy\Cash\DiscountDialog.pas' {DiscountDialogForm: TParentForm},
  VIPDialog in '..\FormsFarmacy\Cash\VIPDialog.pas' {VIPDialogForm: TParentForm},
  DiscountService in '..\FormsFarmacy\DiscountService\DiscountService.pas' {DiscountServiceForm},
  uCardService in '..\FormsFarmacy\DiscountService\uCardService.pas',
  MainCash2 in '..\FormsFarmacy\Cash\MainCash2.pas' {MainCashForm2: TParentForm};

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';

  StartSplash('Старт');
  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  Begin
    //Если все хорошо создаем главную форму Application.CreateForm();
    AllowLocalConnect := False; //True;

    if FindCmdLineSwitch('autologin', true)
    then begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1111', gc_User);
     //TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
     gc_User.Local:=TRUE;// !!!НЕ ЗАГРУЖАЕТСЯ БАЗА!!!
    end
    else
        if ShowModal <> mrOk then exit;
    //then
    begin
      if not gc_User.Local then
      Begin
        TUpdater.AutomaticUpdateProgram;
        TUpdater.AutomaticCheckConnect;
      End
      else
        gc_isSetDefault := True;
      //
      Application.CreateForm(TdmMain, dmMain);
      if False then
       Application.CreateForm(TMainCashForm, MainCashForm)
      else
       Application.CreateForm(TMainCashForm2, MainCashForm);

      Application.CreateForm(TfrmSplash, frmSplash);

      EndSplash;
    end;
  End;
  Application.Run;
end.
