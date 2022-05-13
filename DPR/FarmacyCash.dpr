program FarmacyCash;

uses
  MidasLib,
  Windows,
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
  CashCloseReturnDialog in '..\FormsFarmacy\Cash\CashCloseReturnDialog.pas' {CashCloseReturnDialogForm: TParentForm},
  Cash_Emulation in '..\FormsFarmacy\Cash\Cash_Emulation.pas',
  Cash_MINI_FP54 in '..\FormsFarmacy\Cash\Cash_MINI_FP54.pas',
  ecrmini_TLB in '..\FormsFarmacy\Cash\ecrmini_TLB.pas',
  ChoiceListDiff in '..\FormsFarmacy\Cash\ChoiceListDiff.pas' {ChoiceListDiffForm: TParentForm},
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  ChoosingPresent in '..\FormsFarmacy\Cash\ChoosingPresent.pas' {ChoosingPresentForm: TParentForm},
  SelectionFromDirectory in '..\FormsFarmacy\Cash\SelectionFromDirectory.pas' {SelectionFromDirectoryForm: TParentForm},
  ChoosingRelatedProduct in '..\FormsFarmacy\Cash\ChoosingRelatedProduct.pas' {ChoosingRelatedProductForm},
  EditFromDirectory in '..\FormsFarmacy\Cash\EditFromDirectory.pas' {EditFromDirectoryForm: TParentForm},
  HardwareDialog in '..\FormsFarmacy\Cash\HardwareDialog.pas' {HardwareDialogForm},
  UnitTreeCash in '..\FormsFarmacy\Cash\UnitTreeCash.pas' {UnitTreeCashForm: TParentForm},
  LikiDniproReceiptDialog in '..\FormsFarmacy\Cash\LikiDniproReceiptDialog.pas' {LikiDniproReceiptDialogForm: TParentForm},
  EnterRecipeNumber1303 in '..\FormsFarmacy\Cash\EnterRecipeNumber1303.pas' {EnterRecipeNumber1303Form},
  LikiDniproReceipt in '..\FormsFarmacy\Cash\LikiDniproReceipt.pas',
  ListGoodsBadTiming in '..\FormsFarmacy\Cash\ListGoodsBadTiming.pas' {ListGoodsBadTimingForm: TParentForm},
  ListGoodsIlliquidMarketing in '..\FormsFarmacy\Cash\ListGoodsIlliquidMarketing.pas' {ListGoodsIlliquidMarketingForm: TParentForm},
  LikiDniproeHealth in '..\FormsFarmacy\Cash\LikiDniproeHealth.pas',
  CallbackHandler in '..\FormsFarmacy\Cash\CallbackHandler.pas' {CallbackHandlerForm},
  ChoosingPairSun in '..\FormsFarmacy\Cash\ChoosingPairSun.pas' {ChoosingPairSunForm},
  TestingUser in '..\FormsFarmacy\Cash\TestingUser.pas' {TestingUserForm},
  CashCloseJeckdawsDialog in '..\FormsFarmacy\Cash\CashCloseJeckdawsDialog.pas' {CashCloseJeckdawsDialogForm: TParentForm},
  dsdXMLTransform in '..\SOURCE\COMPONENT\dsdXMLTransform.pas',
  PrintSendDialog in '..\FormsFarmacy\Cash\PrintSendDialog.pas' {PrintSendDialogForm: TParentForm},
  UnitGetCash in '..\FormsFarmacy\Cash\UnitGetCash.pas',
  ChoiceMedicalProgramSP in '..\FormsFarmacy\Cash\ChoiceMedicalProgramSP.pas' {ChoiceMedicalProgramSPForm: TParentForm},
  VchasnoKasaAPI in '..\FormsFarmacy\Cash\VchasnoKasaAPI.pas',
  Cash_VchasnoKasa in '..\FormsFarmacy\Cash\Cash_VchasnoKasa.pas',
  CheckHelsiSignPUSH in '..\FormsFarmacy\Cash\CheckHelsiSignPUSH.pas' {CheckHelsiSignPUSHForm: TParentForm},
  PrinterInterface in '..\FormsFarmacy\Cash\PrinterInterface.pas',
  PrinterFactory in '..\FormsFarmacy\Cash\PrinterFactory.pas',
  Printer_FP3530T_NEW in '..\FormsFarmacy\Cash\Printer_FP3530T_NEW.pas',
  Printer_Emulation in '..\FormsFarmacy\Cash\Printer_Emulation.pas',
  ListGoodsKeyword in '..\FormsFarmacy\Cash\ListGoodsKeyword.pas' {ListGoodsKeywordForm: TParentForm};

{$R *.res}

  var hMutexCurr: HWND;

begin

  hMutexCurr := CreateMutex(nil, false, PChar(ExtractFileName(ParamStr(0))));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(hMutexCurr);
    MessageBox(FindWindow('ProgMan', nil), PChar('Программа уже запущена.'), 'Ошибка', MB_OK);
    Exit;
  end;

  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'FarmacyCash.exe';
  StartSplash('Старт');
  TdsdApplication.Create;

  with TLoginForm1.Create(Application) do
  Begin
    //Если все хорошо создаем главную форму Application.CreateForm();

   //  Выбор формы для запуска
     case 2 of   // 1 для MainCash;  2 для MainCash2
     1: begin
          AllowLocalConnect := False;  //от режима зависит создание файла 'users.local' и переход приложения в автономный режим при обрыве звязи
          isMainForm_OLD:= True;
        end;
     2: begin
          AllowLocalConnect := True;  //от режима зависит создание файла 'users.local' и переход приложения в автономный режим при обрыве звязи
          isMainForm_OLD:= False;
          gc_User.LocalMaxAtempt:=2;
        end;
    end;

    if FindCmdLineSwitch('autologin', True)
    then begin
      AllowLocalConnect := True; //от режима зависит создание файла 'users.local' и переход приложения в автономный режим при обрыве звязи
      edUserName.Text := 'Админ';
      edPassword.Text := 'Админ1234';
      btnOkClick(btnOk);
//    TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1111', gc_User); // не работает вмести с AllowLocalConnect := True;
      //TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
      //if ShowModal <> mrOk then exit;   // для тестирования // НЕ закомменчено
      gc_User.Local:=TRUE;// !!!НЕ ЗАГРУЖАЕТСЯ БАЗА!!!
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
        InitCashSession(True);
        IniUtils.AutomaticUpdateProgramTest;
        IniUtils.AutomaticUpdateProgram;
        IniUtils.AutomaticUpdateFarmacyCashServise;
        if not FindCmdLineSwitch('skipcheckconnect') then TUpdater.AutomaticCheckConnect;
      End
      else
        gc_isSetDefault := True;
      //
      Application.CreateForm(TdmMain, dmMain);
  // определяет главную форму
      if isMainForm_OLD = TRUE
      then
           Application.CreateForm(TMainCashForm, MainCash.MainCashForm) // имя модуля обязательно
      else
          // Форма работате в связке с FarmacyCashServise.exe
          Application.CreateForm(TMainCashForm2, MainCash2.MainCashForm); // имя модуля обязательно


      Application.CreateForm(TfrmSplash, frmSplash);

      EndSplash;
    end;
  End;
  Application.Run;
  CloseHandle(hMutexCurr);
end.
