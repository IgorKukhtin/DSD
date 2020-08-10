program FarmacyCash;

uses
  MidasLib,
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
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
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
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
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
  SPDialog in '..\FormsFarmacy\Cash\SPDialog.pas' {SPDialogForm: TParentForm},
  VIPDialog in '..\FormsFarmacy\Cash\VIPDialog.pas' {VIPDialogForm: TParentForm},
  DiscountService in '..\FormsFarmacy\DiscountService\DiscountService.pas' {DiscountServiceForm},
  uCardService in '..\FormsFarmacy\DiscountService\uCardService.pas',
  MainCash2 in '..\FormsFarmacy\Cash\MainCash2.pas' {MainCashForm2: TParentForm},
  LoginFormInh in '..\FormsFarmacy\Cash\LoginFormInh.pas' {LoginForm1},
  DiscountDialog in '..\FormsFarmacy\Cash\DiscountDialog.pas' {DiscountDialogForm: TParentForm},
  LocalStorage in '..\FormsFarmacy\Cash\LocalStorage.pas',
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  PromoCodeDialog in '..\FormsFarmacy\Cash\PromoCodeDialog.pas' {PromoCodeDialogForm: TParentForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  ListDiff in '..\FormsFarmacy\Cash\ListDiff.pas' {ListDiffForm: TParentForm},
  ListGoods in '..\FormsFarmacy\Cash\ListGoods.pas' {ListGoodsForm: TParentForm},
  ListDiffAddGoods in '..\FormsFarmacy\Cash\ListDiffAddGoods.pas' {ListDiffAddGoodsForm},
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  PayPosTermProcess in '..\FormsFarmacy\Cash\PayPosTermProcess.pas' {PayPosTermProcessForm},
  Pos_ECRCommX_BPOS1Lib in '..\FormsFarmacy\Cash\Pos_ECRCommX_BPOS1Lib.pas',
  PosFactory in '..\FormsFarmacy\Cash\PosFactory.pas',
  PosInterface in '..\FormsFarmacy\Cash\PosInterface.pas',
  EmployeeWorkLog in '..\FormsFarmacy\Cash\EmployeeWorkLog.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  Cash_IKC_E810T in '..\FormsFarmacy\Cash\Cash_IKC_E810T.pas',
  NeoFiscalPrinterDriver_TLB in '..\FormsFarmacy\Cash\NeoFiscalPrinterDriver_TLB.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  ChoiceBankPOSTerminal in '..\FormsFarmacy\Cash\ChoiceBankPOSTerminal.pas' {ChoiceBankPOSTerminalForm: TParentForm},
  GoodsToExpirationDate in '..\FormsFarmacy\Cash\GoodsToExpirationDate.pas',
  ChoiceGoodsAnalog in '..\FormsFarmacy\Cash\ChoiceGoodsAnalog.pas' {ChoiceGoodsAnalogForm: TParentForm},
  Helsi in '..\FormsFarmacy\Cash\Helsi.pas',
  Cash_IKC_C651T in '..\FormsFarmacy\Cash\Cash_IKC_C651T.pas',
  ChoiceHelsiUserName in '..\FormsFarmacy\Cash\ChoiceHelsiUserName.pas' {ChoiceHelsiUserNameForm: TParentForm},
  EnterRecipeNumber in '..\FormsFarmacy\Cash\EnterRecipeNumber.pas' {EnterRecipeNumberForm},
  CheckHelsiSign in '..\FormsFarmacy\Cash\CheckHelsiSign.pas' {CheckHelsiSignForm},
  CheckHelsiSignAllUnit in '..\FormsFarmacy\Cash\CheckHelsiSignAllUnit.pas' {CheckHelsiSignAllUnitForm: TParentForm},
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  PUSHMessageCash in '..\FormsFarmacy\Cash\PUSHMessageCash.pas' {PUSHMessageCashForm},
  EmployeeScheduleCash in '..\FormsFarmacy\Cash\EmployeeScheduleCash.pas' {EmployeeScheduleCashForm: TParentForm},
  EnterLoyaltyNumber in '..\FormsFarmacy\Cash\EnterLoyaltyNumber.pas' {EnterLoyaltyNumberForm},
  Report_ImplementationPlanEmployeeCash in '..\FormsFarmacy\Cash\Report_ImplementationPlanEmployeeCash.pas' {Report_ImplementationPlanEmployeeCashForm},
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  EnterLoyaltySaveMoney in '..\FormsFarmacy\Cash\EnterLoyaltySaveMoney.pas' {EnterLoyaltySaveMoneyForm},
  LoyaltySMList in '..\FormsFarmacy\Cash\LoyaltySMList.pas' {LoyaltySMListForm: TParentForm},
  BuyerList in '..\FormsFarmacy\Cash\BuyerList.pas' {BuyerListForm},
  EnterLoyaltySMDiscount in '..\FormsFarmacy\Cash\EnterLoyaltySMDiscount.pas' {EnterLoyaltySMDiscountForm},
  GetSystemInfo in '..\SOURCE\GetSystemInfo.pas',
  ListSelection in '..\FormsFarmacy\Cash\ListSelection.pas' {ListSelectionForm},
  CashCloseReturnDialog in '..\FormsFarmacy\Cash\CashCloseReturnDialog.pas' {CashCloseReturnDialogForm: TParentForm};

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'FarmacyCash.exe';
  StartSplash('�����');
  TdsdApplication.Create;

  with TLoginForm1.Create(Application) do
  Begin
    //���� ��� ������ ������� ������� ����� Application.CreateForm();

   //  ����� ����� ��� �������
     case 2 of   // 1 ��� MainCash;  2 ��� MainCash2
     1: begin
          AllowLocalConnect := False;  //�� ������ ������� �������� ����� 'users.local' � ������� ���������� � ���������� ����� ��� ������ �����
          isMainForm_OLD:= True;
        end;
     2: begin
          AllowLocalConnect := True;  //�� ������ ������� �������� ����� 'users.local' � ������� ���������� � ���������� ����� ��� ������ �����
          isMainForm_OLD:= False;
          gc_User.LocalMaxAtempt:=2;
        end;
    end;

    if FindCmdLineSwitch('autologin', True)
    then begin
      AllowLocalConnect := True; //�� ������ ������� �������� ����� 'users.local' � ������� ���������� � ���������� ����� ��� ������ �����
      edUserName.Text := '�����';
      edPassword.Text := '�����1234';
      btnOkClick(btnOk);
//    TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����1111', gc_User); // �� �������� ������ � AllowLocalConnect := True;
      //TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����1234', gc_User);
      //if ShowModal <> mrOk then exit;   // ��� ������������ // �� ������������
      gc_User.Local:=TRUE;// !!!�� ����������� ����!!!
    end
    else if ShowModal <> mrOk then
    begin
      Free;
      exit;
    end;

    //then
    begin
      if not gc_User.Local then
      Begin
        InitCashSession;
        IniUtils.AutomaticUpdateProgram;
        if not FindCmdLineSwitch('skipcheckconnect') then TUpdater.AutomaticCheckConnect;
      End
      else
        gc_isSetDefault := True;
      //
      Application.CreateForm(TdmMain, dmMain);
  // ���������� ������� �����
      if isMainForm_OLD = TRUE
      then
           Application.CreateForm(TMainCashForm, MainCash.MainCashForm) // ��� ������ �����������
      else
          // ����� �������� � ������ � FarmacyCashServise.exe
          Application.CreateForm(TMainCashForm2, MainCash2.MainCashForm); // ��� ������ �����������


      Application.CreateForm(TfrmSplash, frmSplash);

      EndSplash;
    end;
  End;
  Application.Run;
end.
