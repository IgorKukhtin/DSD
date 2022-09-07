unit MainCash2;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.StrUtils, System.IOUtils, System.UITypes,
  Vcl.Graphics, System.DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorBase, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ExtCtrls, cxSplitter, dsdDB, Datasnap.DBClient, cxContainer,
  cxTextEdit, cxCurrencyEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, Vcl.Menus, cxCheckBox, Vcl.StdCtrls,
  cxButtons, cxNavigator, CashInterface, IniFIles, cxImageComboBox, dxmdaset,
  ActiveX, Math, ShellApi, System.JSON,
  VKDBFDataSet, FormStorage, CommonData, ParentForm, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, LocalStorage, cxGridExportLink,
  cxButtonEdit, PosInterface, PosFactory, PayPosTermProcess,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  Vcl.ComCtrls, cxBlobEdit, cxMemo, cxRichEdit, cxEditRepositoryItems,
  dxDateRanges;

type

  TMainCashForm2 = class(TAncestorBaseForm)
    MainGridDBTableView: TcxGridDBTableView;
    MainGridLevel: TcxGridLevel;
    MainGrid: TcxGrid;
    BottomPanel: TPanel;
    CheckGridDBTableView: TcxGridDBTableView;
    CheckGridLevel: TcxGridLevel;
    CheckGrid: TcxGrid;
    AlternativeGridDBTableView: TcxGridDBTableView;
    AlternativeGridLevel: TcxGridLevel;
    AlternativeGrid: TcxGrid;
    cxSplitter1: TcxSplitter;
    SearchPanel: TPanel;
    cxSplitter2: TcxSplitter;
    MainPanel: TPanel;
    CheckGridColCode: TcxGridDBColumn;
    CheckGridColName: TcxGridDBColumn;
    CheckGridColPrice: TcxGridDBColumn;
    CheckGridColAmount: TcxGridDBColumn;
    CheckGridColSumm: TcxGridDBColumn;
    AlternativeGridColGoodsCode: TcxGridDBColumn;
    AlternativeGridColGoodsName: TcxGridDBColumn;
    MainColCode: TcxGridDBColumn;
    MainColName: TcxGridDBColumn;
    MainColRemains: TcxGridDBColumn;
    MainColPrice: TcxGridDBColumn;
    MainColReserved: TcxGridDBColumn;
    dsdDBViewAddOnMain: TdsdDBViewAddOn;
    RemainsDS: TDataSource;
    RemainsCDS: TClientDataSet;
    cxLabel1: TcxLabel;
    lcName: TcxLookupComboBox;
    actChoiceGoodsInRemainsGrid: TAction;
    actSold: TAction;
    PopupMenu: TPopupMenu;
    actSold1: TMenuItem;
    N1: TMenuItem;
    FormParams: TdsdFormParams;
    cbSpec: TcxCheckBox;
    actCheck: TdsdOpenForm;
    btnCheck: TcxButton;
    actInsertUpdateCheckItems: TAction;
    spSelectCheck: TdsdStoredProc;
    CheckDS: TDataSource;
    CheckCDS: TClientDataSet;
    MainColMCSValue: TcxGridDBColumn;
    cxLabel2: TcxLabel;
    lblTotalSumm: TcxLabel;
    dsdDBViewAddOnCheck: TdsdDBViewAddOn;
    actPutCheckToCash: TAction;
    AlternativeGridColLinkType: TcxGridDBColumn;
    AlternativeCDS: TClientDataSet;
    AlternativeDS: TDataSource;
    spSelect_Alternative: TdsdStoredProc;
    dsdDBViewAddOnAlternative: TdsdDBViewAddOn;
    actSetVIP: TAction;
    VIP1: TMenuItem;
    AlternativeGridColTypeColor: TcxGridDBColumn;
    AlternativeGridDColPrice: TcxGridDBColumn;
    AlternativeGridColRemains: TcxGridDBColumn;
    btnVIP: TcxButton;
    actOpenCheckVIP: TOpenChoiceForm;
    actLoadVIP: TMultiAction;
    actUpdateRemains: TAction;
    actCalcTotalSumm: TAction;
    actCashWork: TAction;
    N3: TMenuItem;
    actClearAll: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    lblMoneyInCash: TcxLabel;
    actClearMoney: TAction;
    N7: TMenuItem;
    actGetMoneyInCash: TAction;
    N8: TMenuItem;
    spGetMoneyInCash: TdsdStoredProc;
    spGet_Password_MoneyInCash: TdsdStoredProc;
    actSpec: TAction;
    N9: TMenuItem;
    actRefreshLite: TdsdDataSetRefresh;
    actOpenMCS_LiteForm: TdsdOpenForm;
    btnOpenMCSForm: TcxButton;
    spGet_User_IsAdmin: TdsdStoredProc;
    actSetFocus: TAction;
    N10: TMenuItem;
    actRefreshRemains: TAction;
    spDelete_CashSession: TdsdStoredProc;
    DiffCDS: TClientDataSet;
    spSelect_CashRemains_Diff: TdsdStoredProc;
    actExecuteLoadVIP: TAction;
    actRefreshAll: TAction;
    ShapeState: TShape;
    actSelectCheck: TdsdExecStoredProc;
    TimerSaveAll: TTimer;
    pnlVIP: TPanel;
    Label1: TLabel;
    lblCashMember: TLabel;
    Label2: TLabel;
    lblBayer: TLabel;
    chbNotMCS: TcxCheckBox;
    MainColor_calc: TcxGridDBColumn;
    MaincolisFirst: TcxGridDBColumn;
    MaincolIsSecond: TcxGridDBColumn;
    cxButton1: TcxButton;
    actChoiceGoodsFromRemains: TOpenChoiceForm;
    TimerMoneyInCash: TTimer;
    MaincolIsPromo: TcxGridDBColumn;
    actSelectLocalVIPCheck: TAction;
    actCheckConnection: TAction;
    N2: TMenuItem;
    miCheckConnection: TMenuItem;
    spUpdate_UnitForFarmacyCash: TdsdStoredProc;
    CheckGridColPriceSale: TcxGridDBColumn;
    CheckGridColChangePercent: TcxGridDBColumn;
    CheckGridColSummChangePercent: TcxGridDBColumn;
    CheckGridColAmountOrder: TcxGridDBColumn;
    pnlDiscount: TPanel;
    Label3: TLabel;
    lblDiscountExternalName: TLabel;
    Label5: TLabel;
    lblDiscountCardNumber: TLabel;
    miSetDiscountExternal: TMenuItem;
    actSetDiscountExternal: TAction;
    TimerBlinkBtn: TTimer;
    spGet_BlinkVIP: TdsdStoredProc;
    actSetConfirmedKind_UnComplete: TAction;
    actSetConfirmedKind_Complete: TAction;
    N12: TMenuItem;
    VIP3: TMenuItem;
    VIP4: TMenuItem;
    spUpdate_ConfirmedKind: TdsdStoredProc;
    mainMinExpirationDate: TcxGridDBColumn;
    MainColor_ExpirationDate: TcxGridDBColumn;
    actOpenMCSForm: TdsdOpenForm;
    N13: TMenuItem;
    N14: TMenuItem;
    spGet_BlinkCheck: TdsdStoredProc;
    actOpenCheckVIP_Error: TOpenChoiceForm;
    actOpenCheckVIPError1: TMenuItem;
    spCheck_RemainsError: TdsdStoredProc;
    actShowMessage: TShowMessageAction;
    MainConditionsKeepName: TcxGridDBColumn;
    MainGoodsGroupName: TcxGridDBColumn;
    MainAmountIncome: TcxGridDBColumn;
    MainPriceSaleIncome: TcxGridDBColumn;
    MainNDS: TcxGridDBColumn;
    Panel1: TPanel;
    ceScaner: TcxCurrencyEdit;
    lbScaner: TLabel;
    MainisGoodsId_main: TcxGridDBColumn;
    MemData: TdxMemData; // только 2 форма
    MemDataID: TIntegerField; // только 2 форма
    MemDataGOODSCODE: TIntegerField; // только 2 форма
    MemDataGOODSNAME: TStringField; // только 2 форма
    MemDataPRICE: TFloatField; // только 2 форма
    MemDataREMAINS: TFloatField; // только 2 форма
    MemDataMCSVALUE: TFloatField; // только 2 форма
    MemDataRESERVED: TFloatField; // только 2 форма
    MemDataNEWROW: TBooleanField; // только 2 форма
    actAddDiffMemdata: TAction; // только 2 форма
    actSetRimainsFromMemdata: TAction; // только 2 форма
    actServiseRun: TAction; // только 2 форма
    MainColIsSP: TcxGridDBColumn;
    MainColPriceSP: TcxGridDBColumn;
    actSetSP: TAction;
    pnlSP: TPanel;
    Label4: TLabel;
    lblSPKindName: TLabel;
    Label7: TLabel;
    lblMedicSP: TLabel;
    miSetSP: TMenuItem;
    MainColPriceSaleSP: TcxGridDBColumn;
    MainColIntenalSPName: TcxGridDBColumn;
    actOpenGoodsSP_UserForm: TdsdOpenForm;
    miOpenGoodsSP_UserForm: TMenuItem;
    lblPrice: TLabel;
    edPrice: TcxCurrencyEdit;
    spGet_JuridicalList: TdsdStoredProc;
    actGetJuridicalList: TAction;
    miGetJuridicalList: TMenuItem;
    lblAmount: TLabel;
    edDiscountAmount: TcxCurrencyEdit;
    BarCode: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn; // только 2 форма
    actUpdateRemainsCDS: TdsdUpdateDataSet;
    spUpdate_Object_Price: TdsdStoredProc;
    PanelMCSAuto: TPanel;
    Label6: TLabel;
    edDays: TcxCurrencyEdit;
    miMCSAuto: TMenuItem;
    actSetFilter: TAction;
    actSetPromoCode: TAction;
    miSetPromo: TMenuItem;
    pnlPromoCode: TPanel;
    Label8: TLabel;
    lblPromoName: TLabel;
    Label10: TLabel;
    lblPromoCode: TLabel;
    Label12: TLabel;
    edPromoCodeChangePrice: TcxCurrencyEdit;
    mdCheck: TdxMemData;
    mdCheckID: TIntegerField;
    mdCheckAMOUNT: TCurrencyField;
    miPrintNotFiscalCheck: TMenuItem;
    mmSaveToExcel: TMenuItem;
    SaveExcelDialog: TSaveDialog;
    TimerServiceRun: TTimer;
    actManualDiscount: TAction;
    miManualDiscount: TMenuItem;
    pnlManualDiscount: TPanel;
    Label9: TLabel;
    Label15: TLabel;
    edManualDiscount: TcxCurrencyEdit;
    actDivisibilityDialog: TAction;
    edAmount: TcxTextEdit;
    MainisAccommodationName: TcxGridDBColumn;
    spUpdate_Accommodation: TdsdStoredProc;
    actOpenAccommodation: TOpenChoiceForm;
    MemDataACCOMID: TIntegerField;
    Label11: TLabel;
    edPromoCode: TcxTextEdit;
    spGet_PromoCode_by_GUID: TdsdStoredProc;
    MainGridPriceChange: TcxGridDBColumn;
    MemDataACCOMNAME: TStringField;
    actDeleteAccommodation: TAction;
    mmDeleteAccommodation: TMenuItem;
    spDelete_Accommodation: TdsdStoredProc;
    actExpirationDateFilter: TAction;
    N11: TMenuItem;
    pnlExpirationDateFilter: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    edlExpirationDateFilter: TcxTextEdit;
    actListDiffAddGoods: TAction;
    N15: TMenuItem;
    N16: TMenuItem;
    actShowListDiff: TAction;
    N17: TMenuItem;
    N18: TMenuItem;
    actListGoods: TAction;
    N19: TMenuItem;
    actOpenCheckVIP_Search: TOpenChoiceForm;
    actLoadVIP_Search: TMultiAction;
    pm_OpenVIP: TPopupMenu;
    pm_VIP1: TMenuItem;
    pm_VIP2: TMenuItem;
    CheckGridColor_calc: TcxGridDBColumn;
    CheckGridColor_ExpirationDate: TcxGridDBColumn;
    CheckGridAccommodationName: TcxGridDBColumn;
    actCashListDiffPeriod: TdsdOpenForm;
    N20: TMenuItem;
    CashListDiffCDS: TClientDataSet;
    spSelect_CashListDiffGoods: TdsdStoredProc;
    spUpdate_CashSerialNumber: TdsdStoredProc;
    actSetSiteDiscount: TAction;
    N21: TMenuItem;
    pnlSiteDiscount: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    edSiteDiscount: TcxCurrencyEdit;
    spGlobalConst_SiteDiscount: TdsdStoredProc;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    MainFixPercent: TcxGridDBColumn;
    actExecGet_Movement_GoodsSP_ID: TdsdExecStoredProc;
    gpGet_Movement_GoodsSP_ID: TdsdStoredProc;
    actEmployeeScheduleUser: TdsdOpenForm;
    N22: TMenuItem;
    BankPOSTerminalCDS: TClientDataSet;
    UnitConfigCDS: TClientDataSet;
    pnlTaxUnitNight: TPanel;
    Label18: TLabel;
    TaxUnitNightCDS: TClientDataSet;
    MainColPriceNight: TcxGridDBColumn;
    MainGridPriceChangeNight: TcxGridDBColumn;
    edTaxUnitNight: TcxTextEdit;
    cbSpecCorr: TcxCheckBox;
    actSpecCorr: TAction;
    TimerPUSH: TTimer;
    spGet_PUSH_Cash: TdsdStoredProc;
    PUSHDS: TClientDataSet;
    actDoesNotShare: TAction;
    actUpdateRemainsCDS1: TMenuItem;
    spDoesNotShare: TdsdStoredProc;
    spInsert_MovementItem_PUSH: TdsdStoredProc;
    MainMultiplicity: TcxGridDBColumn;
    actOpenCashGoodsOneToExpirationDate: TdsdOpenForm;
    actCashGoodsOneToExpirationDate: TAction;
    MainisGoodsAnalog: TcxGridDBColumn;
    actOpenDelayVIPForm: TdsdOpenForm;
    VIP2: TMenuItem;
    actGoodsAnalog: TAction;
    actGoodsAnalogChoose: TAction;
    N23: TMenuItem;
    N24: TMenuItem;
    pnlAnalogFilter: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    edAnalogFilter: TcxTextEdit;
    actSetSPHelsi: TAction;
    N25: TMenuItem;
    N26: TMenuItem;
    spDelete_AccommodationAllID: TdsdStoredProc;
    spDelete_AccommodationAll: TdsdStoredProc;
    actDeleteAccommodationAllId: TAction;
    actDeleteAccommodationAll: TAction;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    MemDataMEXPDATE: TDateTimeField;
    MemDataPDKINDID: TIntegerField;
    MemDataPDKINDNAME: TStringField;
    MemDataCOLORCALC: TIntegerField;
    MainisPartionDateKindName: TcxGridDBColumn;
    ExpirationDateCDS: TClientDataSet;
    ExpirationDateDS: TDataSource;
    ExpirationDateGrid: TcxGrid;
    ExpirationDateView: TcxGridDBTableView;
    ExpirationDateExpirationDate: TcxGridDBColumn;
    ExpirationDateColor_calc: TcxGridDBColumn;
    ExpirationDateAmount: TcxGridDBColumn;
    ExpirationDateLevel: TcxGridLevel;
    dsdDBViewAddOnExpirationDate: TdsdDBViewAddOn;
    spGet_Movement_InvNumberSP: TdsdStoredProc;
    pnlHelsiError: TPanel;
    Label21: TLabel;
    edHelsiError: TcxTextEdit;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    pm_OpenCheck: TPopupMenu;
    pm_Check: TMenuItem;
    pm_CheckHelsi: TMenuItem;
    pm_CheckHelsiAllUnit: TMenuItem;
    Label22: TLabel;
    lblPromoBayerName: TLabel;
    MemDataAMOUNTMON: TFloatField;
    MemDataPricePD: TFloatField;
    MainPricePartionDate: TcxGridDBColumn;
    TimerDroppedDown: TTimer;
    CheckGridPartionDateKindName: TcxGridDBColumn;
    mdCheckPDKINDID: TIntegerField;
    ProgressBar1: TProgressBar;
    TimerAnalogFilter: TTimer;
    cxButton7: TcxButton;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1BlobItem1: TcxEditRepositoryBlobItem;
    pmOverdueJournal: TMenuItem;
    actOverdueJournal: TdsdOpenForm;
    N30: TMenuItem;
    actReport_GoodsRemainsCash: TdsdOpenForm;
    actReportGoodsRemainsCash1: TMenuItem;
    MainNotSold: TcxGridDBColumn;
    actSendCashJournal: TdsdOpenForm;
    N31: TMenuItem;
    MainMakerName: TcxGridDBColumn;
    actSendCashJournalSun: TdsdOpenForm;
    N32: TMenuItem;
    MemDataDEFERENDS: TFloatField;
    MainDeferredSend: TcxGridDBColumn;
    MemDataREMAINSSUN: TFloatField;
    MainRemainsSun: TcxGridDBColumn;
    actOpenWagesUser: TdsdOpenForm;
    actWagesUser: TAction;
    actDataDialog: TExecuteDialog;
    actExecInventoryEveryMonth: TdsdExecStoredProc;
    actDOCReportInventoryEveryMonth: TdsdDOCReportFormAction;
    actInventoryEveryMonth: TMultiAction;
    spInventoryEveryMonth: TdsdStoredProc;
    cdsInventoryEveryMonth: TClientDataSet;
    N33: TMenuItem;
    N34: TMenuItem;
    spGet_BanCash: TdsdStoredProc;
    actBanCash: TAction;
    MainNotTransferTime: TcxGridDBColumn;
    actNotTransferTime: TAction;
    N35: TMenuItem;
    spLoyaltyGUID: TdsdStoredProc;
    actSetPromoCodeLoyalty: TAction;
    N36: TMenuItem;
    spLoyaltyCheckGUID: TdsdStoredProc;
    pnlPromoCodeLoyalty: TPanel;
    Label23: TLabel;
    Label25: TLabel;
    lblPromoCodeLoyalty: TLabel;
    Label27: TLabel;
    edPromoCodeLoyaltySumm: TcxCurrencyEdit;
    spLoyaltyStatus: TdsdStoredProc;
    actOpenMCS: TAction;
    actReport_IlliquidReductionPlanAll: TdsdOpenForm;
    actReport_ImplementationPlanEmployee: TAction;
    N37: TMenuItem;
    N38: TMenuItem;
    MainFixDiscount: TcxGridDBColumn;
    edPermanentDiscount: TcxTextEdit;
    Label24: TLabel;
    actSetLoyaltySaveMoney: TAction;
    N39: TMenuItem;
    pnlLoyaltySaveMoney: TPanel;
    Label26: TLabel;
    Label28: TLabel;
    lblLoyaltySMBuyer: TLabel;
    lblLoyaltySMSummaRemainder: TLabel;
    edLoyaltySMSummaRemainder: TcxCurrencyEdit;
    cxButton8: TcxButton;
    edLoyaltySMSumma: TcxCurrencyEdit;
    lblLoyaltySMSumma: TLabel;
    spLoyaltySM: TdsdStoredProc;
    LoyaltySMCDS: TClientDataSet;
    spInsertMovementItem: TdsdStoredProc;
    MainNotSold60: TcxGridDBColumn;
    spLoyaltySaveMoneyChekInfo: TdsdStoredProc;
    spCheckItem_SPKind_1303: TdsdStoredProc;
    Panel2: TPanel;
    Panel3: TPanel;
    lblPartnerMedicalName: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    lblMemberSP: TLabel;
    actTechnicalRediscountCurr: TdsdOpenForm;
    actTechnicalRediscountCashier: TdsdOpenForm;
    actTechnicalRediscount: TAction;
    pmTechnicalRediscount: TMenuItem;
    pmTechnicalRediscountCashier: TMenuItem;
    spGet_Movement_TechnicalRediscount_Id: TdsdStoredProc;
    actPromoCodeDoctor: TAction;
    actChoicePromoCodeDoctor: TOpenChoiceForm;
    pmPromoCodeDoctor: TMenuItem;
    spUpdateHardwareDataCash: TdsdStoredProc;
    spUpdateHardwareData: TdsdStoredProc;
    actSaveHardwareData: TAction;
    N40: TMenuItem;
    MemDataNDS: TFloatField;
    MemDataNDSKINDID: TIntegerField;
    CheckGridNDS: TcxGridDBColumn;
    mdCheckNDSKINDID: TIntegerField;
    MainGoodsAnalogATC: TcxGridDBColumn;
    MainGoodsActiveSubstance: TcxGridDBColumn;
    actUpdateProgram: TAction;
    N41: TMenuItem;
    actSendCashJournalVip: TdsdOpenForm;
    VIP5: TMenuItem;
    MainGoodsDiscountName: TcxGridDBColumn;
    MemDataDISCEXTID: TIntegerField;
    MemDataDISCEXTNAME: TStringField;
    MemDataGOODSDIID: TIntegerField;
    MemDataGOODSDINAME: TStringField;
    mdCheckDISCEXTID: TIntegerField;
    ceSummCard: TcxCurrencyEdit;
    Label29: TLabel;
    Panel4: TPanel;
    plSummCard: TPanel;
    actSendPartionDateChangeCashJournal: TdsdOpenForm;
    N42: TMenuItem;
    actOverdueChangeCashJournal: TdsdOpenForm;
    N43: TMenuItem;
    actIncomeHouseholdInventoryCashJournal: TdsdOpenForm;
    N45: TMenuItem;
    actReport_HouseholdInventoryRemainsCash: TdsdOpenForm;
    N46: TMenuItem;
    N47: TMenuItem;
    MemDataUKTZED: TStringField;
    MainUKTZED: TcxGridDBColumn;
    actReturnInJournal: TdsdOpenForm;
    N44: TMenuItem;
    MemDataDIVPARTID: TIntegerField;
    MemDataDIVPARTNAME: TStringField;
    mdCheckDIVPARTID: TIntegerField;
    MainDivisionPartiesName: TcxGridDBColumn;
    MemDataGOODSPROJ: TBooleanField;
    MemDataBANFISCAL: TBooleanField;
    MainisBanFiscalSale: TcxGridDBColumn;
    CheckDivisionPartiesName: TcxGridDBColumn;
    actOpenCheckDeferred: TOpenChoiceForm;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    VIP6: TMenuItem;
    VIP7: TMenuItem;
    VIP8: TMenuItem;
    actLoadDeferred: TMultiAction;
    actOpenCheckDeferred_Search: TOpenChoiceForm;
    actLoadDeferred_Search: TMultiAction;
    actOpenDelayDeferred: TdsdOpenForm;
    actOpenCheckSite: TOpenChoiceForm;
    actLoadSite: TMultiAction;
    actOpenCheckSite_Search: TOpenChoiceForm;
    actLoadSite_Search: TMultiAction;
    actOpenDelaySite: TdsdOpenForm;
    MemDataGOODSPMID: TIntegerField;
    MainAmountSendIn: TcxGridDBColumn;
    MemDataGOODSDIMP: TFloatField;
    spShowPUSH_UKTZED: TdsdStoredProc;
    actShowPUSH_UKTZED: TdsdShowPUSHMessage;
    actGoodsSP_Cash: TdsdOpenForm;
    N53: TMenuItem;
    Label32: TLabel;
    ceVIPLoad: TcxCurrencyEdit;
    actLoadVIPOrder: TMultiAction;
    actExecLoadVIPOrder: TdsdExecStoredProc;
    spSelectChechHead: TdsdStoredProc;
    actOpenCheckLiki24: TOpenChoiceForm;
    actOpenCheckLiki24_Search: TOpenChoiceForm;
    actOpenDelayLiki24: TdsdOpenForm;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    Liki241: TMenuItem;
    actLoadLiki24: TMultiAction;
    actLoadLiki24_Search: TMultiAction;
    Color_IPE: TcxGridDBColumn;
    PlanEmployeeCDS: TClientDataSet;
    actInstructionsCash: TdsdOpenForm;
    N57: TMenuItem;
    actRecipeNumber1303: TAction;
    N13031: TMenuItem;
    pnlPosition: TPanel;
    cmPosition: TcxMemo;
    edName_inn_ua: TcxTextEdit;
    edName_reg_ua: TcxTextEdit;
    edCommentPosition: TcxTextEdit;
    bbPositionNext: TcxButton;
    cbMorionFilter: TcxCheckBox;
    MultiplicitySale: TcxGridDBColumn;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    spPullGoodsCheck: TdsdStoredProc;
    spSelectCheckId: TdsdStoredProc;
    MainFixEndDate: TcxGridDBColumn;
    CheckFixEndDate: TcxGridDBColumn;
    mdVIPCheck: TdxMemData;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    CurrencyField1: TCurrencyField;
    actSenClipboardName: TAction;
    C1: TMenuItem;
    MemDataISGOODSPS: TBooleanField;
    MemDataGOODSPSAM: TCurrencyField;
    spisCheckCombine: TdsdStoredProc;
    actCheckCombine: TOpenChoiceForm;
    actManual: TdsdOpenForm;
    actStartExam: TAction;
    N58: TMenuItem;
    N59: TMenuItem;
    N60: TMenuItem;
    cbDoctors: TcxCheckBox;
    actDoctors: TAction;
    actCheckJackdawsGreenJournalCash: TdsdOpenForm;
    N61: TMenuItem;
    spCheck_PairSunAmount: TdsdStoredProc;
    CheckJuridicalName: TcxGridDBColumn;
    MemDataGOODSDIPR: TCurrencyField;
    spAvailabilityCheckMedicalProgram: TdsdStoredProc;
    spMedicalProgramSP_Goods: TdsdStoredProc;
    MedicalProgramSPGoodsCDS: TClientDataSet;
    spGet_Goods_CodeRazom: TdsdStoredProc;
    MainDeferredTR: TcxGridDBColumn;
    MemDataDEFERENDT: TCurrencyField;
    btnGoodsSPReceiptList: TcxButton;
    actGoodsSPReceiptList: TdsdOpenForm;
    MemDataMORIONCODE: TIntegerField;
    spGetVIPOrder: TdsdStoredProc;
    actCheckSelectionOrder: TOpenChoiceForm;
    actOpenLayoutFile: TAction;
    mmOpenLayoutFile: TMenuItem;
    spLayoutFileFTPParams: TdsdStoredProc;
    actDownloadAndRunFile: TdsdFTP;
    actChoiceLayoutFileCash: TOpenChoiceForm;
    actAddGoodsSupplement: TAction;
    mmAddGoodsSupplement: TMenuItem;
    spGoods_AddSupplement: TdsdStoredProc;
    spGetMedicalProgramSP: TdsdStoredProc;
    spUpdate_User_KeyExpireDate: TdsdStoredProc;
    actUser_expireDate: TAction;
    pmUser_expireDate: TMenuItem;
    actSupplierFailuresCash: TdsdOpenForm;
    N62: TMenuItem;
    actListGoodsKeyword: TAction;
    actListGoodsKeyword1: TMenuItem;
    MainPriceSaleOOC1303: TcxGridDBColumn;
    MainPriceSale1303: TcxGridDBColumn;
    RemainsUnitOneCDS: TClientDataSet;
    spRemainsUnitOne: TdsdStoredProc;
    actExpressVIPConfirm: TdsdOpenForm;
    actChoiceGoodsSPSearch_1303: TdsdOpenForm;
    N13032: TMenuItem;
    actDownloadFarmacy: TAction;
    Farmacyexe1: TMenuItem;
    actChoiceGoodsFromRemains_1303: TdsdOpenForm;
    N13033: TMenuItem;
    MainBrandSPName: TcxGridDBColumn;
    actEnterBuyerForSite: TAction;
    N63: TMenuItem;
    spSelectChechBuyerForSite: TdsdStoredProc;
    actLoadBuyerForSite: TMultiAction;
    actOpenCheckBuyerForSite: TOpenChoiceForm;
    TimerActiveAlerts: TTimer;
    spActiveAlerts: TdsdStoredProc;
    lblActiveAlerts: TcxLabel;
    actOpenFilesToCheck: TAction;
    N64: TMenuItem;
    actChoiceFilesToCheckCash: TOpenChoiceForm;
    spFilesToCheckFTPParams: TdsdStoredProc;
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN);
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountExit(Sender: TObject);
    procedure actPutCheckToCashExecute(Sender: TObject);
    { ******************** }
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actSetVIPExecute(Sender: TObject);
    procedure actCalcTotalSummExecute(Sender: TObject);
    procedure MainColReservedGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure actCashWorkExecute(Sender: TObject);
    procedure actClearAllExecute(Sender: TObject);
    procedure actClearMoneyExecute(Sender: TObject);
    procedure actGetMoneyInCashExecute(Sender: TObject);
    procedure actSpecExecute(Sender: TObject);
    procedure ParentFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lcNameExit(Sender: TObject);
    procedure actUpdateRemainsExecute(Sender: TObject);
    procedure actSetFocusExecute(Sender: TObject);
    procedure actRefreshRemainsExecute(Sender: TObject);
    procedure actExecuteLoadVIPExecute(Sender: TObject);
    procedure actRefreshAllExecute(Sender: TObject);
    procedure SaveLocalVIP;
    procedure MainGridDBTableViewFocusedRecordChanged
      (Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure TimerSaveAllTimer(Sender: TObject);
    procedure lcNameEnter(Sender: TObject);
    procedure TimerMoneyInCashTimer(Sender: TObject);
    procedure ParentFormShow(Sender: TObject);
    procedure actSelectLocalVIPCheckExecute(Sender: TObject);
    procedure actCheckConnectionExecute(Sender: TObject);
    procedure actSetDiscountExternalExecute(Sender: TObject); // ***20.07.16
    procedure CheckCDSBeforePost(DataSet: TDataSet);
    procedure TimerBlinkBtnTimer(Sender: TObject);
    procedure actSetConfirmedKind_CompleteExecute(Sender: TObject);
    procedure actSetConfirmedKind_UnCompleteExecute(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure ParentFormDestroy(Sender: TObject);
    procedure ceScanerKeyPress(Sender: TObject; var Key: Char);
    procedure actSetSPExecute(Sender: TObject);
    procedure actAddDiffMemdataExecute(Sender: TObject); // только 2 форма
    procedure actSetRimainsFromMemdataExecute(Sender: TObject);
    // только 2 форма
    procedure actServiseRunExecute(Sender: TObject);
    // ***10.08.16 // только 2 форма
    procedure actGetJuridicalListExecute(Sender: TObject);
    procedure actGetJuridicalListUpdate(Sender: TObject);
    procedure miMCSAutoClick(Sender: TObject); // ***10.08.16
    procedure N1Click(Sender: TObject);
    procedure N10Click(Sender: TObject); // ***10.08.16
    procedure actSetFilterExecute(Sender: TObject); // ***10.08.16
    procedure actSetPromoCodeExecute(Sender: TObject); // ***05.02.18
    procedure miPrintNotFiscalCheckClick(Sender: TObject);
    procedure mmSaveToExcelClick(Sender: TObject);
    procedure TimerServiceRunTimer(Sender: TObject);
    procedure actManualDiscountExecute(Sender: TObject);
    procedure edAmountKeyPress(Sender: TObject; var Key: Char);
    procedure edAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edAmountExit(Sender: TObject);
    procedure edPromoCodeExit(Sender: TObject);
    procedure edPromoCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPromoCodeKeyPress(Sender: TObject; var Key: Char);
    procedure actDeleteAccommodationExecute(Sender: TObject);
    procedure AccommodationNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure actExpirationDateFilterExecute(Sender: TObject);
    procedure actListDiffAddGoodsExecute(Sender: TObject);
    procedure actShowListDiffExecute(Sender: TObject);
    procedure actListGoodsExecute(Sender: TObject);
    procedure pm_VIP1Click(Sender: TObject);
    procedure CheckGridDBTableViewFocusedRecordChanged
      (Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actSetSiteDiscountExecute(Sender: TObject);
    procedure MainGridPriceChangeNightGetDisplayText
      (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure MainColPriceNightGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure actSpecCorrExecute(Sender: TObject);
    procedure TimerPUSHTimer(Sender: TObject);
    procedure actDoesNotShareExecute(Sender: TObject);
    procedure actCashGoodsOneToExpirationDateExecute(Sender: TObject);
    procedure actGoodsAnalogExecute(Sender: TObject);
    procedure actGoodsAnalogChooseExecute(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure actSetSPHelsiExecute(Sender: TObject);
    procedure actDeleteAccommodationAllIdExecute(Sender: TObject);
    procedure actDeleteAccommodationAllExecute(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure pm_CheckClick(Sender: TObject);
    procedure pm_CheckHelsiClick(Sender: TObject);
    procedure pm_CheckHelsiAllUnitClick(Sender: TObject);
    procedure TimerDroppedDownTimer(Sender: TObject);
    procedure TimerAnalogFilterTimer(Sender: TObject);
    procedure edAnalogFilterExit(Sender: TObject);
    procedure edAnalogFilterPropertiesChange(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure MainisGoodsAnalogGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure MainColCodeCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure actWagesUserExecute(Sender: TObject);
    procedure actBanCashExecute(Sender: TObject);
    procedure MainGridDBTableViewCanFocusRecord(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; var AAllow: Boolean);
    procedure actNotTransferTimeExecute(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure actSetPromoCodeLoyaltyExecute(Sender: TObject);
    procedure actOpenMCSExecute(Sender: TObject);
    procedure actReport_ImplementationPlanEmployeeExecute(Sender: TObject);
    procedure actSetLoyaltySaveMoneyExecute(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure edLoyaltySMSummaExit(Sender: TObject);
    procedure actTechnicalRediscountExecute(Sender: TObject);
    procedure actPromoCodeDoctorExecute(Sender: TObject);
    procedure actSaveHardwareDataExecute(Sender: TObject);
    procedure actUpdateProgramExecute(Sender: TObject);
    procedure MainColNameCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure ceVIPLoadKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ceVIPLoadExit(Sender: TObject);
    procedure Color_IPEGetCellHint(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; ACellViewInfo: TcxGridTableDataCellViewInfo;
      const AMousePos: TPoint; var AHintText: TCaption;
      var AIsHintMultiLine: Boolean; var AHintTextRect: TRect);
    procedure actRecipeNumber1303Execute(Sender: TObject);
    procedure bbPositionNextClick(Sender: TObject);
    procedure cbMorionFilterPropertiesChange(Sender: TObject);
    procedure MainFixPercentStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure CheckGridColNameStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure actSenClipboardNameExecute(Sender: TObject);
    procedure actStartExamExecute(Sender: TObject);
    procedure actDoctorsExecute(Sender: TObject);
    procedure btnGoodsSPReceiptListClick(Sender: TObject);
    procedure actOpenLayoutFileExecute(Sender: TObject);
    procedure spLayoutFileFTPParamsAfterExecute(Sender: TObject);
    procedure actAddGoodsSupplementExecute(Sender: TObject);
    procedure actUser_expireDateExecute(Sender: TObject);
    procedure actListGoodsKeywordExecute(Sender: TObject);
    procedure MainGridDBTableViewStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure actDownloadFarmacyExecute(Sender: TObject);
    procedure actEnterBuyerForSiteExecute(Sender: TObject);
    procedure TimerActiveAlertsTimer(Sender: TObject);
    procedure actOpenFilesToCheckExecute(Sender: TObject);
  private
    isScaner: Boolean;
    FSoldRegim: Boolean;
    fShift: Boolean;
    fPrint: Boolean;
    FTotalSumm: Currency;
    FSummLoyalty: Currency;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    ThreadErrorMessage: String;
    ASalerCash: Currency;
    ASalerCashAdd: Currency;
    PaidType: TPaidType;
    FFiscalNumber: String;
    difUpdate: Boolean; // только 2 форма
    VipCDS, VIPListCDS: TClientDataSet;
    VIPForm: TParentForm;
    // для мигания кнопки
    fBlinkVIP, fBlinkCheck, fBanCash: Boolean;
    time_onBlink, time_onBlinkCheck: TDateTime;
    MovementId_BlinkVIP: String;
    FSaveCheckToMemData: Boolean;
    FShowMessageCheckConnection: Boolean;
    FNeedFullRemains: Boolean;
    MessageByTime: Boolean;

    FPUSHStart: Boolean;
    FPUSHEnd: TDateTime;
    FLoadPUSH: Integer;
    FUpdatePUSH: Integer;

    FOldAnalogFilter: String;

    FAnalogFilter: Integer;

    FIsVIP, FIsTabletki, FIsLiki24 : Boolean;
    FStepSecond : Boolean;
    FStyle: TcxStyle;

    FError_Blink: Integer;
    FErrorRRO: Boolean;

    FUpdateKey_expireDate: Boolean;

    FTextError : String;

    aDistributionPromoId : array of Integer;
    aDistributionPromoAmount : array of Currency;
    aDistributionPromoSum : array of Currency;

    FActiveAlerts : String;
    FActiveAlertsDate : TDateTime;
    FHint: THintWindow;

    FBuyerForSite : string;


    procedure SetBlinkVIP(isRefresh: Boolean);
    procedure SetBlinkCheck(isRefresh: Boolean);
    procedure SetBanCash(isRefresh: Boolean);

    procedure SetSoldRegim(const Value: Boolean);
    // процедура обновляет параметры для введения нового чека
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    // Изменение тела чека
    procedure InsertUpdateBillCheckItems(AJuridicalId : Integer = 0; AJuridicalName : String = '');
    // Обновить остаток согласно пришедшей разнице
    procedure UpdateRemainsFromDiff(ADiffCDS: TClientDataSet);
    // Возвращает товар в верхний грид
    procedure UpdateRemainsFromCheck(AGoodsId: Integer = 0;
      APartionDateKindId: Integer = 0; ANDSKindId: Integer = 0; ADiscountExternalID: Integer = 0;
      ADivisionPartiesID: Integer = 0;  AisPresent: Boolean = False;
      AAmount: Currency = 0; APriceSale: Currency = 0; ALoadVipCheck : Boolean = False);
    // Обрабатывает количество для ВИП чеков
    procedure UpdateRemainsFromVIPCheck(ALoadCheck, ASaveCheck : Boolean);

    // Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
    function fGetCheckAmountTotal(AGoodsId: Integer = 0; AAmount: Currency = 0)
      : Currency;

    // Обновляет сумму по чеку
    procedure CalcTotalSumm;
    // что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
    procedure Add_Log_XML(AMessage: String);
    // Пробивает чек через ЭККА
    function PutCheckToCash(SalerCash, SalerCashAdd: Currency;
      PaidType: TPaidType; var AZReport : Integer; var AFiscalNumber, ACheckNumber: String;
      APOSTerminalCode: Integer = 0; isFiscal: Boolean = True): Boolean;
    // подключение к локальной базе данных
    function InitLocalStorage: Boolean;
    procedure LoadFromLocalStorage;
    procedure LoadBankPOSTerminal;
    procedure LoadUnitConfig;
    procedure LoadTaxUnitNight;
    procedure LoadGoodsExpirationDate;

    // проверили что есть остаток
    function fCheck_RemainsError: Boolean;

    procedure Thread_Exception(var Msg: TMessage); message UM_THREAD_EXCEPTION;
    procedure ConnectionModeChange(var Msg: TMessage);
      message UM_LOCAL_CONNECTION;
    procedure SetWorkMode(ALocal: Boolean);
    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
    // только 2 форма
    function GetAmount: Currency;

    // Сохранение чеков в CSV по дням
    procedure Add_Check_History;
    procedure Start_Check_History(SalerCash, SalerCashAdd: Currency;
      PaidType: TPaidType);
    procedure Finish_Check_History(SalerCash: Currency);
    // Очистка фильтров
    procedure ClearFilterAll;
    // Загружает VIP чек
    procedure LoadVIPCheck;
    procedure SetSiteDiscount(ASiteDiscount: Currency);

    // Установка отмена ночной скидки
    procedure SetTaxUnitNight;
    // Процент ночной скидки по цене
    function CalcTaxUnitNightPercent(ABasePrice: Currency): Currency;
    // Расчет ночной цены
    function CalcTaxUnitNightPrice(ABasePrice, APrice: Currency;
      APercent: Currency = 0): Currency;
    function CalcTaxUnitNightPriceGrid(ABasePrice, APrice: Currency): Currency;

    // Расчет цены, скидок
    procedure CalcPriceSale(var APriceSale, APrice, AChangePercent: Currency;
      APriceBase, APercent: Currency; APriceChange: Currency = 0);
    // Проверка доступности работы с соц. проектами
    function CheckSP: Boolean;

    // Уменьшение остатка в наличии по партиям
    procedure UpdateRemainsGoodsToExpirationDate;

    // Установка фильтра по аналогу
    procedure SetGoodsAnalogFilter(AGoodsAnalog: string);
    // Проверяет наличие медикамента с меньшим сроком
    function ExistsLessAmountMonth(AGoodsId: Integer;
      AAmountMonth: Currency): Boolean;
    // Определяет минимальный срок
    function GetPartionDateKindId: Integer;

    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);

    // Проверка и генерация промокода по Программе лояльности
    procedure Check_Loyalty(ASumma: Currency);
    procedure Check_LoyaltySumma(ASumma: Currency);
    procedure Check_LoyaltySM(ASumma: Currency);
    function CheckShareFromPrice(Amount, Price: Currency; GoodsCode: Integer;
      GoodsName: string): Boolean;
    procedure SaveHardwareData(IsShowInputHardware : boolean = False);
    // Установить дисконтную программу
    procedure SetDiscountExternal(ACode : Integer = 0; ADiscountCard : String = '');

    // Пропись выполнения плана по сотруднику
    procedure UpdateImplementationPlanEmployee;
    // Заполнение шапки главной формы
    procedure SetMainFormCaption;


  public
    // Сохранение чека в локальной базе. возвращает УИД
    function SaveLocal(ADS: TClientDataSet; AManagerId: Integer;
      AManagerName: String; ABayerName, ABayerPhone, AConfirmedKindName,
      AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance,
      AMedicSP, AInvNumberSP: String; AOperDateSP: TDateTime;
      ASPKindId: Integer; ASPKindName: String; ASPTax: Currency;
      APromoCodeID, AManualDiscount: Integer; ASummPayAdd: Currency;
      AMemberSPID, ABankPOSTerminal, AJackdawsChecksCode: Integer;
      ASiteDiscount: Currency; ARoundingDown: Boolean;
      APartionDateKindId: Integer; AConfirmationCodeSP: string;
      ALoyaltySignID: Integer; ALoyaltySMID: Integer; ALoyaltySMSumma: Currency;
      ADivisionPartiesID: Integer; ADivisionPartiesName, AMedicForSale, ABuyerForSale, ABuyerForSalePhone,
      ADistributionPromoList: String; AMedicKashtanId, AMemberKashtanId : Integer;
      AisCorrectMarketing, AisCorrectIlliquidAssets, AisDoctors, AisDiscountCommit : Boolean;
      AMedicalProgramSPId: Integer; AisManual : Boolean; ACategory1303Id : Integer;
      ANeedComplete, AisErrorRRO, AisPaperRecipeSP: Boolean; AZReport : Integer; AFiscalCheckNumber: String;
      AID: Integer; out AUID: String): Boolean;

    procedure pGet_OldSP(var APartnerMedicalId: Integer;
      var APartnerMedicalName, AMedicSP: String; var AOperDateSP: TDateTime);
    function pCheck_InvNumberSP(ASPKind: Integer; ANumber: string): Boolean;
    procedure SetPromoCode(APromoCodeID: Integer;
      APromoName, APromoCodeGUID, ABayerName: String;
      APromoCodeChangePercent: Currency);
    procedure SetPromoCodeLoyalty(APromoCodeID: Integer; APromoCodeGUID: String;
      APromoCodeSumma: Currency; AMovementId : Integer;
      AisPresent : Boolean; AAmountPresent : Currency; AGoodsId : Integer);
    procedure SetPromoCodeLoyaltySM(ALoyaltySMID: Integer;
      APhone, AName: string; ASummaRemainder, AChangeSumma: Currency);
    procedure PromoCodeLoyaltyCalc;
    procedure MobileDiscountCalc;
    procedure SetLoyaltySaveMoney;
    function SetLoyaltySaveMoneyDiscount: Boolean;
    function GetCash: ICash;

    procedure ClearDistributionPromo;
    procedure AddDistributionPromo(AID : Integer; AAmount, ASumm : Currency);
    function ShowDistributionPromo : Boolean;
    function SetMorionCodeFilter : boolean;
    procedure ClearAll;
    procedure LoadMedicalProgramSPGoods(AGoodsId : Integer);
    procedure MoveLogFile;
    procedure SaveUnitConfig;

    property SoldRegim: Boolean read FSoldRegim write SetSoldRegim;
  end;

var
  MainCashForm: TMainCashForm2;
  FLocalDataBaseHead: TVKSmartDBF;
  FLocalDataBaseBody: TVKSmartDBF;
  FLocalDataBaseDiff: TVKSmartDBF; // только 2 форма
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection, csCriticalSection_Save, csCriticalSection_All
    : TRTLCriticalSection;
  FM_SERVISE: Integer;
  // для передачи сообщений между приложение и сервисом // только 2 форма
function GetPrice(Price, Discount: Currency): Currency;
function GetSumm(Amount, Price: Currency; Down: Boolean): Currency;
function GetSummFull(Amount, Price: Currency): Currency;
function GenerateGUID: String;

procedure Add_Log(AMessage: String);
procedure Add_Log_RRO(AMessage: String);

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, DiscountDialog,
  SPDialog, CashWork, MessagesUnit, LikiDniproeHealth,
  LocalWorkUnit, Splash, DiscountService, UnilWin, ListDiff, ListGoods,
  PromoCodeDialog, ListDiffAddGoods, TlHelp32, EmployeeWorkLog,
  GoodsToExpirationDate, ChoiceGoodsAnalog, Helsi, RegularExpressions,
  PUSHMessageCash, PUSHMessage, Updater, HardwareDialog,
  EnterRecipeNumber, CheckHelsiSign, CheckHelsiSignPUSH, CheckHelsiSignAllUnit,
  EmployeeScheduleCash, SelectionFromDirectory, ChoosingPairSun,
  EnterLoyaltyNumber, Report_ImplementationPlanEmployeeCash,
  EnterLoyaltySaveMoney, ChoosingPresent, ChoosingRelatedProduct,
  LoyaltySMList, EnterLoyaltySMDiscount, GetSystemInfo, ListSelection,
  LikiDniproReceipt, EnterRecipeNumber1303, LikiDniproReceiptDialog, Clipbrd,
  TestingUser, ChoiceMedicalProgramSP, SimpleGauge, ListGoodsKeyword,
  EnterBuyerForSite;

const
  StatusUnCompleteCode = 1;
  StatusCompleteCode = 2;
  StatusUnCompleteId = 14;
  StatusCompleteId = 15;

var
  isLog_RRO : Boolean;


function IfZero(N1, N2: Currency): Currency;
begin
  if N1 = 0 then
    Result := N2
  else
    Result := N1;
end;

function IntToSVar(AInt : Variant) : String;
begin
  if AInt = Null then Result := 'Null'
  else Result := IntToStr(AInt);
end;

function MinCurr(N1, N2: Variant) : Currency;
begin
  if (N1 = Null) and (N2 = Null) then Result := 0
  else if (N1 = Null) then Result := N2
  else if (N2 = Null) then Result := N1
  else Result := Min(N1, N2);
end;

// что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
procedure Add_Log(AMessage: String);
var
  F: TextFile;
begin
  WaitForSingleObject(MutexLog, INFINITE);
  try
    try
      AssignFile(F, ChangeFileExt(Application.ExeName, '.log'));
      if not fileExists(ChangeFileExt(Application.ExeName, '.log')) then
      begin
        Rewrite(F);
      end
      else
        Append(F);
      //
      try
        Writeln(F, DateTimeToStr(Now) + ': ' + AMessage);
      finally
        CloseFile(F);
      end;
    except
      on E: Exception do
        ShowMessage
          ('Ошибка сохранения в лог файл. Покажите это окно системному администратору: '
          + #13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexLog);
  end;
end;

procedure Add_Log_RRO(AMessage: String);
var
  F: TextFile;
begin
  WaitForSingleObject(MutexLog, INFINITE);
  try
    try
      if isLog_RRO then
      try
        AssignFile(F, ChangeFileExt(Application.ExeName, '_RRO.log'));
        if not fileExists(ChangeFileExt(Application.ExeName, '_RRO.log')) then
        begin
          Rewrite(F);
        end
        else
          Append(F);
        //
        try
          Writeln(F, DateTimeToStr(Now) + ': ' + AMessage);
        finally
          CloseFile(F);
        end;
      except
        on E: Exception do
          ShowMessage
            ('Ошибка сохранения в лог файл по рро. Покажите это окно системному администратору: '
            + #13#10 + E.Message);
      end;
    finally
      ShowMessage(AMessage);
    end;
  finally
    ReleaseMutex(MutexLog);
  end;
end;

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);
// только 2 форма
begin
  Handled := (Msg.hwnd = Application.Handle) and (Msg.Message = FM_SERVISE);

  if Handled and (Msg.wParam = 1) then
  // WPARAM = 1 значит сообщения от сервиса в приложения  WPARAM = 2 от приложения в сервис
    case Msg.lParam of
      1: // получено сообщение на обновление diff разницы из дбф
        if difUpdate then
        begin
          difUpdate := false;
          actAddDiffMemdata.Execute; // вычитывает дбф в мемдату
          actSetRimainsFromMemdata.Execute;
          // обновляем остатки в товарах и чеках с учетом пришедших остатков в мемдате
          LoadGoodsExpirationDate;
          LoadBankPOSTerminal;
          LoadUnitConfig;
          LoadTaxUnitNight;
          SetTaxUnitNight;
        end;
      3: // получен запрос на обновление всего
        begin
          if FSaveCheckToMemData then
          begin
            FSaveCheckToMemData := false;
            LoadFromLocalStorage;
          end;
          LoadGoodsExpirationDate;
          LoadBankPOSTerminal;
          LoadUnitConfig;
          LoadTaxUnitNight;
          SetTaxUnitNight;
        end;
      4: // получен запрос на сохранение в отдельную таблицу отгруженных чеков
        begin
          mdCheck.Close;
          mdCheck.Open;
          FSaveCheckToMemData := True;
        end;
      5: // получен запрос на отмену сохранения в отдельную таблицу отгруженных чеков
        begin
          FSaveCheckToMemData := false;
          mdCheck.Close;
          mdCheck.Open;
        end;
      6: // служба перешла в онлайн режим
        begin
          FShowMessageCheckConnection := false;
          try
            actCheckConnection.Execute;
          finally
            FShowMessageCheckConnection := True;
          end;
        end;
    end;
end;

function GetPrice(Price, Discount: Currency): Currency;
var
  D, P, RI: Int64;
  S1: String;
begin
  if (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  D := trunc(Discount * 100);
  P := trunc(Price * 100);
  RI := P * (10000 - D);
  S1 := IntToStr(RI);
  if Length(S1) < 5 then
    RI := 0
  else
    RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
  if (Length(S1) >= 4) AND (StrToInt(S1[Length(S1) - 3]) >= 5) then
    RI := RI + 1;
  Result := (RI / 100);
end;

function GetSumm(Amount, Price: Currency; Down: Boolean): Currency;
var
  A, P, RI: Int64;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A * P;
  S1 := IntToStr(RI);
  if Down then
  begin
    if Length(S1) <= 4 then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
    Result := (RI / 10);
  end
  else
  begin
    if Length(S1) <= 4 then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
    if (Length(S1) >= 4) AND (StrToInt(S1[Length(S1) - 3]) >= 5) then
      RI := RI + 1;
    Result := (RI / 10);
  end;
end;

{
function GetSumm(Amount, Price: Currency; Down: Boolean): Currency;
var
  A, P, RI: Int64;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  if Down then
  begin
    RI := A * P;
    S1 := IntToStr(RI);
    if Length(S1) <= 5 then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 5));
    if (Length(S1) >= 5) AND (StrToInt(S1[Length(S1) - 4]) >= 5) then
      Result := RI + 0.5
    else Result := RI;
  end
  else
  begin
    RI := A * P * 2;
    S1 := IntToStr(RI);
    if (Length(S1) <= 5) then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 5));
    if (Length(S1) >= 5) AND (StrToInt(S1[Length(S1) - 4]) >= 5) then
      RI := RI + 1;
    Result := (RI / 2);
  end;
end;}

function GetSummFull(Amount, Price: Currency): Currency;
var
  A, P, RI: Int64;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A * P;
  S1 := IntToStr(RI);
  if Length(S1) < 4 then
    RI := 0
  else
    RI := StrToInt(Copy(S1, 1, Length(S1) - 3));
  if (Length(S1) >= 3) AND (StrToInt(S1[Length(S1) - 2]) >= 5) then
    RI := RI + 1;
  Result := (RI / 100);
end;

function GenerateGUID: String;
var
  G: TGUID;
begin
  CreateGUID(G);
  Result := GUIDToString(G);
end;

procedure TMainCashForm2.AccommodationNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin

  actOpenAccommodation.Execute;
  if actOpenAccommodation.GuiParams.ParamByName('Key').Value <> Null then
    try
      RemainsCDS.DisableControls;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('AccommodationId').AsVariant :=
        actOpenAccommodation.GuiParams.ParamByName('Key').Value;
      RemainsCDS.FieldByName('AccommodationName').AsVariant :=
        actOpenAccommodation.GuiParams.ParamByName('TextValue').Value;
      RemainsCDS.Post;
      spUpdate_Accommodation.Execute;
    finally
      RemainsCDS.EnableControls;
    end;

end;

procedure TMainCashForm2.actAddDiffMemdataExecute(Sender: TObject);
// только 2 форма
begin
  // ShowMessage('memdat-begin');
  Add_Log('Ждем заполнения Memdata');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  Add_Log('Начало заполнения Memdata');
  try
    FLocalDataBaseDiff.Open;
    if not MemData.Active then
      MemData.Open;
    MemData.DisableControls;
    FLocalDataBaseDiff.First;
    while not FLocalDataBaseDiff.Eof do
    begin
      MemData.Append;
      MemData.FieldByName('ID').AsInteger := FLocalDataBaseDiff.FieldByName
        ('ID').AsInteger;
      MemData.FieldByName('GOODSCODE').AsInteger :=
        FLocalDataBaseDiff.FieldByName('GOODSCODE').AsInteger;
      MemData.FieldByName('GOODSNAME').AsString :=
        Trim(FLocalDataBaseDiff.FieldByName('GOODSNAME').AsString);
      MemData.FieldByName('PRICE').AsFloat := FLocalDataBaseDiff.FieldByName
        ('PRICE').AsFloat;
      MemData.FieldByName('NDS').AsFloat := FLocalDataBaseDiff.FieldByName
        ('NDS').AsFloat;
      MemData.FieldByName('NDSKINDID').AsInteger :=
        FLocalDataBaseDiff.FieldByName('NDSKINDID').AsInteger;
      MemData.FieldByName('REMAINS').AsFloat := FLocalDataBaseDiff.FieldByName
        ('REMAINS').AsFloat;
      MemData.FieldByName('MCSVALUE').AsFloat := FLocalDataBaseDiff.FieldByName
        ('MCSVALUE').AsFloat;
      MemData.FieldByName('RESERVED').AsFloat := FLocalDataBaseDiff.FieldByName
        ('RESERVED').AsFloat;
      MemData.FieldByName('MEXPDATE').AsVariant :=
        FLocalDataBaseDiff.FieldByName('MEXPDATE').AsVariant;
      MemData.FieldByName('PDKINDID').AsVariant :=
        FLocalDataBaseDiff.FieldByName('PDKINDID').AsVariant;
      if FLocalDataBaseDiff.FieldByName('PDKINDNAME').IsNull then
        MemData.FieldByName('PDKINDNAME').AsVariant :=
          FLocalDataBaseDiff.FieldByName('PDKINDNAME').AsVariant
      else
        MemData.FieldByName('PDKINDNAME').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('PDKINDNAME').AsString);
      MemData.FieldByName('NEWROW').AsBoolean := FLocalDataBaseDiff.FieldByName
        ('NEWROW').AsBoolean;
      MemData.FieldByName('ACCOMID').AsVariant := FLocalDataBaseDiff.FieldByName
        ('ACCOMID').AsVariant;
      if FLocalDataBaseDiff.FieldByName('ACCOMNAME').IsNull then
        MemData.FieldByName('ACCOMNAME').AsVariant :=
          FLocalDataBaseDiff.FieldByName('ACCOMNAME').AsVariant
      else
        MemData.FieldByName('ACCOMNAME').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('ACCOMNAME').AsString);
      MemData.FieldByName('AMOUNTMON').AsVariant :=
        FLocalDataBaseDiff.FieldByName('AMOUNTMON').AsVariant;
      MemData.FieldByName('PRICEPD').AsVariant := FLocalDataBaseDiff.FieldByName
        ('PRICEPD').AsVariant;
      MemData.FieldByName('COLORCALC').AsVariant :=
        FLocalDataBaseDiff.FieldByName('COLORCALC').AsVariant;
      MemData.FieldByName('DEFERENDS').AsVariant :=
        FLocalDataBaseDiff.FieldByName('DEFERENDS').AsVariant;
      MemData.FieldByName('DEFERENDT').AsVariant :=
        FLocalDataBaseDiff.FieldByName('DEFERENDT').AsVariant;
      MemData.FieldByName('REMAINSSUN').AsVariant :=
        FLocalDataBaseDiff.FieldByName('REMAINSSUN').AsVariant;
      MemData.FieldByName('DISCEXTID').AsVariant :=
        FLocalDataBaseDiff.FieldByName('DISCEXTID').AsVariant;
      if FLocalDataBaseDiff.FieldByName('DISCEXTNAM').IsNull then
        MemData.FieldByName('DISCEXTNAME').AsVariant :=
          FLocalDataBaseDiff.FieldByName('DISCEXTNAM').AsVariant
      else MemData.FieldByName('DISCEXTNAME').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('DISCEXTNAM').AsString);
      MemData.FieldByName('GOODSDIID').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSDIID').AsVariant;
      if FLocalDataBaseDiff.FieldByName('GOODSDINAM').IsNull then
        MemData.FieldByName('GOODSDINAME').AsVariant :=
          FLocalDataBaseDiff.FieldByName('GOODSDINAM').AsVariant
      else MemData.FieldByName('GOODSDINAME').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('GOODSDINAM').AsString);
      if FLocalDataBaseDiff.FieldByName('UKTZED').IsNull then
        MemData.FieldByName('UKTZED').AsVariant :=
          FLocalDataBaseDiff.FieldByName('UKTZED').AsVariant
      else MemData.FieldByName('UKTZED').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('UKTZED').AsString);
      MemData.FieldByName('ISGOODSPS').AsVariant :=
        FLocalDataBaseDiff.FieldByName('ISGOODSPS').AsVariant;
      MemData.FieldByName('GOODSPMID').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSPMID').AsVariant;
      MemData.FieldByName('GOODSPSAM').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSPSAM').AsVariant;
      MemData.FieldByName('DIVPARTID').AsVariant :=
        FLocalDataBaseDiff.FieldByName('DIVPARTID').AsVariant;
      if FLocalDataBaseDiff.FieldByName('DIVPARTID').IsNull then
        MemData.FieldByName('DIVPARTNAME').AsVariant :=
          FLocalDataBaseDiff.FieldByName('DIVPARTNAM').AsVariant
      else MemData.FieldByName('DIVPARTNAME').AsString :=
          Trim(FLocalDataBaseDiff.FieldByName('DIVPARTNAM').AsString);
      MemData.FieldByName('GOODSPROJ').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSPROJ').AsVariant;
      MemData.FieldByName('GOODSPROJ').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSPROJ').AsVariant;
      MemData.FieldByName('GOODSDIMP').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSDIMP').AsVariant;
      MemData.FieldByName('GOODSDIPR').AsVariant :=
        FLocalDataBaseDiff.FieldByName('GOODSDIPR').AsVariant;
      MemData.FieldByName('MORIONCODE').AsVariant :=
        FLocalDataBaseDiff.FieldByName('MORIONCODE').AsVariant;
      FLocalDataBaseDiff.Edit;
      FLocalDataBaseDiff.DeleteRecord;
      FLocalDataBaseDiff.Post;
      MemData.Post;
      FLocalDataBaseDiff.Next;
    end;
    FLocalDataBaseDiff.Pack;
    FLocalDataBaseDiff.Close;
    MemData.EnableControls;
  finally
    ReleaseMutex(MutexDBFDiff);
    Add_Log('Конец заполнения Memdata');
  end;
  // ShowMessage('memdat-end');
  // ShowMessage(inttostr(MemData.RecordCount));
end;

procedure TMainCashForm2.actAddGoodsSupplementExecute(Sender: TObject);
begin
  if RemainsCDS.IsEmpty then Exit;

  if (MessageDlg('Добавить товар:'#13#13 + RemainsCDS.FieldByName('GoodsCode').AsString + ' - ' + RemainsCDS.FieldByName('GoodsName').AsString +
        #13#13'для распределения по дополнению СУН 1', mtInformation, mbOKCancel, 0) = mrOk) then
  begin
     spGoods_AddSupplement.Execute;
     ShowMessage('Товар добавлен для распределения по дополнению СУН 1');
  end;
end;

procedure TMainCashForm2.actCalcTotalSummExecute(Sender: TObject);
begin
  CalcTotalSumm;
end;

procedure TMainCashForm2.actCashGoodsOneToExpirationDateExecute
  (Sender: TObject);
var
  bLocal: Boolean;
begin

  bLocal := True;
  if not gc_User.Local then
  begin
    try
      if CheckGrid.IsFocused then
        actOpenCashGoodsOneToExpirationDate.GuiParams.ParamByName('GoodsId')
          .Value := CheckCDS.FieldByName('GoodsId').AsInteger
      else
        actOpenCashGoodsOneToExpirationDate.GuiParams.ParamByName('GoodsId')
          .Value := RemainsCDS.FieldByName('ID').AsInteger;
      actOpenCashGoodsOneToExpirationDate.Execute;
    except
      bLocal := false;
    end;
  end
  else
    bLocal := false;

  if not bLocal then
  begin
    with TGoodsToExpirationDateForm.Create(nil) do
      try
        if CheckGrid.IsFocused then
          GoodsToExpirationDateExecute(CheckCDS.FieldByName('GoodsId')
            .AsInteger, CheckCDS.FieldByName('GoodsCode').AsInteger,
            CheckCDS.FieldByName('GoodsName').AsString)
        else
          GoodsToExpirationDateExecute(RemainsCDS.FieldByName('ID').AsInteger,
            RemainsCDS.FieldByName('GoodsCode').AsInteger,
            RemainsCDS.FieldByName('GoodsName').AsString);
      finally
        Free;
      end;
  end;
end;

procedure TMainCashForm2.actCashWorkExecute(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, RemainsCDS,
    FormParams.ParamByName('ZReportName').Value) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TMainCashForm2.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if MainGrid.IsFocused then
  Begin
    if RemainsCDS.isempty then
      exit;
    if RemainsCDS.FieldByName('Remains').asCurrency > 0 then
    begin
      SourceClientDataSet := RemainsCDS;
      SoldRegim := True;
      lcName.Text := RemainsCDS.FieldByName('GoodsName').AsString;
      edAmount.Enabled := True;
      if RemainsCDS.FieldByName('Remains').asCurrency > 1 then edAmount.Text := '1'
      else edAmount.Text := RemainsCDS.FieldByName('Remains').AsString;
      ActiveControl := edAmount;
    end
  end
  else if AlternativeGrid.IsFocused then
  Begin
    if AlternativeCDS.isempty then
      exit;
    if AlternativeCDS.FieldByName('Remains').asCurrency > 0 then
    begin
      SourceClientDataSet := AlternativeCDS;
      SoldRegim := True;
      lcName.Text := AlternativeCDS.FieldByName('GoodsName').AsString;
      edAmount.Enabled := True;
      edAmount.Text := '1';
      ActiveControl := edAmount;
    end
  End
  else
  Begin
    if CheckCDS.isempty then
      exit;
    if CheckCDS.FieldByName('Amount').asCurrency > 0 then
    begin
      SourceClientDataSet := CheckCDS;
      SoldRegim := false;
      lcName.Text := CheckCDS.FieldByName('GoodsName').AsString;
      edAmount.Enabled := True;
      if CheckCDS.FieldByName('Amount').asCurrency > 1 then edAmount.Text := '-1'
      else edAmount.Text := '-' + CheckCDS.FieldByName('Amount').AsString;
      ActiveControl := edAmount;
    end;
  End;
end;

procedure TMainCashForm2.actClearAllExecute(Sender: TObject);
  var UID : String;
begin
  // if CheckCDS.IsEmpty then exit;
  if MessageDlg('Очистить все?', mtConfirmation, mbYesNo, 0) <> mrYes then
    exit;

  if ((FormParams.ParamByName('isDiscountCommit').Value = True) or
     FErrorRRO AND UnitConfigCDS.FindField('isErrorRROToVIP').AsBoolean) and
     (FormParams.ParamByName('CheckId').Value = 0) then
  begin
    SaveLocal(CheckCDS, FormParams.ParamByName('ManagerId').Value,
        FormParams.ParamByName('ManagerName').Value,
        FormParams.ParamByName('BayerName').Value,
        // ***16.08.16
        FormParams.ParamByName('BayerPhone').Value,
        FormParams.ParamByName('ConfirmedKindName').Value,
        FormParams.ParamByName('InvNumberOrder').Value,
        FormParams.ParamByName('ConfirmedKindClientName').Value,
        // ***20.07.16
        FormParams.ParamByName('DiscountExternalId').Value,
        FormParams.ParamByName('DiscountExternalName').Value,
        FormParams.ParamByName('DiscountCardNumber').Value,
        // ***08.04.17
        FormParams.ParamByName('PartnerMedicalId').Value,
        FormParams.ParamByName('PartnerMedicalName').Value,
        FormParams.ParamByName('Ambulance').Value,
        FormParams.ParamByName('MedicSP').Value,
        FormParams.ParamByName('InvNumberSP').Value,
        FormParams.ParamByName('OperDateSP').Value,
        // ***15.06.17
        FormParams.ParamByName('SPKindId').Value,
        FormParams.ParamByName('SPKindName').Value,
        FormParams.ParamByName('SPTax').Value,
        // ***05.02.18
        FormParams.ParamByName('PromoCodeID').Value,
        // ***27.06.18
        FormParams.ParamByName('ManualDiscount').Value,
        // ***02.11.18
        FormParams.ParamByName('SummPayAdd').Value,
        // ***14.01.19
        FormParams.ParamByName('MemberSPID').Value,
        // ***20.02.19
        FormParams.ParamByName('BankPOSTerminal').Value,
        // ***25.02.19
        FormParams.ParamByName('JackdawsChecksCode').Value,
        // ***28.01.19
        FormParams.ParamByName('SiteDiscount').Value,
        // ***02.04.19
        FormParams.ParamByName('RoundingDown').Value,
        // ***13.05.19
        FormParams.ParamByName('PartionDateKindId').Value,
        FormParams.ParamByName('ConfirmationCodeSP').Value,
        // ***07.11.19
        FormParams.ParamByName('LoyaltySignID').Value,
        // ***08.01.20
        FormParams.ParamByName('LoyaltySMID').Value,
        FormParams.ParamByName('LoyaltySMSumma').Value,
        // ***16.08.20
        FormParams.ParamByName('DivisionPartiesID').Value,
        FormParams.ParamByName('DivisionPartiesName').Value,
        // ***11.10.20
        FormParams.ParamByName('MedicForSale').Value,
        FormParams.ParamByName('BuyerForSale').Value,
        FormParams.ParamByName('BuyerForSalePhone').Value,
        FormParams.ParamByName('DistributionPromoList').Value,
        // ***05.03.21
        FormParams.ParamByName('MedicKashtanId').Value,
        FormParams.ParamByName('MemberKashtanId').Value,
        // ***19.03.21
        FormParams.ParamByName('isCorrectMarketing').Value,
        FormParams.ParamByName('isCorrectIlliquidAssets').Value,
        FormParams.ParamByName('isDoctors').Value,
        FormParams.ParamByName('isDiscountCommit').Value,
        FormParams.ParamByName('MedicalProgramSPId').Value,
        FormParams.ParamByName('isManual').Value,
        FormParams.ParamByName('Category1303Id').Value,

        False, // NeedComplete
        FErrorRRO, // isErrorRRO
        FormParams.ParamByName('isPaperRecipeSP').Value,
        0,     // ZReport
        '',    // FiscalCheckNumber
        FormParams.ParamByName('CheckId').Value,  // ID чека
        UID // out AUID
        );
     Add_Log('Сохранение вип чека по проведенному дисконту');
  end;

  Add_Log('Clear all');
  // Вернуть товар в верхний грид
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('CheckOldId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('BayerName').Value := '';
  FormParams.ParamByName('ManagerName').Value := '';
  // ***20.07.16
  FormParams.ParamByName('DiscountExternalId').Value := 0;
  FormParams.ParamByName('DiscountExternalName').Value := '';
  FormParams.ParamByName('DiscountCardNumber').Value := '';
  // ***16.08.16
  FormParams.ParamByName('BayerPhone').Value := '';
  FormParams.ParamByName('ConfirmedKindName').Value := '';
  FormParams.ParamByName('InvNumberOrder').Value := '';
  FormParams.ParamByName('ConfirmedKindClientName').Value := '';
  FormParams.ParamByName('SummCard').Value := 0;
  // ***10.04.17
  FormParams.ParamByName('PartnerMedicalId').Value := 0;
  FormParams.ParamByName('PartnerMedicalName').Value := '';
  FormParams.ParamByName('Ambulance').Value := '';
  FormParams.ParamByName('MedicSP').Value := '';
  FormParams.ParamByName('InvNumberSP').Value := '';
  FormParams.ParamByName('OperDateSP').Value := Now;
  // ***15.06.17
  FormParams.ParamByName('SPTax').Value := 0;
  FormParams.ParamByName('SPKindId').Value := 0;
  FormParams.ParamByName('SPKindName').Value := '';
  FormParams.ParamByName('MedicalProgramSPId').Value := 0;
  // ***05.02.18
  FormParams.ParamByName('PromoCodeID').Value := 0;
  FormParams.ParamByName('PromoCodeGUID').Value := '';
  FormParams.ParamByName('PromoName').Value := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value := 0.0;
  // ***27.06.18
  FormParams.ParamByName('ManualDiscount').Value := 0;
  // ***02.11.18
  FormParams.ParamByName('SummPayAdd').Value := 0;
  // ***14.01.19
  FormParams.ParamByName('MemberSPID').Value := 0;
  FormParams.ParamByName('MemberSP').Value := '';
  // ***28.01.19
  FormParams.ParamByName('SiteDiscount').Value := 0;
  // ***20.02.19
  FormParams.ParamByName('BankPOSTerminal').Value := 0;
  // ***25.02.19
  FormParams.ParamByName('JackdawsChecksCode').Value := 0;
  // ***02.04.19
  FormParams.ParamByName('RoundingDown').Value := True;
  // ***25.04.19
  FormParams.ParamByName('HelsiID').Value := '';
  FormParams.ParamByName('HelsiIDList').Value := '';
  FormParams.ParamByName('HelsiName').Value := '';
  FormParams.ParamByName('HelsiQty').Value := 0;
  FormParams.ParamByName('HelsiProgramId').Value := '';
  FormParams.ParamByName('HelsiProgramName').Value := '';
  FormParams.ParamByName('ConfirmationCodeSP').Value := '';
  FormParams.ParamByName('HelsiPartialPrescription').Value := False;
  FormParams.ParamByName('HelsiSkipDispenseSign').Value := False;
  // **13.05.19
  FormParams.ParamByName('PartionDateKindId').Value := 0;
  // **07.11.19
  FormParams.ParamByName('LoyaltySignID').Value := 0;
  FormParams.ParamByName('LoyaltyText').Value := '';
  FormParams.ParamByName('LoyaltyChangeSumma').Value := 0;
  FormParams.ParamByName('LoyaltyShowMessage').Value := True;
  // **08.01.20
  FormParams.ParamByName('LoyaltySMID').Value := 0;
  FormParams.ParamByName('LoyaltySMText').Value := '';
  FormParams.ParamByName('LoyaltySMSumma').Value := 0;
  FormParams.ParamByName('Price1303').Value := 0;
  // ***16.08.20
  FormParams.ParamByName('DivisionPartiesID').Value := 0;
  FormParams.ParamByName('DivisionPartiesName').Value := '';
  // ***01.10.20
  FormParams.ParamByName('LoyaltyMovementId').Value := 0;
  FormParams.ParamByName('LoyaltyPresent').Value := False;
  FormParams.ParamByName('LoyaltyAmountPresent').Value := 0;
  FormParams.ParamByName('LoyaltyGoodsId').Value := 0;
  FormParams.ParamByName('AddPresent').Value := False;
  FormParams.ParamByName('MedicForSale').Value := '';
  FormParams.ParamByName('BuyerForSale').Value := '';
  FormParams.ParamByName('BuyerForSalePhone').Value := '';
  FormParams.ParamByName('DistributionPromoList').Value := '';
  FormParams.ParamByName('isBanAdd').Value := False;
  FormParams.ParamByName('MedicKashtanId').Value := 0;
  FormParams.ParamByName('MedicKashtanName').Value := '';
  FormParams.ParamByName('MemberKashtanId').Value := 0;
  FormParams.ParamByName('MemberKashtanName').Value := '';
  FormParams.ParamByName('isCorrectMarketing').Value := False;
  FormParams.ParamByName('isCorrectIlliquidAssets').Value := False;
  FormParams.ParamByName('isDoctors').Value := False;
  FormParams.ParamByName('isDiscountCommit').Value := False;
  FormParams.ParamByName('isManual').Value := False;
  FormParams.ParamByName('Category1303Id').Value := 0;
  FormParams.ParamByName('Category1303Name').Value := '';
  FormParams.ParamByName('isAutoVIPforSales').Value := False;
  FormParams.ParamByName('isPaperRecipeSP').Value := False;
  FormParams.ParamByName('MobileDiscount').Value := 0;

  ClearFilterAll;

  FFiscalNumber := '';
  fPrint := False;
  pnlVIP.Visible := false;
  edPrice.Value := 0.0;
  edPrice.Visible := false;
  edDiscountAmount.Value := 0.0;
  edDiscountAmount.Visible := false;
  lblPrice.Visible := false;
  lblAmount.Visible := false;
  pnlDiscount.Visible := false;
  pnlSP.Visible := false;
  btnGoodsSPReceiptList.Visible := false;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  ceSummCard.Value := 0;
  plSummCard.Visible := False;
  chbNotMCS.Checked := false;
  UpdateRemainsFromCheck;
  CheckCDS.EmptyDataSet;
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  pnlPromoCodeLoyalty.Visible := false;
  lblPromoCodeLoyalty.Caption := '';
  edPromoCodeLoyaltySumm.Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  edPromoCode.Text := '';
  pnlSiteDiscount.Visible := false;
  edSiteDiscount.Value := 0;
  pnlLoyaltySaveMoney.Visible := false;
  lblLoyaltySMBuyer.Caption := '';
  edLoyaltySMSummaRemainder.Value := 0;
  edLoyaltySMSumma.Value := 0;
  pnlPosition.Visible := False;
  cbMorionFilter.Enabled := True;
  cbMorionFilter.Checked := False;
  pnlInfo.Visible := False;


  MainGridDBTableView.DataController.Filter.Clear;
  CheckGridDBTableView.DataController.Filter.Clear;
  ExpirationDateView.DataController.Filter.Clear;
  DiscountServiceForm.gCode := 0;
  DiscountServiceForm.isBeforeSale := False;
  MessageByTime := False;

  // Ночные скидки
  SetTaxUnitNight;
  // Вычтем из резерва если ВИП чек
  UpdateRemainsFromVIPCheck(False, False);
  // Если грузили СП
  MedicalProgramSPGoodsCDS.Close;
  // очистить рецепт
  ClearReceipt1303
end;

procedure TMainCashForm2.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm2.actDeleteAccommodationAllExecute(Sender: TObject);
var
  nID: Integer;
begin
  if MessageDlg('Удалить все привязки по подразделению?', mtConfirmation,
    [mbYes, mbCancel], 0) <> mrYes then
    exit;

  spDelete_AccommodationAll.Execute;

  try
    nID := RemainsCDS.RecNo;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    RemainsCDS.First;
    while not RemainsCDS.Eof do
    begin
      if not RemainsCDS.FieldByName('AccommodationId').IsNull then
      begin
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('AccommodationId').AsVariant := Null;
        RemainsCDS.FieldByName('AccommodationName').AsVariant := Null;
        RemainsCDS.Post;
      end;
      RemainsCDS.Next;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.RecNo := nID;
    RemainsCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.actDeleteAccommodationAllIdExecute(Sender: TObject);
var
  nID, nAccommodationId: Integer;
begin
  if RemainsCDS.FieldByName('AccommodationID').IsNull then
  begin
    ShowMessage('Медикамент не привязан к размещению!');
    exit;
  end;

  if MessageDlg('Удалить привязку всех медикамента к размещению <' +
    RemainsCDS.FieldByName('AccommodationName').AsString + '> ?',
    mtConfirmation, [mbYes, mbCancel], 0) <> mrYes then
    exit;

  spDelete_AccommodationAllID.Execute;

  nAccommodationId := RemainsCDS.FieldByName('AccommodationId').AsInteger;
  try
    nID := RemainsCDS.RecNo;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    RemainsCDS.First;
    while not RemainsCDS.Eof do
    begin
      if RemainsCDS.FieldByName('AccommodationId').AsInteger = nAccommodationId
      then
      begin
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('AccommodationId').AsVariant := Null;
        RemainsCDS.FieldByName('AccommodationName').AsVariant := Null;
        RemainsCDS.Post;
      end;
      RemainsCDS.Next;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.RecNo := nID;
    RemainsCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.actDeleteAccommodationExecute(Sender: TObject);
begin
  if RemainsCDS.FieldByName('AccommodationID').IsNull then
  begin
    ShowMessage('Медикамент не привязан к размещению!');
    exit;
  end;

  if MessageDlg('Удалить привязку медикамента к размещению?', mtConfirmation,
    [mbYes, mbCancel], 0) <> mrYes then
    exit;

  spDelete_Accommodation.Execute;

  try
    RemainsCDS.DisableControls;
    RemainsCDS.Edit;
    RemainsCDS.FieldByName('AccommodationId').AsVariant := Null;
    RemainsCDS.FieldByName('AccommodationName').AsVariant := Null;
    RemainsCDS.Post;
  finally
    RemainsCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.LoadVIPCheck;
var
  lMsg: String;
  APoint: TPoint;
  GoodsId, nRecNo: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
begin
  inherited;

  if not gc_User.Local and (FormParams.ParamByName('CheckId').Value <> 0) then
  begin
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Active := True;
      try
        // если чек загруженный VIP проверяем нет ли его в DBF
        FLocalDataBaseHead.First;
        while not FLocalDataBaseHead.Eof do
        begin
          if (FLocalDataBaseHead.FieldByName('ID')
            .AsInteger = FormParams.ParamByName('CheckId').Value) and
            not FLocalDataBaseHead.FieldByName('SAVE').AsBoolean then
          begin
            NewCheck(false);
            raise Exception.Create
              ('Выбранный вип чек не сохранен после изменений. Загрузка запрещена...');
            exit;
          end;
          FLocalDataBaseHead.Next;
        end;
      finally
        FLocalDataBaseHead.Close;
      end;
    finally
      ReleaseMutex(MutexDBF);
    end;
  end;

  // обновим "нужные" параметры-Main ***20.07.16
  if (FormParams.ParamByName('isDiscountCommit').Value = False) then
  begin
    DiscountServiceForm.pGetDiscountExternal
      (FormParams.ParamByName('DiscountExternalId').Value,
      FormParams.ParamByName('DiscountCardNumber').Value);
    // ***20.07.16
    if DiscountServiceForm.gService = 'CardService' then
    begin
      // проверка карты + сохраним "текущие" параметры-Main
      if not DiscountServiceForm.fCheckCard(lMsg, DiscountServiceForm.gURL,
        DiscountServiceForm.gService, DiscountServiceForm.gPort,
        DiscountServiceForm.gUserName, DiscountServiceForm.gPassword,
        FormParams.ParamByName('DiscountCardNumber').Value,
        DiscountServiceForm.gisOneSupplier,DiscountServiceForm.gisTwoPackages,
        FormParams.ParamByName('DiscountExternalId').Value) then
      begin
        // обнулим, пусть фармацевт начнет заново
        FormParams.ParamByName('DiscountExternalId').Value := 0;
        // обнулим "нужные" параметры-Item
        // DiscountServiceForm.pSetParamItemNull;
      end;

    end;
  end;

  if (FormParams.ParamByName('isDiscountCommit').Value = False) and
    ((FormParams.ParamByName('DiscountExternalId').Value <> 0) or
    (FormParams.ParamByName('DiscountCardNumber').Value <> ''))  then
  begin
    if (FormParams.ParamByName('InvNumberSP').Value = '') then
    begin
      // Update Дисконт в CDS - по всем "обновим" Дисконт
      DiscountServiceForm.fUpdateCDS_Discount(CheckCDS, lMsg,
        FormParams.ParamByName('DiscountExternalId').Value,
        FormParams.ParamByName('DiscountCardNumber').Value);

      // Проверим цену
      GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
      PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
      NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
      DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
      DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
      try
        RemainsCDS.DisableControls;
        RemainsCDS.Filtered := false;
        with CheckCDS do
        begin
          First;
          while not Eof do
          begin

            RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([FieldByName('GoodsId').AsInteger,
                FieldByName('PartionDateKindId').AsVariant,
                FieldByName('NDSKindId').AsVariant,
                FieldByName('DiscountExternalID').AsVariant,
                FieldByName('DivisionPartiesID').AsVariant]), []);

            if (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency > 0) and
               (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency < FieldByName('PriceSale').AsCurrency) and
               (FieldByName('Amount').AsCurrency > 0) then
            begin
              ShowMessage('Превышена максимально возможная цена на препарат <' + FieldByName('GoodsName').AsString + '>. Обратитесь к Калининой Кристине...');
            end;

            Next;
          end;
        end;
      finally
        RemainsCDS.Filtered := True;
        RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
        RemainsCDS.EnableControls;
      end;

      // Пересчитаем сумму
      CalcTotalSumm;
    end;
  end;

  // ***20.07.16
  lblDiscountExternalName.Caption := '  ' + FormParams.ParamByName
    ('DiscountExternalName').Value + '  ';
  lblDiscountCardNumber.Caption := '  ' + FormParams.ParamByName
    ('DiscountCardNumber').Value + '  ';
  pnlDiscount.Visible := FormParams.ParamByName('DiscountExternalId').Value > 0;

  if pnlDiscount.Visible then
  begin
    try
      RemainsCDS.DisableControls;
      RemainsCDS.Filtered := false;
      RemainsCDS.Filter := '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and GoodsDiscountID = ' + IntToStr(DiscountServiceForm.gDiscountExternalId)
    finally
      RemainsCDS.Filtered := true;
      RemainsCDS.EnableControls;
    end;
  end;

  if FormParams.ParamByName('SPTax').Value <> 0 then
    lblSPKindName.Caption := '  ' + FloatToStr(FormParams.ParamByName('SPTax')
      .Value) + '% : ' + FormParams.ParamByName('SPKindName').Value
  else
    lblSPKindName.Caption := '  ' + FormParams.ParamByName('SPKindName').Value;
  lblPartnerMedicalName.Caption := '  ' + FormParams.ParamByName
    ('PartnerMedicalName').Value;
  // + '  /  № амб. ' + FormParams.ParamByName('Ambulance').Value;
  lblMedicSP.Caption := '  ' + FormParams.ParamByName('MedicSP').Value +
    '  /  № ' + FormParams.ParamByName('InvNumberSP').Value + ' от ' +
    DateToStr(FormParams.ParamByName('OperDateSP').Value);
  lblMemberSP.Caption := '  ' + FormParams.ParamByName('MemberSP').Value;
  pnlSP.Visible := FormParams.ParamByName('InvNumberSP').Value <> '';
  btnGoodsSPReceiptList.Visible := false;

  lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString;
  if (FormParams.ParamByName('ConfirmedKindName').AsString <> '') then
    lblCashMember.Caption := lblCashMember.Caption + ' * ' +
      FormParams.ParamByName('ConfirmedKindName').AsString;
  if (FormParams.ParamByName('InvNumberOrder').AsString <> '') then
    lblCashMember.Caption := lblCashMember.Caption + ' * ' + '№ ' +
      FormParams.ParamByName('InvNumberOrder').AsString;
  if FormParams.ParamByName('isAutoVIPforSales').Value = TRUE then
    lblCashMember.Caption := lblCashMember.Caption + ' ВИП чек для резерва под продажи';
  if FormParams.ParamByName('MobileDiscount').AsFloat > 0 then
    lblCashMember.Caption := lblCashMember.Caption + '; Дисконт по приложению: ' + CurrToStr(FormParams.ParamByName('MobileDiscount').AsFloat) + ' грн.';

  lblBayer.Caption := FormParams.ParamByName('BayerName').AsString;
  ceSummCard.Value := FormParams.ParamByName('SummCard').Value;
  plSummCard.Visible := ceSummCard.Value > 0;
  if (FormParams.ParamByName('BayerPhone').AsString <> '') then
    lblBayer.Caption := lblBayer.Caption + ' * ' + FormParams.ParamByName
      ('BayerPhone').AsString;

  if (FormParams.ParamByName('DiscountExternalId').Value = 0) and
    (FormParams.ParamByName('DiscountCardNumber').Value = '') then
  begin
    if FormParams.ParamByName('PromoCodeId').Value <> 0 then
    begin
      if Length(FormParams.ParamByName('PromoCodeGUID').AsString) > 10 then
        SetPromoCodeLoyalty(FormParams.ParamByName('PromoCodeId').Value,
          FormParams.ParamByName('PromoCodeGUID').AsString,
          FormParams.ParamByName('LoyaltyChangeSumma').Value,
          FormParams.ParamByName('LoyaltyMovementId').Value,
          FormParams.ParamByName('LoyaltyPresent').Value,
          FormParams.ParamByName('LoyaltyAmountPresent').Value,
          FormParams.ParamByName('LoyaltyGoodsId').Value)
      else
        SetPromoCode(FormParams.ParamByName('PromoCodeId').Value,
          FormParams.ParamByName('PromoName').AsString,
          FormParams.ParamByName('PromoCodeGUID').AsString,
          FormParams.ParamByName('BayerName').AsString,
          FormParams.ParamByName('PromoCodeChangePercent').Value)
    end;

    // ***30.06.18
    if FormParams.ParamByName('ManualDiscount').Value > 0 then
    begin

      pnlManualDiscount.Visible := True;
      edManualDiscount.Value := FormParams.ParamByName('ManualDiscount').Value;

      CheckCDS.DisableControls;
      CheckCDS.Filtered := false;
      nRecNo := CheckCDS.RecNo;
      try

        CheckCDS.First;
        while not CheckCDS.Eof do
        begin

          if CheckCDS.FieldByName('ChangePercent').asCurrency <>
            FormParams.ParamByName('ManualDiscount').Value then
          begin
            CheckCDS.Edit;
            CheckCDS.FieldByName('Price').asCurrency :=
              GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate')
              .asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency),
              Self.FormParams.ParamByName('ManualDiscount').Value);
            CheckCDS.FieldByName('ChangePercent').asCurrency :=
              Self.FormParams.ParamByName('ManualDiscount').Value;
            CheckCDS.FieldByName('Summ').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('Price').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value) -
              CheckCDS.FieldByName('Summ').asCurrency;
            CheckCDS.Post;
          end;
          CheckCDS.Next;
        end;
      finally
        CheckCDS.RecNo := nRecNo;
        CheckCDS.Filtered := True;
        CheckCDS.EnableControls;
      end;

      CalcTotalSumm;
    end
    else
      SetSiteDiscount(FormParams.ParamByName('SiteDiscount').Value);
  end;

  // ***04.09.18
  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := false;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID',
        VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
        CheckCDS.FieldByName('PartionDateKindId').AsVariant,
        CheckCDS.FieldByName('NDSKindId').AsVariant,
        CheckCDS.FieldByName('DiscountExternalID').AsVariant,
        CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) and
        (((CheckCDS.FieldByName('Amount').asCurrency +
        CheckCDS.FieldByName('Remains').asCurrency) <> RemainsCDS.FieldByName
        ('Remains').asCurrency) or (CheckCDS.FieldByName('Color_calc').AsInteger
        <> RemainsCDS.FieldByName('Color_calc').AsInteger) or
        (CheckCDS.FieldByName('Color_ExpirationDate').AsInteger <>
        RemainsCDS.FieldByName('Color_ExpirationDate').AsInteger) or
        (CheckCDS.FieldByName('AccommodationName').AsVariant <>
        RemainsCDS.FieldByName('AccommodationName').AsVariant) or
        (CheckCDS.FieldByName('Multiplicity').AsVariant <>
        RemainsCDS.FieldByName('Multiplicity').AsVariant)) then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Remains').asCurrency :=
          RemainsCDS.FieldByName('Remains').asCurrency +
          CheckCDS.FieldByName('Amount').asCurrency;
        if RemainsCDS.FieldByName('Color_calc').AsInteger <> 0 then
        begin
          CheckCDS.FieldByName('Color_calc').AsInteger :=
            RemainsCDS.FieldByName('Color_calc').AsInteger;
          CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
            RemainsCDS.FieldByName('Color_ExpirationDate').AsInteger;
        end
        else
        begin
          CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
          CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
        end;
        CheckCDS.FieldByName('AccommodationName').AsVariant :=
          RemainsCDS.FieldByName('AccommodationName').AsVariant;
        if CheckCDS.FieldByName('Price').asCurrency <>
          CheckCDS.FieldByName('PriceSale').asCurrency then
          CheckCDS.FieldByName('Multiplicity').AsVariant :=
            RemainsCDS.FieldByName('Multiplicity').AsVariant;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
    CheckCDS.First;

    // Вычтем из резерва
    UpdateRemainsFromVIPCheck(True, False);
  finally
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
  end;

  pnlVIP.Visible := True;
end;

procedure TMainCashForm2.pm_VIP1Click(Sender: TObject);
begin
  inherited;

  if (DiscountServiceForm.gCode <> 0) then
  begin
    ShowMessage('Применен дисконт.'#13#10'Открытие отложенных чеков запрещено.'#13#10'Если надо применить дисконт сначало загрузите чек потом примените дисконтную программу.');
    exit;
  end;

  case TMenuItem(Sender).Tag of
    1:
      if actLoadDeferred.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
        or (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;
    2:
      if actLoadDeferred_Search.Execute and
        ((FormParams.ParamByName('CheckId').Value <> 0) or
        (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;

    11:
      if actLoadVIP.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
        or (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;
    12:
      if actLoadVIP_Search.Execute and
        ((FormParams.ParamByName('CheckId').Value <> 0) or
        (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;

    21:
      if actLoadSite.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
        or (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;
    22:
      if actLoadSite_Search.Execute and
        ((FormParams.ParamByName('CheckId').Value <> 0) or
        (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;

    31:
      if actLoadLiki24.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
        or (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;
    32:
      if actLoadLiki24_Search.Execute and
        ((FormParams.ParamByName('CheckId').Value <> 0) or
        (FormParams.ParamByName('ManagerName').AsString <> '')) then
        LoadVIPCheck;
  end;

  //
  SetBlinkVIP(True);
  //
  if not gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      SaveLocalData(VipCDS, vip_lcl);
      SaveLocalData(VIPListCDS, vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
end;

procedure TMainCashForm2.actEnterBuyerForSiteExecute(Sender: TObject);
  var nBuyerForSiteId : Integer;
begin
  if not InputEnterBuyerForSite(nBuyerForSiteId, FBuyerForSite) then Exit;

  actOpenCheckBuyerForSite.GuiParams.ParamByName('BuyerForSiteId').Value := nBuyerForSiteId;
  if actLoadBuyerForSite.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
    or (FormParams.ParamByName('ManagerName').AsString <> '')) then
    LoadVIPCheck;
end;

procedure TMainCashForm2.actExecuteLoadVIPExecute(Sender: TObject);
var
  lMsg: String;
  nRecNo: Integer;
  APoint: TPoint;
begin
  inherited;

  if not CheckCDS.isempty then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;
  if gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(VipCDS, vip_lcl);
      LoadLocalData(VIPListCDS, vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
  APoint := btnVIP.ClientToScreen(Point(0, btnVIP.ClientHeight));
  pm_OpenVIP.Popup(APoint.X, APoint.Y);
end;

procedure TMainCashForm2.ClearFilterAll;
var
  Id: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
begin
  if RemainsCDS.Active and
    ((RemainsCDS.Filter <> 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0')
    or Assigned(RemainsCDS.OnFilterRecord) or pnlAnalogFilter.Visible) then
  begin
    Id := RemainsCDS.FieldByName('Id').AsInteger;
    PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
    NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
    DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
    DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try

      if RemainsUnitOneCDS.Active then
      begin
        RemainsUnitOneCDS.First;
        while not RemainsUnitOneCDS.Eof do
        begin
          if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                   VarArrayOf([RemainsUnitOneCDS.FieldByName('GoodsId').AsInteger,
                               RemainsUnitOneCDS.FieldByName('PartionDateKindId').AsVariant,
                               RemainsUnitOneCDS.FieldByName('NDSKindId').AsVariant,
                               RemainsUnitOneCDS.FieldByName('DiscountExternalID').AsVariant,
                               RemainsUnitOneCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
          begin
            RemainsCDS.Edit;
            RemainsCDS.FieldByName('Remains').AsCurrency := RemainsUnitOneCDS.FieldByName('Remains').AsCurrency;
            RemainsCDS.Post;
          end;

          RemainsUnitOneCDS.Next;
        end;
        RemainsUnitOneCDS.Close;
      end;

      RemainsCDS.OnFilterRecord := Nil;
      RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
      pnlExpirationDateFilter.Visible := false;
      pnlAnalogFilter.Visible := false;
    finally
      RemainsCDS.Filtered := True;
      if not RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([Id, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []) then
        RemainsCDS.Locate('Id', Id, []);
      RemainsCDS.EnableControls;
      edlExpirationDateFilter.Text := '';
      edAnalogFilter.Text := '';
    end;
  end;
end;

procedure TMainCashForm2.actExpirationDateFilterExecute(Sender: TObject);
var
  S: string;
  I: Integer;
begin

  if pnlExpirationDateFilter.Visible then
  begin
    ClearFilterAll;
    exit;
  end
  else
    ClearFilterAll;;

  S := '';
  while True do
  begin
    if not InputQuery('Фильтр по сроку годности остатка',
      'Введите количество месяцев: ', S) then
      exit;
    if S = '' then
      exit;
    if not TryStrToInt(S, I) or (I < 1) then
    begin
      ShowMessage('Количество месяцев должно быть не менее одного.');
    end
    else
      Break;
  end;

  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := false;
  try
    try
      RemainsCDS.Filter :=
        '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and MinExpirationDate <= '
        + QuotedStr(FormatDateTime(FormatSettings.ShortDateFormat,
        IncMonth(Date, I)));
      RemainsCDS.Filtered := True;
      edlExpirationDateFilter.Text :=
        FormatDateTime(FormatSettings.ShortDateFormat, IncMonth(Date, I));
      pnlExpirationDateFilter.Visible := True;
    except
      RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
      pnlExpirationDateFilter.Visible := false;
      edlExpirationDateFilter.Text := '';
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.EnableControls;
  end;

end;

procedure TMainCashForm2.actGetJuridicalListExecute(Sender: TObject);
begin
  if edDiscountAmount.Visible and (edDiscountAmount.Value > 0.0) then
  begin
    spGet_JuridicalList.ParamByName('inGoodsId').Value :=
      RemainsCDS.FieldByName('Id').AsInteger;
    spGet_JuridicalList.ParamByName('inAmount').Value := edDiscountAmount.Value;
    ShowMessage(spGet_JuridicalList.Execute());
  end;
end;

procedure TMainCashForm2.actGetJuridicalListUpdate(Sender: TObject);
begin
  actGetJuridicalList.Enabled := edDiscountAmount.Visible and
    (edDiscountAmount.Value > 0);
end;

procedure TMainCashForm2.actGetMoneyInCashExecute(Sender: TObject);
begin
  if gc_User.Local then
    exit;

  spGet_Password_MoneyInCash.Execute;
  // временно будем без пароля
  // if InputBox('Пароль','Введите пароль:','') <> spGet_Password_MoneyInCash.ParamByName('outPassword').AsString then exit;
  //
  spGetMoneyInCash.ParamByName('inDate').Value := Date;
  spGetMoneyInCash.Execute;
  try
    lblMoneyInCash.Caption := FormatFloat(',0.00',
      spGetMoneyInCash.ParamByName('outTotalSumm').AsFloat);
  finally
    TimerMoneyInCash.Enabled := True;
  end;
end;

// Установка фильтра по аналогу
procedure TMainCashForm2.SetGoodsAnalogFilter(AGoodsAnalog: string);
begin
  Label19.Caption := '  Фильтр: ';
  case FAnalogFilter of
    1:
      Label19.Caption := Label19.Caption + 'Аналоги по действующему веществу';
    2:
      Label19.Caption := Label19.Caption + 'Коды АТС';
    3:
      Label19.Caption := Label19.Caption + 'Действующее вещество';
  end;
  edAnalogFilter.Text := AGoodsAnalog;
  pnlAnalogFilter.Visible := True;
end;

function TMainCashForm2.ExistsLessAmountMonth(AGoodsId: Integer;
  AAmountMonth: Currency): Boolean;
var
  nPos, nPartionDateKindId: Integer;
  cFilter, S, cResult: string;
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  ExpirationDateExpirationDate : TDateTime;
begin
  Result := false;
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  RemainsCDS.DisableControls;
  cFilter := RemainsCDS.Filter;
  RemainsCDS.Filtered := false;
  try
    try
      RemainsCDS.Filter := 'ID = ' + IntToStr(AGoodsId) +
        ' and Remains > 0 and AmountMonth > 0';
      if AAmountMonth > 0 then
        RemainsCDS.Filter := RemainsCDS.Filter + ' and AmountMonth < ' +
          CurrToStr(AAmountMonth);
      RemainsCDS.Filtered := True;
      RemainsCDS.First;
      S := '';
      if not RemainsCDS.Eof then
      begin
        S := S + #13#10 + RemainsCDS.FieldByName('PartionDateKindName').AsString
          + ' - ' + RemainsCDS.FieldByName('Remains').AsString;
        RemainsCDS.Next;
      end;
      if S <> '' then
      begin
        RemainsCDS.First;
        Result := MessageDlg('У медикамента '#13#10 + RemainsCDS.FieldByName
          ('GoodsCode').AsString + ' - ' + RemainsCDS.FieldByName('GoodsName')
          .AsString + #13#10'есть наличие со сроками: '#13#10 + S +
          #13#10#13#10'Опустить товар в чек ?...', mtConfirmation, mbYesNo,
          0) <> mrYes;
      end;

      if UnitConfigCDS.FindField('isMessageByTime').AsBoolean and not MessageByTime then
      begin
        ExpirationDateCDS.First;
        ExpirationDateExpirationDate :=  ExpirationDateCDS.FindField('ExpirationDate').AsDateTime;
        while not ExpirationDateCDS.Eof do
        begin
          if ExpirationDateExpirationDate <> ExpirationDateCDS.FindField('ExpirationDate').AsDateTime then
          begin
            MessageByTime := True;
            ShowPUSHMessageCash('Проверьте соответствие срока годности с фактическим на товаре!'#13#10 +
                                'После пробития программа списывает ближайший короткий срок.', cResult);
            Break;
          end;
          ExpirationDateCDS.Next;
        end;
      end else if UnitConfigCDS.FindField('isMessageByTimePD').AsBoolean and not MessageByTime then
      begin
        nPartionDateKindId := -1;
        ExpirationDateCDS.First;
        while not ExpirationDateCDS.Eof do
        begin
          if nPartionDateKindId < 0 then
          begin
            if PartionDateKindId =  ExpirationDateCDS.FindField('PartionDateKindId').AsVariant then
            begin
               if PartionDateKindId = Null then nPartionDateKindId := 0
               else nPartionDateKindId := PartionDateKindId;
               ExpirationDateExpirationDate :=  ExpirationDateCDS.FindField('ExpirationDate').AsDateTime;
            end;
          end else if (ExpirationDateExpirationDate <> ExpirationDateCDS.FindField('ExpirationDate').AsDateTime) and
                      (nPartionDateKindId = ExpirationDateCDS.FindField('PartionDateKindId').AsInteger) then
          begin
            MessageByTime := True;
            ShowPUSHMessageCash('Проверьте соответствие срока годности с фактическим на товаре!'#13#10 +
                                'После пробития программа списывает ближайший короткий срок.', cResult);
            Break;
          end;
          ExpirationDateCDS.Next;
        end;
      end;
    except
    end;
  finally
    RemainsCDS.Filter := cFilter;
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.actGoodsAnalogChooseExecute(Sender: TObject);
var
  nGoodsAnalogId: Integer;
  cGoodsAnalogName: string;
begin
  if pnlAnalogFilter.Visible then
  begin
    ClearFilterAll;
    exit;
  end
  else
    ClearFilterAll;

  FAnalogFilter := ShowListSelection('Поиск по',
    ['Аналогам по действующему веществу', 'Аналогам товара ATC',
    'Действующему вещество'], FAnalogFilter);
  if FAnalogFilter > 0 then
    SetGoodsAnalogFilter('');
end;

procedure TMainCashForm2.actGoodsAnalogExecute(Sender: TObject);
begin
  if pnlAnalogFilter.Visible then
  begin
    ClearFilterAll;
    exit;
  end
  else
    ClearFilterAll;

  FAnalogFilter := ShowListSelection('Поиск по',
    ['Аналогам по действующему веществу', 'Коду АТС',
    'Действующему вещество'], FAnalogFilter);

  case FAnalogFilter of
    1:
      SetGoodsAnalogFilter(StringReplace(RemainsCDS.FieldByName('GoodsAnalog')
        .AsString, #13#10, ' ', [rfReplaceAll]));
    2:
      SetGoodsAnalogFilter
        (StringReplace(RemainsCDS.FieldByName('GoodsAnalogATC').AsString,
        #13#10, ' ', [rfReplaceAll]));
    3:
      SetGoodsAnalogFilter
        (StringReplace(RemainsCDS.FieldByName('GoodsActiveSubstance').AsString,
        #13#10, ' ', [rfReplaceAll]));
  end;

end;

procedure TMainCashForm2.TimerMoneyInCashTimer(Sender: TObject);
begin
  TimerMoneyInCash.Enabled := false;
  try
    lblMoneyInCash.Caption := '0.00';
  finally
  end;
end;

procedure TMainCashForm2.SaveHardwareData(IsShowInputHardware : boolean = False);
  var Identifier : string; License, Smartphone, Modem, BarcodeScanner	 : boolean; Ini: TIniFile;
begin

  if gc_User.Local or (gc_User.Session = '3') then exit;

  if FileExists(TPath.GetSharedDocumentsPath + '\FarmacyCash\HardwareData.ini') then
  begin
    Ini := TIniFile.Create(TPath.GetSharedDocumentsPath + '\FarmacyCash\HardwareData.ini');
    try
      Identifier := Ini.ReadString('HardwareData', 'Identifier', '');
      License := Ini.ReadBool('HardwareData', 'License', False);
      Smartphone := Ini.ReadBool('HardwareData', 'Smartphone', False);
      Modem := Ini.ReadBool('HardwareData', 'Modem', False);
      BarcodeScanner := Ini.ReadBool('HardwareData', 'BarcodeScanner', False);
    finally
      Ini.free;
    end;

  end else
  begin
    Identifier := '';
    License := False;
    Smartphone := False;
    Modem := False;
    BarcodeScanner := False;
  end;

  if IsShowInputHardware or (Length(Trim(Identifier)) <> 4) then
  begin
    if not InputHardwareDialog(Identifier, License, Smartphone, Modem, BarcodeScanner) then
      exit;

    if (Trim(Identifier) = '') or (Length(Trim(Identifier)) <> 4) then
    begin
      ShowMessage('Не заполнен идентификатор.');
      Exit;
    end;

    if not TDirectory.Exists(TPath.GetSharedDocumentsPath + '\FarmacyCash') then
      TDirectory.CreateDirectory(TPath.GetSharedDocumentsPath + '\FarmacyCash');
    Ini := TIniFile.Create(TPath.GetSharedDocumentsPath + '\FarmacyCash\HardwareData.ini');
    try
      Ini.WriteString('HardwareData', 'Identifier', Identifier);
      Ini.WriteBool('HardwareData', 'License', License);
      Ini.WriteBool('HardwareData', 'Smartphone', Smartphone);
      Ini.WriteBool('HardwareData', 'Modem', Modem);
      Ini.WriteBool('HardwareData', 'BarcodeScanner', BarcodeScanner);
    finally
      Ini.free;
    end;
  end;

  try
    if Assigned(Cash) then
    begin
      spUpdateHardwareDataCash.ParamByName('inIdentifier').Value :=
        Identifier;
      spUpdateHardwareDataCash.ParamByName('inisLicense').Value :=
        License;
      spUpdateHardwareDataCash.ParamByName('inisSmartphone').Value :=
        Smartphone;
      spUpdateHardwareDataCash.ParamByName('inisModem').Value :=
        Modem;
      spUpdateHardwareDataCash.ParamByName('inisBarcodeScanner').Value :=
        BarcodeScanner;
      spUpdateHardwareDataCash.ParamByName('inSerial').Value :=
        Cash.FiscalNumber;
      spUpdateHardwareDataCash.ParamByName('inTaxRate').Value :=
        Cash.GetTaxRate;
      spUpdateHardwareDataCash.ParamByName('inComputerName').Value :=
        GetComputerName;
      spUpdateHardwareDataCash.ParamByName('inBaseBoardProduct').Value :=
        GetBaseBoardProduct;
      spUpdateHardwareDataCash.ParamByName('inProcessorName').Value :=
        GetProcessorName;
      spUpdateHardwareDataCash.ParamByName('inDiskDriveModel').Value :=
        GetDiskDriveModel;
      spUpdateHardwareDataCash.ParamByName('inPhysicalMemory').Value :=
        GetPhysicalMemory;
      spUpdateHardwareDataCash.Execute;
    end
    else
    begin
      spUpdateHardwareData.ParamByName('inIdentifier').Value :=
        Identifier;
      spUpdateHardwareData.ParamByName('inisLicense').Value :=
        License;
      spUpdateHardwareData.ParamByName('inisSmartphone').Value :=
        Smartphone;
      spUpdateHardwareData.ParamByName('inisModem').Value :=
        Modem;
      spUpdateHardwareData.ParamByName('inisBarcodeScanner').Value :=
        BarcodeScanner;
      spUpdateHardwareData.ParamByName('inComputerName').Value :=
        GetComputerName;
      spUpdateHardwareData.ParamByName('inBaseBoardProduct').Value :=
        GetBaseBoardProduct;
      spUpdateHardwareData.ParamByName('inProcessorName').Value :=
        GetProcessorName;
      spUpdateHardwareData.ParamByName('inDiskDriveModel').Value :=
        GetDiskDriveModel;
      spUpdateHardwareData.ParamByName('inPhysicalMemory').Value :=
        GetPhysicalMemory;
      spUpdateHardwareData.Execute;
    end;

    if UnitConfigCDS.FindField('isGetHardwareData').AsBoolean then
    begin
      UnitConfigCDS.Edit;
      UnitConfigCDS.FindField('isGetHardwareData').AsBoolean := false;
      UnitConfigCDS.Post;
    end;
  except
    ON E: Exception do
      Add_Log('SaveHardwareData err=' + E.Message);
  end;
end;

procedure TMainCashForm2.TimerPUSHTimer(Sender: TObject);
var
  cResult: string;
  LocalVersionInfo, BaseVersionInfo: TVersionInfo;

  procedure Load_PUSH(ARun: Boolean);
  begin
    if ARun or (FLoadPUSH > 15) then
    begin
      FLoadPUSH := 0;

      if not gc_User.Local then
        try
          spGet_PUSH_Cash.Execute;
          TimerPUSH.Interval := 1000;
        except
          ON E: Exception do
            Add_Log('Load_PUSH err=' + E.Message);
        end;
    end
    else
      Inc(FLoadPUSH);
  end;

  function isServiseOld : Boolean;
  var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
      OldProgram, OldServise : Boolean;
  begin
    Result := False;
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCashServise.exe', GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe', ''));
    LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe');
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then Result := True;
  end;

begin
  TimerPUSH.Enabled := false;
  TimerPUSH.Interval := 60 * 1000;
  if TimeOf(FPUSHEnd) > TimeOf(Now) then
    FPUSHEnd := Now;
  try

    if FPUSHStart then
    begin
      ShowPUSHMessageCash('Уважаемые коллеги!'#13#10#13#10 +
        '1. Сделайте Х-отчет, убедитесь, что он пустой 0,00.'#13#10 +
        '   Форс-Мажор РРО: звоним в любое время Татьяна (099-641-59-21), Юлия (0957767101)'#13#10
        + '2. Сделайте нулевой чек, проверьте дату и время.'#13#10 +
        '3. Сделайте внесение 100,00 грн.', cResult);

      if isServiseOld then
        ShowPUSHMessageCash('Не обновлена служба FCash Service.'#13#10#13#10'Обратитесь в IT отдел.', cResult);

      ShowPUSHMessageCash('Коллеги, по всем вопросам и предложениям для улучшения мобильного приложения ПРОСЬБА обращаться к Олегу либо к Кристине.'#13#10 +
                          'Чем лучше будет приложение тем больше новых клиентов сможем подтянуть, а это ваши дополнительные +грн к зп!!!', cResult);

      Load_PUSH(True);
    end
    else if UnitConfigCDS.Active and
      Assigned(UnitConfigCDS.FindField('TimePUSHFinal1')) and
      (not UnitConfigCDS.FieldByName('TimePUSHFinal1').IsNull and
      (TimeOf(FPUSHEnd) < TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal1')
      .AsDateTime)) and (TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal1')
      .AsDateTime) < TimeOf(Now)) or not UnitConfigCDS.FieldByName
      ('TimePUSHFinal2').IsNull and
      (TimeOf(FPUSHEnd) < TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal2')
      .AsDateTime)) and (TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal2')
      .AsDateTime) < TimeOf(Now))) then
    begin
      ShowPUSHMessageCash('Уважаемые коллеги!'#13#10 +
        '1. Не забудьте сделать X-отчет!!! Вынесите необходимую сумму наличных средств из кассы согласно Х-отчета за минусом 100,00 грн !!!'#13#10
        + '2. Еще раз сделайте х-отчет!!! Убедитесь, что наличных в кассе 100,00 грн!!!'#13#10
        + '3. Сделайте z-отчет!!!'#13#10 +
        '4. Убедитесь, что Ваш z-отчет отправился в бухгалтерию!!!'#13#10 +
        '5. Форс-Мажор РРО: звоним в любое время : Татьяна (099-641-59-21), Юлия (0957767101)'#13#10
        + '6. Сделайте запись в книге РРО!!!', cResult);
      FPUSHEnd := Now;
    end
    else if (CheckCDS.RecordCount = 0) and PUSHDS.Active and
      (PUSHDS.RecordCount > 0) then
    begin
      PUSHDS.First;
      try
        TimerPUSH.Interval := 1000;

        if PUSHDS.FieldByName('isFormOpen').AsBoolean then
        begin

          if PUSHDS.FieldByName('isExecStoredProc').AsBoolean then
            ExecStoredProc(PUSHDS.FieldByName('FormName').AsString
                         , PUSHDS.FieldByName('Params').AsString
                         , PUSHDS.FieldByName('TypeParams').AsString
                         , PUSHDS.FieldByName('ValueParams').AsString)
          else if PUSHDS.FieldByName('isFormLoad').AsBoolean then
            OpenForm(PUSHDS.FieldByName('FormName').AsString
                   , PUSHDS.FieldByName('Params').AsString
                   , PUSHDS.FieldByName('TypeParams').AsString
                   , PUSHDS.FieldByName('ValueParams').AsString)
          else OpenStaticForm(PUSHDS.FieldByName('FormName').AsString
                            , PUSHDS.FieldByName('Params').AsString
                            , PUSHDS.FieldByName('TypeParams').AsString
                            , PUSHDS.FieldByName('ValueParams').AsString);

          if PUSHDS.FieldByName('Id').AsInteger > 1000 then
          try
            spInsert_MovementItem_PUSH.ParamByName('inMovement').Value :=
              PUSHDS.FieldByName('Id').AsInteger;
            spInsert_MovementItem_PUSH.ParamByName('inResult').Value := '';
            spInsert_MovementItem_PUSH.Execute;
          except
            ON E: Exception do
              Add_Log('Marc_PUSH err=' + E.Message);
          end;
        end else if ShowPUSHMessageCash(PUSHDS.FieldByName('Text').AsString, cResult,
          PUSHDS.FieldByName('isPoll').AsBoolean,
          PUSHDS.FieldByName('FormName').AsString,
          PUSHDS.FieldByName('Button').AsString,
          PUSHDS.FieldByName('Params').AsString,
          PUSHDS.FieldByName('TypeParams').AsString,
          PUSHDS.FieldByName('ValueParams').AsString,
          PUSHDS.FieldByName('isFormLoad').AsBoolean,
          PUSHDS.FieldByName('isExecStoredProc').AsBoolean,
          PUSHDS.FieldByName('isSpecialLighting').AsBoolean,
          PUSHDS.FieldByName('TextColor').AsInteger,
          PUSHDS.FieldByName('Color').AsInteger,
          PUSHDS.FieldByName('isBold').AsBoolean) then
        begin
          if PUSHDS.FieldByName('Id').AsInteger > 1000 then
          try
            spInsert_MovementItem_PUSH.ParamByName('inMovement').Value :=
              PUSHDS.FieldByName('Id').AsInteger;
            if PUSHDS.FieldByName('isPoll').AsBoolean then
              spInsert_MovementItem_PUSH.ParamByName('inResult').Value
                := cResult
            else
              spInsert_MovementItem_PUSH.ParamByName('inResult').Value := '';
            spInsert_MovementItem_PUSH.Execute;
          except
            ON E: Exception do
              Add_Log('Marc_PUSH err=' + E.Message);
          end;
        end;
      finally
        PUSHDS.Delete;
      end;
    end else if not gc_User.Local then
    begin
      if FUpdatePUSH = 0 then
      begin
        BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)),
                           GetBinaryPlatfotmSuffics(ParamStr(0), ''));
        LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
        if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
           ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
        begin
          ShowPUSHMessageCash('Коллеги, обновите FCash, доступно новое обновление (Ctrl+U)!', cResult);
        end;

        if NeedTestProgram then
        begin
          ShowPUSHMessageCash('Коллеги, обновите FCash, для вас доступна тестовая версия (Ctrl+U)!', cResult);
        end;

        if UnitConfigCDS.FindField('isGetHardwareData').AsBoolean and (HourOf(Now) < 15) then
          SaveHardwareData;
      end;
      Inc(FUpdatePUSH);
      if FUpdatePUSH = 11 then FUpdatePUSH := 0;
    end;
    Load_PUSH(false);

    // Удалим Скайп
    if UnitConfigCDS.FindField('isRemovingPrograms').AsBoolean and (gc_User.Session <> '3') then
    begin
      UnitConfigCDS.Edit;
      UnitConfigCDS.FindField('isRemovingPrograms').AsBoolean := False;
      UnitConfigCDS.Post;
      ShellExecute(0,'open','powershell.exe','Get-AppxPackage *skypeapp* | Remove-AppxPackage', nil, SW_HIDE);
    end;

  finally
    FPUSHStart := false;
    TimerPUSH.Enabled := True;
  end;
end;

procedure TMainCashForm2.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if GetAmount <> 0 then
  begin // ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
    if not Assigned(SourceClientDataSet) then
      SourceClientDataSet := RemainsCDS;

    if SoldRegim AND (SourceClientDataSet.FieldByName('Price').asCurrency = 0)
    then
    begin
      ShowMessage('Нельзя продать товар с 0 ценой! Свяжитесь с менеджером');
      exit;
    end;

    InsertUpdateBillCheckItems;
  end;
  SoldRegim := True;
  if isScaner = True then
    ActiveControl := ceScaner
  else
    ActiveControl := lcName;
end;

procedure TMainCashForm2.actListGoodsKeywordExecute(Sender: TObject);
begin
  with TListGoodsKeywordForm.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainCashForm2.actBanCashExecute(Sender: TObject);
begin
  inherited;
  SetBanCash(True);
end;

procedure TMainCashForm2.actListDiffAddGoodsExecute(Sender: TObject);
begin

  if not RemainsCDS.Active then
    exit;
  if RemainsCDS.RecordCount < 1 then
    exit;

  with TListDiffAddGoodsForm.Create(nil) do
    try
      GoodsCDS := RemainsCDS;
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainCashForm2.actListGoodsExecute(Sender: TObject);
var
  S: string;
begin
  if not fileExists(Goods_lcl) then
  begin
    ShowMessage
      ('Справочник медикаментов не найден обратитесь к администратору...');
    exit;
  end;

  if Self.ActiveControl is TcxGridSite then
    S := MainGridDBTableView.DataController.Search.SearchText
  else if ActiveControl is TcxCustomComboBoxInnerEdit then
    S := Copy(lcName.Text, 1, Length(lcName.Text) - Length(lcName.SelText))
  else
    S := '';;

  with TListGoodsForm.Create(nil) do
    try
      if S <> '' then
        SetFilter(S);

      ShowModal
    finally
      Free;
    end;
end;

procedure TMainCashForm2.actManualDiscountExecute(Sender: TObject);
var
  S: string;
  I, nRecNo: Integer;
begin
  if not(Sender is TcxButton) then
  begin

    if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
    begin
      ShowMessage
        ('Применен соц проект.'#13#10'Для променениея ручной скидки обнулите чек и набрать позиции заново..');
      exit;
    end;

    if (DiscountServiceForm.gCode <> 0) then
    begin
      ShowMessage
        ('Применен дисконт.'#13#10'Для променениея ручной скидки обнулите чек и набрать позиции заново..');
      exit;
    end;

    if FormParams.ParamByName('PromoCodeGUID').Value <> '' then
    begin
      ShowMessage
        ('Установлен промокод.'#13#10'Для променениея ручной скидки обнулите промокод..');
      exit;
    end;

    if FormParams.ParamByName('SiteDiscount').Value <> 0 then
    begin
      ShowMessage
        ('Установлена скидка через сайт.'#13#10'Для променениея ручной скидки обнулите скидку через сайт..');
      exit;
    end;

    S := '';
    while True do
    begin
      if not InputQuery('Ручная скидка', 'Процент скидки: ', S) then
        exit;
      if S = '' then
        exit;
      if not TryStrToInt(S, I) or (I < 0) or (I > 50) then
      begin
        ShowMessage('Должно быть число от 0 до 50.');
      end
      else
        Break;
    end;
  end
  else
    I := 0;

  FormParams.ParamByName('ManualDiscount').Value := I;
  pnlManualDiscount.Visible := FormParams.ParamByName('ManualDiscount')
    .Value > 0;
  edManualDiscount.Value := FormParams.ParamByName('ManualDiscount').Value;

  FormParams.ParamByName('PromoCodeID').Value := 0;
  FormParams.ParamByName('PromoCodeGUID').Value := '';
  FormParams.ParamByName('PromoName').Value := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value := 0;

  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  pnlPromoCodeLoyalty.Visible := false;
  lblPromoCodeLoyalty.Caption := '';
  edPromoCodeLoyaltySumm.Value := 0;
  pnlLoyaltySaveMoney.Visible := false;
  lblLoyaltySMBuyer.Caption := '';
  edLoyaltySMSummaRemainder.Value := 0;
  edLoyaltySMSumma.Value := 0;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if CheckCDS.FieldByName('ChangePercent').asCurrency <>
        FormParams.ParamByName('ManualDiscount').Value then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('ManualDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('ManualDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
  end;
  CalcTotalSumm;
end;

procedure TMainCashForm2.actNotTransferTimeExecute(Sender: TObject);
var
  dsdSave: TdsdStoredProc;
  NotTransferTime: Boolean;
begin
  if not UnitConfigCDS.Active or
    not Assigned(UnitConfigCDS.FindField('isSpotter')) then
    exit;
  if not UnitConfigCDS.FindField('isSpotter').AsBoolean then
  begin
    ShowMessage('У вас нет прав изменять признак "Не переводить в сроки"');
    exit;
  end;

  if gc_User.Local then
  Begin
    ShowMessage('В отложенном режиме не работает...');
    exit;
  End;

  dsdSave := TdsdStoredProc.Create(nil);
  try
    // Проверить в каком состоянии документ.
    dsdSave.StoredProcName := 'gpGet_Object_Goods';
    dsdSave.OutputType := otResult;
    dsdSave.Params.Clear;
    dsdSave.Params.AddParam('inId', ftInteger, ptInput,
      RemainsCDS.FieldByName('Id').Value);
    dsdSave.Params.AddParam('NotTransferTime', ftBoolean, ptOutput, Null);
    dsdSave.Execute(false, false);
    if dsdSave.Params.ParamByName('NotTransferTime').Value = Null then
      exit;

    NotTransferTime := dsdSave.Params.ParamByName('NotTransferTime').Value;
    if NotTransferTime then
    begin
      if MessageDlg('Убрать признак "Не переводить в сроки"?', mtConfirmation,
        mbYesNo, 0) <> mrYes then
        exit;
    end
    else if MessageDlg('Установить признак "Не переводить в сроки"?',
      mtConfirmation, mbYesNo, 0) <> mrYes then
      exit;

    dsdSave.StoredProcName := 'gpUpdate_Goods_NotTransferTime';
    dsdSave.OutputType := otResult;
    dsdSave.Params.Clear;
    dsdSave.Params.AddParam('inId', ftInteger, ptInput,
      RemainsCDS.FieldByName('Id').Value);
    dsdSave.Params.AddParam('ioNotTransferTime', ftBoolean, ptInputOutput,
      not NotTransferTime);
    dsdSave.Execute(false, false);

    try
      RemainsCDS.DisableControls;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('NotTransferTime').AsBoolean :=
        dsdSave.Params.ParamByName('ioNotTransferTime').Value;
      RemainsCDS.Post;
    finally
      RemainsCDS.EnableControls;
    end;
  finally
    freeAndNil(dsdSave);
  end;
end;

procedure TMainCashForm2.actOpenFilesToCheckExecute(Sender: TObject);
  var nId : Integer;
begin
  if UnitConfigCDS.FieldByName('FilesToCheckCount').AsInteger <= 0 then Exit;
  if  UnitConfigCDS.FieldByName('FilesToCheckCount').AsInteger > 1 then
  begin
    if not actChoiceFilesToCheckCash.Execute then Exit;
    nId := actChoiceFilesToCheckCash.GuiParams.ParamByName('Key').Value;
  end else nId := UnitConfigCDS.FieldByName('FilesToCheckID').AsInteger;

  spFilesToCheckFTPParams.ParamByName('inID').Value := nId;
  if spFilesToCheckFTPParams.Execute = '' then actDownloadAndRunFile.Execute;
end;

procedure TMainCashForm2.actOpenLayoutFileExecute(Sender: TObject);
  var nId : Integer;
begin
  if UnitConfigCDS.FieldByName('LayoutFileCount').AsInteger <= 0 then Exit;
  if  UnitConfigCDS.FieldByName('LayoutFileCount').AsInteger > 1 then
  begin
    if not actChoiceLayoutFileCash.Execute then Exit;
    nId := actChoiceLayoutFileCash.GuiParams.ParamByName('Key').Value;
  end else nId := UnitConfigCDS.FieldByName('LayoutFileID').AsInteger;

  spLayoutFileFTPParams.ParamByName('inID').Value := nId;
  if spLayoutFileFTPParams.Execute = '' then actDownloadAndRunFile.Execute;
end;

procedure TMainCashForm2.actOpenMCSExecute(Sender: TObject);
begin
  if UnitConfigCDS.FieldByName('isNotCashMCS').AsBoolean then
  begin
    ShowMessage('Уважаемые коллеги. Изменение <НТЗ> заблокировано.');
  end
  else
    actOpenMCSForm.Execute;
end;

// проверили что есть остаток
function TMainCashForm2.fCheck_RemainsError: Boolean;
var
  JsonArray: TJSONArray;
  JSONObject: TJSONObject;
  JsonText: String;
  B: TBookmark;

  procedure AddParamToJSON(AName: string; AValue: Variant; ADataType: TFieldType);
    var intValue: integer; n : Double;
  begin
    if AValue = NULL then
      JSONObject.AddPair(LowerCase(AName), TJSONNull.Create)
    else if ADataType = ftDateTime then
      JSONObject.AddPair(LowerCase(AName), FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue))
    else if ADataType = ftFloat then
    begin
      if TryStrToFloat(AValue, n) then
        JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(n))
      else
        JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
    end else if ADataType = ftInteger then
    begin
      if TryStrToInt(AValue, intValue) then
        JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(intValue))
      else
        JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
    end
    else
      JSONObject.AddPair(LowerCase(AName), TJSONString.Create(AValue));
  end;

begin
  Result := false;
  //
  JSONArray := TJSONArray.Create();
  try
    // формируется список товаров
    with CheckCDS do
    begin
      B := GetBookmark;
      DisableControls;
      try
        First;
        while Not Eof do
        Begin
          JSONObject := TJSONObject.Create;
          AddParamToJSON('GoodsId', FieldByName('GoodsId').AsVariant, FieldByName('GoodsId').DataType);
          AddParamToJSON('Amount', FieldByName('Amount').AsVariant, FieldByName('Amount').DataType);
          AddParamToJSON('PartionDateKindId', FieldByName('PartionDateKindId').AsVariant, FieldByName('PartionDateKindId').DataType);
          AddParamToJSON('NDSKindId', FieldByName('NDSKindId').AsVariant, FieldByName('NDSKindId').DataType);
          AddParamToJSON('DivisionPartiesId', FieldByName('DivisionPartiesId').AsVariant, FieldByName('DivisionPartiesId').DataType);
          AddParamToJSON('JuridicalId', FieldByName('JuridicalId').AsVariant, FieldByName('JuridicalId').DataType);
          JsonArray.AddElement(JSONObject);
          Next;
        End;
        GotoBookmark(B);
        FreeBookmark(B);
      finally
        EnableControls;
      end;
    end;
  finally
    JsonText := JSONArray.ToString;
    JSONArray.Free;
  end;
  //
  // теперь вызов
  with spCheck_RemainsError do
    try
      if (FormParams.ParamByName('HelsiPartialPrescription').Value = False) then
        ParamByName('inSPKindId').Value := Self.FormParams.ParamByName('SPKindId').Value
      else ParamByName('inSPKindId').Value := 0;
      ParamByName('inJSON').Value := JsonText;
      Execute;
      Result := ParamByName('outMessageText').Value = '';
      // if not Result then ShowMessage(ParamByName('outMessageText').Value);
    except
      // т.е. нет связи и это не является ошибкой
      Result := True;
    end;
  if not Result then
  begin
    actShowMessage.MessageText := spCheck_RemainsError.ParamByName
      ('outMessageText').Value;
    actShowMessage.Execute;
  end;
end;

procedure TMainCashForm2.actPromoCodeDoctorExecute(Sender: TObject);
begin
  if not actChoicePromoCodeDoctor.Execute then
    exit;
  edPromoCode.Text := actChoicePromoCodeDoctor.GuiParams.ParamByName
    ('TextValue').Value;
  edPromoCodeExit(Sender);
end;

procedure TMainCashForm2.actPutCheckToCashExecute(Sender: TObject);
var
  UID, CheckNumber, ConfirmationCode, S, S1, cResult: String;
  lMsg: String;
  isPromoForSale, isYes, isDiscountCommit: Boolean;
  dsdSave: TdsdStoredProc;
  nBankPOSTerminal: Integer;
  nPOSTerminalCode: Integer;
  HelsiError: Boolean;
  nOldColor: Integer;
  nSumAll: Currency;
  GoodsId: Integer;
  nRecNo: Integer;
  GoodsIdPS, nGoodsNotUKTZED, nGoodsUKTZED: Integer;
  nAmountPS, nPresent: Currency;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  aRelatedProductId : array of Integer;
  aRelatedProductPrice : array of Currency;
  I, CheckOldId, ZReport : integer;
begin
  if CheckCDS.RecordCount = 0 then
    exit;
  TimerDroppedDown.Enabled := True;
  CheckOldId := 0;

  if pnlPosition.Visible then
  begin
    ShowMessage('Ошибка. Закончите подбор медикаментов по рецепту.');
    exit;
  end;

  if FormParams.ParamByName('isAutoVIPforSales').Value = TRUE then
  begin
    ShowMessage('Ошибка. ВИП чек для резерва под продажи проводить запрещено.');
    exit;
  end;

  if (FormParams.ParamByName('CheckId').Value <> 0) and
    (FormParams.ParamByName('ConfirmedKindName').AsString = 'Не подтвержден')
  then
  begin
    ShowMessage('Ошибка.VIP-чек <Не подтвержден>.');
    exit;
  end;

  if (FormParams.ParamByName('CheckId').Value = 0) and
    (FormParams.ParamByName('SiteDiscount').Value > 0) then
  begin
    ShowMessage
      ('Ошибка.Установлен признак <Скидка через сайт> необходимо установить VIP-чек.');
    exit;
  end;

  if fBanCash then
  begin
    ShowMessage
      ('Уважаемые коллеги, вы не поставили отметку времени прихода и ухода в график (Ctrl+T), исходя из персонального графика работы (время вводится с шагом 30 мин)');
    exit;
  end;

  if not DiscountServiceForm.isBeforeSale and (DiscountServiceForm.gCode <> 0) and
    (FormParams.ParamByName('isDiscountCommit').Value = False) then
  begin
    ShowMessage('По дисконтрой программе не запрошена возможность продажи!');
    exit;
  end;

  if (FormParams.ParamByName('HelsiID').Value <> '') then
  begin
    if CheckCDS.RecordCount <> 1 then
    begin
      ShowMessage('Ошибка.В чеке для Соц.проекта должен быть один товар.');
      exit;
    end;

    if cbSpec.Checked or cbSpecCorr.Checked then
    begin
      ShowMessage('Ошибка.Пробейте снова, чек по СП не погашен поскольку проходит галкой.');
      exit;
    end;

    if (FormParams.ParamByName('HelsiPartialPrescription').Value = True) then
    begin
      if RoundTo(CheckCDS.FieldByName('CountSP').asCurrency * CheckCDS.FieldByName
        ('Amount').asCurrency, -2) > FormParams.ParamByName('HelsiQty').Value then
      begin
        ShowMessage('Ошибка.'#13#10'В рецепте выписано: ' + FormatCurr('0.####',
          FormParams.ParamByName('HelsiQty').Value) + ' единиц'#13#10'В чеке: ' +
          FormatCurr('0.####', RoundTo(CheckCDS.FieldByName('CountSP').asCurrency *
          CheckCDS.FieldByName('Amount').asCurrency, -2)) +
          ' единиц'#13#10'Проверьте количество товара, опущенного в чек.');
        exit;
      end else if MessageDlg('В рецепте выписано: ' + FormatCurr('0.####',
          FormParams.ParamByName('HelsiQty').Value) + ' единиц'#13#10'В чеке: ' +
          FormatCurr('0.####', RoundTo(CheckCDS.FieldByName('CountSP').asCurrency *
          CheckCDS.FieldByName('Amount').asCurrency, -2)) +
          ' единиц'#13#10'Производит отпуск ментшего количества чем выписано ?...',
          mtConfirmation, mbYesNo, 0) <> mrYes then Exit;
    end else if RoundTo(CheckCDS.FieldByName('CountSP').asCurrency * CheckCDS.FieldByName
      ('Amount').asCurrency, -2) <> FormParams.ParamByName('HelsiQty').Value then
    begin
      ShowMessage('Ошибка.'#13#10'В рецепте выписано: ' + FormatCurr('0.####',
        FormParams.ParamByName('HelsiQty').Value) + ' единиц'#13#10'В чеке: ' +
        FormatCurr('0.####', RoundTo(CheckCDS.FieldByName('CountSP').asCurrency *
        CheckCDS.FieldByName('Amount').asCurrency, -2)) +
        ' единиц'#13#10'Проверьте количество товара, опущенного в чек.');
      exit;
    end;

    if not InputQuery('Введите код подтверждения рецепта',
      'Код подтверждения: ', ConfirmationCode) then
      exit;
    FormParams.ParamByName('ConfirmationCodeSP').Value := ConfirmationCode;
  end;

  if FormParams.ParamByName('PartnerMedicalId').Value <> 0 then
    if not CheckSP then
      exit;

  ClearDistributionPromo;

  // Контроль чека до печати
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  nPresent := 0; nGoodsNotUKTZED := 0; nGoodsUKTZED := 0;
  isPromoForSale := False;
  try
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    with CheckCDS do
    begin
      First;
      while not Eof do
      begin

        RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
            VarArrayOf([FieldByName('GoodsId').AsInteger,
            FieldByName('PartionDateKindId').AsVariant,
            FieldByName('NDSKindId').AsVariant,
            FieldByName('DiscountExternalID').AsVariant,
            FieldByName('DivisionPartiesID').AsVariant]), []);

        if (FieldByName('Multiplicity').asCurrency <> 0) and
          (FieldByName('Price').asCurrency <> FieldByName('PriceSale').asCurrency)
          and (trunc(FieldByName('Amount').asCurrency /
          FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0) then
        begin
          ShowMessage('Для медикамента '#13#10 + FieldByName('GoodsName').AsString
            + #13#10'установлена кратность при отпуске со скидкой.'#13#10#13#10 +
            'Отпускать со скидкой разрешено кратно ' + FieldByName('Multiplicity')
            .AsString + ' упаковки.');
          exit;
        end;

        if (FieldByName('PartionDateKindId').AsInteger <> 0) and
          (FieldByName('AmountMonth').AsInteger = 0) and
          not(actSpecCorr.Checked or actSpec.Checked) and
          (FieldByName('Amount').AsCurrency <> 0) and
          (FormParams.ParamByName('isCorrectMarketing').Value = False) and
          (FormParams.ParamByName('isCorrectIlliquidAssets').Value = False) then
        begin
          ShowMessage('Ошибка.В чеке использован просроченный товар '#13#10 +
            FieldByName('GoodsName').AsString);
          exit;
        end;

        if DiscountServiceForm.gCode <> 0 then
        begin
          if RemainsCDS.FieldByName('GoodsDiscountId').AsInteger <> DiscountServiceForm.gDiscountExternalId then
          begin
            ShowMessage('Ошибка.Товар <' + FieldByName('GoodsName').AsString + '> не участвует в дисконтной программе ' + FormParams.ParamByName('DiscountExternalName').Value + '!');
            exit;
          end;

          if (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency > 0) and
             (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency < FieldByName('PriceSale').AsCurrency) and
             (FieldByName('Amount').AsCurrency > 0) then
          begin
            ShowMessage('Превышена максимально возможная цена на препарат <' + FieldByName('GoodsName').AsString + '>. Обратитесь к Калининой Кристине...');
            exit;
          end;

        end else if RemainsCDS.FieldByName('isGoodsForProject').AsBoolean and (RemainsCDS.FieldByName('GoodsDiscountId').AsInteger <> 0) then
        begin
          ShowMessage('Ошибка.Товар <' + FieldByName('GoodsName').AsString + '> предназначен для дисконтной программе ' + RemainsCDS.FindField('GoodsDiscountName').AsString + '!');
          exit;
        end;

        if RemainsCDS.FieldByName('isOnlySP').AsBoolean and (FormParams.ParamByName('HelsiID').Value = '') then
        begin
          ShowMessage('Ошибка.Товар <' + FieldByName('GoodsName').AsString + '> предназначен для программы "Доступні ліки"!');
          exit;
        end;

        if FieldByName('isGoodsPairSun').AsBoolean then
        begin

          // Только целое количество
          if (Round(FieldByName('Amount').AsCurrency) <> FieldByName('Amount').AsCurrency) then
          begin
            ShowMessage('Товар по соц.проекту должен продаваться целыми упаковками...');
            exit;
          end;

          // Проверим наличие парного
          nRecNo := RecNo;
          nAmountPS := 0;
          try
            GoodsIdPS := FieldByName('GoodsId').AsInteger;
            First;
            while not Eof do
            begin
              if (FieldByName('GoodsPairSunMainId').AsInteger = GoodsIdPS) and
                 ((FieldByName('GoodsPairSunAmount').AsCurrency = 1) or (FieldByName('JuridicalId').AsInteger <> 0)) then
                nAmountPS := nAmountPS + FieldByName('Amount').AsCurrency * FieldByName('GoodsPairSunAmount').AsCurrency;
              Next;
            end;
          finally
            RecNo := nRecNo;
          end;

          if nAmountPS < FieldByName('Amount').AsCurrency then
          begin
            ShowMessage('Количество товара <' + FieldByName('GoodsName').AsString + '> по соц.проекту больше количества парного товара...');
            exit;
          end;
        end;

        if (FieldByName('MultiplicitySale').AsCurrency > 0) and (Frac(FieldByName('Amount').AsCurrency) <> 0) then
        begin
          if Frac(FieldByName('Amount').AsCurrency / FieldByName('MultiplicitySale').AsCurrency) <> 0 then
          begin
            if not FieldByName('isMultiplicityError').AsBoolean or (RemainsCDS.FieldByName('Remains').AsCurrency > 0) then
            begin
              ShowMessage('Деление медикамента разрешено кратно ' + FieldByName('MultiplicitySale').AsString + ' !');
              exit;
            end;
          end;
        end;

        if (FieldByName('Amount').AsCurrency > 0) and not FieldByName('isPresent').AsBoolean then
        begin
          if RemainsCDS.FieldByName('isBanFiscalSale').AsBoolean then
            nGoodsUKTZED := FieldByName('GoodsId').AsInteger
          else nGoodsNotUKTZED := FieldByName('GoodsId').AsInteger;
        end;

//        if (FieldByName('Amount').AsCurrency > 0) and FieldByName('isPresent').AsBoolean and
//           (FormParams.ParamByName('LoyaltyGoodsId').Value <> FieldByName('GoodsId').AsInteger)  then
//        begin
//          ShowMessage('Подарки можно продавать только по акции!');
//          exit;
//        end;

        if FieldByName('isPresent').AsBoolean  then nPresent := nPresent + FieldByName('Amount').AsCurrency;

        if not isPromoForSale then isPromoForSale := RemainsCDS.FieldByName('isPromoForSale').AsBoolean;

        isYes := False;
        if (RemainsCDS.FieldByName('RelatedProductId').AsInteger <> 0) then
        begin

          for I := Low(aRelatedProductId) to High(aRelatedProductId) do
            if aRelatedProductId[I] = RemainsCDS.FieldByName('RelatedProductId').AsInteger then
          begin
            if aRelatedProductPrice[I] < RemainsCDS.FieldByName('Price').AsCurrency then
              aRelatedProductPrice[I] := RemainsCDS.FieldByName('Price').AsCurrency;
            isYes := True;
          end;

          if not isYes then
          begin
            SetLength(aRelatedProductId, Length(aRelatedProductId) + 1);
            SetLength(aRelatedProductPrice, Length(aRelatedProductPrice) + 1 );
            aRelatedProductId[High(aRelatedProductId)] := RemainsCDS.FieldByName('RelatedProductId').AsInteger;
            aRelatedProductPrice[High(aRelatedProductPrice)] := RemainsCDS.FieldByName('Price').AsCurrency;
          end;

        end;

        if (RemainsCDS.FieldByName('DistributionPromoID').AsInteger <> 0) and
           (FieldByName('Amount').AsCurrency > 0) then
        begin
          AddDistributionPromo (RemainsCDS.FieldByName('DistributionPromoID').AsInteger, FieldByName('Amount').AsCurrency, FieldByName('Summ').AsCurrency);
        end;

        if (Frac(FieldByName('Amount').AsCurrency) <> 0) and (DiscountServiceForm.gCode <> 0) then
        begin
          ShowMessage('Деление медикамента для дисконтных программ запрещено!');
          exit;
        end;

        if (RemainsCDS.FieldByName('GoodsDiscountID').AsInteger <> 0) and
           (RemainsCDS.FieldByName('GoodsDiscountID').AsInteger <> DiscountServiceForm.gDiscountExternalId) and
           ((FieldByName('Amount').AsCurrency > 0) and (Frac(FieldByName('Amount').AsCurrency) = 0) and (RemainsCDS.FieldByName('GoodsDiscountID').AsInteger = 4521216) or
           (FormParams.ParamByName('isDiscountCommit').Value = False) and FieldByName('isPriceDiscount').AsBoolean) and
           (FormParams.ParamByName('SPKindId').Value = 0) then
        begin
          if not gc_User.Local then
          begin
            spGet_Goods_CodeRazom.ParamByName('inDiscountExternal').Value  := RemainsCDS.FieldByName('GoodsDiscountID').AsInteger;
            spGet_Goods_CodeRazom.ParamByName('inGoodsId').Value  := FieldByName('GoodsId').AsInteger;
            spGet_Goods_CodeRazom.ParamByName('inAmount').Value  := FieldByName('Amount').AsCurrency;
            spGet_Goods_CodeRazom.ParamByName('outCodeRazom').Value := 0;
            spGet_Goods_CodeRazom.Execute;
            if spGet_Goods_CodeRazom.ParamByName('outCodeRazom').AsFloat <> 0 then
            begin
              ShowMessage('Пробейте товар по ДП через ввод карты (F7 - проект ' + RemainsCDS.FieldByName('GoodsDiscountName').AsString + ')');
              exit;
            end;
          end
          else
          begin
            if RemainsCDS.FieldByName('GoodsDiscountID').AsInteger = 4521216 then
            begin
              ShowMessage('Пробейте товар по ДП через ввод карты (F7 - проект ' + RemainsCDS.FieldByName('GoodsDiscountName').AsString + ')');
              exit;
            end;
          end;
        end;

        if (FormParams.ParamByName('isDiscountCommit').Value = False) then
        begin
          if (FieldByName('Price').AsCurrency = FieldByName('PriceSale').AsCurrency) and
             (FieldByName('Amount').AsCurrency > 0) and FieldByName('isPriceDiscount').AsBoolean then
          begin
            ShowMessage('Со скидкой товар <' + FieldByName('GoodsName').AsString +
              '> не кратный упаковки отпускать запрещено, обнулите количество и пробейте отдельным чеком (без скидки)');
            exit;
          end;
        end;

//        if (FieldByName('Amount').AsCurrency > 0) and
//           ((FieldByName('Price').AsCurrency < UnitConfigCDS.FieldByName('MinPriceSale').AsCurrency) and (DiscountServiceForm.gCode = 0) and (FormParams.ParamByName('SPKindId').Value = 0) or
//           (FieldByName('Price').AsCurrency < UnitConfigCDS.FieldByName('MinPriceSale').AsCurrency) and (FieldByName('Price').AsCurrency > 0) AND
//           ((DiscountServiceForm.gCode <> 0) or (FormParams.ParamByName('SPKindId').Value <> 0))) then
//        begin
//          ShowMessage('Продажа товаров с ценой менее ' + UnitConfigCDS.FieldByName('MinPriceSale').AsString + ' грн. запрещена');
//          exit;
//        end;

        Next;
      end;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
  end;

  if not UnitConfigCDS.FieldByName('isGoodsUKTZEDRRO').AsBoolean and (nGoodsUKTZED <> 0) then
  begin
    try
      if CheckCDS.Locate('GoodsID', nGoodsUKTZED, []) then
      begin

        if UnitConfigCDS.FieldByName('isCheckUKTZED').AsBoolean and (nGoodsNotUKTZED <> 0) then
        begin
          ShowMessage('В чеке есть позиция по УКТВЭД, чтобы не передавать большие суммы в бухгалтерию - можно данный код пробить в отдельном чеке.'#13#10#13#10 +
            CheckCDS.FieldByName('GoodsCode').AsString + ' - ' + CheckCDS.FieldByName('GoodsName').AsString);
          Exit;
        end;

        if not actSpec.Checked then
        begin
          if not gc_User.Local then
          begin
            actShowPUSH_UKTZED.Execute
          end else ShowMessage('Товар <' + CheckCDS.FieldByName('GoodsName').AsString + '> из выбранной партии по техническим причинам пробивается по служебному чеку (зеленая галка)...');
          exit;
        end;
      end else Exit;
    finally
    end;
  end;

  // Выбор сопутствующего товара
  isYes := False;
  if Length(aRelatedProductId) > 0 then for I := Low(aRelatedProductId) to High(aRelatedProductId) do
  begin
    MainCashForm.RemainsCDS.DisableControls;
    MainCashForm.RemainsCDS.Filtered := false;
    try
      with TChoosingRelatedProductForm.Create(nil) do
      try
        if not SetRelatedProduct(aRelatedProductId[I], aRelatedProductPrice[I]) then Continue;
        if ShowModal = mrOk then
        begin
          ChoosingRelatedProductCDS.First;
          while not ChoosingRelatedProductCDS.Eof do
          begin
            if ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency > 0 then
            begin
              if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                        VarArrayOf([ChoosingRelatedProductCDS.FieldByName('GoodsId').AsInteger,
                                    ChoosingRelatedProductCDS.FieldByName('PartionDateKindId').AsVariant,
                                    ChoosingRelatedProductCDS.FieldByName('NDSKindId').AsVariant,
                                    ChoosingRelatedProductCDS.FieldByName('DiscountExternalID').AsVariant,
                                    ChoosingRelatedProductCDS.FieldByName('DivisionPartiesID').AsVariant]), []) and
                (RemainsCDS.FieldByName('Remains').AsCurrency >= ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency) then
              try
                edAmount.Text := CurrToStr(ChoosingRelatedProductCDS.FieldByName('Amount').AsCurrency);
                InsertUpdateBillCheckItems;
                isYes := True;
              finally
              end;
            end;
            ChoosingRelatedProductCDS.Next;
          end;
        end;
      finally
        Free;
      end;
    finally
      MainCashForm.RemainsCDS.Filtered := True;
      MainCashForm.RemainsCDS.EnableControls;
    end;
  end;
  if isYes then Exit;

  // Заполнение врача и покупателя для продажи
  if isPromoForSale then
  begin
    if not ShowSelectionFromDirectory('врача для вставки в документ', 'Ф.И.О. врача',
             'MedicForSale', 'gpSelect_Object_MedicForSale', 'Name', S) then Exit;
    FormParams.ParamByName('MedicForSale').Value := S;
    if not ShowSelectionFromDirectory('покупателя для вставки в документ', 'Ф.И.О. покупателя', 'Номер телефона',
             'BuyerForSale', 'gpSelect_Object_BuyerForSale', 'Name', 'Phone', S, S1) then Exit;
    FormParams.ParamByName('BuyerForSale').Value := S;
    FormParams.ParamByName('BuyerForSalePhone').Value := S1;
  end;

  if (nPresent > 0) and not FormParams.ParamByName('LoyaltyPresent').Value then
  begin
    ShowMessage('Подарки можно продавать только по акции!');
    exit;
  end;

  if nPresent > FormParams.ParamByName('LoyaltyAmountPresent').Value then
  begin
    ShowMessage('Количество подарков в чеке превышает количество по акции!');
    exit;
  end;

  if UnitConfigCDS.FieldByName('LoyaltySaveMoneyCount').AsInteger > 0 then
  begin
    if not pnlLoyaltySaveMoney.Visible then
      SetLoyaltySaveMoney;
    if not SetLoyaltySaveMoneyDiscount then
      exit;
  end;

  // Контроль суммы скидки
  if FormParams.ParamByName('LoyaltyChangeSumma').Value <> 0 then
  begin
    nSumAll := 0;
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
        nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceDiscount').asCurrency,
          FormParams.ParamByName('RoundingDown').Value)
      else
        nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
      CheckCDS.Next;
    end;

    if nSumAll < FormParams.ParamByName('LoyaltyChangeSumma').Value then
    begin
      ShowMessage('Cумма отпускаемого товара ' + FormatCurr(',0.00', nSumAll) +
        ' должна быть больше суммы скидки ' + FormatCurr(',0.00',
        FormParams.ParamByName('LoyaltyChangeSumma').Value) + '.');
      exit;
    end;
  end;

  // проверили что есть остаток
  if not gc_User.Local then
    if fCheck_RemainsError = false then
      exit;

  if not ShowDistributionPromo then Exit;

  // Commit Дисконт из CDS - по всем
  if (FormParams.ParamByName('DiscountExternalId').Value > 0) and
     (FormParams.ParamByName('isDiscountCommit').Value = False) then
  begin

    if not ShowPUSHMessageCash('Провести продажу по дисконтной программе на сумму ' + lblTotalSumm.Caption + ' грн.?', cResult) then Exit;

    if Assigned(Cash) then CheckNumber := IntToStr(Cash.GetLastCheckId + 1);

    if not DiscountServiceForm.fCommitCDS_Discount(CheckNumber,
      CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value,
      FormParams.ParamByName('DiscountCardNumber').Value, isDiscountCommit) then Exit;
    FormParams.ParamByName('isDiscountCommit').Value := isDiscountCommit;

    FormParams.ParamByName('isDiscountCommit').Value := True;
  end;

  if Assigned(Cash) then CheckNumber := IntToStr(Cash.GetLastCheckId + 1);
  if not OrdersСreate1303(CheckNumber, CheckCDS) then Exit;

  Add_Log('PutCheckToCash');
  PaidType := ptMoney;
  // спросили сумму и тип оплаты
  if not fShift then
  begin // если с Shift, то считаем, что дали без сдачи
    if not CashCloseDialogExecute(FTotalSumm, ASalerCash, ASalerCashAdd,
      PaidType, nBankPOSTerminal, nPOSTerminalCode) then
    Begin
      if Self.ActiveControl <> edAmount then
        Self.ActiveControl := MainGrid;
      exit;
    End;
    // ***02.11.18
    FormParams.ParamByName('SummPayAdd').Value := ASalerCashAdd;
    // ***20.02.19
    FormParams.ParamByName('BankPOSTerminal').Value := nBankPOSTerminal;
  end
  else
    ASalerCash := FTotalSumm;

  HelsiError := false;
  if (FormParams.ParamByName('HelsiID').Value <> '') then
  begin
    HelsiError := True;
    if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1 then
    begin
      if not CreateNewDispense(CheckCDS.FieldByName('IdSP').AsString,
        CheckCDS.FieldByName('ProgramIdSP').AsString,
        RoundTo(CheckCDS.FieldByName('CountSP').asCurrency * CheckCDS.FieldByName
        ('Amount').asCurrency, -2), CheckCDS.FieldByName('PriceSale').asCurrency,
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PriceSale').asCurrency, -2),
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PriceRetSP').asCurrency, -2) -
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PaymentSP').asCurrency, -2),
        CheckCDS.FieldByName('Summ').asCurrency, ConfirmationCode) then
      begin
        if Self.ActiveControl <> edAmount then
          Self.ActiveControl := MainGrid;
        exit;
      end;
    end else if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 2 then
    begin
      if not CreateLikiDniproeHealthNewDispense(CheckCDS.FieldByName('IdSP').AsString,
        CheckCDS.FieldByName('ProgramIdSP').AsString,
        RoundTo(CheckCDS.FieldByName('CountSP').asCurrency * CheckCDS.FieldByName
        ('Amount').asCurrency, -2), CheckCDS.FieldByName('PriceSale').asCurrency,
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PriceSale').asCurrency, -2),
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PriceRetSP').asCurrency, -2) -
        RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
        CheckCDS.FieldByName('PaymentSP').asCurrency, -2), ConfirmationCode) then
      begin
        if Self.ActiveControl <> edAmount then
          Self.ActiveControl := MainGrid;
        exit;
      end;
    end;
  end;

  // показали что началась печать
  ShapeState.Brush.Color := clYellow;
  ShapeState.Repaint;
  Application.ProcessMessages;

  // проверили что этот чек Не был проведен другой кассой - 04.02.2017
  if not gc_User.Local and (FormParams.ParamByName('CheckId').Value <> 0) then
  begin
    dsdSave := TdsdStoredProc.Create(nil);
    try
      // Проверить в каком состоянии документ.
      dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
      dsdSave.OutputType := otResult;
      dsdSave.Params.Clear;
      dsdSave.Params.AddParam('inId', ftInteger, ptInput,
        FormParams.ParamByName('CheckId').Value);
      dsdSave.Params.AddParam('outState', ftInteger, ptOutput, Null);
      dsdSave.Execute(false, false);
      if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then
      // проведен
      Begin
        ShowMessage
          ('Ошибка.Данный чек уже сохранен другой кассой.Для продолжения - необходимо обнулить чек и набрать позиции заново.');
        Add_Log('Ошибка.Данный чек уже сохранен другой кассой.Для продолжения - необходимо обнулить чек и набрать позиции заново.');
        exit;
      End;
    finally
      freeAndNil(dsdSave);
    end;
  end;

  FormParams.ParamByName('PartionDateKindId').Value := GetPartionDateKindId;

  // послали на печать
  try

    Add_Log('Печать чека');
    if PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd,
      MainCashForm.PaidType, ZReport, FFiscalNumber, CheckNumber, nPOSTerminalCode) then
    Begin
      Add_Log('Печать чека завершена');

      Add_Log('Сохранение чека');
      ShapeState.Brush.Color := clRed;
      ShapeState.Repaint;
      if SaveLocal(CheckCDS, FormParams.ParamByName('ManagerId').Value,
        FormParams.ParamByName('ManagerName').Value,
        FormParams.ParamByName('BayerName').Value,
        // ***16.08.16
        FormParams.ParamByName('BayerPhone').Value,
        FormParams.ParamByName('ConfirmedKindName').Value,
        FormParams.ParamByName('InvNumberOrder').Value,
        FormParams.ParamByName('ConfirmedKindClientName').Value,
        // ***20.07.16
        FormParams.ParamByName('DiscountExternalId').Value,
        FormParams.ParamByName('DiscountExternalName').Value,
        FormParams.ParamByName('DiscountCardNumber').Value,
        // ***08.04.17
        FormParams.ParamByName('PartnerMedicalId').Value,
        FormParams.ParamByName('PartnerMedicalName').Value,
        FormParams.ParamByName('Ambulance').Value,
        FormParams.ParamByName('MedicSP').Value,
        FormParams.ParamByName('InvNumberSP').Value,
        FormParams.ParamByName('OperDateSP').Value,
        // ***15.06.17
        FormParams.ParamByName('SPKindId').Value,
        FormParams.ParamByName('SPKindName').Value,
        FormParams.ParamByName('SPTax').Value,
        // ***05.02.18
        FormParams.ParamByName('PromoCodeID').Value,
        // ***27.06.18
        FormParams.ParamByName('ManualDiscount').Value,
        // ***02.11.18
        FormParams.ParamByName('SummPayAdd').Value,
        // ***14.01.19
        FormParams.ParamByName('MemberSPID').Value,
        // ***20.02.19
        FormParams.ParamByName('BankPOSTerminal').Value,
        // ***25.02.19
        FormParams.ParamByName('JackdawsChecksCode').Value,
        // ***28.01.19
        FormParams.ParamByName('SiteDiscount').Value,
        // ***02.04.19
        FormParams.ParamByName('RoundingDown').Value,
        // ***13.05.19
        FormParams.ParamByName('PartionDateKindId').Value,
        FormParams.ParamByName('ConfirmationCodeSP').Value,
        // ***07.11.19
        FormParams.ParamByName('LoyaltySignID').Value,
        // ***08.01.20
        FormParams.ParamByName('LoyaltySMID').Value,
        FormParams.ParamByName('LoyaltySMSumma').Value,
        // ***16.08.20
        FormParams.ParamByName('DivisionPartiesID').Value,
        FormParams.ParamByName('DivisionPartiesName').Value,
        // ***11.10.20
        FormParams.ParamByName('MedicForSale').Value,
        FormParams.ParamByName('BuyerForSale').Value,
        FormParams.ParamByName('BuyerForSalePhone').Value,
        FormParams.ParamByName('DistributionPromoList').Value,
        // ***05.03.21
        FormParams.ParamByName('MedicKashtanId').Value,
        FormParams.ParamByName('MemberKashtanId').Value,
        // ***19.03.21
        FormParams.ParamByName('isCorrectMarketing').Value,
        FormParams.ParamByName('isCorrectIlliquidAssets').Value,
        FormParams.ParamByName('isDoctors').Value,
        FormParams.ParamByName('isDiscountCommit').Value,
        FormParams.ParamByName('MedicalProgramSPId').Value,
        FormParams.ParamByName('isManual').Value,
        FormParams.ParamByName('Category1303Id').Value,

        True, // NeedComplete
        False, // isErrorRRO
        FormParams.ParamByName('isPaperRecipeSP').Value,
        ZReport,     // Номер Z отчета
        CheckNumber, // FiscalCheckNumber
        FormParams.ParamByName('CheckId').Value,  // ID чека
        UID // out AUID
        ) then
      Begin

        if (FormParams.ParamByName('HelsiID').Value <> '') then
        begin

//          if (gc_User.Session = '3') then HelsiError := True
//          else
          if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1 then
          begin
            HelsiError := not SetPayment(CheckNumber,
              CheckCDS.FieldByName('Summ').asCurrency);
            if not HelsiError then
              HelsiError := not IntegrationClientSign;
            if not HelsiError then
              HelsiError := not ProcessSignedDispense;

            if HelsiError then
            begin
              RejectDispense;

              if CreateNewDispense(CheckCDS.FieldByName('IdSP').AsString,
                CheckCDS.FieldByName('ProgramIdSP').AsString,
                RoundTo(CheckCDS.FieldByName('CountSP').asCurrency *
                CheckCDS.FieldByName('Amount').asCurrency, -2),
                CheckCDS.FieldByName('PriceSale').asCurrency,
                RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
                CheckCDS.FieldByName('PriceSale').asCurrency, -2),
                RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
                CheckCDS.FieldByName('PriceRetSP').asCurrency, -2) -
                RoundTo(CheckCDS.FieldByName('Amount').asCurrency *
                CheckCDS.FieldByName('PaymentSP').asCurrency, -2),
                CheckCDS.FieldByName('Summ').asCurrency,
                ConfirmationCode) then
              begin
                HelsiError := not SetPayment(CheckNumber,
                  CheckCDS.FieldByName('Summ').asCurrency);
                if not HelsiError then
                  HelsiError := not IntegrationClientSign;
                if not HelsiError then
                  HelsiError := not ProcessSignedDispense;
              end;

              if HelsiError then
                RejectDispense;
            end;

            if not GetStateReceipt then
            begin
              // pnlHelsiError.Visible := True;
              // edHelsiError.Text := FormParams.ParamByName('InvNumberSP').Value;

              nOldColor := Screen.MessageFont.Color;
              try
                Screen.MessageFont.Color := clRed;
                Screen.MessageFont.Size := Screen.MessageFont.Size + 2;
                MessageDlg
                  ('РЕЦЕПТ НЕ ПРОШЕЛ ПО ХЕЛСИ !!!'#13#10#13#10'Нужно его погасить в FCASH в "Чеки->Сверка Чеков с Хелси"!',
                  mtError, [mbOK], 0);
              finally
                Screen.MessageFont.Size := Screen.MessageFont.Size - 2;
                Screen.MessageFont.Color := nOldColor;
              end;
            end;
          end else if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 2 then
          begin
            if not SignRecipeLikiDniproeHealth then
            begin
              nOldColor := Screen.MessageFont.Color;
              try
                Screen.MessageFont.Color := clRed;
                Screen.MessageFont.Size := Screen.MessageFont.Size + 2;
                MessageDlg
                  ('РЕЦЕПТ НЕ ПРОШЕЛ ПО ХЕЛСИ !!!'#13#10#13#10'Нужно его погасить в FCASH в "Чеки->Сверка Чеков с Хелси"!',
                  mtError, [mbOK], 0);
              finally
                Screen.MessageFont.Size := Screen.MessageFont.Size - 2;
                Screen.MessageFont.Color := nOldColor;
              end;
            end;
          end else
          begin
            MessageDlg('Не определен механизм подписи рецепта!', mtError, [mbOK], 0);
          end;
        End;

        Add_Log('Чек сохранен');
        CheckOldId := FormParams.ParamByName('CheckOldId').Value;
        NewCheck(false);
      end;
    End;

    if HelsiError and (UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1) then RejectDispense;

  finally
    ShapeState.Brush.Color := clGreen;
    ShapeState.Repaint;

    if (CheckOldId <> 0) and (MessageDlg('Загрузить разбитый ВИП чек?', mtConfirmation, mbYesNo, 0) = mrYes) then
    begin
       spSelectCheckId.ParamByName('inMovementId').Value := CheckOldId;
       spSelectCheckId.Execute;
       spSelectCheck.Execute;
       LoadVIPCheck;
    end;
  end;
end;

procedure TMainCashForm2.actRecipeNumber1303Execute(Sender: TObject);
  var S : string;
begin
  if not CheckSP then Exit;

  if UnitConfigCDS.FieldByName('LikiDneproToken').AsString = '' then
  Begin
    ShowMessage('Подразделение не подключено для погашение рецептов в МИС «Каштан»!');
    Exit;
  End;

  if not UnitConfigCDS.FieldByName('isSP1303').AsBoolean then
  Begin
    ShowMessage('Подразделение не подключено для погашение рецептов по программе 1303.');
    Exit;
  End;

  if UnitConfigCDS.FieldByName('EndDateSP1303').AsDateTime < Date then
  Begin
    ShowMessage('Срок действия договора по программе 1303 закончился.');
    Exit;
  End;

  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage('Применен соц проект.'#13#10'Для повторного применения обнулите чек..');
    exit;
  end;

  if pnlHelsiError.Visible then
  begin
    ShowMessage('Обработайте непогашенный чек Хелси!');
    exit;
  end;

  if (not CheckCDS.isempty) and (Self.FormParams.ParamByName('InvNumberSP')
    .Value = '') or pnlManualDiscount.Visible or pnlPromoCode.Visible or
    pnlSiteDiscount.Visible then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;

  if pnlPromoCode.Visible or pnlPromoCodeLoyalty.Visible then
  begin
    ShowMessage('В текущем чеке применен промокод. Сначала очистите чек!');
    exit;
  end;

  pnlPosition.Visible := False;
  cbMorionFilter.Enabled := True;
  cbMorionFilter.Checked := False;

  S := '';
  if not InputEnterRecipeNumber1303(S) then Exit;

  if GetReceipt1303(S) then
  begin
    if LikiDniproReceiptApi.Recipe.FRecipe_Type in [2, 3] then
    begin
      if not ShowLikiDniproReceiptDialog then Exit;
      bbPositionNextClick(Sender);
    end else ShowMessage('Тип рецепта не поддерживаеться.');
  end;

end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
var
  lMsg: String;
begin
  startSplash('Начало обновления данных с сервера');
  try
    // ShowMessage('Загрузка из Remains');
    MainGridDBTableView.BeginUpdate;
    RemainsCDS.DisableControls;
    // AlternativeCDS.DisableControls;
    ExpirationDateCDS.DisableControls;
    try
      if not fileExists(Remains_lcl) or
      // not FileExists(Alternative_lcl) then
        not fileExists(GoodsExpirationDate_lcl) then
      Begin
        ShowMessage('Нет локального хранилища. Дальнейшая работа невозможна!');
        Close;
      End;
      WaitForSingleObject(MutexRemains, INFINITE);
      try
        LoadLocalData(RemainsCDS, Remains_lcl);
      finally
        ReleaseMutex(MutexRemains);
      end;
      // WaitForSingleObject(MutexAlternative, INFINITE);
      // try
      // LoadLocalData(AlternativeCDS, Alternative_lcl);
      // finally
      // ReleaseMutex(MutexAlternative);
      // end;
      WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
      try
        LoadLocalData(ExpirationDateCDS, GoodsExpirationDate_lcl);
      finally
        ReleaseMutex(MutexGoodsExpirationDate);
      end;
      UpdateImplementationPlanEmployee;
      // Заполнение шапки главной формы
      SetMainFormCaption;
    finally
      RemainsCDS.EnableControls;
      ExpirationDateCDS.EnableControls;
      // AlternativeCDS.EnableControls;
      MainGridDBTableView.EndUpdate;
    end;
    if not gc_User.Local then
    begin
      ChangeStatus
        ('Загрузка приходных накладных от дистрибьютора в медреестр Pfizer МДМ');
      lMsg := '';
      // ЗАРАДИ ЖИТТЯ
      if not DiscountServiceForm.fPfizer_Send(2807930, lMsg) then
      begin
        ChangeStatus('Ошибка в медреестре Pfizer МДМ :' + lMsg);
        sleep(2000);
      end
      else
      begin
        ChangeStatus
          ('Накладные зарегистрированы в медреестре Pfizer МДМ успешно :' +
          lMsg);
        sleep(1000);
      end;
      // Пфайзер "Заради життя онко-группа"
      if not DiscountServiceForm.fPfizer_Send(15615415, lMsg) then
      begin
        ChangeStatus('Ошибка в медреестре Pfizer МДМ :' + lMsg);
        sleep(2000);
      end
      else
      begin
        ChangeStatus
          ('Накладные зарегистрированы в медреестре Pfizer МДМ успешно :' +
          lMsg);
        sleep(1000);
      end;
    end;
  finally
    EndSplash;
  end;
end;

procedure TMainCashForm2.actRefreshRemainsExecute(Sender: TObject);
begin
  // StartRefreshDiffThread; // оставлено для кор|ектной синхронизации двух форм
end;

procedure TMainCashForm2.actReport_ImplementationPlanEmployeeExecute
  (Sender: TObject);
begin
  with TReport_ImplementationPlanEmployeeCashForm.Create(nil) do
    try
      Show;
    finally
    end;
end;

procedure TMainCashForm2.actSaveHardwareDataExecute(Sender: TObject);
begin
  SaveHardwareData(True);
end;

procedure TMainCashForm2.actSelectLocalVIPCheckExecute(Sender: TObject);
var
  vip, vipList: TClientDataSet;
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
begin
  inherited;

  vip := TClientDataSet.Create(Nil);
  vipList := TClientDataSet.Create(nil);
  try
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(vip, vip_lcl);
      LoadLocalData(vipList, vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
    Add_Log('Select VIP - ' +
      VarToStr(FormParams.ParamByName('CheckId').Value));
    if vip.Locate('Id', FormParams.ParamByName('CheckId').Value, []) then
    Begin
      vipList.Filter := 'MovementId = ' + FormParams.ParamByName
        ('CheckId').AsString;
      vipList.Filtered := True;
      vipList.First;
      While not vipList.Eof do
      Begin
        CheckCDS.Append;
        CheckCDS.FieldByName('Id').AsInteger := vipList.FieldByName('Id')
          .AsInteger;
        CheckCDS.FieldByName('GoodsId').AsInteger :=
          vipList.FieldByName('GoodsId').AsInteger;
        CheckCDS.FieldByName('GoodsCode').AsInteger :=
          vipList.FieldByName('GoodsCode').AsInteger;
        CheckCDS.FieldByName('GoodsName').AsString :=
          vipList.FieldByName('GoodsName').AsString;
        CheckCDS.FieldByName('Amount').AsFloat := VipList.FieldByName('Amount').AsFloat;
        // VipList.FieldByName('Amount').AsFloat; //маленькая ошибочка, поставил 0, ***20.07.16
        CheckCDS.FieldByName('Price').AsFloat :=
          vipList.FieldByName('Price').AsFloat;
        CheckCDS.FieldByName('Summ').AsFloat :=
          vipList.FieldByName('Summ').AsFloat;
        CheckCDS.FieldByName('NDS').AsFloat :=
          vipList.FieldByName('NDS').AsFloat;
        CheckCDS.FieldByName('NDSKindId').AsInteger :=
          vipList.FieldByName('NDSKindId').AsInteger;
        CheckCDS.FieldByName('DiscountExternalID').AsVariant :=
          vipList.FieldByName('DiscountExternalID').AsVariant;
        CheckCDS.FieldByName('DiscountExternalName').AsVariant :=
          vipList.FieldByName('DiscountExternalName').AsVariant;
        CheckCDS.FieldByName('DivisionPartiesID').AsVariant :=
          vipList.FieldByName('DivisionPartiesID').AsVariant;
        CheckCDS.FieldByName('DivisionPartiesName').AsVariant :=
          vipList.FieldByName('DivisionPartiesName').AsVariant;
        // ***20.07.16
        CheckCDS.FieldByName('PriceSale').asCurrency :=
          vipList.FieldByName('PriceSale').asCurrency;
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          vipList.FieldByName('ChangePercent').asCurrency;
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          vipList.FieldByName('SummChangePercent').asCurrency;
        // ***19.08.16
        CheckCDS.FieldByName('AmountOrder').asCurrency :=
          vipList.FieldByName('AmountOrder').asCurrency;
        // ***10.08.16
        CheckCDS.FieldByName('List_UID').AsString :=
          vipList.FieldByName('List_UID').AsString;
        // ***10.08.16
        CheckCDS.FieldByName('PartionDateKindId').AsVariant :=
          vipList.FieldByName('PartionDateKindId').AsVariant;
        CheckCDS.FieldByName('PartionDateKindName').AsVariant :=
          vipList.FieldByName('PartionDateKindName').AsVariant;
        CheckCDS.FieldByName('PricePartionDate').AsVariant :=
          vipList.FieldByName('PricePartionDate').AsVariant;
        CheckCDS.FieldByName('AmountMonth').AsVariant :=
          vipList.FieldByName('AmountMonth').AsVariant;
        if vipList.FieldByName('PricePartionDate').asCurrency <> 0 then
          CheckCDS.FieldByName('PriceDiscount').AsVariant :=
            vipList.FieldByName('PricePartionDate').AsVariant
        else
          CheckCDS.FieldByName('PriceDiscount').AsVariant :=
            vipList.FieldByName('Price').AsFloat;
        CheckCDS.FieldByName('isGoodsPairSun').AsVariant :=
          vipList.FieldByName('isGoodsPairSun').AsVariant;
        CheckCDS.FieldByName('GoodsPairSunMainId').AsVariant :=
          vipList.FieldByName('GoodsPairSunMainId').AsVariant;
        CheckCDS.FieldByName('GoodsPairSunAmount').AsVariant :=
          vipList.FieldByName('GoodsPairSunAmount').AsVariant;
        CheckCDS.FieldByName('isPresent').AsVariant :=
          vipList.FieldByName('isPresent').AsVariant;
        CheckCDS.FieldByName('JuridicalId').AsVariant :=
          vipList.FieldByName('JuridicalId').AsVariant;
        // ***21.10.18
        GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
        PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
        NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
        DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
        DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
        RemainsCDS.DisableControls;
        RemainsCDS.Filtered := false;
        try
          if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
            VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
            CheckCDS.FieldByName('PartionDateKindId').AsVariant,
            CheckCDS.FieldByName('NDSKindId').AsVariant,
            CheckCDS.FieldByName('DiscountExternalID').AsVariant,
            CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
          begin
            CheckCDS.FieldByName('Remains').asCurrency :=
              RemainsCDS.FieldByName('Remains').asCurrency;
            CheckCDS.FieldByName('Color_calc').AsInteger :=
              RemainsCDS.FieldByName('Color_calc').AsInteger;
            CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
              RemainsCDS.FieldByName('Color_ExpirationDate').AsInteger;
            CheckCDS.FieldByName('AmountMonth').AsVariant :=
              RemainsCDS.FieldByName('AmountMonth').AsVariant;
          end
          else
          begin
            CheckCDS.FieldByName('Remains').asCurrency := 0;
            CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
            CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
          end;
        finally
          RemainsCDS.Filtered := True;
          RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
            VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
          RemainsCDS.EnableControls;
        end;
        // ***05.11.18
        CheckCDS.FieldByName('AccommodationName').AsVariant :=
          RemainsCDS.FieldByName('AccommodationName').AsVariant;
        // ***15.03.19
        if CheckCDS.FieldByName('Price').asCurrency <>
          CheckCDS.FieldByName('PriceSale').asCurrency then
          CheckCDS.FieldByName('Multiplicity').AsVariant :=
            RemainsCDS.FieldByName('Multiplicity').AsVariant;
        if CheckCDS.FieldByName('isPresent').AsVariant then
          CheckCDS.FieldByName('Color_calc').AsInteger := TColor($FFB0FF);
        // ***09.11.21
        CheckCDS.FieldByName('GoodsDiscountProcent').AsVariant :=Null;
        CheckCDS.FieldByName('PriceSaleDiscount').AsVariant := Null;
        CheckCDS.FieldByName('isPriceDiscount').AsBoolean := False;

        CheckCDS.Post;
        Add_Log('Id - ' + vipList.FieldByName('Id').AsString + ' GoodsCode - ' +
          vipList.FieldByName('GoodsCode').AsString + ' GoodsName - ' +
          vipList.FieldByName('GoodsName').AsString + ' AmountOrder - ' +
          vipList.FieldByName('AmountOrder').AsString + ' Price - ' +
          vipList.FieldByName('Price').AsString);
//        if FormParams.ParamByName('CheckId').Value <> 0 then
//          // UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger, CheckCDS.FieldByName('Amount').AsFloat);
//          // маленькая ошибочка, попробуем с VipList, ***20.07.16
//          UpdateRemainsFromCheck(vipList.FieldByName('GoodsId').AsInteger,
//            vipList.FieldByName('PartionDateKindId').AsInteger,
//            vipList.FieldByName('NDSKindId').AsInteger,
//            vipList.FieldByName('DiscountExternalID').AsInteger,
//            vipList.FieldByName('DivisionPartiesID').AsInteger,
//            vipList.FieldByName('isPresent').AsBoolean,
//            vipList.FieldByName('Amount').AsFloat,
//            vipList.FieldByName('PriceSale').asCurrency,
//            True);
        vipList.Next;
      End;
    End;

    CalcTotalSumm;
  finally
    vip.Close;
    vip.Free;
    vipList.Close;
    vipList.Free;
  end;
end;

procedure TMainCashForm2.actSenClipboardNameExecute(Sender: TObject);
begin
  if (ActiveControl is TcxGridSite) AND (ActiveControl.Parent = CheckGrid) AND not CheckCDS.IsEmpty then
  begin
    Clipboard.AsText := CheckCDS.FieldByName('GoodsCode').AsString + ' - ' + CheckCDS.FieldByName('GoodsName').AsString;
  end else if not RemainsCDS.IsEmpty then
  begin
    Clipboard.AsText := RemainsCDS.FieldByName('GoodsCode').AsString + ' - ' + RemainsCDS.FieldByName('GoodsName').AsString;
  end;
end;

procedure TMainCashForm2.actSetFilterExecute(Sender: TObject);
begin
  inherited;
  // if RemainsCDS.Active and AlternativeCDS.Active then

  // a1  код из события RemainsCDSAfterScroll для ускорения работы приложения
  // if RemainsCDS.IsEmpty then
  // AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId= 0'
  // else if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
  // AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  // else
  // AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
  // ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
  // ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
  // a1

  if RemainsCDS.isempty then
    ExpirationDateCDS.Filter := 'Amount <> 0 AND ID = 0'
  else
    ExpirationDateCDS.Filter := 'Amount <> 0 AND ID = ' + RemainsCDS.FieldByName
      ('Id').AsString;
end;

procedure TMainCashForm2.actServiseRunExecute(Sender: TObject);
// только 2 форма
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;

  function ProcessExists(exeFileName: string): Boolean;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
  begin
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    Result := false;
    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
        = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
        = UpperCase(exeFileName))) then
      begin
        Result := True;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle);
  end;

begin
  // if gc_User.Local then Exit;

  ExecuteFile := 'FarmacyCashServise.exe';
  // служба уже запущена, работаем с ней
  if ProcessExists(ExecuteFile) then
  begin
    if FNeedFullRemains then
      PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 30);
    FNeedFullRemains := false;
    exit;
  end;

  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile);
    ParamString := '"' + IniUtils.gUserName + '" "' + IniUtils.gPassValue + '"';
    // Кавычки обязательно

    // ParamString:= gc_User.Session;
    { ParamString can contain theapplication parameters. }
    lpParameters := PChar(ParamString);
    { StartInString specifies thename of the working
      directory.If ommited, the current directory is used. }
    // lpDirectory := PChar(StartInString);
    nShow := SW_SHOWNORMAL;
  end;

  if ShellExecuteEx(@SEInfo) then
  begin
    FNeedFullRemains := false;
    // repeat Application.HandleMessage;
    // GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    // until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
    // ShowMessage('Программа отработала');
  end
  else
    ShowMessage('Ошибка запуска сервиса');
end;

procedure TMainCashForm2.actSetFocusExecute(Sender: TObject);
begin
  if isScaner = True then
    ActiveControl := ceScaner
  else
    ActiveControl := lcName;
end;

procedure TMainCashForm2.SetPromoCodeLoyaltySM(ALoyaltySMID: Integer;
  APhone, AName: string; ASummaRemainder, AChangeSumma: Currency);
var
  nRecNo: Integer;
begin

  if ALoyaltySMID = 0 then
  begin
    FormParams.ParamByName('LoyaltySMID').Value := 0;
    FormParams.ParamByName('LoyaltySMText').Value := '';
    FormParams.ParamByName('LoyaltySMSumma').Value := 0;

    pnlLoyaltySaveMoney.Visible := false;
    lblLoyaltySMBuyer.Caption := '';
    edLoyaltySMSummaRemainder.Value := 0;
    edLoyaltySMSumma.Value := 0;
  end
  else
  begin
    FormParams.ParamByName('LoyaltySMID').Value := ALoyaltySMID;
    FormParams.ParamByName('LoyaltySMText').Value := '';
    FormParams.ParamByName('LoyaltySMSumma').Value := AChangeSumma;
    // ***27.06.18

    pnlLoyaltySaveMoney.Visible := ALoyaltySMID > 0;
    lblLoyaltySMBuyer.Caption := AName + '  ' + APhone;
    edLoyaltySMSummaRemainder.Value := ASummaRemainder;
    edLoyaltySMSumma.Value := AChangeSumma;
    lblLoyaltySMSummaRemainder.Visible := ASummaRemainder > 0;
    edLoyaltySMSummaRemainder.Visible := lblLoyaltySMSummaRemainder.Visible;
    lblLoyaltySMSumma.Visible := lblLoyaltySMSummaRemainder.Visible;
    edLoyaltySMSumma.Visible := lblLoyaltySMSummaRemainder.Visible;
    FormParams.ParamByName('ManualDiscount').Value := 0;
  end;

  FormParams.ParamByName('ManualDiscount').Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;

  PromoCodeLoyaltyCalc;
  CalcTotalSumm;
end;

procedure TMainCashForm2.SetLoyaltySaveMoney;
var
  nID: Integer;
  cPhone, cName: string;
  nLoyaltySMID: Integer;
  nPromoCodeSumma: Currency;
begin

  nPromoCodeSumma := 0;
  if not InputEnterLoyaltySaveMoney(nID, cPhone, cName, nLoyaltySMID) then
    exit;
  if nID = 0 then
    exit;

  if gc_User.Local then
  begin
    if nLoyaltySMID <> 0 then
      SetPromoCodeLoyaltySM(nLoyaltySMID, cPhone, cName, 0, 0)
    else
      ShowMessage('Активной акции по покупателю '#13#10 + cName + ' ' + cPhone +
        #13#10'не найдено..');
  end
  else
  begin
    spLoyaltySM.ParamByName('inBuyerID').Value := nID;
    spLoyaltySM.Execute;
    if LoyaltySMCDS.RecordCount <= 0 then
    begin
      ShowMessage('Активной акции по покупателю '#13#10 + cName + ' ' + cPhone +
        #13#10'не найдено..');
      exit;
    end
    else if LoyaltySMCDS.RecordCount = 1 then
    begin
      if LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger = 0 then
      begin
        spInsertMovementItem.ParamByName('ioId').Value := 0;
        spInsertMovementItem.ParamByName('inMovementId').Value :=
          LoyaltySMCDS.FieldByName('Id').AsInteger;
        spInsertMovementItem.ParamByName('inBuyerID').Value :=
          LoyaltySMCDS.FieldByName('BuyerID').AsInteger;
        spInsertMovementItem.Execute;

        if spInsertMovementItem.ParamByName('ioId').Value <> 0 then
        begin
          spLoyaltySM.ParamByName('inBuyerID').Value :=
            LoyaltySMCDS.FieldByName('BuyerID').AsInteger;
          spLoyaltySM.Execute;
          if not LoyaltySMCDS.Locate('LoyaltySMID',
            spInsertMovementItem.ParamByName('ioId').Value, []) or
            (LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger <>
            spInsertMovementItem.ParamByName('ioId').Value) then
            LoyaltySMCDS.Close;
        end
        else
          ShowMessage
            ('Ошибка прикрепления покупателя к акции.'#13#10#13#10'Повторите попытку.');
        if not LoyaltySMCDS.Active then
          exit;
      end;
    end
    else
    begin
      if not ShowLoyaltySMList then
        exit;
      if not LoyaltySMCDS.Active then
        exit;
    end;
    if LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger > 0 then
      SetPromoCodeLoyaltySM(LoyaltySMCDS.FieldByName('LoyaltySMID').AsInteger,
        cPhone, cName, LoyaltySMCDS.FieldByName('SummaRemainder').asCurrency, 0)
    else
      ShowMessage
        ('Ошибка прикрепления покупателя к акции.'#13#10#13#10'Повторите попытку.');
  end;
end;

function TMainCashForm2.SetLoyaltySaveMoneyDiscount: Boolean;
var
  nDoscount: Currency;
begin
  Result := True;
  if not pnlLoyaltySaveMoney.Visible then
    exit;

  Result := ShowEnterLoyaltySMDiscount(lblLoyaltySMBuyer.Caption, FTotalSumm,
    edLoyaltySMSummaRemainder.Value, nDoscount);
  if Result then
  begin
    edLoyaltySMSumma.Value := nDoscount;
    edLoyaltySMSummaExit(Nil);
  end;
end;

function TMainCashForm2.GetCash: ICash;
begin
  Result := Cash;
end;


procedure TMainCashForm2.actSetLoyaltySaveMoneyExecute(Sender: TObject);
begin

  if UnitConfigCDS.FieldByName('LoyaltySaveMoneyCount').AsInteger <= 0 then
  Begin
    ShowMessage('Программа лояльности накопительная не активна...');
    exit;
  End;

  if gc_User.Local and not fileExists(Buyer_lcl) then
  Begin
    ShowMessage('В отложенном режиме справочник покупатедлей не найден...');
    exit;
  End;

  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage
      ('Применен соц проект.'#13#10'Для променениея программы лояльности обнулите чек и набрать позиции заново..');
    exit;
  end;

  if (DiscountServiceForm.gService = 'AbbottCard') then
  begin
    ShowMessage
      ('Применен дисконт.'#13#10'Для променениея программы лояльности обнулите чек и набрать позиции заново..');
    exit;
  end;

  if FormParams.ParamByName('PromoCodeGUID').Value <> '' then
  begin
    ShowMessage
      ('Установлен промокод.'#13#10'Для применениея изменения обнулите промокод..');
    exit;
  end;

  if FormParams.ParamByName('SiteDiscount').Value <> 0 then
  begin
    ShowMessage
      ('Установлена скидка через сайт.'#13#10'Для променениея программы лояльности обнулите скидку через сайт..');
    exit;
  end;

  if (DiscountServiceForm.gCode <> 0) then
  begin
    ShowMessage
      ('Применен дисконт.'#13#10'Применение программы лояльности запрещено..');
    exit;
  end;

  SetLoyaltySaveMoney;
  SetLoyaltySaveMoneyDiscount;
end;

procedure TMainCashForm2.SetPromoCode(APromoCodeID: Integer;
  APromoName, APromoCodeGUID, ABayerName: String;
  APromoCodeChangePercent: Currency);
var
  nRecNo: Integer;
begin

  if APromoCodeID = 0 then
  begin
    FormParams.ParamByName('PromoCodeID').Value := 0;
    FormParams.ParamByName('PromoCodeGUID').Value := '';
    FormParams.ParamByName('PromoName').Value := '';
    FormParams.ParamByName('BayerName').Value := '';
    FormParams.ParamByName('PromoCodeChangePercent').Value := 0;

    pnlPromoCode.Visible := false;
    lblPromoName.Caption := '';
    lblPromoCode.Caption := '';
    edPromoCodeChangePrice.Value := 0;
    pnlPromoCodeLoyalty.Visible := false;
    lblPromoCodeLoyalty.Caption := '';
    edPromoCodeLoyaltySumm.Value := 0;
  end
  else
  begin
    FormParams.ParamByName('PromoCodeID').Value := APromoCodeID;
    FormParams.ParamByName('PromoCodeGUID').Value := APromoCodeGUID;
    FormParams.ParamByName('PromoName').Value := APromoName;
    FormParams.ParamByName('BayerName').Value := ABayerName;
    FormParams.ParamByName('PromoCodeChangePercent').Value :=
      APromoCodeChangePercent;
    // ***27.06.18

    FormParams.ParamByName('ManualDiscount').Value := 0;

    pnlPromoCode.Visible := APromoCodeID > 0;
    lblPromoName.Caption := '  ' + APromoName + '  ';
    lblPromoBayerName.Caption := '  ' + ABayerName + '  ';
    lblPromoCode.Caption := '  ' + APromoCodeGUID + '  ';
    edPromoCodeChangePrice.Value := APromoCodeChangePercent;
  end;

  FormParams.ParamByName('ManualDiscount').Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  pnlPromoCodeLoyalty.Visible := false;
  lblPromoCodeLoyalty.Caption := '';
  edPromoCodeLoyaltySumm.Value := 0;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if (DiscountServiceForm.gCode > 0) and
        (CheckCDS.FieldByName('PriceSale').asCurrency <> RemainsCDS.FieldByName('Price').asCurrency) then
      begin

      end
      else if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (FormParams.ParamByName('Price1303').Value <> 0) then
      begin
        // на всяк случай - УСТАНОВИМ скидку еще разок
        CheckCDS.FieldByName('PriceSale').asCurrency :=
          FormParams.ParamByName('Price1303').Value;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(FormParams.ParamByName('Price1303').Value *
          (1 - Self.FormParams.ParamByName('SPTax').Value / 100), 0);
        // и УСТАНОВИМ скидку - с процентом SPTax
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SPTax').Value;
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
      end
      else if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
      begin
        // на всяк случай - УСТАНОВИМ скидку еще разок
        CheckCDS.FieldByName('PriceSale').asCurrency :=
          RemainsCDS.FieldByName('Price').asCurrency;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
          .asCurrency, RemainsCDS.FieldByName('Price').asCurrency) *
          (1 - Self.FormParams.ParamByName('SPTax').Value / 100), 0);
        // и УСТАНОВИМ скидку - с процентом SPTax
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SPTax').Value;
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
      end
      else if (RemainsCDS.FieldByName('isSP').AsBoolean = True) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (FormParams.ParamByName('HelsiSkipDispenseSign').Value = False) then
      begin
        // на всяк случай - УСТАНОВИМ скидку еще разок
        CheckCDS.FieldByName('PriceSale').asCurrency :=
          RemainsCDS.FieldByName('PriceSaleSP').asCurrency;
        CheckCDS.FieldByName('Price').asCurrency :=
          RemainsCDS.FieldByName('PriceSP').asCurrency;
        // и УСТАНОВИМ скидку
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          CheckCDS.FieldByName('Amount').asCurrency *
          (RemainsCDS.FieldByName('PriceSaleSP').asCurrency -
          RemainsCDS.FieldByName('PriceSP').asCurrency);
      end
      else if (DiscountServiceForm.gCode <> 0) and edPrice.Visible and (abs(edPrice.Value) > 0.0001) then
      begin
        // на всяк случай - УСТАНОВИМ скидку еще разок
        CheckCDS.FieldByName('PriceSale').asCurrency :=
          RemainsCDS.FieldByName('Price').asCurrency;
        CheckCDS.FieldByName('Price').asCurrency := edPrice.Value;
        // и УСТАНОВИМ скидку
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          CheckCDS.FieldByName('Amount').asCurrency *
          (RemainsCDS.FieldByName('Price').asCurrency - edPrice.Value);
      end
      else if (FormParams.ParamByName('LoyaltyChangeSumma').Value = 0) and
        (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
        CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value,
        CheckCDS.FieldByName('GoodsId').AsInteger) then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if Self.FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PricePartionDate').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceSale').asCurrency;
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
  end;
  CalcTotalSumm;
end;

procedure TMainCashForm2.actSetPromoCodeExecute(Sender: TObject);
var
  PromoCodeId, nRecNo: Integer;
  PromoName, PromoCodeGUID, BayerName: String;
  PromoCodeChangePercent: Currency;
begin

  with TPromoCodeDialogForm.Create(nil) do
    try
      PromoCodeId := Self.FormParams.ParamByName('PromoCodeID').Value;
      PromoCodeGUID := Self.FormParams.ParamByName('PromoCodeGUID').Value;
      PromoName := Self.FormParams.ParamByName('PromoName').Value;
      BayerName := Self.FormParams.ParamByName('BayerName').Value;
      PromoCodeChangePercent := Self.FormParams.ParamByName
        ('PromoCodeChangePercent').Value;
      if not PromoCodeDialogExecute(PromoCodeId, PromoCodeGUID, PromoName,
        BayerName, PromoCodeChangePercent) then
        exit;
    finally
      Free;
    end;

  SetPromoCode(PromoCodeId, PromoName, PromoCodeGUID, BayerName,
    PromoCodeChangePercent);
end;

procedure TMainCashForm2.PromoCodeLoyaltyCalc;
var
  nRecNo: Integer;
  nSumAll, nPrice, nChangeSumma: Currency;
begin

  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  nSumAll := 0;
  nRecNo := CheckCDS.RecNo;
  try

    nChangeSumma := FormParams.ParamByName('LoyaltyChangeSumma').Value +
      FormParams.ParamByName('LoyaltySMSumma').Value;

    if nChangeSumma > 0 then
    begin
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if not CheckCDS.FieldByName('isPresent').AsBoolean then
        begin
          if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
            nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount')
              .asCurrency, CheckCDS.FieldByName('PriceDiscount').asCurrency,
              FormParams.ParamByName('RoundingDown').Value)
          else
            nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
        end;
        CheckCDS.Next;
      end;
    end;

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if nChangeSumma > 0 then
      begin
        if (CheckCDS.FieldByName('Amount').asCurrency <> 0) and (nSumAll > 0)
        then
        begin
          if nChangeSumma < nSumAll then
          begin
            if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
              nPrice := GetPrice(GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PriceDiscount').asCurrency,
                FormParams.ParamByName('RoundingDown').Value) *
                (nSumAll - nChangeSumma) / nSumAll / CheckCDS.FieldByName
                ('Amount').asCurrency, 0)
            else
              nPrice := GetPrice(GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency,
                FormParams.ParamByName('RoundingDown').Value) *
                (nSumAll - nChangeSumma) / nSumAll / CheckCDS.FieldByName
                ('Amount').asCurrency, 0);
          end
          else
            nPrice := 0.1;
          if nPrice < 0.1 then
            nPrice := 0.1;

          if nPrice <> CheckCDS.FieldByName('Price').asCurrency then
          begin
            CheckCDS.Edit;
            CheckCDS.FieldByName('Price').asCurrency := nPrice;
            CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
            CheckCDS.FieldByName('Summ').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('Price').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value) -
              CheckCDS.FieldByName('Summ').asCurrency;
            CheckCDS.Post;
          end;
        end;
      end
      else if Self.FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PricePartionDate').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceDiscount').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceSale').asCurrency;
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.MobileDiscountCalc;
var
  nRecNo: Integer;
  nSumAll, nPrice, nChangeSumma: Currency;
begin

  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  nSumAll := 0;
  nRecNo := CheckCDS.RecNo;
  try

    nChangeSumma := FormParams.ParamByName('MobileDiscount').Value;

    if nChangeSumma > 0 then
    begin
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if not CheckCDS.FieldByName('isPresent').AsBoolean then
        begin
          if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
            nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount')
              .asCurrency, CheckCDS.FieldByName('PriceDiscount').asCurrency,
              FormParams.ParamByName('RoundingDown').Value)
          else
            nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
        end;
        CheckCDS.Next;
      end;
    end;

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if nChangeSumma > 0 then
      begin
        if (CheckCDS.FieldByName('Amount').asCurrency <> 0) and (nSumAll > 0)
        then
        begin
          if nChangeSumma < nSumAll then
          begin
            if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
              nPrice := RoundTo(GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PriceDiscount').asCurrency,
                FormParams.ParamByName('RoundingDown').Value) *
                (nSumAll - nChangeSumma) / nSumAll / CheckCDS.FieldByName
                ('Amount').asCurrency, -1)
            else
              nPrice := RoundTo(GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency,
                FormParams.ParamByName('RoundingDown').Value) *
                (nSumAll - nChangeSumma) / nSumAll / CheckCDS.FieldByName
                ('Amount').asCurrency, -1);
          end
          else
            nPrice := 0.1;
          if nPrice < 0.1 then
            nPrice := 0.1;

          if nPrice <> CheckCDS.FieldByName('Price').asCurrency then
          begin
            CheckCDS.Edit;
            CheckCDS.FieldByName('Price').asCurrency := nPrice;
            CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
            CheckCDS.FieldByName('Summ').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('Price').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value) -
              CheckCDS.FieldByName('Summ').asCurrency;
            CheckCDS.Post;
          end;
        end;
      end
      else if Self.FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PricePartionDate').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PriceDiscount').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceDiscount').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceSale').asCurrency;
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.SetPromoCodeLoyalty(APromoCodeID: Integer;
  APromoCodeGUID: String; APromoCodeSumma: Currency; AMovementId : Integer;
  AisPresent : Boolean; AAmountPresent : Currency; AGoodsId : Integer);
var
  nRecNo: Integer;
begin

  if APromoCodeID = 0 then
  begin
    FormParams.ParamByName('PromoCodeID').Value := 0;
    FormParams.ParamByName('PromoCodeGUID').Value := '';
    FormParams.ParamByName('LoyaltyChangeSumma').Value := 0;
    FormParams.ParamByName('LoyaltyMovementId').Value := 0;
    FormParams.ParamByName('LoyaltyPresent').Value := False;
    FormParams.ParamByName('LoyaltyAmountPresent').Value := 0;
    FormParams.ParamByName('LoyaltyGoodsId').Value := 0;

    pnlPromoCodeLoyalty.Visible := false;
    lblPromoCodeLoyalty.Caption := '';
    edPromoCodeLoyaltySumm.Value := 0;
  end
  else
  begin
    FormParams.ParamByName('PromoCodeID').Value := APromoCodeID;
    FormParams.ParamByName('PromoCodeGUID').Value := APromoCodeGUID;
    FormParams.ParamByName('LoyaltyChangeSumma').Value := APromoCodeSumma;
    FormParams.ParamByName('LoyaltyMovementId').Value := AMovementId;
    FormParams.ParamByName('LoyaltyPresent').Value := AisPresent;
    FormParams.ParamByName('LoyaltyAmountPresent').Value := AAmountPresent;
    FormParams.ParamByName('LoyaltyGoodsId').Value := AGoodsId;
    // ***27.06.18

    pnlPromoCodeLoyalty.Visible := APromoCodeID > 0;
    lblPromoCodeLoyalty.Caption := '  ' + APromoCodeGUID + '  ';

    if AisPresent then
    begin
      Label27.Caption := 'Кол-во подакрков';
      edPromoCodeLoyaltySumm.Value := AAmountPresent;
    end else
    begin
      Label27.Caption := 'Сумма скидки';
      edPromoCodeLoyaltySumm.Value := APromoCodeSumma;
    end;

    FormParams.ParamByName('ManualDiscount').Value := 0;
  end;

  FormParams.ParamByName('ManualDiscount').Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;

  if AisPresent and (AGoodsId <> 0) then
  begin
    if RemainsCDS.Locate('Id', AGoodsId, []) and (RemainsCDS.FieldByName('Remains').AsCurrency >= 1) then
    begin
      try
        edAmount.Text := CurrToStr(AAmountPresent);
        FormParams.ParamByName('AddPresent').Value := True;
        InsertUpdateBillCheckItems;
      finally
        FormParams.ParamByName('AddPresent').Value := False;
      end;
    end;
  end;

  if AisPresent and (AGoodsId = 0) then
  begin
    with TChoosingPresentForm.Create(nil) do
    try
      Amount := AAmountPresent;
      FormParams.ParamByName('MovementId').Value := AMovementId;
      Label10.Caption := 'Выбирите ' + CurrToStr(AAmountPresent) + ' единиц товара для вставки в документ';
      actRefresh.Execute;
      if ShowModal = mrOk then
      begin
        ChoosingPresentCDS.First;
        while not ChoosingPresentCDS.Eof do
        begin
          if ChoosingPresentCDS.FieldByName('Amount').AsCurrency > 0 then
          begin
            if RemainsCDS.Locate('Id', ChoosingPresentCDS.FieldByName('GoodsId').AsInteger, []) and
              (RemainsCDS.FieldByName('Remains').AsCurrency >= ChoosingPresentCDS.FieldByName('Amount').AsCurrency) then
            try
              edAmount.Text := CurrToStr(ChoosingPresentCDS.FieldByName('Amount').AsCurrency);
              MainCashForm.FormParams.ParamByName('AddPresent').Value := True;
              InsertUpdateBillCheckItems;
            finally
              MainCashForm.FormParams.ParamByName('AddPresent').Value := False;
            end;
          end;
          ChoosingPresentCDS.Next;
        end;
      end else
      begin
        NewCheck;
        Exit;
      end;
    finally
      Free;
    end;
  end;

  PromoCodeLoyaltyCalc;
  CalcTotalSumm;
end;

procedure TMainCashForm2.actSetPromoCodeLoyaltyExecute(Sender: TObject);
var
  сGUID: String;
begin

  if gc_User.Local then
  Begin
    ShowMessage('В отложенном режиме не работает...');
    exit;
  End;

  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage
      ('Применен соц проект.'#13#10'Для променениея программы лояльности обнулите чек и набрать позиции заново..');
    exit;
  end;

  if (DiscountServiceForm.gService = 'AbbottCard') then
  begin
    ShowMessage
      ('Применен дисконт.'#13#10'Для променениея программы лояльности обнулите чек и набрать позиции заново..');
    exit;
  end;

  if FormParams.ParamByName('PromoCodeGUID').Value <> '' then
  begin
    ShowMessage
      ('Установлен промокод.'#13#10'Для применениея изменения обнулите промокод..');
    exit;
  end;

  if FormParams.ParamByName('SiteDiscount').Value <> 0 then
  begin
    ShowMessage
      ('Установлена скидка через сайт.'#13#10'Для променениея программы лояльности обнулите скидку через сайт..');
    exit;
  end;

  if (DiscountServiceForm.gCode <> 0) then
  begin
    ShowMessage
      ('Применен дисконт.'#13#10'Применение программы лояльности запрещено..');
    exit;
  end;

  if not InputEnterLoyaltyNumber(сGUID) then
    exit;

  spLoyaltyCheckGUID.ParamByName('inGUID').Value := сGUID;
  spLoyaltyCheckGUID.ParamByName('outID').Value := 0;
  spLoyaltyCheckGUID.ParamByName('outAmount').Value := 0;
  spLoyaltyCheckGUID.ParamByName('outError').Value := '';
  spLoyaltyCheckGUID.ParamByName('outMovementId').Value := 0;
  spLoyaltyCheckGUID.ParamByName('outisPresent').Value := False;
  spLoyaltyCheckGUID.ParamByName('outAmountPresent').Value := 0;
  spLoyaltyCheckGUID.ParamByName('outGoodsId').Value := 0;
  spLoyaltyCheckGUID.Execute;

  if spLoyaltyCheckGUID.ParamByName('outError').Value <> '' then
  begin
    ShowMessage(spLoyaltyCheckGUID.ParamByName('outError').Value);
    exit;
  end;

  if (spLoyaltyCheckGUID.ParamByName('outID').Value = 0) or
    (spLoyaltyCheckGUID.ParamByName('outAmount').AsFloat = 0) and
    not spLoyaltyCheckGUID.ParamByName('outisPresent').Value then
  begin
    ShowMessage('Ошибка получения данных о скидке.');
    exit;
  end;

  SetPromoCodeLoyalty(spLoyaltyCheckGUID.ParamByName('outID').Value, сGUID,
    spLoyaltyCheckGUID.ParamByName('outAmount').AsFloat,
    spLoyaltyCheckGUID.ParamByName('outMovementId').Value,
    spLoyaltyCheckGUID.ParamByName('outisPresent').Value,
    spLoyaltyCheckGUID.ParamByName('outAmountPresent').AsFloat,
    spLoyaltyCheckGUID.ParamByName('outGoodsId').Value);
end;

procedure TMainCashForm2.edPromoCodeExit(Sender: TObject);
begin
  if (Length(Trim(edPromoCode.Text)) = 8) or (Length(Trim(edPromoCode.Text)) = 6)
  then
  begin
    try
      FormParams.ParamByName('PromoCodeGUID').Value := Trim(edPromoCode.Text);
      spGet_PromoCode_by_GUID.Execute;
      SetPromoCode(FormParams.ParamByName('PromoCodeID').Value,
        FormParams.ParamByName('PromoName').Value,
        FormParams.ParamByName('PromoCodeGUID').Value,
        FormParams.ParamByName('BayerName').Value,
        FormParams.ParamByName('PromoCodeChangePercent').AsFloat);
      ActiveControl := MainGrid;
    Except
      ON E: Exception do
      Begin
        ShowMessage('Ошибка: ' + E.Message);
        ActiveControl := edPromoCode;
      End;
    end;
  end
  else
  begin
    if Length(Trim(edPromoCode.Text)) <> 0 then
    begin
      ActiveControl := edPromoCode;
      ShowMessage
        ('Ошибка. Значение <Промокод> не определено. Длина промокода должна быть 6 или 8 символов');
    end
    else
      SetPromoCode(0, '', '', '', 0);
  end;
end;

procedure TMainCashForm2.edPromoCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_RETURN:
        PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
      VK_ESCAPE:
        begin
          edPromoCode.Text := FormParams.ParamByName('PromoCodeGUID').Value;
          PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
        end;
    end;
end;

procedure TMainCashForm2.edPromoCodeKeyPress(Sender: TObject; var Key: Char);
begin
  { if not CharInSet(Key, [#8, '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'a', 'b', 'c', 'd', 'e', 'f',
    'A', 'B', 'C', 'D', 'E', 'F']) then Key:= #0; }
end;

procedure TMainCashForm2.actSetRimainsFromMemdataExecute(Sender: TObject);
// только 2 форма
var
  GoodsId, nCheckId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  Amount_find: Currency;
  oldFilter: String;
  oldFiltered: Boolean;
begin
  // ShowMessage('actSetRimainsFromMemdataExecute - begin');
  Add_Log('Начало заполнения с Memdata');
  // AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  RemainsCDS.DisableControls;
  nCheckId := 0;
  if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
    nCheckId := CheckCDS.FieldByName('GoodsId').AsInteger;
  RemainsCDS.Filtered := false;
  // AlternativeCDS.Filtered := False;
  CheckCDS.DisableControls;
  oldFilter := CheckCDS.Filter;
  oldFiltered := CheckCDS.Filtered;
  try
    MemData.First;
    while not MemData.Eof do
    begin
      // сначала найдем кол-во в чеках
      Amount_find := 0;
      CheckCDS.Filter := 'GoodsId = ' +
        IntToStr(MemData.FieldByName('Id').AsInteger) +
        ' and PartionDateKindId = ' + IntToSVar(MemData.FieldByName('PDKINDID').AsVariant) +
        ' and NDSKindId = ' + IntToSVar(MemData.FieldByName('NDSKindId').AsVariant) +
        ' and DiscountExternalID = ' + IntToSVar(MemData.FieldByName('DISCEXTID').AsVariant) +
        ' and DivisionPartiesID = ' + IntToSVar(MemData.FieldByName('DIVPARTID').AsVariant);
      CheckCDS.Filtered := True;
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        Amount_find := Amount_find + CheckCDS.FieldByName('Amount').asCurrency;
        CheckCDS.Next;
      end;
      CheckCDS.Filter := oldFilter;
      CheckCDS.Filtered := oldFiltered;

      if not RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([MemData.FieldByName('Id').AsInteger,
        MemData.FieldByName('PDKINDID').AsVariant,
        MemData.FieldByName('NDSKINDID').AsVariant,
        MemData.FieldByName('DISCEXTID').AsVariant,
        MemData.FieldByName('DIVPARTID').AsVariant]), []) and
        MemData.FieldByName('NewRow').AsBoolean then
      Begin
        // Add_Log('    Add ' + MemData.FieldByName('GoodsCode').AsString + ' - ' + MemData.FieldByName('GoodsName').AsString + '; ' + MemData.FieldByName('Remains').AsString);
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := MemData.FieldByName('Id')
          .AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger :=
          MemData.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString :=
          MemData.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency :=
          MemData.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('NDS').asCurrency :=
          MemData.FieldByName('NDS').asCurrency;
        RemainsCDS.FieldByName('NDSKindId').AsInteger :=
          MemData.FieldByName('NDSKINDID').AsInteger;
        RemainsCDS.FieldByName('DiscountExternalID').AsVariant :=
          MemData.FieldByName('DISCEXTID').AsVariant;
        RemainsCDS.FieldByName('DiscountExternalName').AsVariant :=
          MemData.FieldByName('DISCEXTNAME').AsVariant;
        RemainsCDS.FieldByName('DivisionPartiesID').AsVariant :=
          MemData.FieldByName('DIVPARTID').AsVariant;
        RemainsCDS.FieldByName('DivisionPartiesName').AsVariant :=
          MemData.FieldByName('DIVPARTNAME').AsVariant;
        RemainsCDS.FieldByName('Remains').asCurrency :=
          MemData.FieldByName('Remains').asCurrency;
        RemainsCDS.FieldByName('MCSValue').asCurrency :=
          MemData.FieldByName('MCSValue').asCurrency;
        RemainsCDS.FieldByName('Reserved').AsVariant :=
          MemData.FieldByName('Reserved').AsVariant;
        RemainsCDS.FieldByName('MinExpirationDate').AsVariant :=
          MemData.FieldByName('MEXPDATE').AsVariant;
        RemainsCDS.FieldByName('PartionDateKindId').AsVariant :=
          MemData.FieldByName('PDKINDID').AsVariant;
        RemainsCDS.FieldByName('PartionDateKindName').AsVariant :=
          MemData.FieldByName('PDKINDNAME').AsVariant;
        RemainsCDS.FieldByName('AccommodationID').AsVariant :=
          MemData.FieldByName('ACCOMID').AsVariant;
        RemainsCDS.FieldByName('AccommodationName').AsVariant :=
          MemData.FieldByName('ACCOMNAME').AsVariant;
        RemainsCDS.FieldByName('AmountMonth').AsVariant :=
          MemData.FieldByName('AMOUNTMON').AsVariant;
        RemainsCDS.FieldByName('PricePartionDate').AsVariant :=
          MemData.FieldByName('PRICEPD').AsVariant;
        RemainsCDS.FieldByName('DeferredSend').AsVariant :=
          MemData.FieldByName('DEFERENDS').AsVariant;
        RemainsCDS.FieldByName('DeferredTR').AsVariant :=
          MemData.FieldByName('DEFERENDT').AsVariant;
        RemainsCDS.FieldByName('RemainsSun').AsVariant :=
          MemData.FieldByName('REMAINSSUN').AsVariant;
        RemainsCDS.FieldByName('Color_calc').AsVariant :=
          MemData.FieldByName('COLORCALC').AsVariant;
        RemainsCDS.FieldByName('GoodsDiscountID').AsVariant :=
          MemData.FieldByName('GOODSDIID').AsVariant;
        RemainsCDS.FieldByName('GoodsDiscountName').AsVariant :=
          MemData.FieldByName('GOODSDINAME').AsVariant;
        RemainsCDS.FieldByName('UKTZED').AsVariant :=
          MemData.FieldByName('UKTZED').AsVariant;
        RemainsCDS.FieldByName('isGoodsPairSun').AsVariant :=
          MemData.FieldByName('ISGOODSPS').AsVariant;
        RemainsCDS.FieldByName('GoodsPairSunMainId').AsVariant :=
          MemData.FieldByName('GOODSPMID').AsVariant;
        RemainsCDS.FieldByName('GoodsPairSunAmount').AsVariant :=
          MemData.FieldByName('GOODSPSAM').AsVariant;
        RemainsCDS.FieldByName('isGoodsForProject').AsVariant :=
          MemData.FieldByName('GOODSPROJ').AsVariant;
        RemainsCDS.FieldByName('isBanFiscalSale').AsVariant :=
          MemData.FieldByName('GOODSPROJ').AsVariant;
        RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsVariant :=
          MemData.FieldByName('GOODSDIMP').AsVariant;
        RemainsCDS.FieldByName('GoodsDiscountProcentSite').AsVariant :=
          MemData.FieldByName('GOODSDIPR').AsVariant;
        RemainsCDS.FieldByName('MorionCode').AsVariant :=
          MemData.FieldByName('MORIONCODE').AsVariant;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([MemData.FieldByName('Id').AsInteger,
          MemData.FieldByName('PDKINDID').AsVariant,
          MemData.FieldByName('NDSKINDID').AsVariant,
          MemData.FieldByName('DISCEXTID').AsVariant,
          MemData.FieldByName('DIVPARTID').AsVariant]), []) then
        Begin
          // Add_Log('    Update ' + MemData.FieldByName('GoodsCode').AsString + ' - ' + MemData.FieldByName('GoodsName').AsString + '; ' +
          // RemainsCDS.FieldByName('Remains').AsString + ' = ' + MemData.FieldByName('Remains').AsString);
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency :=
            MemData.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('NDS').asCurrency :=
            MemData.FieldByName('NDS').asCurrency;
          RemainsCDS.FieldByName('NDSKindId').AsInteger :=
            MemData.FieldByName('NDSKINDID').AsInteger;
          RemainsCDS.FieldByName('DiscountExternalID').AsVariant :=
            MemData.FieldByName('DISCEXTID').AsVariant;
          RemainsCDS.FieldByName('DiscountExternalName').AsVariant :=
            MemData.FieldByName('DISCEXTName').AsVariant;
          RemainsCDS.FieldByName('DivisionPartiesID').AsVariant :=
            MemData.FieldByName('DIVPARTID').AsVariant;
          RemainsCDS.FieldByName('DivisionPartiesName').AsVariant :=
            MemData.FieldByName('DIVPARTNAME').AsVariant;
          RemainsCDS.FieldByName('Remains').asCurrency :=
            MemData.FieldByName('Remains').asCurrency - Amount_find;
          RemainsCDS.FieldByName('MCSValue').asCurrency :=
            MemData.FieldByName('MCSValue').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency :=
            MemData.FieldByName('Reserved').asCurrency;
          RemainsCDS.FieldByName('MinExpirationDate').AsVariant :=
            MemData.FieldByName('MEXPDATE').AsVariant;
          RemainsCDS.FieldByName('PartionDateKindId').AsVariant :=
            MemData.FieldByName('PDKINDID').AsVariant;
          RemainsCDS.FieldByName('PartionDateKindName').AsVariant :=
            MemData.FieldByName('PDKINDNAME').AsVariant;
          RemainsCDS.FieldByName('AccommodationID').AsVariant :=
            MemData.FieldByName('ACCOMID').AsVariant;
          RemainsCDS.FieldByName('AccommodationName').AsVariant :=
            MemData.FieldByName('ACCOMNAME').AsVariant;
          RemainsCDS.FieldByName('AmountMonth').AsVariant :=
            MemData.FieldByName('AMOUNTMON').AsVariant;
          RemainsCDS.FieldByName('PricePartionDate').AsVariant :=
            MemData.FieldByName('PRICEPD').AsVariant;
          RemainsCDS.FieldByName('DeferredSend').AsVariant :=
            MemData.FieldByName('DEFERENDS').AsVariant;
          RemainsCDS.FieldByName('DeferredTR').AsVariant :=
            MemData.FieldByName('DEFERENDT').AsVariant;
          RemainsCDS.FieldByName('RemainsSun').AsVariant :=
            MemData.FieldByName('REMAINSSUN').AsVariant;
          RemainsCDS.FieldByName('Color_calc').AsVariant :=
            MemData.FieldByName('COLORCALC').AsVariant;
          RemainsCDS.FieldByName('GoodsDiscountID').AsVariant :=
            MemData.FieldByName('GOODSDIID').AsVariant;
          RemainsCDS.FieldByName('GoodsDiscountName').AsVariant :=
            MemData.FieldByName('GOODSDINAME').AsVariant;
          RemainsCDS.FieldByName('UKTZED').AsVariant :=
            MemData.FieldByName('UKTZED').AsVariant;
          RemainsCDS.FieldByName('isGoodsPairSun').AsVariant :=
            MemData.FieldByName('ISGOODSPS').AsVariant;
          RemainsCDS.FieldByName('GoodsPairSunMainId').AsVariant :=
            MemData.FieldByName('GOODSPMID').AsVariant;
          RemainsCDS.FieldByName('GoodsPairSunAmount').AsVariant :=
            MemData.FieldByName('GOODSPSAM').AsVariant;
          RemainsCDS.FieldByName('isBanFiscalSale').AsVariant :=
            MemData.FieldByName('BANFISCAL').AsVariant;
          RemainsCDS.FieldByName('isGoodsForProject').AsVariant :=
            MemData.FieldByName('GOODSPROJ').AsVariant;
          RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsVariant :=
            MemData.FieldByName('GOODSDIMP').AsVariant;
          RemainsCDS.FieldByName('GoodsDiscountProcentSite').AsVariant :=
            MemData.FieldByName('GOODSDIPR').AsVariant;
          RemainsCDS.FieldByName('MorionCode').AsVariant :=
            MemData.FieldByName('MORIONCODE').AsVariant;
          RemainsCDS.Post;
        End;
      End;

      MemData.Next;
    end;

    // AlternativeCDS.First;
    // while Not AlternativeCDS.eof do
    // Begin
    // if MemData.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
    // Begin
    // if AlternativeCDS.FieldByName('Remains').asCurrency <> MemData.FieldByName('Remains').asCurrency then
    // Begin
    // AlternativeCDS.Edit;
    // AlternativeCDS.FieldByName('Remains').asCurrency := MemData.FieldByName('Remains').asCurrency;
    // AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency - Amount_find;
    // AlternativeCDS.Post;
    // End;
    // End;
    // AlternativeCDS.Next;
    // End;
    MemData.Close;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKINDID;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
    // AlternativeCDS.Filtered := true;
    // AlternativeCDS.EnableControls;
    if nCheckId <> 0 then
      CheckCDS.Locate('GoodsId', nCheckId, []);
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered := oldFiltered;
    difUpdate := True;
    Add_Log('Конец заполнения с Memdata');
  end;

  // ShowMessage('actSetRimainsFromMemdataExecute - end');

end;

procedure TMainCashForm2.actSetConfirmedKind_CompleteExecute(Sender: TObject);
var
  UID: String;
  lConfirmedKindName: String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
    ShowMessage('Ошибка.VIP-чек не загружен.');
    exit
  end;

  // Изменили <Статус заказа> и получили его название
  with spUpdate_ConfirmedKind do
    try
      ParamByName('inMovementId').Value :=
        FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_Complete';
      Execute;
      lConfirmedKindName := ParamByName('ouConfirmedKindName').Value;
    except
      ShowMessage('Ошибка.Нет связи с сервером');
    end;

  if spUpdate_ConfirmedKind.ParamByName('outMessageText').Value <> '' then
  begin
    actShowMessage.MessageText := spUpdate_ConfirmedKind.ParamByName
      ('outMessageText').Value;
    actShowMessage.Execute;
  end;

  if lConfirmedKindName = '' then
  begin
    ShowMessage('Ошибка.Нельзя изменить статус чека');
    exit;
  end;

  FormParams.ParamByName('ConfirmedKindName').Value := lConfirmedKindName;

  if SaveLocal(CheckCDS, FormParams.ParamByName('ManagerId').Value,
    FormParams.ParamByName('ManagerName').Value,
    FormParams.ParamByName('BayerName').Value
    // ***16.08.16
    , FormParams.ParamByName('BayerPhone').Value, lConfirmedKindName,
    FormParams.ParamByName('InvNumberOrder').Value,
    FormParams.ParamByName('ConfirmedKindClientName').Value
    // ***20.07.16
    , FormParams.ParamByName('DiscountExternalId').Value,
    FormParams.ParamByName('DiscountExternalName').Value,
    FormParams.ParamByName('DiscountCardNumber').Value
    // ***08.04.17
    , FormParams.ParamByName('PartnerMedicalId').Value,
    FormParams.ParamByName('PartnerMedicalName').Value,
    FormParams.ParamByName('Ambulance').Value, FormParams.ParamByName('MedicSP')
    .Value, FormParams.ParamByName('InvNumberSP').Value,
    FormParams.ParamByName('OperDateSP').Value
    // ***15.06.17
    , FormParams.ParamByName('SPKindId').Value,
    FormParams.ParamByName('SPKindName').Value,
    FormParams.ParamByName('SPTax').Value
    // ***05.02.18
    , FormParams.ParamByName('PromoCodeID').Value
    // ***27.06.18
    , FormParams.ParamByName('ManualDiscount').Value
    // ***02.11.18
    , FormParams.ParamByName('SummPayAdd').Value
    // ***14.01.19
    , FormParams.ParamByName('MemberSPID').Value
    // ***20.02.19
    , FormParams.ParamByName('BankPOSTerminal').Value
    // ***25.02.19
    , FormParams.ParamByName('JackdawsChecksCode').Value
    // ***28.01.19
    , FormParams.ParamByName('SiteDiscount').Value
    // ***02.04.19
    , FormParams.ParamByName('RoundingDown').Value
    // ***13.05.19
    , FormParams.ParamByName('PartionDateKindId').Value,
    FormParams.ParamByName('ConfirmationCodeSP').Value
    // ***07.11.19
    , FormParams.ParamByName('LoyaltySignID').Value
    // ***08.01.20
    , FormParams.ParamByName('LoyaltySMID').Value,
    FormParams.ParamByName('LoyaltySMSumma').Value
    // ***16.08.20
    , FormParams.ParamByName('DivisionPartiesID').Value
    , FormParams.ParamByName('DivisionPartiesName').Value
      // ***11.10.20
    , FormParams.ParamByName('MedicForSale').Value
    , FormParams.ParamByName('BuyerForSale').Value
    , FormParams.ParamByName('BuyerForSalePhone').Value
    , FormParams.ParamByName('DistributionPromoList').Value
      // ***05.03.21
    , FormParams.ParamByName('MedicKashtanId').Value
    , FormParams.ParamByName('MemberKashtanId').Value
    // ***19.03.21
    , FormParams.ParamByName('isCorrectMarketing').Value
    , FormParams.ParamByName('isCorrectIlliquidAssets').Value
    , FormParams.ParamByName('isDoctors').Value
    , FormParams.ParamByName('isDiscountCommit').Value
    // ***04.10.21
    , FormParams.ParamByName('MedicalProgramSPId').Value
    , FormParams.ParamByName('isManual').Value
    , FormParams.ParamByName('Category1303Id').Value

    , false // NeedComplete
    , False // isErrorRRO
    , FormParams.ParamByName('isPaperRecipeSP').Value
    , 0  // ZReport
    , '' // FiscalCheckNumber
    , FormParams.ParamByName('CheckId').Value // Id чека
    , UID // out AUID
    ) then
  begin

    //
    NewCheck(false);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString +
      ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString + ' * ' +
      '№ ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP(True);
end;

procedure TMainCashForm2.actSetConfirmedKind_UnCompleteExecute(Sender: TObject);
var
  UID: String;
  lConfirmedKindName: String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
    ShowMessage('Ошибка.VIP-чек не загружен.');
    exit
  end;

  // Изменили <Статус заказа> и получили его название
  with spUpdate_ConfirmedKind do
    try
      ParamByName('inMovementId').Value :=
        FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_UnComplete';
      Execute;
      lConfirmedKindName := ParamByName('ouConfirmedKindName').Value;
    except
      ShowMessage('Ошибка.Нет связи с сервером');
    end;

  if lConfirmedKindName = '' then
  begin
    ShowMessage('Ошибка.Нельзя изменить статус чека');
    exit;
  end;

  FormParams.ParamByName('ConfirmedKindName').Value := lConfirmedKindName;

  if SaveLocal(CheckCDS, FormParams.ParamByName('ManagerId').Value,
    FormParams.ParamByName('ManagerName').Value,
    FormParams.ParamByName('BayerName').Value
    // ***16.08.16
    , FormParams.ParamByName('BayerPhone').Value, lConfirmedKindName,
    FormParams.ParamByName('InvNumberOrder').Value,
    FormParams.ParamByName('ConfirmedKindClientName').Value
    // ***20.07.16
    , FormParams.ParamByName('DiscountExternalId').Value,
    FormParams.ParamByName('DiscountExternalName').Value,
    FormParams.ParamByName('DiscountCardNumber').Value
    // ***08.04.17
    , FormParams.ParamByName('PartnerMedicalId').Value,
    FormParams.ParamByName('PartnerMedicalName').Value,
    FormParams.ParamByName('Ambulance').Value, FormParams.ParamByName('MedicSP')
    .Value, FormParams.ParamByName('InvNumberSP').Value,
    FormParams.ParamByName('OperDateSP').Value
    // ***15.06.17
    , FormParams.ParamByName('SPKindId').Value,
    FormParams.ParamByName('SPKindName').Value,
    FormParams.ParamByName('SPTax').Value
    // ***05.02.18
    , FormParams.ParamByName('PromoCodeID').Value
    // ***27.06.18
    , FormParams.ParamByName('ManualDiscount').Value
    // ***02.11.18
    , FormParams.ParamByName('SummPayAdd').Value
    // ***14.01.19
    , FormParams.ParamByName('MemberSPID').Value
    // ***20.02.19
    , FormParams.ParamByName('BankPOSTerminal').Value
    // ***25.02.19
    , FormParams.ParamByName('JackdawsChecksCode').Value
    // ***28.01.19
    , FormParams.ParamByName('SiteDiscount').Value
    // ***02.04.19
    , FormParams.ParamByName('RoundingDown').Value
    // ***13.05.19
    , FormParams.ParamByName('PartionDateKindId').Value
    , FormParams.ParamByName('ConfirmationCodeSP').Value
    // ***07.11.19
    , FormParams.ParamByName('LoyaltySignID').Value
    // ***08.01.20
    , FormParams.ParamByName('LoyaltySMID').Value
    , FormParams.ParamByName('LoyaltySMSumma').Value
    // ***16.08.20
    , FormParams.ParamByName('DivisionPartiesID').Value
    , FormParams.ParamByName('DivisionPartiesName').Value
    // ***11.10.20
    , FormParams.ParamByName('MedicForSale').Value
    , FormParams.ParamByName('BuyerForSale').Value
    , FormParams.ParamByName('BuyerForSalePhone').Value
    , FormParams.ParamByName('DistributionPromoList').Value
    // ***05.03.21
    , FormParams.ParamByName('MedicKashtanId').Value
    , FormParams.ParamByName('MemberKashtanId').Value
    // ***19.03.21
    , FormParams.ParamByName('isCorrectMarketing').Value
    , FormParams.ParamByName('isCorrectIlliquidAssets').Value
    , FormParams.ParamByName('isDoctors').Value
    , FormParams.ParamByName('isDiscountCommit').Value
    // ***04.10.21
    , FormParams.ParamByName('MedicalProgramSPId').Value
    , FormParams.ParamByName('isManual').Value
    , FormParams.ParamByName('Category1303Id').Value

    , false // NeedComplete
    , False // isErrorRRO
    , FormParams.ParamByName('isPaperRecipeSP').Value
    , 0  // ZReport
    , '' // FiscalCheckNumber
    , FormParams.ParamByName('CheckId').Value // Id чека
    , UID // out AUID
    ) then
  begin

    //
    NewCheck(false);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString +
      ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString + ' * ' +
      '№ ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP(True);
end;

// ***20.07.16
procedure TMainCashForm2.SetDiscountExternal(ACode : Integer = 0; ADiscountCard : String = '');
var
  DiscountExternalId: Integer; MovementItemID, gCode : Integer;
  DiscountExternalName, DiscountCardNumber: String;
  lMsg: String;
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalGoodsID, DivisionPartiesID: Variant;
  nPriceSite: boolean;
begin

  if pnlManualDiscount.Visible or pnlPromoCode.Visible or pnlSiteDiscount.Visible
  then
  Begin
    ShowMessage('В текущем чеке применена скидка. Сначала очистите чек!');
    exit;
  End;

  if pnlHelsiError.Visible then
  begin
    ShowMessage('Обработайте непогашенный чек Хелси!');
    exit;
  end;

  if pnlPromoCode.Visible or pnlPromoCodeLoyalty.Visible then
  begin
    ShowMessage('В текущем чеке применен промокод. Сначала очистите чек!');
    exit;
  end;

  if (CheckCDS.RecordCount > 1) and (FormParams.ParamByName('CheckId').Value = 0) then
  begin
    ShowMessage('Ошибка.В чеке для дисконтной программы должен быть один товар.');
    exit;
  end;

  if FormParams.ParamByName('isDiscountCommit').Value = True then
  begin
    ShowMessage('По текущему чеку Дисконт проведен на сайте!');
    exit;
  end;

  if DiscountServiceForm.isPrepared then
  begin
    ShowMessage('В текущем чеке запрошена возможность продажи. Произведите продажу или очистите чек!');
    exit;
  end;

  if pnlLoyaltySaveMoney.Visible then
  begin
    ShowMessage('В текущем чеке применена программа лояльности . Сначала очистите чек!');
    exit;
  end;

  with CheckCDS do
  begin
    First;
    while not Eof do
    begin

      if (Frac(FieldByName('Amount').AsCurrency) <> 0) then
      begin
        ShowMessage('Деление медикамента для дисконтных программ запрещено!');
        exit;
      end;

      Next;
    end;
  end;

  with TDiscountDialogForm.Create(nil) do
    try
      DiscountExternalId := Self.FormParams.ParamByName
        ('DiscountExternalId').Value;
      DiscountExternalName := Self.FormParams.ParamByName
        ('DiscountExternalName').Value;
      DiscountCardNumber := Self.FormParams.ParamByName
        ('DiscountCardNumber').Value;
      if not DiscountDialogExecute(DiscountExternalId, DiscountExternalName,
        DiscountCardNumber, ACode, ADiscountCard) then
        exit;
    finally
      Free;
    end;
  //

  if FormParams.ParamByName('CheckId').Value <> 0 then
  begin
    MovementItemID := 0;
    try
      RemainsCDS.DisableControls;
      RemainsCDS.Filtered := false;
      with CheckCDS do
      begin
        First;
        while not Eof do
        begin

          if RemainsCDS.Locate('ID',
             VarArrayOf([FieldByName('GoodsId').AsInteger,
             FieldByName('PartionDateKindId').AsVariant,
             FieldByName('NDSKindId').AsVariant,
             FieldByName('DiscountExternalID').AsVariant,
             FieldByName('DivisionPartiesID').AsVariant]), []) and
             (RemainsCDS.FieldByName('GoodsDiscountName').AsString = DiscountExternalName) then
          begin

            if (RemainsCDS.FieldByName('Remains').AsCurrency < 0) and (FormParams.ParamByName('ConfirmedKindName').AsString <> 'Подтвержден') then
            begin
                ShowMessage('Товар <' + FieldByName('GoodsName').AsString +
                  '> входит в дисконтную программу <' + DiscountExternalName + '> наличия нет для продажи.');
            end else
            begin
              if FieldByName('Id').AsInteger = 0 then
              begin
                ShowMessage('Что-то пошло не так очистите чек и званого его загрузите.');
                Exit;
              end;

              if CheckCDS.RecordCount > 1 then
              begin
                if MessageDlg('Извлечь из отложенного чека товар <' + FieldByName('GoodsName').AsString +
                  '> дисконтной программы <' + DiscountExternalName + '> в отдельный ВИП чек?', mtConfirmation, mbYesNo, 0) = mrYes then
                begin
                  MovementItemID := FieldByName('Id').AsInteger;
                  Break
                end;
              end else
              begin
                MovementItemID := FieldByName('Id').AsInteger;
                Break
              end;
            end;
          end;
          Next;
        end;
      end;
    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.EnableControls;
    end;

    if MovementItemID <> 0 then
    begin
      if CheckCDS.RecordCount > 1 then
      begin
         spPullGoodsCheck.ParamByName('inMovementId').Value := FormParams.ParamByName('CheckId').Value;
         spPullGoodsCheck.ParamByName('inMovementItemId').Value := MovementItemID;
         spPullGoodsCheck.ParamByName('outMovementId').Value :=  0;
         spPullGoodsCheck.Execute;
         if spPullGoodsCheck.ParamByName('outMovementId').Value <> 0 then
         begin
           CheckCDS.EmptyDataSet;
           NewCheck(True);
           FormParams.ParamByName('CheckOldId').Value := spPullGoodsCheck.ParamByName('inMovementId').Value;
           spSelectCheckId.ParamByName('inMovementId').Value := spPullGoodsCheck.ParamByName('outMovementId').Value;
           spSelectCheckId.Execute;
           spSelectCheck.Execute;
           FormParams.ParamByName('DiscountExternalId').Value := DiscountExternalId;
           FormParams.ParamByName('DiscountExternalName').Value := DiscountExternalName;
           FormParams.ParamByName('DiscountCardNumber').Value := DiscountCardNumber;
           LoadVIPCheck;
           Exit;
         end else Exit;
      end;
    end else
    begin
      ShowMessage('В чеке не найдены товары дисконтной программы: ' + DiscountExternalName);
      Exit;
    end;
  end;

  nPriceSite := False;

  with CheckCDS do
  begin
    First;
    while not Eof do
    begin

      if (FieldByName('Amount').AsCurrency > 0) and FieldByName('isPriceDiscount').AsBoolean and (FieldByName('GoodsDiscountProcent').AsCurrency > 0) then
      begin
        nPriceSite := True;
        Edit;
        if FieldByName('GoodsDiscountProcent').AsCurrency < 100 then
           FieldByName('PriceSale').AsCurrency := GetPrice(FieldByName('Price').AsCurrency * 100 / (100 - FieldByName('GoodsDiscountProcent').AsCurrency), 0)
        else FieldByName('PriceSale').AsCurrency := FieldByName('PriceSaleDiscount').AsCurrency;
        Post;
      end;

      Next;
    end;
  end;


  FormParams.ParamByName('DiscountExternalId').Value := DiscountExternalId;
  FormParams.ParamByName('DiscountExternalName').Value := DiscountExternalName;
  FormParams.ParamByName('DiscountCardNumber').Value := DiscountCardNumber;

  // update DataSet - еще раз по всем "обновим" Дисконт
  DiscountServiceForm.fUpdateCDS_Discount(CheckCDS, lMsg,
    FormParams.ParamByName('DiscountExternalId').Value,
    FormParams.ParamByName('DiscountCardNumber').Value,
    nPriceSite);

  // Проверим цену
  try
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    with CheckCDS do
    begin
      First;
      while not Eof do
      begin

        RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
            VarArrayOf([FieldByName('GoodsId').AsInteger,
            FieldByName('PartionDateKindId').AsVariant,
            FieldByName('NDSKindId').AsVariant,
            FieldByName('DiscountExternalID').AsVariant,
            FieldByName('DivisionPartiesID').AsVariant]), []);

        if (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency > 0) and
           (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency < FieldByName('PriceSale').AsCurrency) and
           (FieldByName('Amount').AsCurrency > 0) then
        begin
          ShowMessage('Превышена максимально возможная цена на препарат <' + FieldByName('GoodsName').AsString + '>. Обратитесь к Калининой Кристине...');
        end;

        Next;
      end;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.EnableControls;
  end;
  //
  CalcTotalSumm;
  //
  pnlDiscount.Visible := DiscountExternalId > 0;
  lblDiscountExternalName.Caption := '  ' + DiscountExternalName + '  ';
  lblDiscountCardNumber.Caption := '  ' + DiscountCardNumber + '  ';
  lblPrice.Visible := (DiscountServiceForm.gService = 'AbbottCard') and
    (DiscountServiceForm.gUserName = '');
  edPrice.Visible := lblPrice.Visible;
  lblAmount.Visible := lblPrice.Visible;
  edDiscountAmount.Visible := lblAmount.Visible;

  if pnlDiscount.Visible then
  begin

    spRemainsUnitOne.ParamByName('inDiscountExternalId').Value :=  DiscountExternalId;
    spRemainsUnitOne.Execute;

    try
      RemainsCDS.DisableControls;
      RemainsCDS.Filtered := false;

      if RemainsUnitOneCDS.Active then
      begin
        RemainsUnitOneCDS.First;
        while not RemainsUnitOneCDS.Eof do
        begin
          if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                   VarArrayOf([RemainsUnitOneCDS.FieldByName('GoodsId').AsInteger,
                               RemainsUnitOneCDS.FieldByName('PartionDateKindId').AsVariant,
                               RemainsUnitOneCDS.FieldByName('NDSKindId').AsVariant,
                               RemainsUnitOneCDS.FieldByName('DiscountExternalID').AsVariant,
                               RemainsUnitOneCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
          begin
            RemainsCDS.Edit;
            RemainsCDS.FieldByName('Remains').AsCurrency := RemainsUnitOneCDS.FieldByName('RemainsDiscount').AsCurrency;
            RemainsCDS.Post;
          end;

          RemainsUnitOneCDS.Next;
        end;
      end;

      RemainsCDS.Filter := '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and GoodsDiscountID = ' + IntToStr(DiscountServiceForm.gDiscountExternalId)
    finally
      RemainsCDS.Filtered := true;
      RemainsCDS.EnableControls;
    end;
  end;
end;

procedure TMainCashForm2.actSetDiscountExternalExecute(Sender: TObject);
begin
  SetDiscountExternal;
end;

// ***28.01.19

procedure TMainCashForm2.SetSiteDiscount(ASiteDiscount: Currency);
var
  nRecNo: Integer;
begin

  FormParams.ParamByName('SiteDiscount').Value := ASiteDiscount;
  pnlSiteDiscount.Visible := FormParams.ParamByName('SiteDiscount').Value > 0;
  edSiteDiscount.Value := FormParams.ParamByName('SiteDiscount').Value;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindId').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []);

      if (FormParams.ParamByName('LoyaltyChangeSumma').Value = 0) and
        (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
        CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value,
        CheckCDS.FieldByName('GoodsId').AsInteger) then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          GetPrice(IfZero(CheckCDS.FieldByName('PricePartionDate').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency),
          Self.FormParams.ParamByName('SiteDiscount').Value);
        CheckCDS.FieldByName('ChangePercent').asCurrency :=
          Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end
      else if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PricePartionDate').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('PriceSale').asCurrency,
          FormParams.ParamByName('RoundingDown').Value) -
          CheckCDS.FieldByName('Summ').asCurrency;
        CheckCDS.Post;
      end  // Если есть цена со скидкой
      else if (RemainsCDS.FieldByName('PriceChange').asCurrency > 0) and
        (CheckCDS.FieldByName('Price').asCurrency <> CheckCDS.FieldByName('PriceSale').asCurrency) and
        (CheckCDS.FieldByName('Price').asCurrency = RemainsCDS.FieldByName('PriceChange').asCurrency) and
        (RemainsCDS.FieldByName('FixEndDate').IsNull or (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date)) then
      begin

        CheckCDS.Edit;
        CheckCDS.FieldByName('TypeDiscount').AsInteger := 1;
        CheckCDS.Post;

      end // Если есть процент скидки
      else if (RemainsCDS.FieldByName('FixPercent').asCurrency > 0) and
        (CheckCDS.FieldByName('Price').asCurrency <> CheckCDS.FieldByName('PriceSale').asCurrency) and
        (CheckCDS.FieldByName('Price').asCurrency = GetPrice(CheckCDS.FieldByName('PriceSale').asCurrency, RemainsCDS.FieldByName('FixPercent').asCurrency)) and
        (RemainsCDS.FieldByName('FixEndDate').IsNull or (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date)) then
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('TypeDiscount').AsInteger := 2;
        CheckCDS.Post;
      end
      else // Если есть сумма скидки
      if (RemainsCDS.FieldByName('FixDiscount').asCurrency > 0) and
        (CheckCDS.FieldByName('Price').asCurrency <> CheckCDS.FieldByName('PriceSale').asCurrency) and
        (CheckCDS.FieldByName('Price').asCurrency = GetPrice(CheckCDS.FieldByName('PriceSale').asCurrency - RemainsCDS.FieldByName('FixDiscount').asCurrency, 0)) and
        (RemainsCDS.FieldByName('FixEndDate').IsNull or (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date)) then
      begin

        CheckCDS.Edit;
        CheckCDS.FieldByName('TypeDiscount').AsInteger := 3;
        CheckCDS.Post;

      end else
      begin
        CheckCDS.Edit;
        CheckCDS.FieldByName('Price').asCurrency :=
          CheckCDS.FieldByName('PriceSale').asCurrency;
        CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);
        CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
        CheckCDS.Post;
      end;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
  end;
  CalcTotalSumm;
end;

procedure TMainCashForm2.actSetSiteDiscountExecute(Sender: TObject);
var
  nRecNo: Integer;
  nSiteDiscount: Currency;
begin
  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage
      ('Применен соц проект.'#13#10'Для променениея скидка через сайт обнулите чек и набрать позиции заново..');
    exit;
  end;

  if (DiscountServiceForm.gService = 'AbbottCard') then
  begin
    ShowMessage
      ('Применен дисконт.'#13#10'Для променениея скидка через сайт обнулите чек и набрать позиции заново..');
    exit;
  end;

  nSiteDiscount := 0;
  if pnlSiteDiscount.Visible then
  begin
    if MessageDlg('Убрать скидку через сайт?', mtConfirmation, mbYesNo, 0) <> mrYes
    then
      exit;
  end
  else
  begin
    try
      spGlobalConst_SiteDiscount.Execute;
      if spGlobalConst_SiteDiscount.Params.Items[0].Value <> Null then
        nSiteDiscount := spGlobalConst_SiteDiscount.Params.Items[0].AsFloat
      else
        nSiteDiscount := 0;
    except
      on E: Exception do
        ShowMessage('Ошибка получения скидки через сайт: ' + #13#10 +
          E.Message);
    end;

    if nSiteDiscount = 0 then
    begin
      ShowMessage
        ('Операция недоступна.'#13#10'Процент скидки через сайт не установлен.');
      exit;
    end;
  end;

  SetSiteDiscount(nSiteDiscount);
end;

function TMainCashForm2.CheckSP: Boolean;
begin
  Result := false;

  if not UnitConfigCDS.FieldByName('isSP').AsBoolean then
  Begin
    ShowMessage
      ('По подразделению работа со скидками по соц проекту запрещена!');
    exit;
  End;

  if not UnitConfigCDS.FieldByName('DateSP').IsNull and
    (UnitConfigCDS.FieldByName('DateSP').AsDateTime > Date) then
  Begin
    ShowMessage
      ('По подразделению работа со скидками по соц проекту будет доступна с ' +
      FormatDateTime('dd mmmm yyyy', UnitConfigCDS.FieldByName('DateSP')
      .AsDateTime) + 'г.!');
    exit;
  End;

  if not UnitConfigCDS.FieldByName('StartTimeSP').IsNull and
    not UnitConfigCDS.FieldByName('EndTimeSP').IsNull then
  begin
    if (UnitConfigCDS.FieldByName('StartTimeSP').AsDateTime <>
      UnitConfigCDS.FieldByName('EndTimeSP').AsDateTime) and
      ((TimeOf(UnitConfigCDS.FieldByName('StartTimeSP').AsDateTime) > Time) or
      (TimeOf(UnitConfigCDS.FieldByName('EndTimeSP').AsDateTime) < Time)) then
    Begin
      ShowMessage
        ('По подразделению работа со скидками по соц проекту разрешена с ' +
        FormatDateTime('hh:nn:ss', UnitConfigCDS.FieldByName('StartTimeSP')
        .AsDateTime) + ' по ' + FormatDateTime('hh:nn:ss',
        UnitConfigCDS.FieldByName('EndTimeSP').AsDateTime) + ' !');
      exit;
    End;
  end;
  Result := True;
end;

procedure TMainCashForm2.actSetSPExecute(Sender: TObject);
var
  PartnerMedicalId, SPKindId, MemberSPID, I: Integer;
  PartnerMedicalName, MedicSP, Ambulance, InvNumberSP, SPKindName,
    MemberSP: String;
  OperDateSP: TDateTime;
  SPTax: Currency;
  HelsiID, HelsiIDList, HelsiName, HelsiProgramId, HelsiProgramName: string;
  HelsiQty: Currency;
  HelsiPartialPrescription : Boolean;
  HelsiSkipDispenseSign : Boolean;
  isPaperRecipeSP : Boolean;
  Res : TArray<string>;
begin

  if not CheckSP then
    exit;

  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage('Применен соц проект.'#13#10'Для повторного применения обнулите чек..');
    exit;
  end;

  if pnlHelsiError.Visible then
  begin
    ShowMessage('Обработайте непогашенный чек Хелси!');
    exit;
  end;

  if (not CheckCDS.isempty) and (Self.FormParams.ParamByName('InvNumberSP')
    .Value = '') or pnlManualDiscount.Visible or pnlPromoCode.Visible or
    pnlSiteDiscount.Visible then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;

  if pnlPromoCode.Visible or pnlPromoCodeLoyalty.Visible then
  begin
    ShowMessage('В текущем чеке применен промокод. Сначала очистите чек!');
    exit;
  end;

  //
  with TSPDialogForm.Create(nil) do
    try
      if UnitConfigCDS.FieldByName('PartnerMedicalID').IsNull then
      begin
        PartnerMedicalId := Self.FormParams.ParamByName
          ('PartnerMedicalId').Value;
        PartnerMedicalName := Self.FormParams.ParamByName
          ('PartnerMedicalName').Value;
      end
      else
      begin
        PartnerMedicalId := UnitConfigCDS.FieldByName('PartnerMedicalID')
          .AsInteger;
        PartnerMedicalName := UnitConfigCDS.FieldByName
          ('PartnerMedicalName').AsString;
      end;
      Ambulance := Self.FormParams.ParamByName('Ambulance').Value;
      MedicSP := Self.FormParams.ParamByName('MedicSP').Value;
      InvNumberSP := Self.FormParams.ParamByName('InvNumberSP').Value;
      SPTax := Self.FormParams.ParamByName('SPTax').Value;
      if UnitConfigCDS.FieldByName('SPKindId').IsNull then
      begin
        SPKindId := Self.FormParams.ParamByName('SPKindId').Value;
        SPKindName := Self.FormParams.ParamByName('SPKindName').Value;
        SPTax := Self.FormParams.ParamByName('SPTax').Value;
      end
      else
      begin
        SPKindId := UnitConfigCDS.FieldByName('SPKindId').AsInteger;
        SPKindName := UnitConfigCDS.FieldByName('SPKindName').AsString;
        SPTax := UnitConfigCDS.FieldByName('SPTax').AsInteger;
      end;
      MemberSPID := Self.FormParams.ParamByName('MemberSPID').Value;
      MemberSP := Self.FormParams.ParamByName('MemberSP').Value;
      HelsiID := Self.FormParams.ParamByName('HelsiID').Value;
      HelsiIDList := Self.FormParams.ParamByName('HelsiIDList').Value;
      HelsiName := Self.FormParams.ParamByName('HelsiName').Value;
      HelsiQty := Self.FormParams.ParamByName('HelsiQty').Value;
      HelsiProgramId := Self.FormParams.ParamByName('HelsiProgramId').Value;
      HelsiProgramName := Self.FormParams.ParamByName('HelsiProgramName').Value;
      isPaperRecipeSP := False;

      //
      if Self.FormParams.ParamByName('PartnerMedicalId').Value > 0 then
        OperDateSP := Self.FormParams.ParamByName('OperDateSP').Value
      else
        OperDateSP := Now;
      if not DiscountDialogExecute(PartnerMedicalId, SPKindId,
        PartnerMedicalName, Ambulance, MedicSP, InvNumberSP, SPKindName,
        OperDateSP, SPTax, MemberSPID, MemberSP, HelsiID, HelsiIDList,
        HelsiName, HelsiQty, HelsiProgramId, HelsiProgramName, HelsiPartialPrescription,
        HelsiSkipDispenseSign, isPaperRecipeSP) then
        exit;
    finally
      Free;
    end;
  //

  if (SPKindId = UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger) and (HelsiPartialPrescription = False) then
  begin
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Open;
      FLocalDataBaseHead.First;
      while not FLocalDataBaseHead.Eof do
      begin
        if Trim(FLocalDataBaseHead.FieldByName('INVNUMSP').AsString) = InvNumberSP
        then
        begin
          ShowMessage
            ('Ошибка.<Номер рецепта> уже использован. Повторное использование запрещено...');
          NewCheck(false);
          exit;
        end;
        FLocalDataBaseHead.Next;
      end;
    finally
      FLocalDataBaseHead.Close;
      ReleaseMutex(MutexDBF);
    end;

    if not gc_User.Local then
    begin
      spGet_Movement_InvNumberSP.ParamByName('inSPKindId').Value := SPKindId;
      spGet_Movement_InvNumberSP.ParamByName('inInvNumberSP').Value := InvNumberSP;
      if spGet_Movement_InvNumberSP.Execute = '' then
      begin
        if spGet_Movement_InvNumberSP.ParamByName('outIsExists').Value then
        begin
          ShowMessage
            ('Ошибка.<Номер рецепта> уже использован. Повторное использование запрещено...');
          NewCheck(false);
          exit;
        end;
      end
      else begin
        NewCheck(false);
        exit;
      end;
    end;
  end;

  if SPKindId = UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger then
  begin
    spAvailabilityCheckMedicalProgram.ParamByName('inSPKindId').Value := UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger;
    spAvailabilityCheckMedicalProgram.ParamByName('inProgramId').Value := HelsiProgramId;
    spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value := Null;
    spAvailabilityCheckMedicalProgram.Execute;
    if (isPaperRecipeSP = False) and
       ((spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value = Null) or
       (spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value = 0)) then
    begin
      ShowMessage('Медицынская программа <' + HelsiProgramName + '> не подключена для аптеки.');
      exit;
    end;
    FormParams.ParamByName('MedicalProgramSPId').Value := spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value;
  end;

  if SPKindId = 4823010 then
  begin
    if not UnitConfigCDS.FieldByName('isSP1303').AsBoolean then
    Begin
      ShowMessage('Подразделение не подключено для погашение рецептов по программе 1303.');
      Exit;
    End;

    if UnitConfigCDS.FieldByName('EndDateSP1303').AsDateTime < Date then
    Begin
      ShowMessage('Срок действия договора по программе 1303 закончился.');
      Exit;
    End;
  end;

  FormParams.ParamByName('PartnerMedicalId').Value := PartnerMedicalId;
  FormParams.ParamByName('PartnerMedicalName').Value := PartnerMedicalName;
  FormParams.ParamByName('Ambulance').Value := Ambulance;
  FormParams.ParamByName('MedicSP').Value := MedicSP;
  FormParams.ParamByName('InvNumberSP').Value := InvNumberSP;
  FormParams.ParamByName('OperDateSP').Value := OperDateSP;
  FormParams.ParamByName('SPTax').Value := SPTax;
  FormParams.ParamByName('SPKindId').Value := SPKindId;
  FormParams.ParamByName('SPKindName').Value := SPKindName;
  FormParams.ParamByName('MemberSPID').Value := MemberSPID;
  FormParams.ParamByName('MemberSP').Value := MemberSP;
  FormParams.ParamByName('RoundingDown').Value := True; // SPKindId = 4823009;
  FormParams.ParamByName('HelsiID').Value := HelsiID;
  FormParams.ParamByName('HelsiIDList').Value := HelsiIDList;
  FormParams.ParamByName('HelsiName').Value := HelsiName;
  FormParams.ParamByName('HelsiQty').Value := HelsiQty;
  FormParams.ParamByName('HelsiProgramId').Value := HelsiProgramId;
  FormParams.ParamByName('HelsiProgramName').Value := HelsiProgramName;
  FormParams.ParamByName('HelsiPartialPrescription').Value := HelsiPartialPrescription;
  FormParams.ParamByName('HelsiSkipDispenseSign').Value := HelsiSkipDispenseSign;
  FormParams.ParamByName('isPaperRecipeSP').Value := isPaperRecipeSP;

  //
  if FormParams.ParamByName('SPTax').Value <> 0 then
    lblSPKindName.Caption := '  ' + FloatToStr(FormParams.ParamByName('SPTax')
      .Value) + '% : ' + FormParams.ParamByName('SPKindName').Value
  else
    lblSPKindName.Caption := '  ' + FormParams.ParamByName('SPKindName').Value;
  pnlSP.Visible := InvNumberSP <> '';
  btnGoodsSPReceiptList.Visible := FormParams.ParamByName('HelsiIDList').Value <> '';
  if (FormParams.ParamByName('HelsiID').Value <> '') or (isPaperRecipeSP = true) then
  begin
    if FormParams.ParamByName('isPaperRecipeSP').Value = True then
    begin
      Label30.Caption := '       ФИО Врача: ';
      lblPartnerMedicalName.Caption := '  ' + FormParams.ParamByName('MedicSP').Value;
    end else
    begin
      Label30.Caption := '     Медикамент.: ';
      lblPartnerMedicalName.Caption := '  ' + HelsiName;
    end;
    Label7.Caption := 'Вып.';
    Label31.Caption := 'Программа.';
    lblMemberSP.Caption := '  ' + HelsiProgramName;

    // + '  /  № амб. ' + Ambulance;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      try
        if isPaperRecipeSP = True then
        begin
          RemainsCDS.Filter :=
            '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and (';
          RemainsCDS.Filter := RemainsCDS.Filter + 'IdSP <> '''')';
        end
        else if HelsiIDList <> '' then
        begin
          Res := TRegEx.Split(HelsiIDList, FormatSettings.ListSeparator);

          RemainsCDS.Filter :=
            '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and (';
          for I := 0 to High(Res) do
          begin
            if I = 0 then
              RemainsCDS.Filter := RemainsCDS.Filter + 'IdSP = ' +
                QuotedStr(Res[I])
            else
              RemainsCDS.Filter := RemainsCDS.Filter + ' or IdSP = ' +
                QuotedStr(Res[I]);
          end;
          RemainsCDS.Filter := RemainsCDS.Filter + ')'
        end else
          RemainsCDS.Filter :=
            '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and DosageIdSP = '
            + QuotedStr(HelsiID);

        if isPaperRecipeSP = False then
        begin

           if not HelsiPartialPrescription then
           begin
             RemainsCDS.Filter := RemainsCDS.Filter + ' and (CountSP <> CountSPMin and CountSPMin <= ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value) +
               ' or CountSP = CountSPMin';
             RemainsCDS.Filter := RemainsCDS.Filter + ' and (CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value) + ' or CountSP = '
              + CurrToStr(FormParams.ParamByName('HelsiQty').Value / 2) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 3) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
              .Value / 4) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 5) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 6) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
              .Value / 7) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 8) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 9) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
              .Value / 10) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 11) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 12) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 13) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 14) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 15) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 16) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 17) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 18) + ' or CountSP = ' +
              CurrToStr(FormParams.ParamByName('HelsiQty').Value / 19) +
              ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
              / 20) + '))';
           end else  RemainsCDS.Filter := RemainsCDS.Filter + ' and CountSPMin <= ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value);

        end;
        RemainsCDS.Filtered := True;
      except
        RemainsCDS.Filter :=
          'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
      end;
    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.EnableControls;
    end;
    lblMedicSP.Caption := CurrToStr(HelsiQty) + ' рец. №' + InvNumberSP + ' от '
      + DateToStr(OperDateSP);
  end
  else
  begin
    Label30.Caption := '     Мед.уч.: ';
    Label7.Caption := 'ФИО Врача:';
    Label31.Caption := 'ФИО Пациента:';

    lblPartnerMedicalName.Caption := '  ' + FormParams.ParamByName
      ('PartnerMedicalName').Value;
    // + '  /  № амб. ' + FormParams.ParamByName('Ambulance').Value;
    lblMedicSP.Caption := '  ' + FormParams.ParamByName('MedicSP').Value +
      '  /  № ' + FormParams.ParamByName('InvNumberSP').Value + ' от ' +
      DateToStr(FormParams.ParamByName('OperDateSP').Value);
    lblMemberSP.Caption := '  ' + FormParams.ParamByName('MemberSP').Value;
    pnlSP.Visible := FormParams.ParamByName('InvNumberSP').Value <> '';
    btnGoodsSPReceiptList.Visible := false;
  end;
end;

procedure TMainCashForm2.actSetSPHelsiExecute(Sender: TObject);
var
  InvNumberSP: String;
  OperDateSP: TDateTime;
  HelsiID, HelsiIDList, HelsiName, ProgramId, ProgramName: string;
  HelsiQty: Currency; PartialPrescription, HelsiSkipDispenseSign : Boolean;
  Res: TArray<string>;
  I, UserId: Integer;
  Key_expireDate : TDateTime;
begin

  if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1 then
  begin
    if UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger = 0 then
    Begin
      ShowMessage('Не определен ID СП !');
      exit;
    End;
  end else if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 2 then
  begin
    if UnitConfigCDS.FieldByName('LikiDneproeHealthToken').AsString = '' then
    Begin
      ShowMessage('Не определен ID СП !');
      exit;
    End;
  end;

  if pnlHelsiError.Visible then
  begin
    ShowMessage('Обработайте непогашенный чек Хелси!');
    exit;
  end;

  if pnlPromoCode.Visible or pnlPromoCodeLoyalty.Visible then
  begin
    ShowMessage('В текущем чеке применен промокод. Сначала очистите чек!');
    exit;
  end;

  if not CheckSP then
    exit;

  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage('Применен соц проект.'#13#10'Для повторного применения обнулите чек..');
    exit;
  end;

  if not CheckCDS.isempty or pnlManualDiscount.Visible or
    pnlPromoCode.Visible or pnlSiteDiscount.Visible then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;

  InvNumberSP := '';
  if not InputEnterRecipeNumber(InvNumberSP) then
    exit;

  try

    if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1 then
    begin
      if not GetHelsiReceipt(InvNumberSP, HelsiID, HelsiIDList, HelsiName, HelsiQty,
        OperDateSP, ProgramId, ProgramName, PartialPrescription, HelsiSkipDispenseSign) then
      begin
        NewCheck(false);
        exit;
      end;
    end else if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 2 then
    begin
      if not GetLikiDniproeHealthReceipt(InvNumberSP, HelsiID, HelsiIDList, HelsiName, HelsiQty,
        OperDateSP) then
      begin
        NewCheck(false);
        exit;
      end;
    end;

  finally

    if not gc_User.Local and (FUpdateKey_expireDate = False) and GetKey_expireDate(UserId, Key_expireDate) then
    begin
      try
        spUpdate_User_KeyExpireDate.ParamByName('inID').Value := UserId;
        spUpdate_User_KeyExpireDate.ParamByName('inKeyExpireDate').Value := Key_expireDate;
        spUpdate_User_KeyExpireDate.Execute;
        FUpdateKey_expireDate := True;
      except
      end;
    end;
  end;

  if PartialPrescription = False then
  begin
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Open;
      FLocalDataBaseHead.First;
      while not FLocalDataBaseHead.Eof do
      begin
        if Trim(FLocalDataBaseHead.FieldByName('INVNUMSP').AsString) = InvNumberSP
        then
        begin
          ShowMessage
            ('Ошибка.<Номер рецепта> уже использован. Повторное использование запрещено...');
          NewCheck(false);
          exit;
        end;
        FLocalDataBaseHead.Next;
      end;
    finally
      FLocalDataBaseHead.Close;
      ReleaseMutex(MutexDBF);
    end;

    if not gc_User.Local then
    begin
      spGet_Movement_InvNumberSP.ParamByName('inSPKindId').Value := UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger;
      spGet_Movement_InvNumberSP.ParamByName('inInvNumberSP').Value := InvNumberSP;
      if spGet_Movement_InvNumberSP.Execute = '' then
      begin
        if spGet_Movement_InvNumberSP.ParamByName('outIsExists').Value then
        begin
          ShowMessage
            ('Ошибка.<Номер рецепта> уже использован. Повторное использование запрещено...');
          NewCheck(false);
          exit;
        end;
      end
      else begin
        NewCheck(false);
        exit;
      end;
    end;
  end;

  spAvailabilityCheckMedicalProgram.ParamByName('inSPKindId').Value := UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger;
  spAvailabilityCheckMedicalProgram.ParamByName('inProgramId').Value := ProgramId;
  spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value := Null;
  spAvailabilityCheckMedicalProgram.Execute;
  if (spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value = Null) or
     (spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value = 0) then
  begin
    ShowMessage('Медицинская программа <' + ProgramName + '> не подключена для аптеки.');
    exit;
  end;
  FormParams.ParamByName('MedicalProgramSPId').Value := spAvailabilityCheckMedicalProgram.ParamByName('outMedicalProgramSPID').Value;

  FormParams.ParamByName('InvNumberSP').Value := InvNumberSP;
  FormParams.ParamByName('OperDateSP').Value := OperDateSP;
  FormParams.ParamByName('SPKindId').Value :=
    UnitConfigCDS.FieldByName('Helsi_IdSP').AsInteger;
  FormParams.ParamByName('SPKindName').Value := 'Доступні Ліки';
  FormParams.ParamByName('RoundingDown').Value := True;
  FormParams.ParamByName('HelsiID').Value := HelsiID;
  FormParams.ParamByName('HelsiIDList').Value := HelsiIDList;
  FormParams.ParamByName('HelsiName').Value := HelsiName;
  FormParams.ParamByName('HelsiQty').Value := HelsiQty;
  FormParams.ParamByName('HelsiProgramId').Value := ProgramId;
  FormParams.ParamByName('HelsiProgramName').Value := ProgramName;
  FormParams.ParamByName('HelsiPartialPrescription').Value := PartialPrescription;
  FormParams.ParamByName('HelsiSkipDispenseSign').Value := HelsiSkipDispenseSign;

  //
  if FormParams.ParamByName('SPTax').Value <> 0 then
    lblSPKindName.Caption := '  ' + FloatToStr(FormParams.ParamByName('SPTax')
      .Value) + '% : ' + FormParams.ParamByName('SPKindName').Value
  else
    lblSPKindName.Caption := '  ' + FormParams.ParamByName('SPKindName').Value;
  pnlSP.Visible := InvNumberSP <> '';
  btnGoodsSPReceiptList.Visible := FormParams.ParamByName('HelsiIDList').Value <> '';
  if FormParams.ParamByName('HelsiID').Value <> '' then
  begin
    Label30.Caption := '     Медикамент.: ';
    Label7.Caption := 'Вып.';
    Label31.Caption := 'Программа.';
    lblPartnerMedicalName.Caption := '  ' + HelsiName;
    lblMemberSP.Caption := ' ' + ProgramName;
    // + '  /  № амб. ' + Ambulance;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      try
        if HelsiIDList <> '' then
        begin
          Res := TRegEx.Split(HelsiIDList, FormatSettings.ListSeparator);
          RemainsCDS.Filter :=
            '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and (';
          for I := 0 to High(Res) do
          begin
            if I = 0 then
              RemainsCDS.Filter := RemainsCDS.Filter + 'IdSP = ' +
                QuotedStr(Res[I])
            else
              RemainsCDS.Filter := RemainsCDS.Filter + ' or IdSP = ' +
                QuotedStr(Res[I]);
          end;
          RemainsCDS.Filter := RemainsCDS.Filter + ')'
        end
        else
          RemainsCDS.Filter :=
            '(Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0) and DosageIdSP = '
            + QuotedStr(HelsiID);

        if not PartialPrescription then
        begin

          RemainsCDS.Filter := RemainsCDS.Filter + ' and (CountSP <> CountSPMin and CountSPMin <= ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value) +
             ' or CountSP = CountSPMin';
          RemainsCDS.Filter := RemainsCDS.Filter + ' and (CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value) + ' or CountSP = '
                    + CurrToStr(FormParams.ParamByName('HelsiQty').Value / 2) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 3) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
                    .Value / 4) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 5) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 6) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
                    .Value / 7) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 8) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 9) + ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty')
                    .Value / 10) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 11) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 12) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 13) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 14) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 15) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 16) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 17) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 18) + ' or CountSP = ' +
                    CurrToStr(FormParams.ParamByName('HelsiQty').Value / 19) +
                    ' or CountSP = ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value
                    / 20) + '))';
        end else RemainsCDS.Filter := RemainsCDS.Filter + ' and CountSPMin <= ' + CurrToStr(FormParams.ParamByName('HelsiQty').Value);

        RemainsCDS.Filtered := True;
      except
        RemainsCDS.Filter :=
          'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
      end;
    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.EnableControls;
    end;
    lblMedicSP.Caption := CurrToStr(HelsiQty) + '  рец. № ' + InvNumberSP +
      '  от ' + DateToStr(OperDateSP);
  end
  else
  begin
    Label30.Caption := '     Мед.уч.: ';
    Label7.Caption := 'ФИО Врача:';
  end;
end;

procedure TMainCashForm2.actSetVIPExecute(Sender: TObject);
var
  ManagerID: Integer;
  ManagerName, BayerName: String;
  ConfirmedKindName_calc: String;
  UID: String;
begin
  // ShowMessage('actSetVIPExecute');
  if CheckCDS.isempty then
  Begin
    ShowMessage('Текущий чек пустой!');
    exit;
  End;
  if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage('Чек по СП в VIP оправлять запрещено!.');
    exit;
  end;

  if FormParams.ParamByName('isAutoVIPforSales').Value = FALSE then
  begin

    if not VIPDialogExecute(ManagerID, ManagerName, BayerName) then
      exit;
    //
    FormParams.ParamByName('ManagerId').Value := ManagerID;
    FormParams.ParamByName('ManagerName').Value := ManagerName;
    FormParams.ParamByName('BayerName').Value := BayerName;
    if FormParams.ParamByName('ConfirmedKindName').Value = '' then
      FormParams.ParamByName('ConfirmedKindName').Value := 'подтвержден';
    ConfirmedKindName_calc := FormParams.ParamByName('ConfirmedKindName').Value;
  end else if MessageDlg('Сохранить ВИП чек для резерва под продажи?', mtConfirmation, mbYesNo, 0) <> mrYes then exit;

  //
  if SaveLocal(CheckCDS, ManagerID, ManagerName, BayerName
    // ***16.08.16
    , FormParams.ParamByName('BayerPhone').Value, ConfirmedKindName_calc,
    FormParams.ParamByName('InvNumberOrder').Value,
    FormParams.ParamByName('ConfirmedKindClientName').Value
    // ***20.07.16
    , FormParams.ParamByName('DiscountExternalId').Value,
    FormParams.ParamByName('DiscountExternalName').Value,
    FormParams.ParamByName('DiscountCardNumber').Value
    // ***08.04.17
    , FormParams.ParamByName('PartnerMedicalId').Value,
    FormParams.ParamByName('PartnerMedicalName').Value,
    FormParams.ParamByName('Ambulance').Value, FormParams.ParamByName('MedicSP')
    .Value, FormParams.ParamByName('InvNumberSP').Value,
    FormParams.ParamByName('OperDateSP').Value
    // ***15.06.17
    , FormParams.ParamByName('SPKindId').Value,
    FormParams.ParamByName('SPKindName').Value,
    FormParams.ParamByName('SPTax').Value
    // ***05.02.18
    , FormParams.ParamByName('PromoCodeID').Value
    // ***27.06.18
    , FormParams.ParamByName('ManualDiscount').Value
    // ***02.11.18
    , FormParams.ParamByName('SummPayAdd').Value
    // ***14.01.19
    , FormParams.ParamByName('MemberSPID').Value
    // ***20.02.19
    , FormParams.ParamByName('BankPOSTerminal').Value
    // ***25.02.19
    , FormParams.ParamByName('JackdawsChecksCode').Value
    // ***14.01.19
    , FormParams.ParamByName('SiteDiscount').Value
    // ***02.04.19
    , FormParams.ParamByName('RoundingDown').Value
    // ***13.05.19
    , FormParams.ParamByName('PartionDateKindId').Value
    , FormParams.ParamByName('ConfirmationCodeSP').Value
    // ***07.11.19
    , FormParams.ParamByName('LoyaltySignID').Value
    // ***08.01.20
    , FormParams.ParamByName('LoyaltySMID').Value
    , FormParams.ParamByName('LoyaltySMSumma').Value
    // ***16.08.20
    , FormParams.ParamByName('DivisionPartiesID').Value
    , FormParams.ParamByName('DivisionPartiesName').Value
    // ***11.10.20
    , FormParams.ParamByName('MedicForSale').Value
    , FormParams.ParamByName('BuyerForSale').Value
    , FormParams.ParamByName('BuyerForSalePhone').Value
    , FormParams.ParamByName('DistributionPromoList').Value
    // ***05.03.21
    , FormParams.ParamByName('MedicKashtanId').Value
    , FormParams.ParamByName('MemberKashtanId').Value
    // ***19.03.21
    , FormParams.ParamByName('isCorrectMarketing').Value
    , FormParams.ParamByName('isCorrectIlliquidAssets').Value
    , FormParams.ParamByName('isDoctors').Value
    , FormParams.ParamByName('isDiscountCommit').Value
    // ***04.10.21
    , FormParams.ParamByName('MedicalProgramSPId').Value
    , FormParams.ParamByName('isManual').Value
    , FormParams.ParamByName('Category1303Id').Value

    , false // NeedComplete
    , False // isErrorRRO
    , FormParams.ParamByName('isPaperRecipeSP').Value
    , 0 // ZReport
    , '' // FiscalCheckNumber
    , FormParams.ParamByName('CheckId').Value // Id чека
    , UID // out AUID
    ) then
  begin
    if FormParams.ParamByName('CheckId').Value <> 0 then UpdateRemainsFromVIPCheck(False, True);
    NewCheck(false);
  End;
end;

procedure TMainCashForm2.actShowListDiffExecute(Sender: TObject);
begin
  inherited;
  if not fileExists(ListDiff_lcl) then
  begin
    ShowMessage('Данных для просмотра нет...');
    exit;
  end;

  with TListDiffForm.Create(nil) do
    try
      ShowModal
    finally
      Free;
    end;
end;

procedure TMainCashForm2.actSoldExecute(Sender: TObject);
begin
  SoldRegim := not SoldRegim;
  edAmount.Enabled := false;
  edAmount.Text := '';
  lcName.Text := '';
  if isScaner = True then
    ActiveControl := ceScaner
  else
    ActiveControl := lcName;
end;

procedure TMainCashForm2.actSpecCorrExecute(Sender: TObject);
begin
  if actSpec.Checked then
    actSpec.Checked := false;
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  if actSpecCorr.Checked then
    FormParams.ParamByName('JackdawsChecksCode').Value := 2
  else
    FormParams.ParamByName('JackdawsChecksCode').Value := 0;
end;

procedure TMainCashForm2.actSpecExecute(Sender: TObject);
begin
  if actSpecCorr.Checked then
    actSpecCorr.Checked := false;
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  if actSpec.Checked then
    FormParams.ParamByName('JackdawsChecksCode').Value := 1
  else
    FormParams.ParamByName('JackdawsChecksCode').Value := 0;
end;

procedure TMainCashForm2.actStartExamExecute(Sender: TObject);
begin
  ShowTestingUser;
end;

procedure TMainCashForm2.actTechnicalRediscountExecute(Sender: TObject);
begin
  spGet_Movement_TechnicalRediscount_Id.ParamByName('outMovementId').Value := 0;
  spGet_Movement_TechnicalRediscount_Id.Execute;
  if spGet_Movement_TechnicalRediscount_Id.ParamByName('outMovementId').Value <> 0
  then
  begin
    actTechnicalRediscountCurr.GuiParams.ParamByName('Id').Value :=
      spGet_Movement_TechnicalRediscount_Id.ParamByName('outMovementId').Value;
    actTechnicalRediscountCurr.Execute;
  end
  else
    ShowMessage
      ('Активный документ технической инвентаризации не найден.'#13#10'Попробуйте позже.');
end;

procedure TMainCashForm2.actDoctorsExecute(Sender: TObject);
begin
  //
end;

procedure TMainCashForm2.actDoesNotShareExecute(Sender: TObject);
begin
  if not RemainsCDS.Active then
    exit;
  if RemainsCDS.RecordCount < 1 then
    exit;

  try
    if gc_User.Local then
    begin
      if RemainsCDS.FieldByName('DoesNotShare').AsBoolean then
      begin
        if MessageDlg
          ('В автономно режиме снять признак блокировки деления медикамента можно только на время текущего сеанса.'#13#10#13#10
          + 'Снять признак блокировки деления медикамента"'#13#10 +
          RemainsCDS.FieldByName('GoodsName').AsString +
          #13#10' на время сеанса?', mtConfirmation, mbYesNo, 0) <> mrYes then
          exit;
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('DoesNotShare').AsBoolean := false;
        RemainsCDS.Post;
      end
      else
        ShowMessage('В автономно режиме установка признака невозможно.');
      exit;
    end;

    if RemainsCDS.FieldByName('DoesNotShare').AsBoolean then
    begin
      if MessageDlg('Снять с медикамента'#13#10 + RemainsCDS.FieldByName
        ('GoodsName').AsString +
        #13#10'признак блокировки деления медикамента?', mtConfirmation,
        mbYesNo, 0) <> mrYes then
        exit;

      spDoesNotShare.ParamByName('inDoesNotShare').Value := false;
      spDoesNotShare.Execute;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('DoesNotShare').AsBoolean := false;
      RemainsCDS.Post;

    end
    else
    begin
      if MessageDlg('Установить на медикамент'#13#10 + RemainsCDS.FieldByName
        ('GoodsName').AsString +
        #13#10'признак блокировки деления медикамента?', mtConfirmation,
        mbYesNo, 0) <> mrYes then
        exit;

      spDoesNotShare.ParamByName('inDoesNotShare').Value := True;
      spDoesNotShare.Execute;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('DoesNotShare').AsBoolean := True;
      RemainsCDS.Post;

    end;
  except
    ON E: Exception do
    begin
      Add_Log('Error set DoesNotShare = ' + E.Message);
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TMainCashForm2.actDownloadFarmacyExecute(Sender: TObject);
var Path : string;
begin
  Path := ExpandFileName('..\..\Project\Bin\');

  if not TDirectory.Exists(Path) then
  begin
    ShowMessage('Проверьте путь ' + Path + 'Farmacy.exe.');
    Exit;
  end;

  TUpdater.AutomaticDownloadFarmacy(Path);
end;

procedure TMainCashForm2.actUpdateProgramExecute(Sender: TObject);
var LocalVersionInfo, BaseVersionInfo: TVersionInfo; Step : Integer;

  function ProcessExists(exeFileName: string): Boolean;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
  begin
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    Result := false;
    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
        = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
        = UpperCase(exeFileName))) then
      begin
        Result := True;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle);
  end;

  begin
  if not gc_User.Local then
  Begin

    // Проверка тестовой версии программы
    try
      Application.ProcessMessages;
      if NeedTestProgram then
      begin
        if (MessageDlg('Обнаружена тестовая версия программы! Обновить?', mtInformation, mbOKCancel, 0) = mrOk) then
        begin
          PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 9); // только 2 форма
          Step := 0;
          while ProcessExists('FarmacyCashServise.exe') do
          begin
            Sleep(2000);
            Inc(Step);
            if Step > 5 then
            begin
              ShowMessage('Ошибка закрытия сервиса.'#13#10'Попробуйте через 5 минут.');
              Exit;
            end;
          end;
          InitCashSession(False);
          if TUpdater.AutomaticUpdateProgramTestStart then
          begin
            UpdateTestProgram;
            Application.Terminate
          end;
        end;
        Exit;
      end;
    except
      on E: Exception do
         ShowMessage('Не работает автоматическое обновление.'#13#10'Обратитесь к разработчику ' + E.Message);
    end;

    // Проверка новой версии программы
    try
      Application.ProcessMessages;
      BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)),
                         GetBinaryPlatfotmSuffics(ParamStr(0), ''));
      LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
      if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
         ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
      begin
        if (MessageDlg('Обнаружена новая версия программы! Обновить', mtInformation, mbOKCancel, 0) = mrOk) then
        begin
          if not UpdateOption then Exit;
          PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 9); // только 2 форма
          Step := 0;
          while ProcessExists('FarmacyCashServise.exe') do
          begin
            Sleep(2000);
            Inc(Step);
            if Step > 5 then
            begin
              ShowMessage('Ошибка закрытия сервиса.'#13#10'Попробуйте через 5 минут.');
              Exit;
            end;
          end;
          InitCashSession(False);
          TUpdater.AutomaticUpdateProgramStart;
        end;
      end else ShowMessage('Обновление на данный момент отстутствует...');
    except
      on E: Exception do
         ShowMessage('Не работает автоматическое обновление.'#13#10'Обратитесь к разработчику ' + E.Message);
    end;

  End;
end;

procedure TMainCashForm2.actUpdateRemainsExecute(Sender: TObject);
begin
  exit;
  UpdateRemainsFromDiff(nil);
end;

procedure TMainCashForm2.actUser_expireDateExecute(Sender: TObject);
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
  Key_expireDate : TDateTime;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Object_HelsiUserKey';
        sp.Execute(False,False);

        with TGaugeFactory.GetGauge('Проверить срок действия по всем файловым ключам', 0, ds.RecordCount) do
        begin
          Start;
          try
            ds.First;
            while not ds.Eof do
            begin
              if (ds.FieldByName('Base64Key').AsString <> '') and (ds.FieldByName('KeyPassword').AsString <> '') then
                if GetKey_User_expireDate(ds.FieldByName('Base64Key').AsString, ds.FieldByName('KeyPassword').AsString , Key_expireDate) then
              begin
                spUpdate_User_KeyExpireDate.ParamByName('inID').Value := ds.FieldByName('Id').AsInteger;
                spUpdate_User_KeyExpireDate.ParamByName('inKeyExpireDate').Value := Key_expireDate;
                spUpdate_User_KeyExpireDate.Execute;
              end;
              ds.Next;
              IncProgress(1);
            end;
          finally
            Finish;
          end;
        end;

      Except ON E:Exception do
      end;
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.actWagesUserExecute(Sender: TObject);
var
  cPasswordWages, S: string;

  function GetPasswordWages: string;
  var
    dsdPasswordWages: TdsdStoredProc;
  begin
    dsdPasswordWages := TdsdStoredProc.Create(nil);
    try
      dsdPasswordWages.StoredProcName := 'gpGet_User_PasswordWages';
      dsdPasswordWages.OutputType := otResult;
      dsdPasswordWages.Params.Clear;
      dsdPasswordWages.Params.AddParam('outPasswordWages', ftString,
        ptOutput, Null);
      dsdPasswordWages.Execute(false, false);
      Result := dsdPasswordWages.ParamByName('outPasswordWages').AsString;
    finally
      freeAndNil(dsdPasswordWages);
    end;
  end;

begin
  if gc_User.Local then
  Begin
    ShowMessage('В отложенном режиме не работает...');
    exit;
  End;

  cPasswordWages := GetPasswordWages;

  if cPasswordWages <> '' then
  begin
    if not InputQuery('Ввод пароля', #31'Пароль для просмотра з.п.: ', S) then
      exit;
    if cPasswordWages <> S then
    begin
      ShowMessage('Пароль введен неверно...');
      exit;
    end;
  end;

  actOpenWagesUser.Execute;
end;

procedure TMainCashForm2.btnCheckClick(Sender: TObject);
var
  APoint: TPoint;
begin
  if gc_User.Local then
  Begin
    ShowMessage('В отложенном режиме не работает...');
    exit;
  End;
  APoint := btnCheck.ClientToScreen(Point(0, btnCheck.ClientHeight));
  pm_OpenCheck.Popup(APoint.X, APoint.Y);
end;

procedure TMainCashForm2.btnGoodsSPReceiptListClick(Sender: TObject);
begin
  //
  actGoodsSPReceiptList.GuiParams.ParamByName('MedicalProgramSPId').Value := FormParams.ParamByName('MedicalProgramSPId').Value;
  actGoodsSPReceiptList.GuiParams.ParamByName('Medication_ID_List').Value :=
    StringReplace(FormParams.ParamByName('HelsiIDList').Value, FormatSettings.ListSeparator, ',', [rfReplaceAll]);
  actGoodsSPReceiptList.Execute;
end;

procedure TMainCashForm2.cbMorionFilterPropertiesChange(Sender: TObject);
begin
  inherited;
  if cbMorionFilter.Checked = False then
  begin
    RemainsCDS.Filtered := False;
    RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
    RemainsCDS.Filtered := True;
  end else SetMorionCodeFilter;
end;

procedure TMainCashForm2.ceAmountExit(Sender: TObject);
begin
  edAmount.Enabled := false;
  edAmount.Text := '';
  lcName.Text := '';
end;

procedure TMainCashForm2.ceScanerKeyPress(Sender: TObject; var Key: Char);
const
  zc_BarCodePref_Object: String = '201al00';
  zc_BarCodePref_XanthisCare: String = '21016';
var
  isFind: Boolean;
  Key2: Word;
  str_add, str_old: String;
  nID: Integer;
begin
  isFind := false;
  isScaner := True;
  //
  if Key = #13 then
  begin
    // ЭТО карта Ксантис Забота
    if zc_BarCodePref_XanthisCare = Copy(ceScaner.Text, 1, Length(zc_BarCodePref_XanthisCare)) then
    begin
      if Length(ceScaner.Text) <> 13 then
      begin
        ShowMessage ('Ошибка. Длина штрихкода должна быть 13 символов.');
      end else SetDiscountExternal(16, ceScaner.Text);
      Exit;
    end;

    RemainsCDS.AfterScroll := nil;
    RemainsCDS.DisableControls;
    try
      // ЭТО Ш/К - ПРОИЗВОДИТЕЛЯ
      if zc_BarCodePref_Object <> Copy(ceScaner.Text, 1,
        Length(zc_BarCodePref_Object)) then
      begin

        // потом покажем
        str_add := '(произв)';

        str_old := RemainsCDS.Filter;
        nID := RemainsCDS.FieldByName('ID').AsInteger;
        RemainsCDS.Filtered := false;
        try
          try
            if str_old <> '' then
              RemainsCDS.Filter := '(' + str_old + ')';
            RemainsCDS.Filter := RemainsCDS.Filter + ' and BarCode like ''%' +
              Trim(ceScaner.Text) + '%''';
            RemainsCDS.Filtered := True;
            RemainsCDS.First;
            // проверили что равно...
            isFind := Pos(Trim(ceScaner.Text), RemainsCDS.FieldByName('BarCode')
              .AsString) > 0;
            if isFind then
              nID := RemainsCDS.FieldByName('ID').AsInteger;
          except
          end;
        finally
          RemainsCDS.Filtered := false;
          RemainsCDS.Filter := str_old;
          RemainsCDS.Filtered := True;
          RemainsCDS.Locate('ID', nID, []);
        end;
      end

      // ЭТО Ш/К - НАШ ID
      else
      begin
        // потом покажем
        str_add := '(НАШ)';

        // Сначала определим наш ID
        StrToInt(Copy(ceScaner.Text, 4, 9));
        // нашли
        isFind := RemainsCDS.Locate('GoodsId_main',
          StrToInt(Copy(ceScaner.Text, 4, 9)), []);
        // еще проверили что равно...
        isFind := (isFind) and (RemainsCDS.FieldByName('GoodsId_main')
          .AsInteger = StrToInt(Copy(ceScaner.Text, 4, 9)));

        // если не нашли - попробуем по всей строке - зачем ?
        if not isFind then
        begin
          isFind := RemainsCDS.Locate('BarCode', Trim(ceScaner.Text), []);
          // еще проверили что равно...
          isFind := (isFind) and
            (Trim(RemainsCDS.FieldByName('BarCode').AsString)
            = Trim(ceScaner.Text));
        end;
      end;

      //
      if isFind then
        lbScaner.Caption := 'найдено ' + str_add + ' ' + ceScaner.Text
      else
        lbScaner.Caption := 'не найдено ' + str_add + ' ' + ceScaner.Text;

      // всегда очистим
      ceScaner.Text := '';

    except
      lbScaner.Caption := 'Ошибка в Ш/К';
    end;
    //
    RemainsCDS.EnableControls;

  end;

  if isFind = True then
  begin
    isScaner := True;
    //
    lcName.Text := RemainsCDS.FieldByName('GoodsName').AsString;
    Key2 := VK_RETURN;
    lcNameKeyDown(Self, Key2, []);
  end;

end;

procedure TMainCashForm2.ceVIPLoadExit(Sender: TObject);
  var cResult: String;
begin

  if ceVIPLoad.Text = '' then Exit;

  if not CheckCDS.isempty then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;

  if (DiscountServiceForm.gCode <> 0) then
  begin
    ShowMessage('Применен дисконт.'#13#10'Открытие отложенных чеков запрещено.'#13#10'Если надо применить дисконт сначало загрузите чек потом примените дисконтную программу.');
    exit;
  end;

  spGetVIPOrder.ParamByName('inVIPOrder').Value := ceVIPLoad.Text;
  spGetVIPOrder.ParamByName('outisMoreThanOne').Value := False;
  spGetVIPOrder.ParamByName('outVIPOrder').Value := '';
  spGetVIPOrder.Execute;

  if spGetVIPOrder.ParamByName('outisMoreThanOne').Value = True then
  begin
    actCheckSelectionOrder.GuiParams.ParamByName('VIPOrder').Value := ceVIPLoad.Text;
    if not actCheckSelectionOrder.Execute then Exit;
    ceVIPLoad.Text := actCheckSelectionOrder.GuiParams.ParamByName('TextValue').Value;
  end else ceVIPLoad.Text := spGetVIPOrder.ParamByName('outVIPOrder').Value;

  spisCheckCombine.ParamByName('inVIPOrder').Value := ceVIPLoad.Text;
  spisCheckCombine.ParamByName('outIsCheckCombine').Value := False;
  spisCheckCombine.ParamByName('outText').Value := '';
  spisCheckCombine.ParamByName('outBayer').Value := '';
  spisCheckCombine.Execute;

  if spisCheckCombine.ParamByName('outIsCheckCombine').Value then
  begin
    if ShowPUSHMessageCash('У покупателя: ' + spisCheckCombine.ParamByName('outBayer').Value + #13#10#13#10 +
                           'Есть отложенные чеки: ' + spisCheckCombine.ParamByName('outText').Value + #13#10#13#10 +
                           'Объединить чеки в один?', cResult) then
    begin
      actCheckCombine.GuiParams.ParamByName('VIPOrder').Value := ceVIPLoad.Text;
      if not actCheckCombine.Execute then
      begin
        ceVIPLoad.Text := '';
        Exit;
      end;
    end;
  end;

  spSelectChechHead.ParamByName('inVIPOrder').Value :=  ceVIPLoad.Text;
  ceVIPLoad.Text := '';
  if actLoadVIPOrder.Execute and ((FormParams.ParamByName('CheckId').Value <> 0)
    or (FormParams.ParamByName('ManagerName').AsString <> '')) then
    LoadVIPCheck;
end;

procedure TMainCashForm2.ceVIPLoadKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_RETURN:
        PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
      VK_ESCAPE:
        begin
          ceVIPLoad.Text := '';
          PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
        end;
    end;
end;

procedure TMainCashForm2.actCheckConnectionExecute(Sender: TObject);
begin
  try
    spGet_User_IsAdmin.Execute;
    gc_User.Local := false;
    if FShowMessageCheckConnection then
      ShowMessage('Режим работы: В сети');
  except
    Begin
      gc_User.Local := True;
      if FShowMessageCheckConnection then
        ShowMessage('Режим работы: Автономно');
    End;
  end;
end;

procedure TMainCashForm2.CheckCDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if DataSet.FieldByName('List_UID').AsString = '' then
    DataSet.FieldByName('List_UID').AsString := GenerateGUID;
  if CheckCDS.FieldByName('PartionDateKindId').AsVariant = 0 then
  begin
    CheckCDS.FieldByName('PartionDateKindId').AsVariant := Null;
    CheckCDS.FieldByName('PartionDateKindName').AsVariant := Null;
    CheckCDS.FieldByName('PricePartionDate').AsVariant := Null;
  end;
  if CheckCDS.FieldByName('DiscountExternalID').AsVariant = 0 then
  begin
    CheckCDS.FieldByName('DiscountExternalID').AsVariant := Null;
    CheckCDS.FieldByName('DiscountExternalName').AsVariant := Null;
  end;
  if CheckCDS.FieldByName('DivisionPartiesID').AsVariant = 0 then
  begin
    CheckCDS.FieldByName('DivisionPartiesID').AsVariant := Null;
    CheckCDS.FieldByName('DivisionPartiesName').AsVariant := Null;
  end;
end;

procedure TMainCashForm2.CheckGridColNameStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if (ARecord.Values[CheckGridColSummChangePercent.Index] <> Null) and (ARecord.Values[CheckGridColSummChangePercent.Index] <> 0) then
    FStyle.Color := TColor($FFD784);
  AStyle := FStyle;
end;

procedure TMainCashForm2.CheckGridDBTableViewFocusedRecordChanged
  (Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord
  : TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;

  if CheckGrid.IsFocused then
  begin
    if not CheckCDS.isempty then
    begin
      edAmount.Style.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleDisabled.Color := CheckCDS.FieldByName('Color_calc')
        .AsInteger;
      edAmount.StyleFocused.Color := CheckCDS.FieldByName('Color_calc')
        .AsInteger;
      edAmount.StyleHot.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
    end
    else
    begin
      edAmount.Style.Color := clWhite;
      edAmount.StyleDisabled.Color := clBtnFace;
      edAmount.StyleFocused.Color := clWhite;
      edAmount.StyleHot.Color := clWhite;
    end;
  end;

end;

procedure TMainCashForm2.Color_IPEGetCellHint(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; ACellViewInfo: TcxGridTableDataCellViewInfo;
  const AMousePos: TPoint; var AHintText: TCaption;
  var AIsHintMultiLine: Boolean; var AHintTextRect: TRect);
begin
  if not PlanEmployeeCDS.Active then Exit;

  if ARecord.Values[Sender.Index] > 0 then
  begin
    if PlanEmployeeCDS.Locate('GoodsCode', ARecord.Values[MainColCode.Index], []) then
    begin
      if PlanEmployeeCDS.FieldByName('AmountPlan').AsCurrency > 0 then
        AHintText := 'Для выполнения мин. плана - ' + PlanEmployeeCDS.FieldByName('AmountPlan').AsString + #13#10
      else AHintText := 'Мин. план выполнен' + #13#10;
      if PlanEmployeeCDS.FieldByName('AmountPlanAward').AsCurrency > 0 then
        AHintText := AHintText + 'Для выполнения плана для премии - ' + PlanEmployeeCDS.FieldByName('AmountPlanAward').AsString
      else AHintText := AHintText + 'План для премии выполнен';
      AIsHintMultiLine := False;
    end;
  end;
end;

procedure TMainCashForm2.ConnectionModeChange(var Msg: TMessage);
begin
  SetWorkMode(gc_User.Local);
end;

procedure TMainCashForm2.cxButton4Click(Sender: TObject);
begin
  if MessageDlg('Отменить обработку непогашенного чека Хелси?', mtConfirmation,
    mbYesNo, 0) <> mrYes then
    exit;
  pnlHelsiError.Visible := false;
  edHelsiError.Text := '';
end;

procedure TMainCashForm2.cxButton5Click(Sender: TObject);
begin
  if GetStateReceipt then
  begin
    ShowMessage('Рецепт погашен...');
    pnlHelsiError.Visible := false;
    edHelsiError.Text := '';
  end
  else
    ShowMessage('Рецепт не погашен...');
end;

procedure TMainCashForm2.cxButton6Click(Sender: TObject);
var
  HelsiError: Boolean;
begin
  if UnitConfigCDS.FieldByName('eHealthApi').AsInteger = 1 then
  begin
    HelsiError := True;
    if CreateNewDispense then
    begin
      HelsiError := not SetPayment;
      if not HelsiError then
        HelsiError := not IntegrationClientSign;
      if not HelsiError then
        HelsiError := not ProcessSignedDispense;
    end;

    if HelsiError then
      RejectDispense;
    if HelsiError then
      cxButton5Click(Sender);
  end;
end;

procedure TMainCashForm2.cxButton7Click(Sender: TObject);
var
  Id: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
begin
  if Assigned(RemainsCDS.OnFilterRecord) or pnlAnalogFilter.Visible then
  begin
    Id := RemainsCDS.FieldByName('Id').AsInteger;
    PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
    NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
    DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
    DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      RemainsCDS.OnFilterRecord := Nil;
      pnlAnalogFilter.Visible := false;
    finally
      RemainsCDS.Filtered := True;
      if not RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([Id, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []) then
        RemainsCDS.Locate('Id', Id, []);
      RemainsCDS.EnableControls;
      edAnalogFilter.Text := '';
    end;
  end;
end;

procedure TMainCashForm2.cxButton8Click(Sender: TObject);
begin
  SetPromoCodeLoyaltySM(0, '', '', 0, 0);
end;

function TMainCashForm2.SetMorionCodeFilter : boolean;
  var S, S1, cResult : string; I : Integer; Res, ResQ: TArray<string>;
begin
  cbMorionFilter.Properties.OnChange := Nil;
  try
    if LikiDniproReceiptApi.PositionCDS.FieldByName('id_morion').AsString <> '' then
    begin
      Res := TRegEx.Split(LikiDniproReceiptApi.PositionCDS.FieldByName('id_morion').AsString, ',');
      ResQ := TRegEx.Split(LikiDniproReceiptApi.PositionCDS.FieldByName('qpack_int').AsString, ',');
      S := ''; S1 := '';
      for I := 0 to High(Res) do
      begin
        if I = 0 then
          S := S + 'MorionCode = ' + Res[I]
        else S := S + ' or MorionCode = ' + Res[I];
        S1 := #13'Код мориона: ' + Res[I] + ' в упаковке ' +  ResQ[I];
      end;

      RemainsCDS.DisableControls;
      try
        RemainsCDS.Filtered := False;
        RemainsCDS.Filter := 'Remains <> 0 and (' + S + ')';
        RemainsCDS.Filtered := True;
      finally
//        if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
//        begin
//          if RemainsCDS.RecordCount = 0 then
//          begin
//            ShowPUSHMessageCash('Рецепт не может быть отпущен! Обратитесь к Ирине Колеуш для работы с кодом Мориона.'#13#13 +
//              'Чеке номер: ' + LikiDniproReceiptApi.Recipe.FRecipe_Number + #13 +
//              'В чеке товар: ' + LikiDniproReceiptApi.PositionCDS.FieldByName('position').AsString + #13 + S1, cResult);
//            NewCheck;
//          end;
//        end else if LikiDniproReceiptApi.Recipe.FRecipe_Type = 3 then
//        begin
          if RemainsCDS.RecordCount = 0 then
          begin
            RemainsCDS.Filtered := False;
            RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0 or DeferredTR <> 0';
            RemainsCDS.Filtered := True;
            cbMorionFilter.Enabled := False;
            cbMorionFilter.Checked := False;
          end else
          begin
            cbMorionFilter.Enabled := True;
            cbMorionFilter.Checked := True;
          end;
//        end;
        RemainsCDS.EnableControls;
      end;
    end else
    begin
      cbMorionFilter.Enabled := False;
      cbMorionFilter.Checked := False;
    end;
  finally
    cbMorionFilter.Properties.OnChange := cbMorionFilterPropertiesChange;
  end;
end;

procedure TMainCashForm2.bbPositionNextClick(Sender: TObject);
begin
  inherited;
  cbMorionFilter.Properties.OnChange := Nil;
  try
//    if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
//    begin
//      cbMorionFilter.Enabled := True;
//      cbMorionFilter.Checked := True;
//      cbMorionFilter.Enabled := False;
//    end else
//    begin
      cbMorionFilter.Enabled := True;
      if cbMorionFilter.Checked then cbMorionFilter.Checked := False;
//    end;
  finally
    cbMorionFilter.Properties.OnChange := cbMorionFilterPropertiesChange;
  end;

  if not pnlPosition.Visible then
  begin
    pnlPosition.Visible := True;
    LikiDniproReceiptApi.PositionCDS.First;
  end else
  begin
    LikiDniproReceiptApi.PositionCDS.Next;
    if LikiDniproReceiptApi.PositionCDS.Eof then
    begin
      pnlPosition.Visible := False;
      Exit;
    end;
  end;

  cmPosition.Text := LikiDniproReceiptApi.PositionCDS.FieldByName('position').AsString;
  edName_inn_ua.Text := LikiDniproReceiptApi.PositionCDS.FieldByName('name_inn_ua').AsString;
  edName_reg_ua.Text := LikiDniproReceiptApi.PositionCDS.FieldByName('name_reg_ua').AsString;
  edCommentPosition.Text := LikiDniproReceiptApi.PositionCDS.FieldByName('comment').AsString +
                            '. Выписано: ' + LikiDniproReceiptApi.PositionCDS.FieldByName('drugs_need_bought').AsString +
                            IfThen(LikiDniproReceiptApi.PositionCDS.FieldByName('doctor_recommended_manufacturer').AsString = '', '',
                            '. Рек. произв. ' + LikiDniproReceiptApi.PositionCDS.FieldByName('doctor_recommended_manufacturer').AsString);

  SetMorionCodeFilter;
  if cbMorionFilter.Checked = True then cbMorionFilter.Checked := False;

end;

procedure TMainCashForm2.edAmountExit(Sender: TObject);
begin
  edAmount.Enabled := false;
  edAmount.Text := '';
  lcName.Text := '';
end;

procedure TMainCashForm2.edAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm2.edAmountKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '/', FormatSettings.DecimalSeparator, #8]) or
    CharInSet(Key, ['/', FormatSettings.DecimalSeparator]) and
    ((Pos(FormatSettings.DecimalSeparator, edAmount.Text) > 0) and
    (Pos(FormatSettings.DecimalSeparator, edAmount.SelText) = 0) or
    (Pos('/', edAmount.Text) > 0)) or (Key = '-') and (edAmount.SelStart <> 0)
    or (Pos(FormatSettings.DecimalSeparator, edAmount.Text) > 0) and
    CharInSet(Key, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and
    (edAmount.SelStart >= Pos(FormatSettings.DecimalSeparator, edAmount.Text))
    and ((Length(edAmount.Text) - Pos(FormatSettings.DecimalSeparator,
    edAmount.Text)) >= 3) then
    Key := #0;
end;

procedure TMainCashForm2.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
Var
  I, j: Integer;
  Res1, Res2: TArray<string>;
begin
  Accept := false;
  if Trim(FOldAnalogFilter) = '' then
    exit;
  case FAnalogFilter of
    1:
      if DataSet.FieldByName('GoodsAnalog').AsString = '' then
        exit;
    2:
      if DataSet.FieldByName('GoodsAnalogATC').AsString = '' then
        exit;
    3:
      if DataSet.FieldByName('GoodsActiveSubstance').AsString = '' then
        exit;
  else
    exit;
  end;

  Res1 := TRegEx.Split(StringReplace(Trim(FOldAnalogFilter), '  ', '',
    [rfReplaceAll]), ' ');
  case FAnalogFilter of
    1:
      Res2 := TRegEx.Split(DataSet.FieldByName('GoodsAnalog').AsString, #13#10);
    2:
      Res2 := TRegEx.Split(DataSet.FieldByName('GoodsAnalogATC')
        .AsString, #13#10);
    3:
      Res2 := TRegEx.Split(DataSet.FieldByName('GoodsActiveSubstance')
        .AsString, #13#10);
  end;

  for I := 0 to High(Res1) do
    for j := 0 to High(Res2) do
      if Pos(AnsiUpperCase(Res1[I]), AnsiUpperCase(Res2[j])) > 0 then
      begin
        Accept := True;
        exit;
      end;
end;

procedure TMainCashForm2.edAnalogFilterExit(Sender: TObject);
begin
  TimerAnalogFilter.Enabled := false;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := false;
  RemainsCDS.DisableControls;
  try
    RemainsCDS.Filtered := false;
    RemainsCDS.OnFilterRecord := Nil;
    if FOldAnalogFilter <> '' then
    begin
      RemainsCDS.OnFilterRecord := FilterRecord;
    end;
    RemainsCDS.First;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.EnableControls
  end;
end;

procedure TMainCashForm2.edAnalogFilterPropertiesChange(Sender: TObject);
begin
  if Trim(edAnalogFilter.Text) = FOldAnalogFilter then
    exit;
  FOldAnalogFilter := Trim(edAnalogFilter.Text);
  TimerAnalogFilter.Enabled := false;
  TimerAnalogFilter.Interval := 100;
  TimerAnalogFilter.Enabled := True;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := True;
end;

procedure TMainCashForm2.edLoyaltySMSummaExit(Sender: TObject);
begin
  if edLoyaltySMSumma.Value < 0 then
  begin
    ShowMessage('Сумма скидки должна быть больше нуля!');
    edLoyaltySMSumma.Value := 0;
  end
  else if edLoyaltySMSummaRemainder.Value < edLoyaltySMSumma.Value then
  begin
    ShowMessage('Сумма скидки должна меньше или равна накопленной сумме!');
    edLoyaltySMSumma.Value := 0;
  end;

  FormParams.ParamByName('LoyaltySMSumma').Value := edLoyaltySMSumma.Value;
  PromoCodeLoyaltyCalc;
  CalcTotalSumm;
end;

procedure TMainCashForm2.miMCSAutoClick(Sender: TObject);
begin
  if RemainsCDS.State in dsEditModes then
    RemainsCDS.Post;
  //
  edDays.Value := 7;
  PanelMCSAuto.Visible := not PanelMCSAuto.Visible;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName
    ('MCSValue').Index].Options.Editing := PanelMCSAuto.Visible;
end;

procedure TMainCashForm2.miPrintNotFiscalCheckClick(Sender: TObject);
var
  CheckNumber: string; ZReport: Integer;
begin
  PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd,
    MainCashForm.PaidType, ZReport, FFiscalNumber, CheckNumber, 0, false);
end;

procedure TMainCashForm2.mmSaveToExcelClick(Sender: TObject);
begin
  inherited;
  SaveExcelDialog.FileName := 'Список товаров.xls';
  if not SaveExcelDialog.Execute then
    exit;
  try
    if not pnlExpirationDateFilter.Visible then
      RemainsCDS.Filtered := false;
    ExportGridToExcel(SaveExcelDialog.FileName, MainGrid);
  finally
    RemainsCDS.Filtered := True;
  end;
end;

procedure TMainCashForm2.FormCreate(Sender: TObject);
var
  F: String;
begin
  inherited;
  FStyle := TcxStyle.Create(nil);
  FormClassName := Self.ClassName;

  MoveLogFile;

  Application.OnMessage := AppMsgHandler; // только 2 форма
  // мемдата для сохранения отгруженных чеков во время получение полных остатков
  FSaveCheckToMemData := false;
  FShowMessageCheckConnection := True;
  mdCheck.Active := True;
  edAmount.Enabled := False;
  edAmount.Text := '';
  isScaner := false;
  difUpdate := True;
  FPUSHStart := True;
  FUpdatePUSH := 0;
  fPrint := False;
  FStepSecond := False;
  FError_Blink := 0;
  FBuyerForSite := '';
  //
  edDays.Value := 7;
  PanelMCSAuto.Visible := false;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName
    ('MCSValue').Index].Options.Editing := false;
  // для
  // создаем мутексы если не созданы
  InitMutex;

  DiscountServiceForm := TDiscountServiceForm.Create(Self);

  // сгенерили гуид для определения сессии
  ChangeStatus('Установка первоначальных параметров');
  // CashSessionId только в службе
  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDGet;
  FormParams.ParamByName('ZReportName').Value := StringReplace(iniLocalUnitNameGet, '/', ',', [rfReplaceAll]);
  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('OperDate').Value := Date;
  ShapeState.Brush.Color := clGreen;
  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;
  ChangeStatus('Загрузка профиля пользователя');

  if gc_User.Local then
    UserSettingsStorageAddOn.LoadUserSettingsData
      (GetLocalMainFormData(gc_User.Session))
  else
    UserSettingsStorageAddOn.LoadUserSettings;

  // Временно переместим план в начало грида
  Color_IPE.Index := 0;

  try
    ChangeStatus('Инициализация оборудования');
    Cash := TCashFactory.GetCash(iniCashType);

    if (Cash <> nil) AND (Cash.FiscalNumber = '') AND (iniCashType = 'FP320')
    then
    Begin
      MessageDlg
        ('Ошибка инициализации кассового аппарата. Дальнейшая работа программы невозможна.'
        + #13#10 + 'Для кассового апарата типа "DATECS FP-320" ' + #13#10 +
        'необходимо внести его серийный номер в файл настроек' + #13#10 +
        '(Секция [TSoldWithCompMainForm] параметр "FP320SERIAL")', mtError,
        [mbOK], 0);

      Application.Terminate;
      exit;
    End;

  except
    Begin
      ShowMessage
        ('Внимание! Программа не может подключиться к фискальному аппарату.' +
        #13 + 'Дальнейшая работа программы возможна только в нефискальном режиме!');
    End;
  end;

  if (Cash <> nil) and (Cash.FiscalNumber <> '') then
  begin
    iniLocalCashRegisterSave(Cash.FiscalNumber);
  end;

  // а2 начало -  только 2 форма
  ChangeStatus('Удаление файла остатков');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  try
    if fileExists(iniLocalDataBaseDiff) then
      DeleteFile(iniLocalDataBaseDiff);
  finally
    ReleaseMutex(MutexDBFDiff);
  end;
  // а2 конец -  только 2 форма
  ChangeStatus('Инициализация локального хранилища');
  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;

  SetWorkMode(gc_User.Local);

  SoldParallel := iniSoldParallel;
  CheckCDS.CreateDataSet;
  ChangeStatus('Подготовка нового чека');
  try
    NewCheck;
  except
  end;
  OnCLoseQuery := ParentFormCloseQuery;
  OnShow := ParentFormShow;

  EmployeeWorkLog_LogIn;
  SetBlinkVIP(True);
  SetBlinkCheck(True);
  SetBanCash(True);
  TimerBlinkBtn.Enabled := True;
  FNeedFullRemains := True;
  TimerServiceRun.Enabled := True;
  FOldAnalogFilter := '';
  FAnalogFilter := 0;
  FUpdateKey_expireDate := False;
  FTextError := '';

  isLog_RRO := iniLog_RRO;

  LoadGoodsExpirationDate;
  LoadBankPOSTerminal;
  LoadUnitConfig;
  LoadTaxUnitNight;
  SetTaxUnitNight;
  SetMainFormCaption;

  if (Cash <> nil) and UnitConfigCDS.FieldByName('isSetDateRRO').AsBoolean then
  begin
    if Abs(MinutesBetween(Cash.GetTime, Now)) > 2 then Cash.SetTime;
  end;
end;

function TMainCashForm2.InitLocalStorage: Boolean;
begin
  Result := false;

  WaitForSingleObject(MutexDBF, INFINITE);
  WaitForSingleObject(MutexDBFDiff, INFINITE);

  try
    Result := InitLocalDataBaseHead(Self, FLocalDataBaseHead) and
      InitLocalDataBaseBody(Self, FLocalDataBaseBody) and
      InitLocalDataBaseDiff(Self, FLocalDataBaseDiff);

    if Result then
    begin
      FLocalDataBaseHead.Active := false;
      FLocalDataBaseBody.Active := false;
      FLocalDataBaseDiff.Active := false;
    end;
  finally
    ReleaseMutex(MutexDBF);
    ReleaseMutex(MutexDBFDiff);
  end;
end;

function TMainCashForm2.CheckShareFromPrice(Amount, Price: Currency;
  GoodsCode: Integer; GoodsName: string): Boolean;
var
  Res: TArray<string>;
  I: Integer;
begin
  Result := True;
  if Self.FormParams.ParamByName('SPKindId').Value = 4823010 then
    exit;
  if UnitConfigCDS.FieldByName('ShareFromPrice').asCurrency <= 0 then
    exit;
  if Price >= UnitConfigCDS.FieldByName('ShareFromPrice').asCurrency then
    exit;
  if frac(Amount) = 0 then
    exit;

  if Assigned(SourceClientDataSet.FindField('Remains')) then
  begin
    if frac(SourceClientDataSet.FindField('Remains').AsCurrency - Amount) = 0 then exit;
  end else
  begin
    if frac(SourceClientDataSet.FindField('Amount').AsCurrency - Amount) = 0 then exit;
  end;


  // Исключения по вхождению
  if UnitConfigCDS.FieldByName('ShareFromPriceName').AsString <> '' then
  begin
    Res := TRegEx.Split(UnitConfigCDS.FieldByName('ShareFromPriceName')
      .AsString, ';');
    for I := 0 to High(Res) do
      if Res[I] <> '' then
      begin
        if Res[I][1] = '%' then
        begin
          if Pos(AnsiLowerCase(Copy(Res[I], 2, Length(Res[I]) - 1)),
            AnsiLowerCase(GoodsName)) > 0 then
            exit;
        end
        else if Pos(AnsiLowerCase(Res[I]), AnsiLowerCase(GoodsName)) = 1 then
          exit;
      end;
  end;

  // Исключения по коду
  if UnitConfigCDS.FieldByName('ShareFromPriceCode').AsString <> '' then
  begin
    Res := TRegEx.Split(UnitConfigCDS.FieldByName('ShareFromPriceCode')
      .AsString, ';');
    for I := 0 to High(Res) do
      if Res[I] = IntToStr(GoodsCode) then
        exit;
  end;

  ShowMessage('Деление медикамента c ценой менее ' + UnitConfigCDS.FieldByName
    ('ShareFromPrice').AsString + ' грн. заблокировано!');
  Result := false;
end;

function GoodsToJSON(AId : Integer; AAmount : Currency; APartionDateKindId, ANdsKindId, ADivisionPartiesId : Variant) : String;
  var JsonArray: TJSONArray;
      JSONObject: TJSONObject;

  procedure AddParamToJSON(AName: string; AValue: Variant; ADataType: TFieldType);
    var intValue: integer; n : Double;
  begin
    try
      if AValue = NULL then
        JSONObject.AddPair(LowerCase(AName), TJSONNull.Create)
      else if ADataType = ftDateTime then
        JSONObject.AddPair(LowerCase(AName), FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue))
      else if ADataType = ftFloat then
      begin
        if TryStrToFloat(AValue, n) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(n))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end else if ADataType = ftInteger then
      begin
        if TryStrToInt(AValue, intValue) then
          JSONObject.AddPair(LowerCase(AName), TJSONNumber.Create(intValue))
        else
          JSONObject.AddPair(LowerCase(AName), TJSONNull.Create);
      end
      else
        JSONObject.AddPair(LowerCase(AName), TJSONString.Create(AValue));
    except
      on E:Exception do raise Exception.Create('Ошибка добавления <' + AName + '> в Json: ' + e.Message);
    end;
  end;

  begin
    JSONArray := TJSONArray.Create();
    try

      JSONObject := TJSONObject.Create;
      AddParamToJSON('GoodsId', AId, ftInteger);
      AddParamToJSON('Amount', AAmount, ftFloat);
      AddParamToJSON('PartionDateKindId', APartionDateKindId, ftInteger);
      AddParamToJSON('NdsKindId', ANdsKindId, ftInteger);
      AddParamToJSON('DivisionPartiesId', ADivisionPartiesId, ftInteger);
      JsonArray.AddElement(JSONObject);
      Result := JSONArray.ToString;
    finally
      JSONArray.Free;
    end;
end;

procedure TMainCashForm2.InsertUpdateBillCheckItems(AJuridicalId : Integer = 0; AJuridicalName : String = '');
var
  lQuantity, lPrice, lPriceSale, lChangePercent, lSummChangePercent,
    nAmount, nAmountPS, nAmountPSJ, nAmountPSM, nAmountM, nGoodsPairSunAmount, nRemains, nAmountPut: Currency;
  lMsg: String; bOk, bBadJuridical : boolean;
  lGoodsId_bySoldRegim, lTypeDiscount, nRecNo, nId, nGoodsPairSunMainId,
  nJuridicalId, nJuridicalPSId : Integer;
  nMultiplicity: Currency;
  nFixEndDate: Variant;
  Bookmark : TBookmark;
  cFilterOld, cJuridicalName, cJuridicalPSName, cResult : String;
  ChoosingPairSunForm : TChoosingPairSunForm;
begin

  // Ночные скидки
  SetTaxUnitNight;
  nMultiplicity := 0;
  lTypeDiscount := 0;
  nFixEndDate := Null;
  nJuridicalId := AJuridicalId;
  cJuridicalName := AJuridicalName;

  if pnlHelsiError.Visible then
  begin
    ShowMessage('Обработайте непогашенный чек Хелси!');
    exit;
  end;

  if FormParams.ParamByName('isCorrectMarketing').Value then
  begin
    ShowMessage('Чек по корректировки суммы маркетинга в ЗП по сотруднику редактировать запрещено!');
    exit;
  end;

  if FormParams.ParamByName('isCorrectIlliquidAssets').Value then
  begin
    ShowMessage('Чек по корректировки суммы нелеквидов в ЗП по сотруднику редактировать запрещено!');
    exit;
  end;

  nAmount := GetAmount;
  if nAmount = 0 then
    exit;
  if not Assigned(SourceClientDataSet) then
    SourceClientDataSet := RemainsCDS;

  if (nAmount > 0) and (FormParams.ParamByName('isAutoVIPforSales').Value = TRUE) and
     not SourceClientDataSet.FieldByName('isVIPforSales').AsBoolean  then
  begin
    ShowMessage('Ошибка. Товар запрещен для вставки в ВИП чек для резерва под продажи.');
    exit;
  end;

  if SoldRegim AND (nAmount > 0) and
    (nAmount > SourceClientDataSet.FieldByName('Remains').asCurrency) then
  begin
    ShowMessage('Не хватает количества для продажи!');
    exit;
  end;
  if not SoldRegim AND (nAmount < 0) and
    (abs(nAmount) > abs(CheckCDS.FieldByName('Amount').asCurrency)) then
  begin
    ShowMessage('Не хватает количества для возврата!');
    exit;
  end;
  if ((nAmount > 0) and SourceClientDataSet.FieldByName('DoesNotShare')
    .AsBoolean or (nAmount < 0) and CheckCDS.FieldByName('DoesNotShare')
    .AsBoolean) and (nAmount <> Round(nAmount)) then
  begin
    ShowMessage('Деление медикамента заблокировано!');
    exit;
  end;

  if (Frac(nAmount) <> 0) and (DiscountServiceForm.gCode <> 0) then
  begin
    ShowMessage('Деление медикамента для дисконтных программ запрещено!');
    exit;
  end;

  if (SourceClientDataSet.FieldByName('MultiplicitySale').AsCurrency > 0) and (Frac(nAmount) <> 0) then
  begin
    nAmountM := Abs(nAmount) / SourceClientDataSet.FieldByName('MultiplicitySale').AsCurrency;
    nAmountM := Frac(nAmountM);

    if (nAmountM <> 0) then
    begin
      if (nAmount > 0) then
      begin
        if not SourceClientDataSet.FieldByName('isMultiplicityError').AsBoolean or (Frac(SourceClientDataSet.FieldByName('Remains').AsCurrency - nAmount) <> 0) then
        begin
          ShowMessage('Деление медикамента разрешено кратно ' + SourceClientDataSet.FieldByName('MultiplicitySale').AsString + ' !');
          exit;
        end;
      end else if (nAmount < 0) then
      begin
        if not SourceClientDataSet.FieldByName('isMultiplicityError').AsBoolean or (Frac(SourceClientDataSet.FieldByName('Amount').AsCurrency - nAmount) <> 0) then
        begin
          ShowMessage('Деление медикамента разрешено кратно ' + SourceClientDataSet.FieldByName('MultiplicitySale').AsString + ' !');
          exit;
        end;
      end;
    end;
  end;

  if Assigned(SourceClientDataSet.FindField('GoodsId')) then
    nId := SourceClientDataSet.FieldByName('GoodsId').AsInteger
  else nId := SourceClientDataSet.FieldByName('Id').AsInteger;
  nGoodsPairSunMainId := SourceClientDataSet.FieldByName('GoodsPairSunMainId').AsInteger;
  nGoodsPairSunAmount := SourceClientDataSet.FieldByName('GoodsPairSunAmount').AsInteger;

  if (nGoodsPairSunAmount > 1)  then
  begin

    Bookmark := CheckCDS.GetBookmark;
    try
      // Собираем сколько уже есть
      nAmountPS := 0;
      if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([nId,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) then
      begin
        nAmountPS := nAmountPS + checkCDS.FieldByName('Amount').AsCurrency;
      end;
    finally
      CheckCDS.GotoBookmark(Bookmark);
    end;

    // проверяем наличие по поставщику
    if not gc_User.Local then
    begin
      spCheck_PairSunAmount.ParamByName('inGoodsId').Value := nId;
      spCheck_PairSunAmount.ParamByName('inNDSKindId').Value := SourceClientDataSet.FieldByName('NDSKindId').AsVariant;
      spCheck_PairSunAmount.ParamByName('inPartionDateKindId').Value := SourceClientDataSet.FieldByName('PartionDateKindId').AsVariant;
      spCheck_PairSunAmount.ParamByName('inDivisionPartiesId').Value := SourceClientDataSet.FieldByName('DivisionPartiesId').AsVariant;
      spCheck_PairSunAmount.ParamByName('inAmount').Value := nAmountPS + nAmount;
      spCheck_PairSunAmount.ParamByName('outAmount').Value := 0;
      spCheck_PairSunAmount.ParamByName('outJuridicalId').Value := 0;
      spCheck_PairSunAmount.ParamByName('outJuridicalName').Value := '';
      spCheck_PairSunAmount.Execute;
      nJuridicalId := spCheck_PairSunAmount.ParamByName('outJuridicalId').Value;
      cJuridicalName := spCheck_PairSunAmount.ParamByName('outJuridicalName').Value;
    end;

    // Правим привязку к поставщику
    if nAmount < 0 then
    try
      if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([nId,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) and
          (CheckCDS.FieldByName('JuridicalId').AsInteger <> nJuridicalId) then
      begin
        CheckCDS.Edit;
        if nJuridicalId = 0 then
        begin
          CheckCDS.FieldByName('JuridicalId').AsVariant := Null;
          CheckCDS.FieldByName('JuridicalName').AsVariant := Null;
        end else
        begin
          CheckCDS.FieldByName('JuridicalId').AsVariant := nJuridicalId;
          CheckCDS.FieldByName('JuridicalName').AsVariant := cJuridicalName;
        end;
        CheckCDS.Post;
      end;
    finally
      CheckCDS.GotoBookmark(Bookmark);
    end;

  end else if not FStepSecond and SourceClientDataSet.FieldByName('isGoodsPairSun').AsBoolean then
  begin

    Bookmark := CheckCDS.GetBookmark;
    try
      nAmountPS := 0;
      if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([nId,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) and
          (CheckCDS.FieldByName('JuridicalId').AsInteger <> 0) then
      begin
        nJuridicalId := CheckCDS.FieldByName('JuridicalId').AsVariant;
        cJuridicalName := CheckCDS.FieldByName('JuridicalName').AsVariant;
        nAmountPS := nAmountPS + checkCDS.FieldByName('Amount').AsCurrency;
      end;
    finally
      CheckCDS.GotoBookmark(Bookmark);
    end;

    if nJuridicalId <> 0 then
    begin

      // проверяем наличие по поставщику
      if not gc_User.Local then
      begin
        spCheck_PairSunAmount.ParamByName('inGoodsId').Value := nId;
        spCheck_PairSunAmount.ParamByName('inNDSKindId').Value := SourceClientDataSet.FieldByName('NDSKindId').AsVariant;
        spCheck_PairSunAmount.ParamByName('inPartionDateKindId').Value := SourceClientDataSet.FieldByName('PartionDateKindId').AsVariant;
        spCheck_PairSunAmount.ParamByName('inDivisionPartiesId').Value := SourceClientDataSet.FieldByName('DivisionPartiesId').AsVariant;
        spCheck_PairSunAmount.ParamByName('inAmount').Value := nAmountPS + nAmount;
        spCheck_PairSunAmount.ParamByName('outAmount').Value := 0;
        spCheck_PairSunAmount.ParamByName('outJuridicalId').Value := 0;
        spCheck_PairSunAmount.ParamByName('outJuridicalName').Value := '';
        spCheck_PairSunAmount.Execute;
        if spCheck_PairSunAmount.ParamByName('outJuridicalId').Value <> nJuridicalId then
        begin
          ShowMessage('Нет товара в наличии по поставщику ' + cJuridicalName + ' попробуйте распределить от основного товара!');
          Exit;
        end;
      end;

    end;
  end else if FStepSecond and SourceClientDataSet.FieldByName('isGoodsPairSun').AsBoolean then
  begin

    Bookmark := CheckCDS.GetBookmark;
    try
      nAmountPS := 0;
      if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([nId,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) and
          (CheckCDS.FieldByName('JuridicalId').AsInteger <> nJuridicalId) then
      begin
        CheckCDS.Edit;
        if nJuridicalId = 0 then
        begin
          CheckCDS.FieldByName('JuridicalId').AsVariant := Null;
          CheckCDS.FieldByName('JuridicalName').AsVariant := Null;
        end else
        begin
          CheckCDS.FieldByName('JuridicalId').AsVariant := nJuridicalId;
          CheckCDS.FieldByName('JuridicalName').AsVariant := cJuridicalName;
        end;
        CheckCDS.Post;
      end;
    finally
      CheckCDS.GotoBookmark(Bookmark);
    end;
  end;

//  if (nAmount > 0) and SourceClientDataSet.FieldByName('isPresent').AsBoolean and
//    (FormParams.ParamByName('LoyaltyGoodsId').Value <> nId) then
//  begin
//    ShowMessage('Подарки можно продавать только по акции!');
//    exit;
//  end;

  try
    if not FStepSecond and SourceClientDataSet.FieldByName('isGoodsPairSun').AsBoolean then
    begin
      // Только целое количество
      if (Round(nAmount) <> nAmount) then
      begin
        ShowMessage('Товар по соц.проекту должен продаваться целыми упаковками...');
        exit;
      end;
      Bookmark := CheckCDS.GetBookmark;
      nAmountPS := 0;
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if checkCDS.FieldByName('GoodsPairSunMainId').AsInteger = nId then
          nAmountPS := nAmountPS + checkCDS.FieldByName('Amount').AsCurrency * checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency;
        if checkCDS.FieldByName('GoodsId').AsInteger = nId then
          nAmountPS := nAmountPS - checkCDS.FieldByName('Amount').AsCurrency;
        CheckCDS.Next;
      end;
      CheckCDS.GotoBookmark(Bookmark);

      // Проверим наличие парного
      if nAmount > 0 then
      begin
        if (nAmount - nAmountPS) > 0 then
        begin
          cFilterOld := RemainsCDS.Filter;
          RemainsCDS.DisableControls;
          RemainsCDS.Filtered := False;
          RemainsCDS.Filter := 'Remains > 1 and GoodsPairSunMainId = ' + IntToStr(nId);
          RemainsCDS.Filtered := True;
          RemainsCDS.First;
          nAmountM := nAmount;
          ChoosingPairSunForm := TChoosingPairSunForm.Create(Self);
          try
            bOk := False;
            nAmount := nAmount - nAmountPS;
            while not RemainsCDS.Eof do
            begin
              if (RemainsCDS.FieldByName('Remains').AsCurrency >= nAmount / RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency)
                 and (Frac(nAmount / RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency) = 0)
                 and ((RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency = 1) or
                      not gc_User.Local and (RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency > 1)) then
              begin

                if RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency > 1 then
                begin
                  spCheck_PairSunAmount.ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').AsInteger;
                  spCheck_PairSunAmount.ParamByName('inNDSKindId').Value := RemainsCDS.FieldByName('NDSKindId').AsVariant;
                  spCheck_PairSunAmount.ParamByName('inPartionDateKindId').Value := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
                  spCheck_PairSunAmount.ParamByName('inDivisionPartiesId').Value := RemainsCDS.FieldByName('DivisionPartiesId').AsVariant;
                  spCheck_PairSunAmount.ParamByName('inAmount').Value := nAmount / RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency;
                  spCheck_PairSunAmount.ParamByName('outAmount').Value := 0;
                  spCheck_PairSunAmount.ParamByName('outJuridicalId').Value := 0;
                  spCheck_PairSunAmount.Execute;
                  if spCheck_PairSunAmount.ParamByName('outJuridicalId').Value > 0 then
                    ChoosingPairSunForm.ChoosingPairSunCDS.AppendRecord(
                               [RemainsCDS.FieldByName('Id').AsInteger,
                                RemainsCDS.FindField('GoodsCode').AsVariant,
                                RemainsCDS.FindField('GoodsName').AsVariant,
                                RemainsCDS.FindField('Remains').AsVariant,
                                nAmount / RemainsCDS.FieldByName('GoodsPairSunAmount').AsCurrency,
                                RemainsCDS.FindField('Price').AsVariant,
                                RemainsCDS.FindField('PartionDateKindId').AsVariant,
                                RemainsCDS.FindField('NDSKindId').AsVariant,
                                RemainsCDS.FindField('DiscountExternalID').AsVariant,
                                RemainsCDS.FindField('DivisionPartiesID').AsVariant]);
                end else
                    ChoosingPairSunForm.ChoosingPairSunCDS.AppendRecord(
                               [RemainsCDS.FieldByName('Id').AsInteger,
                                RemainsCDS.FindField('GoodsCode').AsVariant,
                                RemainsCDS.FindField('GoodsName').AsVariant,
                                RemainsCDS.FindField('Remains').AsVariant,
                                nAmount,
                                RemainsCDS.FindField('Price').AsVariant,
                                RemainsCDS.FindField('PartionDateKindId').AsVariant,
                                RemainsCDS.FindField('NDSKindId').AsVariant,
                                RemainsCDS.FindField('DiscountExternalID').AsVariant,
                                RemainsCDS.FindField('DivisionPartiesID').AsVariant]);
              end;
              RemainsCDS.Next;
            end;

            if ChoosingPairSunForm.ChoosingPairSunCDS.RecordCount > 0 then
            begin

              if ChoosingPairSunForm.ChoosingPairSunCDS.RecordCount > 1 then
              begin
                if ChoosingPairSunForm.ShowModal <> mrOk then Exit;
              end;

              if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                    VarArrayOf([ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('Id').AsInteger,
                                ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('PartionDateKindId').AsVariant,
                                ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('NDSKindId').AsVariant,
                                ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('DiscountExternalID').AsVariant,
                                ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
              begin
                try
                  FStepSecond := True;
                  if CheckCDS = SourceClientDataSet then CheckCDS.Locate('GoodsId', nId, []);
                  edAmount.Text := CurrToStr(ChoosingPairSunForm.ChoosingPairSunCDS.FieldByName('Amount').AsCurrency);
                  InsertUpdateBillCheckItems;
                  bOk := True;
                finally
                  FStepSecond := False;
                end;
              end;
            end;

            if not bOk then
            begin
              if nAmountPS < nAmount then
              begin
                ShowMessage('Парного товара к товару по соц.проекту не хватает или найден...');
                exit;
              end;
            end;

          finally
            ChoosingPairSunForm.Free;
            RemainsCDS.Filtered := False;
            RemainsCDS.Filter := cFilterOld;
            RemainsCDS.Filtered := True;
            RemainsCDS.EnableControls;
            CheckCDS.GotoBookmark(Bookmark);
            nAmount := nAmountM;
          end;
        end;
      end else if nAmount < 0 then
      begin
        nAmountPS := nAmountPS;
        SourceClientDataSet.DisableControls;
        CheckCDS.DisableControls;
        try
          if CheckCDS.Locate('GoodsPairSunMainId', nId, []) then
          begin
            if Frac(nAmountPS + nAmount / checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency) <> 0 then
            begin
              ShowMessage('Нарушиться кратности парного товара попробуйте другое количество...');
              exit;
            end;

            if (nAmount / checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency + checkCDS.FieldByName('Amount').AsCurrency) < 0 then
              edAmount.Text := CurrToStr(- checkCDS.FieldByName('Amount').AsCurrency)
            else edAmount.Text := CurrToStr(nAmount / checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency);

            try
              FStepSecond := True;
              InsertUpdateBillCheckItems;
            finally
              FStepSecond := False;
            end;
          end;
        finally
          CheckCDS.EnableControls;
          SourceClientDataSet.EnableControls;
          CheckCDS.GotoBookmark(Bookmark);
        end;
      end;
    end;

    if not CheckShareFromPrice(nAmount,
      SourceClientDataSet.FieldByName('Price').asCurrency,
      SourceClientDataSet.FieldByName('GoodsCode').AsInteger,
      SourceClientDataSet.FieldByName('GoodsName').AsString) then exit;

    // if (nAmount > 0) and (CheckCDS.RecordCount > 0) then
    // begin
    // if checkCDS.Locate('GoodsId', SourceClientDataSet.FieldByName('Id').asInteger,[]) then
    // begin
    // if checkCDS.FieldByName('PartionDateKindId').AsInteger <> SourceClientDataSet.FieldByName('PartionDateKindId').AsInteger then
    // begin
    // ShowMessage('В чек уже опущен медикаменты со сроком <' + checkCDS.FieldByName('PartionDateKindName').Value + '>'#13#10 +
    // 'Нельзя в один чек опускать один медикамент с разными сроками.');
    // Exit;
    // end;
    // end;
    // end;

    if Assigned(SourceClientDataSet.FindField('AmountMonth')) then
    begin
      if SourceClientDataSet.FindField('AmountMonth').IsNull or
        (SourceClientDataSet.FindField('AmountMonth').asCurrency > 1) then
        if ExistsLessAmountMonth(SourceClientDataSet.FieldByName('Id').AsInteger,
          SourceClientDataSet.FieldByName('AmountMonth').asCurrency) then
          exit;
    end;

    //
    if SoldRegim = True then
    begin
      //
      // 23.01.2018 - Нужно опять вернуть  проверку, чтобы в один чек пробивался только один пр-т
      if (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (CheckCDS.RecordCount >= 1) then
      begin
        ShowMessage('Ошибка.В чеке для Соц.проекта уже есть <' +
          IntToStr(CheckCDS.RecordCount) + '> Товар.Запрещено больше чем <1>.');
        exit;
      end;
      FormParams.ParamByName('Price1303').Value := 0;

      if (Self.FormParams.ParamByName('SPKindId').Value <> 4823010) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (Self.FormParams.ParamByName('SPTax').Value = 0) and
        (SourceClientDataSet.FieldByName('isSP').AsBoolean = false) then
      begin
        ShowMessage('Ошибка.Выбранный код товара не участвует в Соц.проекте!');
        exit;
      end;

      // проверка ЗАПРЕТ на отпуск препаратов без кода мориона, для пост. 1303
      if (Self.FormParams.ParamByName('SPKindId').Value = 4823010) and
        (SourceClientDataSet.FieldByName('MorionCode').AsInteger = 0) and
        Assigned(LikiDniproReceiptApi) and (LikiDniproReceiptApi.Recipe.FRecipe_Type = 2) then
      begin
        ShowPUSHMessageCash('БЛОК ОТПУСКА !'#13'Рецепт погасить невозможно, на товар отсутствует в нашей базе код Мориона.'#13 +
          'Сделать PrintScreen экрана с ошибкой и отправить на Telegram   в группу ПКМУ1303  (инфо для Пелиной Любови)', cResult);
        exit;
      end;

      // проверка ЗАПРЕТ на отпуск препаратов у которых ндс 20%, для пост. 1303
      if (Self.FormParams.ParamByName('SPKindId').Value = 4823010) then
      begin
        spCheckItem_SPKind_1303.ParamByName('inSPKindId').Value :=
          Self.FormParams.ParamByName('SPKindId').Value;
        spCheckItem_SPKind_1303.ParamByName('inGoodsId').Value :=
          SourceClientDataSet.FieldByName('Id').AsInteger;
        spCheckItem_SPKind_1303.ParamByName('inPriceSale').Value :=
          SourceClientDataSet.FieldByName('Price').asCurrency;
        spCheckItem_SPKind_1303.ParamByName('outError').Value := '';
        spCheckItem_SPKind_1303.ParamByName('outError2').Value := '';
        spCheckItem_SPKind_1303.ParamByName('outSentence').Value := '';
        spCheckItem_SPKind_1303.ParamByName('outPrice').Value := 0;
        spCheckItem_SPKind_1303.Execute;
        if //(spCheckItem_SPKind_1303.ParamByName('outSentence').Value <> '') and
          (spCheckItem_SPKind_1303.ParamByName('outPrice').AsFloat <> 0) then
        begin
  //        if MessageDlg(spCheckItem_SPKind_1303.ParamByName('outError').Value +
  //          #13#10#13#10 + 'Yes - ' + spCheckItem_SPKind_1303.ParamByName
  //          ('outSentence').Value, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  //        begin
            FormParams.ParamByName('Price1303').Value :=
              spCheckItem_SPKind_1303.ParamByName('outPrice').AsFloat;
  //        end
  //        else
  //          exit;
        end
        else if spCheckItem_SPKind_1303.ParamByName('outError').Value <> '' then
        begin
          ShowMessage(spCheckItem_SPKind_1303.ParamByName('outError').Value +
            spCheckItem_SPKind_1303.ParamByName('outError2').Value);
          exit;
        end;
      end;

      if DiscountServiceForm.gCode <> 0 then
      begin
        if RemainsCDS.FieldByName('GoodsDiscountId').AsInteger <> DiscountServiceForm.gDiscountExternalId then
        begin
          ShowMessage('Ошибка.Товар <' + RemainsCDS.FieldByName('GoodsName').AsString + '> не участвует в дисконтной программе ' + FormParams.ParamByName('DiscountExternalName').Value + '!');
          exit;
        end;
      end else if RemainsCDS.FieldByName('isGoodsForProject').AsBoolean and (RemainsCDS.FieldByName('GoodsDiscountId').AsInteger <> 0) then
      begin
        ShowMessage('Ошибка.Товар <' + RemainsCDS.FieldByName('GoodsName').AsString + '> предназначен для дисконтной программе ' + RemainsCDS.FindField('GoodsDiscountName').AsString + '!');
        exit;
      end;
    end;

    if RemainsCDS.FieldByName('isOnlySP').AsBoolean and (FormParams.ParamByName('HelsiID').Value = '') then
    begin
      ShowMessage('Ошибка.Товар <' + RemainsCDS.FieldByName('GoodsName').AsString + '> предназначен для программы "Доступні ліки"!');
      exit;
    end;

    if not gc_User.Local and (nAmount > 0) and
      (Self.FormParams.ParamByName('SPKindId').Value = 4823009) and
      (FormParams.ParamByName('HelsiPartialPrescription').Value = False) then
    begin
      with spCheck_RemainsError do
        try
          ParamByName('inSPKindId').Value := Self.FormParams.ParamByName('SPKindId').Value;
          ParamByName('inJSON').Value := GoodsToJSON(RemainsCDS.FieldByName('Id').AsInteger, nAmount +
             IfThen(not CheckCDS.IsEmpty and (RemainsCDS.FieldByName('Id').AsInteger = CheckCDS.FieldByName('GoodsId').AsInteger), CheckCDS.FieldByName('Amount').asCurrency, 0),
             RemainsCDS.FindField('PartionDateKindId').AsVariant, RemainsCDS.FindField('NDSKindId').AsVariant, RemainsCDS.FindField('DivisionPartiesID').AsVariant);
          Execute;
          if ParamByName('outMessageText').Value <> '' then
          begin
            ShowMessage('Ошибка.' + ParamByName('outMessageText').Value);
            exit;

          end;
        except
        end;
    end;


    //
    // потому что криво, надо правильно определить ТОВАР + цена БЕЗ скидки
    if SoldRegim = True then // это ПРОДАЖА
    begin

      lGoodsId_bySoldRegim := SourceClientDataSet.FieldByName('Id').AsInteger;
      lTypeDiscount := 0;

      if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (FormParams.ParamByName('Price1303').Value <> 0) then
      begin
        // цена БЕЗ скидки
        lPriceSale := FormParams.ParamByName('Price1303').Value;
        // цена СО скидкой - с процентом SPTax
        lPrice := FormParams.ParamByName('Price1303').Value *
          (1 - Self.FormParams.ParamByName('SPTax').Value / 100);
      end
      else if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
      begin
        // цена БЕЗ скидки
        lPriceSale := SourceClientDataSet.FieldByName('Price').asCurrency;
        // цена СО скидкой - с процентом SPTax
        lPrice := SourceClientDataSet.FieldByName('Price').asCurrency *
          (1 - Self.FormParams.ParamByName('SPTax').Value / 100);
      end
      else if (SourceClientDataSet.FieldByName('isSP').AsBoolean = True) and
        (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
        (FormParams.ParamByName('HelsiSkipDispenseSign').Value = False) then
      begin
        if (FormParams.ParamByName('MedicalProgramSPId').Value = SourceClientDataSet.FieldByName('MedicalProgramSPId').AsInteger) then
        begin
          // цена БЕЗ скидки
          lPriceSale := SourceClientDataSet.FieldByName('PriceSaleSP').asCurrency;
          // цена СО скидкой
          lPrice := SourceClientDataSet.FieldByName('PriceSP').asCurrency;
        end else
        begin

          LoadMedicalProgramSPGoods(SourceClientDataSet.FieldByName('Id').AsInteger);

          // цена БЕЗ скидки
          lPriceSale := MedicalProgramSPGoodsCDS.FieldByName('PriceSaleSP').asCurrency;
          // цена СО скидкой
          lPrice := MedicalProgramSPGoodsCDS.FieldByName('PriceSP').asCurrency;
        end;
      end
      else if (DiscountServiceForm.gCode <> 0) and edPrice.Visible and (abs(edPrice.Value) > 0.0001) then
      begin
        // цена БЕЗ скидки
        lPriceSale := SourceClientDataSet.FieldByName('Price').asCurrency;
        // цена СО скидкой
        lPrice := edPrice.Value;
      end
      else if (FormParams.ParamByName('LoyaltyChangeSumma').Value = 0) and
        (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
        CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value,
        SourceClientDataSet.FieldByName('Id').AsInteger) then
      begin
        // цена БЕЗ скидки
        lPriceSale := SourceClientDataSet.FieldByName('Price').asCurrency;
        // цена СО скидкой
        lPrice := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
          Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
          Self.FormParams.ParamByName('SiteDiscount').Value);
      end
      else if (Self.FormParams.ParamByName('ManualDiscount').Value > 0) then
      begin
        // цена БЕЗ скидки
        lPriceSale := SourceClientDataSet.FieldByName('Price').asCurrency;
        // цена СО скидкой
        lPrice := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
          Self.FormParams.ParamByName('ManualDiscount').Value);
      end
      else if (Self.FormParams.ParamByName('SiteDiscount').Value > 0) then
      begin
        // цена БЕЗ скидки
        lPriceSale := SourceClientDataSet.FieldByName('Price').asCurrency;
        // цена СО скидкой
        lPrice := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
          Self.FormParams.ParamByName('SiteDiscount').Value);
      end
      else
      begin

        // Если есть цена со скидкой
        if (SourceClientDataSet.FieldByName('PriceChange').asCurrency > 0) and
          (IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
          SourceClientDataSet.FieldByName('Price').asCurrency) >
          CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price')
          .asCurrency, SourceClientDataSet.FieldByName('PriceChange').asCurrency)) and
          (SourceClientDataSet.FieldByName('FixEndDate').IsNull or
          (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime >= Date))
        then
        begin

          // Смотрим может уже опущено
          if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
            VarArrayOf([SourceClientDataSet.FieldByName('Id').AsInteger,
            SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
            SourceClientDataSet.FindField('NDSKindId').AsVariant,
            SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
            SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
            FormParams.ParamByName('AddPresent').Value]), []) then nAmountPut :=  CheckCDS.FieldByName('Amount').AsCurrency
          else nAmountPut := 0;

          if not SourceClientDataSet.FieldByName('FixEndDate').IsNull and
             (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime < Date) then
          begin
            ShowMessage('Срок действия акции закончился: ' + SourceClientDataSet.FieldByName('FixEndDate').AsString + '.');
            CalcPriceSale(lPriceSale, lPrice, lChangePercent,
              IfZero(SourceClientDataSet.FieldByName('PricePartionDate')
              .asCurrency, SourceClientDataSet.FieldByName('Price')
              .asCurrency), 0);
          end else
          begin

              if SourceClientDataSet.FieldByName('Multiplicity').asCurrency <> 0 then
              begin
                if trunc((abs(nAmount) + nAmountPut) / SourceClientDataSet.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                SourceClientDataSet.FieldByName('PriceChange').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( SourceClientDataSet.FieldByName('Multiplicity').AsCurrency *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            SourceClientDataSet.FieldByName('PriceChange').asCurrency)), -1)));

                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                           SourceClientDataSet.FieldByName('Price').asCurrency), 0);
                end else
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                SourceClientDataSet.FieldByName('PriceChange').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( (abs(nAmount) + nAmountPut) *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            SourceClientDataSet.FieldByName('PriceChange').asCurrency)), -1)));

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 1;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    SourceClientDataSet.FieldByName('Price').asCurrency, 0,
                    SourceClientDataSet.FieldByName('PriceChange').asCurrency);
                end;
              end else
              begin
                  ShowMessage('Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                              SourceClientDataSet.FieldByName('PriceChange').asCurrency)) + ' грн.');

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 1;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    SourceClientDataSet.FieldByName('Price').asCurrency, 0,
                    SourceClientDataSet.FieldByName('PriceChange').asCurrency);
              end;

          end;
        end
        else
        // Если есть процент скидки
        if (SourceClientDataSet.FieldByName('FixPercent').asCurrency > 0) and
           (SourceClientDataSet.FieldByName('FixEndDate').IsNull or
           (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime >= Date)) then
        begin

          // Смотрим может уже опущено
          if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
            VarArrayOf([SourceClientDataSet.FieldByName('Id').AsInteger,
            SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
            SourceClientDataSet.FindField('NDSKindId').AsVariant,
            SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
            SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
            FormParams.ParamByName('AddPresent').Value]), []) then nAmountPut :=  CheckCDS.FieldByName('Amount').AsCurrency
          else nAmountPut := 0;

          if not SourceClientDataSet.FieldByName('FixEndDate').IsNull and
             (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime < Date) then
          begin
            ShowMessage('Срок действия акции закончился: ' + SourceClientDataSet.FieldByName('FixEndDate').AsString + '.');
            CalcPriceSale(lPriceSale, lPrice, lChangePercent,
              IfZero(SourceClientDataSet.FieldByName('PricePartionDate')
              .asCurrency, SourceClientDataSet.FieldByName('Price')
              .asCurrency), 0);
          end else
          begin

              if SourceClientDataSet.FieldByName('Multiplicity').asCurrency <> 0 then
              begin
                if trunc((abs(nAmount) + nAmountPut) / SourceClientDataSet.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                                SourceClientDataSet.FieldByName('Price').asCurrency),
                                                                SourceClientDataSet.FieldByName('FixPercent').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( SourceClientDataSet.FieldByName('Multiplicity').AsCurrency *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                            SourceClientDataSet.FieldByName('Price').asCurrency),
                                            SourceClientDataSet.FieldByName('FixPercent').asCurrency)), -1)));

                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                           SourceClientDataSet.FieldByName('Price').asCurrency), 0);
                end else
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                                SourceClientDataSet.FieldByName('Price').asCurrency),
                                                                SourceClientDataSet.FieldByName('FixPercent').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( (abs(nAmount) + nAmountPut) *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                            SourceClientDataSet.FieldByName('Price').asCurrency),
                                            SourceClientDataSet.FieldByName('FixPercent').asCurrency)), -1)));

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 2;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                           SourceClientDataSet.FieldByName('Price').asCurrency),
                           SourceClientDataSet.FieldByName('FixPercent').asCurrency);
                end;
              end else
              begin
                  ShowMessage('Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                              IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                              SourceClientDataSet.FieldByName('Price').asCurrency),
                                                              SourceClientDataSet.FieldByName('FixPercent').asCurrency)) + ' грн.');

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 2;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                           SourceClientDataSet.FieldByName('Price').asCurrency),
                           SourceClientDataSet.FieldByName('FixPercent').asCurrency);
              end;

          end;
        end
        else
        // Если есть сумма скидки
        if (SourceClientDataSet.FieldByName('FixDiscount').asCurrency > 0) and
           (SourceClientDataSet.FieldByName('FixEndDate').IsNull or
           (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime >= Date)) then
        begin

          // Смотрим может уже опущено
          if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
            VarArrayOf([SourceClientDataSet.FieldByName('Id').AsInteger,
            SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
            SourceClientDataSet.FindField('NDSKindId').AsVariant,
            SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
            SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
            FormParams.ParamByName('AddPresent').Value]), []) then nAmountPut :=  CheckCDS.FieldByName('Amount').AsCurrency
          else nAmountPut := 0;

          if not SourceClientDataSet.FieldByName('FixEndDate').IsNull and
             (SourceClientDataSet.FieldByName('FixEndDate').AsDateTime < Date) then
          begin
            ShowMessage('Срок действия акции закончился: ' + SourceClientDataSet.FieldByName('FixEndDate').AsString + '.');
            CalcPriceSale(lPriceSale, lPrice, lChangePercent,
              IfZero(SourceClientDataSet.FieldByName('PricePartionDate')
              .asCurrency, SourceClientDataSet.FieldByName('Price')
              .asCurrency), 0);
          end else
          begin

              if SourceClientDataSet.FieldByName('Multiplicity').asCurrency <> 0 then
              begin
                if trunc((abs(nAmount) + nAmountPut) / SourceClientDataSet.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                                SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( SourceClientDataSet.FieldByName('Multiplicity').AsCurrency *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                            SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency)), -1)));

                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                           SourceClientDataSet.FieldByName('Price').asCurrency), 0);
                end else
                begin
                  ShowMessage
                    ('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10
                    + 'Отпускать со скидкой разрешено кратно ' +
                    SourceClientDataSet.FieldByName('Multiplicity').AsString +
                    ' упаковки.'#13#10'Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                                IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                                SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency)) + ' грн.'#13#10 +
                    'Сумма скидки составит: ' + CurrToStr(RoundTo( (abs(nAmount) + nAmountPut) *
                      (SourceClientDataSet.FieldByName('Price').asCurrency -
                      CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                            IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                            SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency)), -1)));

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 3;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    SourceClientDataSet.FieldByName('Price').asCurrency, 0,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                    SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency);
                end;
              end else
              begin
                  ShowMessage('Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                                                              IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                                                              SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency)) + ' грн.');

                  nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').asCurrency;
                  nFixEndDate := SourceClientDataSet.FieldByName('FixEndDate').AsVariant;
                  lTypeDiscount := 3;
                  CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                    SourceClientDataSet.FieldByName('Price').asCurrency, 0,
                    IfZero(SourceClientDataSet.FieldByName('PricePartionDate').asCurrency,
                    SourceClientDataSet.FieldByName('Price').asCurrency) - SourceClientDataSet.FieldByName('FixDiscount').asCurrency);
              end;
          end;
        end
        else if SourceClientDataSet.FieldByName('PricePartionDate').asCurrency <> 0 then
        begin
          CalcPriceSale(lPriceSale, lPrice, lChangePercent,
            SourceClientDataSet.FieldByName('Price').asCurrency, 0,
            SourceClientDataSet.FieldByName('PricePartionDate').asCurrency);
        end
        else
        begin
          CalcPriceSale(lPriceSale, lPrice, lChangePercent,
            SourceClientDataSet.FieldByName('Price').asCurrency, 0);
        end;
      end;

      // Если скидка по сети и не установлены соц. приект и дисконтная программа
      if (Self.FormParams.ParamByName('InvNumberSP').Value = '') and
        (DiscountServiceForm.gCode = 0) and not UnitConfigCDS.FieldByName
        ('PermanentDiscountID').IsNull and
        (UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency > 0)
      then
      begin
        if lChangePercent = 0 then
        begin
          if lPrice = lPriceSale then
          begin
            CalcPriceSale(lPriceSale, lPrice, lChangePercent, lPriceSale,
              UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency)

          end
          else
            lPrice := GetPrice(lPrice,
              UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency);

        end
        else
        begin
          CalcPriceSale(lPriceSale, lPrice, lChangePercent, lPriceSale,
            lChangePercent + UnitConfigCDS.FieldByName('PermanentDiscountPercent')
            .asCurrency)
        end;
      end;
    end
    else // это ВОЗВРАТ
    begin
      lGoodsId_bySoldRegim := CheckCDS.FieldByName('GoodsId').AsInteger;
      if CheckCDS.FieldByName('PriceSale').asCurrency > 0
      // !!!на всяк случай, временно
      then
        lPriceSale := CheckCDS.FieldByName('PriceSale').asCurrency
      else
        lPriceSale := CheckCDS.FieldByName('Price').asCurrency;
      // ?цена СО скидкой в этом случае такая же?
      lPrice := lPriceSale;
      // Кратность упаковки
      nMultiplicity := CheckCDS.FieldByName('Multiplicity').asCurrency;
      nFixEndDate := CheckCDS.FieldByName('FixEndDate').AsVariant;
    end;

    if SoldRegim AND (nAmount > 0) then
    Begin
      CheckCDS.DisableControls;
      try
        CheckCDS.Filtered := false;
        // попытка добавить препарат с другой ценой. обновляем цену у уже существующего и обнуляем суммы для пересчета
        if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([SourceClientDataSet.FieldByName('Id').AsInteger,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) and
          ((CheckCDS.FieldByName('PriceSale').asCurrency <> lPriceSale) or
          (CheckCDS.FieldByName('Price').asCurrency <> lPrice)) and
          (CheckCDS.FieldByName('AmountOrder').asCurrency = 0) then
        Begin

          if FormParams.ParamByName('isBanAdd').Value and
            ((CheckCDS.FieldByName('Amount').asCurrency + nAmount) > Ceil(CheckCDS.FieldByName('AmountOrder').asCurrency)) then
          begin
            ShowMessage('Увеличивать количество на целые значения запрещено, можно до ближайшего целого. Отпустите клиента отдельтным чеком.');
            Exit;
          end;

          CheckCDS.Edit;
          CheckCDS.FieldByName('Price').asCurrency := lPrice;
          CheckCDS.FieldByName('Summ').asCurrency := 0;
          CheckCDS.FieldByName('PriceSale').asCurrency := lPriceSale;
          CheckCDS.FieldByName('ChangePercent').asCurrency := lChangePercent;
          CheckCDS.FieldByName('SummChangePercent').asCurrency := 0;
          CheckCDS.FieldByName('PartionDateKindId').AsVariant :=
            SourceClientDataSet.FindField('PartionDateKindId').AsVariant;
          CheckCDS.FieldByName('PartionDateKindName').AsVariant :=
            SourceClientDataSet.FindField('PartionDateKindName').AsVariant;
          CheckCDS.FieldByName('PricePartionDate').AsVariant :=
            SourceClientDataSet.FieldByName('PricePartionDate').AsVariant;
          CheckCDS.FieldByName('AmountMonth').AsVariant :=
            SourceClientDataSet.FieldByName('AmountMonth').AsVariant;
          CheckCDS.FieldByName('NDS').AsVariant := SourceClientDataSet.FindField
            ('NDS').AsVariant;
          CheckCDS.FieldByName('NDSKindId').AsVariant :=
            SourceClientDataSet.FindField('NDSKindId').AsVariant;
          CheckCDS.FieldByName('DiscountExternalID').AsVariant :=
            SourceClientDataSet.FindField('DiscountExternalID').AsVariant;
          CheckCDS.FieldByName('DiscountExternalName').AsVariant :=
            SourceClientDataSet.FindField('DiscountExternalName').AsVariant;
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant :=
            SourceClientDataSet.FindField('DivisionPartiesID').AsVariant;
          CheckCDS.FieldByName('DivisionPartiesName').AsVariant :=
            SourceClientDataSet.FindField('DivisionPartiesName').AsVariant;
          CheckCDS.FieldByName('PriceDiscount').AsVariant := lPrice;
          CheckCDS.FieldByName('TypeDiscount').AsVariant := lTypeDiscount;
          CheckCDS.FieldByName('UKTZED').AsVariant :=
            SourceClientDataSet.FindField('UKTZED').AsVariant;
          CheckCDS.FieldByName('isGoodsPairSun').AsVariant :=
            SourceClientDataSet.FindField('isGoodsPairSun').AsVariant;
          CheckCDS.FieldByName('GoodsPairSunMainId').AsVariant :=
            SourceClientDataSet.FindField('GoodsPairSunMainId').AsVariant;
          CheckCDS.FieldByName('GoodsPairSunAmount').AsVariant :=
            SourceClientDataSet.FindField('GoodsPairSunAmount').AsVariant;
          CheckCDS.FieldByName('isPresent').AsVariant :=
            FormParams.ParamByName('AddPresent').Value;

          if RemainsCDS <> SourceClientDataSet then
          begin
            RemainsCDS.DisableControls;
            RemainsCDS.Filtered := false;
            nRecNo := RemainsCDS.RecNo;
            try
              if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
                CheckCDS.FieldByName('PartionDateKindId').AsVariant,
                CheckCDS.FieldByName('NDSKindId').AsVariant,
                CheckCDS.FieldByName('DiscountExternalID').AsVariant,
                CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) and
                (RemainsCDS.FieldByName('Color_calc').AsInteger <> 0) then
              begin
                CheckCDS.FieldByName('Color_calc').AsInteger :=
                  RemainsCDS.FieldByName('Color_calc').AsInteger;
                CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
                  RemainsCDS.FieldByName('Color_ExpirationDate').AsInteger;
                CheckCDS.FieldByName('AccommodationName').AsVariant :=
                  SourceClientDataSet.FieldByName('AccommodationName').AsVariant;
              end
              else
              begin
                CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
                CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
              end;
            finally
              RemainsCDS.RecNo := nRecNo;
              RemainsCDS.Filtered := True;
              RemainsCDS.EnableControls;
            end;
          end
          else
          begin
            if SourceClientDataSet.FieldByName('Color_calc').AsInteger <> 0 then
            begin
              CheckCDS.FieldByName('Color_calc').AsInteger :=
                SourceClientDataSet.FieldByName('Color_calc').AsInteger;
              CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
                SourceClientDataSet.FieldByName('Color_ExpirationDate').AsInteger;
            end
            else
            begin
              CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
              CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
            end;
          end;
          if nJuridicalId = 0 then
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := Null;
            CheckCDS.FieldByName('JuridicalName').AsVariant := Null;
          end else
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := nJuridicalId;
            CheckCDS.FieldByName('JuridicalName').AsVariant := cJuridicalName;
          end;

          if CheckCDS.FieldByName('isPresent').AsVariant then
            CheckCDS.FieldByName('Color_calc').AsInteger := TColor($FFB0FF);
          CheckCDS.Post;
        End
        else if not CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([SourceClientDataSet.FieldByName('Id').AsInteger,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) then
        Begin

          if FormParams.ParamByName('isBanAdd').Value then
          begin
            ShowMessage('Добавлять товар в чек запрещено. Отпустите клиента отдельным новым чеком.');
            Exit;
          end;

          CheckCDS.Append;
          CheckCDS.FieldByName('Id').AsInteger := 0;
          CheckCDS.FieldByName('ParentId').AsInteger := 0;
          CheckCDS.FieldByName('GoodsId').AsInteger :=
            SourceClientDataSet.FieldByName('Id').AsInteger;
          CheckCDS.FieldByName('GoodsCode').AsInteger :=
            SourceClientDataSet.FieldByName('GoodsCode').AsInteger;
          CheckCDS.FieldByName('GoodsName').AsString :=
            SourceClientDataSet.FieldByName('GoodsName').AsString;
          CheckCDS.FieldByName('Amount').asCurrency := 0;
          CheckCDS.FieldByName('Price').asCurrency := lPrice;
          CheckCDS.FieldByName('Summ').asCurrency := 0;
          CheckCDS.FieldByName('NDS').asCurrency :=
            SourceClientDataSet.FieldByName('NDS').asCurrency;
          CheckCDS.FieldByName('NDSKindId').AsInteger :=
            SourceClientDataSet.FieldByName('NDSKindId').AsInteger;
          CheckCDS.FieldByName('DiscountExternalID').AsVariant :=
            SourceClientDataSet.FieldByName('DiscountExternalID').AsVariant;
          CheckCDS.FieldByName('DiscountExternalName').AsVariant :=
            SourceClientDataSet.FieldByName('DiscountExternalName').AsVariant;
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant :=
            SourceClientDataSet.FieldByName('DivisionPartiesID').AsVariant;
          CheckCDS.FieldByName('DivisionPartiesName').AsVariant :=
            SourceClientDataSet.FieldByName('DivisionPartiesName').AsVariant;
          CheckCDS.FieldByName('isErased').AsBoolean := false;
          // ***20.07.16
          CheckCDS.FieldByName('PriceSale').asCurrency := lPriceSale;
          CheckCDS.FieldByName('ChangePercent').asCurrency := lChangePercent;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            lSummChangePercent;
          // ***19.08.16
          CheckCDS.FieldByName('AmountOrder').asCurrency := 0;
          // ***10.08.16
          CheckCDS.FieldByName('List_UID').AsString := GenerateGUID;
          // ***04.09.18
          CheckCDS.FieldByName('Remains').asCurrency :=
            SourceClientDataSet.FieldByName('Remains').asCurrency;
          // ***31.03.19
          CheckCDS.FieldByName('DoesNotShare').AsBoolean :=
            SourceClientDataSet.FieldByName('DoesNotShare').AsBoolean;
          // ***25.04.19
          CheckCDS.FieldByName('IdSP').AsString := SourceClientDataSet.FieldByName('IdSP').AsString;

          if (SourceClientDataSet.FieldByName('isSP').AsBoolean = True) and
           (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
           (FormParams.ParamByName('MedicalProgramSPId').Value <> 0)  then
          begin

            if FormParams.ParamByName('MedicalProgramSPId').Value = SourceClientDataSet.FieldByName('MedicalProgramSPId').AsInteger  then
            begin
              CheckCDS.FieldByName('ProgramIdSP').AsString := SourceClientDataSet.FieldByName('ProgramIdSP').AsString;
              CheckCDS.FieldByName('CountSP').asCurrency :=
                SourceClientDataSet.FieldByName('CountSP').asCurrency;
              CheckCDS.FieldByName('PriceRetSP').asCurrency :=
                SourceClientDataSet.FieldByName('PriceRetSP').asCurrency;
              CheckCDS.FieldByName('PaymentSP').asCurrency :=
                SourceClientDataSet.FieldByName('PaymentSP').asCurrency;
            end else
            begin

              LoadMedicalProgramSPGoods(SourceClientDataSet.FieldByName('Id').AsInteger);

              CheckCDS.FieldByName('ProgramIdSP').AsString := MedicalProgramSPGoodsCDS.FieldByName('ProgramIdSP').AsString;
              CheckCDS.FieldByName('CountSP').asCurrency :=
                MedicalProgramSPGoodsCDS.FieldByName('CountSP').asCurrency;
              CheckCDS.FieldByName('PriceRetSP').asCurrency :=
                MedicalProgramSPGoodsCDS.FieldByName('PriceRetSP').asCurrency;
              CheckCDS.FieldByName('PaymentSP').asCurrency :=
                MedicalProgramSPGoodsCDS.FieldByName('PaymentSP').asCurrency;
            end;

          end else
          begin
            CheckCDS.FieldByName('ProgramIdSP').AsString := SourceClientDataSet.FieldByName('ProgramIdSP').AsString;
            CheckCDS.FieldByName('CountSP').asCurrency :=
              SourceClientDataSet.FieldByName('CountSP').asCurrency;
            CheckCDS.FieldByName('PriceRetSP').asCurrency :=
              SourceClientDataSet.FieldByName('PriceRetSP').asCurrency;
            CheckCDS.FieldByName('PaymentSP').asCurrency :=
              SourceClientDataSet.FieldByName('PaymentSP').asCurrency;
          end;

          CheckCDS.FieldByName('PartionDateKindId').AsVariant :=
            SourceClientDataSet.FindField('PartionDateKindId').AsVariant;
          CheckCDS.FieldByName('PartionDateKindName').AsVariant :=
            SourceClientDataSet.FindField('PartionDateKindName').AsVariant;
          CheckCDS.FieldByName('PricePartionDate').AsVariant :=
            SourceClientDataSet.FieldByName('PricePartionDate').AsVariant;
          CheckCDS.FieldByName('AmountMonth').AsVariant :=
            SourceClientDataSet.FieldByName('AmountMonth').AsVariant;
          CheckCDS.FieldByName('PriceDiscount').AsVariant := lPrice;
          CheckCDS.FieldByName('TypeDiscount').AsVariant := lTypeDiscount;
          CheckCDS.FieldByName('UKTZED').AsVariant :=
            SourceClientDataSet.FieldByName('UKTZED').AsVariant;
          CheckCDS.FieldByName('isGoodsPairSun').AsVariant :=
            SourceClientDataSet.FieldByName('isGoodsPairSun').AsVariant;
          CheckCDS.FieldByName('GoodsPairSunMainId').AsVariant :=
            SourceClientDataSet.FieldByName('GoodsPairSunMainId').AsVariant;
          CheckCDS.FieldByName('GoodsPairSunAmount').AsVariant :=
            SourceClientDataSet.FieldByName('GoodsPairSunAmount').AsVariant;
          CheckCDS.FieldByName('MultiplicitySale').AsVariant :=
            SourceClientDataSet.FieldByName('MultiplicitySale').AsVariant;
          CheckCDS.FieldByName('isMultiplicityError').AsVariant :=
            SourceClientDataSet.FieldByName('isMultiplicityError').AsVariant;
          CheckCDS.FieldByName('isPresent').AsVariant :=
            FormParams.ParamByName('AddPresent').Value;

          if RemainsCDS <> SourceClientDataSet then
          begin
            RemainsCDS.DisableControls;
            RemainsCDS.Filtered := false;
            nRecNo := RemainsCDS.RecNo;
            try
              if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
                CheckCDS.FieldByName('PartionDateKindId').AsVariant,
                CheckCDS.FieldByName('NDSKindId').AsVariant,
                CheckCDS.FieldByName('DiscountExternalID').AsVariant,
                CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) and
                (RemainsCDS.FieldByName('Color_calc').AsInteger <> 0) then
              begin
                CheckCDS.FieldByName('Color_calc').AsInteger :=
                  RemainsCDS.FieldByName('Color_calc').AsInteger;
                CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
                  RemainsCDS.FieldByName('Color_ExpirationDate').AsInteger;
                CheckCDS.FieldByName('AccommodationName').AsVariant :=
                  SourceClientDataSet.FieldByName('AccommodationName').AsVariant;
              end
              else
              begin
                CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
                CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
              end;
            finally
              RemainsCDS.RecNo := nRecNo;
              RemainsCDS.Filtered := True;
              RemainsCDS.EnableControls;
            end;
          end
          else
          begin
            if SourceClientDataSet.FieldByName('Color_calc').AsInteger <> 0 then
            begin
              CheckCDS.FieldByName('Color_calc').AsInteger :=
                SourceClientDataSet.FieldByName('Color_calc').AsInteger;
              CheckCDS.FieldByName('Color_ExpirationDate').AsInteger :=
                SourceClientDataSet.FieldByName('Color_ExpirationDate').AsInteger;
            end
            else
            begin
              CheckCDS.FieldByName('Color_calc').AsInteger := clWhite;
              CheckCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
            end;
          end;
          if Assigned(SourceClientDataSet.FindField('AccommodationName')) then
            CheckCDS.FieldByName('AccommodationName').AsVariant :=
              SourceClientDataSet.FieldByName('AccommodationName').AsVariant;
          CheckCDS.FieldByName('Multiplicity').AsVariant := nMultiplicity;
          CheckCDS.FieldByName('FixEndDate').AsVariant := nFixEndDate;
          if nJuridicalId = 0 then
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := Null;
            CheckCDS.FieldByName('JuridicalName').AsVariant := Null;
          end else
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := nJuridicalId;
            CheckCDS.FieldByName('JuridicalName').AsVariant := cJuridicalName;
          end;

          if CheckCDS.FieldByName('isPresent').AsVariant then
            CheckCDS.FieldByName('Color_calc').AsInteger := TColor($FFB0FF);

          // ***09.11.21
          CheckCDS.FieldByName('GoodsDiscountProcent').AsVariant :=Null;
          CheckCDS.FieldByName('PriceSaleDiscount').AsVariant := Null;
          CheckCDS.FieldByName('isPriceDiscount').AsBoolean := False;

          CheckCDS.Post;

        End else if CheckCDS.Locate('GoodsId;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID;isPresent',
          VarArrayOf([nId,
          SourceClientDataSet.FindField('PartionDateKindId').AsVariant,
          SourceClientDataSet.FindField('NDSKindId').AsVariant,
          SourceClientDataSet.FindField('DiscountExternalID').AsVariant,
          SourceClientDataSet.FindField('DivisionPartiesID').AsVariant,
          FormParams.ParamByName('AddPresent').Value]), []) and
          (CheckCDS.FieldByName('JuridicalId').AsInteger <> nJuridicalId) then
        Begin
          if CheckCDS.FieldByName('AmountOrder').asCurrency > 0 then
            lPriceSale := CheckCDS.FieldByName('PriceSale').asCurrency;

          CheckCDS.Edit;
          if nJuridicalId = 0 then
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := Null;
            CheckCDS.FieldByName('JuridicalName').AsVariant := Null;
          end else
          begin
            CheckCDS.FieldByName('JuridicalId').AsVariant := nJuridicalId;
            CheckCDS.FieldByName('JuridicalName').AsVariant := cJuridicalName;
          end;
          CheckCDS.Post;

        end else if CheckCDS.FieldByName('AmountOrder').asCurrency > 0 then
          lPriceSale := CheckCDS.FieldByName('PriceSale').asCurrency;
      finally
        CheckCDS.Filtered := True;
        CheckCDS.EnableControls;
      end;
      UpdateRemainsFromCheck(SourceClientDataSet.FieldByName('Id').AsInteger,
        SourceClientDataSet.FindField('PartionDateKindId').AsInteger,
        SourceClientDataSet.FindField('NDSKindId').AsInteger,
        SourceClientDataSet.FindField('DiscountExternalID').AsInteger,
        SourceClientDataSet.FindField('DivisionPartiesID').AsInteger,
        FormParams.ParamByName('AddPresent').Value, nAmount,
        lPriceSale);
      // Update Дисконт в CDS - по всем "обновим" Дисконт
      if (FormParams.ParamByName('DiscountExternalId').Value > 0) and
       (FormParams.ParamByName('isDiscountCommit').Value = False) then
      begin
        DiscountServiceForm.fUpdateCDS_Discount(CheckCDS, lMsg,
          FormParams.ParamByName('DiscountExternalId').Value,
          FormParams.ParamByName('DiscountCardNumber').Value);

        // Проверим цену
        try
          RemainsCDS.DisableControls;
          RemainsCDS.Filtered := false;
          with CheckCDS do
          begin
            First;
            while not Eof do
            begin

              RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([FieldByName('GoodsId').AsInteger,
                  FieldByName('PartionDateKindId').AsVariant,
                  FieldByName('NDSKindId').AsVariant,
                  FieldByName('DiscountExternalID').AsVariant,
                  FieldByName('DivisionPartiesID').AsVariant]), []);

              if (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency > 0) and
                 (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency < FieldByName('PriceSale').AsCurrency) and
                 (FieldByName('Amount').AsCurrency > 0) then
              begin
                ShowMessage('Превышена максимально возможная цена на препарат <' + FieldByName('GoodsName').AsString + '>. Обратитесь к Калининой Кристине...');
              end;

              Next;
            end;
          end;
        finally
          RemainsCDS.Filtered := True;
          RemainsCDS.EnableControls;
        end;
      end;

      CalcTotalSumm;
    End
    else if not SoldRegim AND (nAmount <> 0) then
    Begin

      if FormParams.ParamByName('isBanAdd').Value and (nAmount > 0) and
        ((CheckCDS.FieldByName('Amount').asCurrency + nAmount) > Ceil (CheckCDS.FieldByName('AmountOrder').asCurrency)) then
      begin
        ShowMessage('Увеличивать количество на целые значения запрещено, можно до ближайшего целого. Отпустите клиента отдельтным чеком.');
        Exit;
      end;

      if (nAmount > 0) then
      begin
        if (nAmount + CheckCDS.FieldByName('Amount').asCurrency) >
          CheckCDS.FieldByName('Remains').asCurrency then
        begin
          ShowMessage('Не хватает количества для продажи!');
          exit;
        end;
      end;

      // Проверим фиксированные скидки
      try
        RemainsCDS.DisableControls;
        RemainsCDS.Filtered := false;

        if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindId').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) and
          (CheckCDS.FieldByName('AmountOrder').asCurrency = 0)  then
        begin

          lPriceSale := CheckCDS.FieldByName('PriceSale').asCurrency;
          lPrice := CheckCDS.FieldByName('Price').asCurrency;
          lTypeDiscount := CheckCDS.FieldByName('TypeDiscount').AsInteger;
          lChangePercent := CheckCDS.FieldByName('ChangePercent').asCurrency;
          nMultiplicity := CheckCDS.FieldByName('Multiplicity').asCurrency;
          nFixEndDate := CheckCDS.FieldByName('FixEndDate').AsVariant;

          // Если есть цена со скидкой
          if (RemainsCDS.FieldByName('PriceChange').asCurrency > 0) and
            (IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
            RemainsCDS.FieldByName('Price').asCurrency) >
            CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price')
            .asCurrency, RemainsCDS.FieldByName('PriceChange').asCurrency)) and
            (RemainsCDS.FieldByName('FixEndDate').IsNull or
            (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date))
          then
          begin

            if not RemainsCDS.FieldByName('FixEndDate').IsNull and
               (RemainsCDS.FieldByName('FixEndDate').AsDateTime < Date) then
            begin
              lPrice :=  lPriceSale;
              lTypeDiscount := 0;
            end else
            begin

                if RemainsCDS.FieldByName('Multiplicity').asCurrency <> 0 then
                begin
                  if trunc((nAmount + CheckCDS.FieldByName('Amount').asCurrency) / RemainsCDS.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                  begin
                    lPrice :=  lPriceSale;
                    lTypeDiscount := 0;
                  end else
                  begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 1;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      lPriceSale, 0,
                      RemainsCDS.FieldByName('PriceChange').asCurrency);
                  end;
                end else
                begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 1;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      lPriceSale, 0,
                      RemainsCDS.FieldByName('PriceChange').asCurrency);
                end;

            end;
          end
          else
          // Если есть процент скидки
          if (RemainsCDS.FieldByName('FixPercent').asCurrency > 0) and
             (RemainsCDS.FieldByName('FixEndDate').IsNull or
             (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date)) then
          begin

            if not RemainsCDS.FieldByName('FixEndDate').IsNull and
               (RemainsCDS.FieldByName('FixEndDate').AsDateTime < Date) then
            begin
              lPrice :=  lPriceSale;
              lTypeDiscount := 0;
            end else
            begin

                if RemainsCDS.FieldByName('Multiplicity').asCurrency <> 0 then
                begin
                  if trunc((nAmount + CheckCDS.FieldByName('Amount').asCurrency) / RemainsCDS.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                  begin
                    lPrice :=  lPriceSale;
                    lTypeDiscount := 0;
                  end else
                  begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 2;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
                             lPriceSale),
                             RemainsCDS.FieldByName('FixPercent').asCurrency);
                  end;
                end else
                begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 2;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
                             lPriceSale),
                             RemainsCDS.FieldByName('FixPercent').asCurrency);
                end;

            end;
          end
          else
          // Если есть сумма скидки
          if (RemainsCDS.FieldByName('FixDiscount').asCurrency > 0) and
             (RemainsCDS.FieldByName('FixEndDate').IsNull or
             (RemainsCDS.FieldByName('FixEndDate').AsDateTime >= Date)) then
          begin

            if not RemainsCDS.FieldByName('FixEndDate').IsNull and
               (RemainsCDS.FieldByName('FixEndDate').AsDateTime < Date) then
            begin
              lPrice :=  lPriceSale;
              lTypeDiscount := 0;
            end else
            begin

                if RemainsCDS.FieldByName('Multiplicity').asCurrency <> 0 then
                begin
                  if trunc((nAmount + CheckCDS.FieldByName('Amount').asCurrency) / RemainsCDS.FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0 then
                  begin
                    lPrice :=  lPriceSale;
                    lTypeDiscount := 0;
                  end else
                  begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 3;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      RemainsCDS.FieldByName('Price').asCurrency, 0,
                      IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
                      lPriceSale) - RemainsCDS.FieldByName('FixDiscount').asCurrency);
                  end;
                end else
                begin
                    nMultiplicity := RemainsCDS.FieldByName('Multiplicity').asCurrency;
                    nFixEndDate := RemainsCDS.FieldByName('FixEndDate').AsVariant;
                    lTypeDiscount := 3;
                    CalcPriceSale(lPriceSale, lPrice, lChangePercent,
                      RemainsCDS.FieldByName('Price').asCurrency, 0,
                      IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
                      lPriceSale) - RemainsCDS.FieldByName('FixDiscount').asCurrency);
                end;
            end;
          end;

          if (lPrice <> CheckCDS.FieldByName('Price').asCurrency) or
             (lTypeDiscount <> CheckCDS.FieldByName('TypeDiscount').AsVariant) then
          begin
            CheckCDS.Edit;
            CheckCDS.FieldByName('PriceSale').asCurrency := lPriceSale;
            CheckCDS.FieldByName('Price').asCurrency := lPrice;
            CheckCDS.FieldByName('TypeDiscount').AsVariant := lTypeDiscount;
            CheckCDS.FieldByName('ChangePercent').AsVariant := lChangePercent;
            CheckCDS.FieldByName('Multiplicity').asCurrency := nMultiplicity;
            CheckCDS.FieldByName('FixEndDate').AsVariant := nFixEndDate;
            CheckCDS.Post;
          end;
        end;
      finally
        RemainsCDS.Filtered := True;
        RemainsCDS.EnableControls;
      end;


      UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger,
        CheckCDS.FindField('PartionDateKindId').AsInteger,
        CheckCDS.FindField('NDSKindId').AsInteger,
        CheckCDS.FindField('DiscountExternalID').AsInteger,
        CheckCDS.FindField('DivisionPartiesID').AsInteger,
        CheckCDS.FindField('isPresent').AsBoolean, nAmount,
        CheckCDS.FieldByName('PriceSale').asCurrency);

      // Update Дисконт в CDS - по всем "обновим" Дисконт
      if (FormParams.ParamByName('DiscountExternalId').Value > 0) and
        (FormParams.ParamByName('isDiscountCommit').Value = False) then
      begin
        DiscountServiceForm.fUpdateCDS_Discount(CheckCDS, lMsg,
          FormParams.ParamByName('DiscountExternalId').Value,
          FormParams.ParamByName('DiscountCardNumber').Value);

        // Проверим цену
        try
          RemainsCDS.DisableControls;
          RemainsCDS.Filtered := false;
          with CheckCDS do
          begin
            First;
            while not Eof do
            begin

              RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                  VarArrayOf([FieldByName('GoodsId').AsInteger,
                  FieldByName('PartionDateKindId').AsVariant,
                  FieldByName('NDSKindId').AsVariant,
                  FieldByName('DiscountExternalID').AsVariant,
                  FieldByName('DivisionPartiesID').AsVariant]), []);

              if (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency > 0) and
                 (RemainsCDS.FieldByName('GoodsDiscountMaxPrice').AsCurrency < FieldByName('PriceSale').AsCurrency) and
                 (FieldByName('Amount').AsCurrency > 0) then
              begin
                ShowMessage('Превышена максимально возможная цена на препарат <' + FieldByName('GoodsName').AsString + '>. Обратитесь к Калининой Кристине...');
              end;

              Next;
            end;
          end;
        finally
          RemainsCDS.Filtered := True;
          RemainsCDS.EnableControls;
        end;
      end;

      CalcTotalSumm;
    End
    else if SoldRegim AND (nAmount < 0) then
      ShowMessage('Для продажи можно указывать только количество больше 0!')
    else if not SoldRegim AND (nAmount = 0) then
      ShowMessage
        ('При изменении количества можно указывать значения не равные 0!');

  finally

    if not FStepSecond and not UnitConfigCDS.FindField('isPairedOnlyPromo').AsBoolean and
       (nGoodsPairSunMainId <> 0) then
    begin
      nAmountPS := 0; nAmountPSJ := 0; nAmountPSM := 0; nJuridicalPSId := 0; cJuridicalPSName := '';
      bBadJuridical := False;
      Bookmark := CheckCDS.GetBookmark;

      // Собираем наличие

      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if (checkCDS.FieldByName('GoodsPairSunMainId').AsInteger = nGoodsPairSunMainId)
          {and (Frac(checkCDS.FieldByName('Amount').AsCurrency) = 0)} then
        begin
          nAmountPS := nAmountPS + checkCDS.FieldByName('Amount').AsCurrency * checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency;
          if checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency > 1 then
          begin
            nAmountPSJ := nAmountPSJ + checkCDS.FieldByName('Amount').AsCurrency * checkCDS.FieldByName('GoodsPairSunAmount').AsCurrency;
            if (checkCDS.FieldByName('JuridicalId').AsInteger <> 0) then
            begin
              if (bBadJuridical = False) and ((nJuridicalPSId = 0) or (nJuridicalPSId = checkCDS.FieldByName('JuridicalId').AsInteger)) then
              begin
                nJuridicalPSId := checkCDS.FieldByName('JuridicalId').AsInteger;
                cJuridicalPSName := checkCDS.FieldByName('JuridicalName').AsString;
              end else bBadJuridical := True;
            end else bBadJuridical := True;
          end
        end;

        if checkCDS.FieldByName('GoodsId').AsInteger = nGoodsPairSunMainId then
          nAmountPSM := nAmountPSM + checkCDS.FieldByName('Amount').AsCurrency;
        CheckCDS.Next;
      end;
      CheckCDS.GotoBookmark(Bookmark);

      if (bBadJuridical = True) or gc_User.Local then
      begin
        nAmountPS := nAmountPS - nAmountPSJ;
        nJuridicalPSId := 0;
        cJuridicalPSName := '';
        nAmountPSJ := 0;
      end;

      nAmountPS := Floor (nAmountPS);

      if nAmountPSM < nAmountPS then
      begin

        cFilterOld := RemainsCDS.Filter;
        RemainsCDS.DisableControls;
        RemainsCDS.Filtered := False;
        RemainsCDS.Filter := 'Remains >= 1 and Id = ' + IntToStr(nGoodsPairSunMainId);
        RemainsCDS.Filtered := True;
        RemainsCDS.First;
        try
          while not RemainsCDS.Eof do
          begin

            if nJuridicalPSId > 0 then
            begin
              spCheck_PairSunAmount.ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').AsVariant;
              spCheck_PairSunAmount.ParamByName('inNDSKindId').Value := RemainsCDS.FieldByName('NDSKindId').AsVariant;
              spCheck_PairSunAmount.ParamByName('inPartionDateKindId').Value := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
              spCheck_PairSunAmount.ParamByName('inDivisionPartiesId').Value := RemainsCDS.FieldByName('DivisionPartiesId').AsVariant;
              spCheck_PairSunAmount.ParamByName('inAmount').Value := RemainsCDS.FieldByName('Remains').AsCurrency;
              spCheck_PairSunAmount.ParamByName('outAmount').Value := 0;
              spCheck_PairSunAmount.ParamByName('outJuridicalId').Value := 0;
              spCheck_PairSunAmount.Execute;
              nRemains := spCheck_PairSunAmount.ParamByName('outAmount').Value;
            end else nRemains := RemainsCDS.FieldByName('Remains').AsCurrency ;

            if nRemains >= 1 then
            begin
              try
                FStepSecond := True;
                if nRemains <= (nAmountPS - nAmountPSM) then
                  nAmount := nRemains
                else nAmount := nAmountPS - nAmountPSM;
                nAmountPSM := nAmountPSM + nAmount;
                SoldRegim := True;
                edAmount.Text := CurrToStr(nAmount);
                SourceClientDataSet := RemainsCDS;
                InsertUpdateBillCheckItems(nJuridicalPSId, cJuridicalPSName);
              finally
                FStepSecond := False;
              end;
            end;
            RemainsCDS.Next;
          end;
        finally
          RemainsCDS.Filtered := False;
          RemainsCDS.Filter := cFilterOld;
          RemainsCDS.Filtered := True;
          RemainsCDS.EnableControls;
          RemainsCDS.Locate('ID', nID, []);
        end;

      end else if nAmountPSM > nAmountPS then
      begin
        try
          while (nAmountPSM <> nAmountPS) and CheckCDS.Locate('GoodsId', nGoodsPairSunMainId, []) do
          begin
            try
              FStepSecond := True;
              if checkCDS.FieldByName('Amount').AsCurrency < (nAmountPSM - nAmountPS) then
                nAmount := - checkCDS.FieldByName('Amount').AsCurrency
              else nAmount := nAmountPS - nAmountPSM;
              nAmountPSM := nAmountPSM + nAmount;
              SoldRegim := False;
              CheckGrid.SetFocus;
              SourceClientDataSet := checkCDS;
              edAmount.Text := CurrToStr(nAmount);
              InsertUpdateBillCheckItems(nJuridicalPSId, cJuridicalPSName);
            finally
              FStepSecond := False;
            end;
          end;
        finally
          CheckCDS.Locate('GoodsId', nID, []);
          RemainsCDS.Locate('ID', nID, []);
        end;
      end;
    end;
  end;
end;

procedure TMainCashForm2.Label4Click(Sender: TObject);
begin
  inherited;

end;

{ ------------------------------------------------------------------------------ }

procedure TMainCashForm2.UpdateRemainsFromDiff(ADiffCDS: TClientDataSet);
var
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  nCheckId: Integer;
  Amount_find: Currency;
  oldFilter: String;
  oldFiltered: Boolean;
begin
  // Если нет расхождений - ничего не делаем
  if ADiffCDS = nil then
    ADiffCDS := DiffCDS;
  if ADiffCDS.isempty then
    exit;
  // отключаем реакции

  Add_Log('Начало обновления остатков');
  // AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  RemainsCDS.DisableControls;
  nCheckId := 0;
  if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
    nCheckId := CheckCDS.FieldByName('GoodsId').AsInteger;
  RemainsCDS.Filtered := false;
  // AlternativeCDS.Filtered := False;
  ADiffCDS.DisableControls;
  CheckCDS.DisableControls;
  oldFilter := CheckCDS.Filter;
  oldFiltered := CheckCDS.Filtered;

  try
    ADiffCDS.First;
    while not ADiffCDS.Eof do
    begin
      // сначала найдем кол-во в чеках
      Amount_find := 0;
      CheckCDS.Filter := 'GoodsId = ' +
        IntToStr(ADiffCDS.FieldByName('Id').AsInteger) +
        ' and PartionDateKindId = ' + IntToSVar(ADiffCDS.FieldByName('PDKINDID').AsVariant) +
        ' and NDSKindId = ' + IntToSVar(ADiffCDS.FieldByName('NDSKindId').AsVariant) +
        ' and DiscountExternalID = ' + IntToSVar(ADiffCDS.FieldByName('DISCEXTID').AsVariant) +
        ' and DivisionPartiesID = ' + IntToSVar(ADiffCDS.FieldByName('DIVPARTID').AsVariant);
      CheckCDS.Filtered := True;
      CheckCDS.First;
      Amount_find := 0;
      while not CheckCDS.Eof do
      begin
        Amount_find := Amount_find + CheckCDS.FieldByName('Amount').asCurrency;
        CheckCDS.Next;
      end;
      CheckCDS.Filter := oldFilter;
      CheckCDS.Filtered := oldFiltered;

      if ADiffCDS.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := ADiffCDS.FieldByName('Id')
          .AsInteger;
        RemainsCDS.FieldByName('PartionDateKindId').AsInteger :=
          ADiffCDS.FieldByName('PDKINDID').AsInteger;
        RemainsCDS.FieldByName('NDSKindId').AsInteger :=
          ADiffCDS.FieldByName('NDSKINDId').AsInteger;
        RemainsCDS.FieldByName('DiscountExternalID').AsVariant :=
          ADiffCDS.FieldByName('DiscountExternalID').AsVariant;
        RemainsCDS.FieldByName('DiscountExternalName').AsVariant :=
          ADiffCDS.FieldByName('DiscountExternalName').AsVariant;
        RemainsCDS.FieldByName('DivisionPartiesID').AsVariant :=
          ADiffCDS.FieldByName('DivisionPartiesID').AsVariant;
        RemainsCDS.FieldByName('DivisionPartiesName').AsVariant :=
          ADiffCDS.FieldByName('DivisionPartiesName').AsVariant;
        RemainsCDS.FieldByName('NDS').AsCurrency :=
          ADiffCDS.FieldByName('NDS').AsCurrency;
        RemainsCDS.FieldByName('GoodsCode').AsInteger :=
          ADiffCDS.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString :=
          ADiffCDS.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency :=
          ADiffCDS.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('Remains').asCurrency :=
          ADiffCDS.FieldByName('Remains').asCurrency;
        RemainsCDS.FieldByName('MCSValue').asCurrency :=
          ADiffCDS.FieldByName('MCSValue').asCurrency;
        RemainsCDS.FieldByName('Reserved').asCurrency :=
          ADiffCDS.FieldByName('Reserved').asCurrency;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([ADiffCDS.FieldByName('Id').AsInteger,
          ADiffCDS.FieldByName('PDKINDID').AsVariant,
          ADiffCDS.FieldByName('NDSKINDId').AsVariant,
          ADiffCDS.FieldByName('DiscountExternalID').AsVariant,
          ADiffCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency :=
            ADiffCDS.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency :=
            ADiffCDS.FieldByName('Remains').asCurrency - Amount_find;
          RemainsCDS.FieldByName('MCSValue').asCurrency :=
            ADiffCDS.FieldByName('MCSValue').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency :=
            ADiffCDS.FieldByName('Reserved').asCurrency;
          RemainsCDS.Post;
        End;
      End;
      ADiffCDS.Next;
    end;

    // AlternativeCDS.First;
    // while Not AlternativeCDS.eof do
    // Begin
    // if ADIffCDS.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
    // Begin
    // if AlternativeCDS.FieldByName('Remains').asCurrency <> ADIffCDS.FieldByName('Remains').asCurrency then
    // Begin
    // AlternativeCDS.Edit;
    // AlternativeCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
    // AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency - Amount_find;
    // AlternativeCDS.Post;
    // End;
    // End;
    // AlternativeCDS.Next;
    // End;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
    // AlternativeCDS.Filtered := true;
    // AlternativeCDS.EnableControls;
    if nCheckId <> 0 then
      CheckCDS.Locate('GoodsId', nCheckId, []);
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered := oldFiltered;
    Add_Log('Конец обновления остатков');
  end;
end;

procedure TMainCashForm2.CalcTotalSumm;
var
  B: TBookmark;  nID : Integer;
Begin

  if (FormParams.ParamByName('LoyaltyChangeSumma').Value +
    FormParams.ParamByName('LoyaltySMSumma').Value) > 0 then
    PromoCodeLoyaltyCalc;

  if FormParams.ParamByName('MobileDiscount').AsFloat > 0 then
    MobileDiscountCalc;

  FTotalSumm := 0;
  FSummLoyalty := 0;
  try
    RemainsCDS.DisableControls;
    nID := RemainsCDS.RecNo;
    RemainsCDS.Filtered := false;
    WITH CheckCDS DO
    Begin
      B := GetBookmark;
      DisableControls;
      try
        First;
        while Not Eof do
        Begin
          if not FieldByName('isPresent').AsBoolean then
            FTotalSumm := FTotalSumm + FieldByName('Summ').asCurrency;
          if not FieldByName('isPresent').AsBoolean and
             RemainsCDS.Locate('ID', FieldByName('GoodsId').AsInteger, []) and
             not RemainsCDS.FieldByName('isStaticCode').AsBoolean then
            FSummLoyalty := FSummLoyalty + FieldByName('Summ').asCurrency;
          Next;
        End;
        GotoBookmark(B);
        FreeBookmark(B);
      finally
        EnableControls;
      end;
    End;
    lblTotalSumm.Caption := FormatFloat(',0.00', FTotalSumm);
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.RecNo := nID;
    RemainsCDS.EnableControls;
  End;

  Check_LoyaltySumma(FSummLoyalty);

End;

procedure TMainCashForm2.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_Tab) and (ActiveControl = lcName) then
    ActiveControl := MainGrid;
end;

procedure TMainCashForm2.lcNameEnter(Sender: TObject);
begin
  inherited;
  SourceClientDataSet := nil;
  isScaner := false;
end;

procedure TMainCashForm2.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_Tab) < 0) and (GetKeyState(VK_CONTROL) < 0) then
  begin
    ActiveControl := CheckGrid;
    exit
  end;
  if GetKeyState(VK_Tab) < 0 then
    ActiveControl := MainGrid;
end;

procedure TMainCashForm2.lcNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) and
    ((SoldRegim AND (lcName.Text = RemainsCDS.FieldByName('GoodsName').AsString)
    ) or (not SoldRegim AND (lcName.Text = CheckCDS.FieldByName('GoodsName')
    .AsString))) then
  begin
    edAmount.Enabled := True;
    if SoldRegim then
    begin
      if RemainsCDS.FieldByName('Remains').asCurrency > 1 then edAmount.Text := '1'
      else edAmount.Text := RemainsCDS.FieldByName('Remains').AsString;
    end
    else
    begin
      if CheckCDS.FieldByName('Amount').asCurrency > 1 then edAmount.Text := '-1'
      else edAmount.Text := '-' + CheckCDS.FieldByName('Amount').AsString;
    end;
    ActiveControl := edAmount;
  end;
  if Key = VK_Tab then
    ActiveControl := MainGrid;
end;

procedure TMainCashForm2.MainColCodeCustomDrawCell
  (Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  AText: string;
begin
  if AViewInfo.Focused then
  begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
  ACanvas.FillRect(AViewInfo.Bounds);
  if not VarIsNull(AViewInfo.GridRecord.Values[MainNotSold60.Index]) and
    AViewInfo.GridRecord.Values[MainNotSold60.Index] then
  begin
    ACanvas.Pen.Color := clBlue;
    ACanvas.Rectangle(Rect(AViewInfo.Bounds.Left + 1, AViewInfo.Bounds.Top + 1,
      AViewInfo.Bounds.Right - 1, AViewInfo.Bounds.Bottom - 2));
  end
  else if not VarIsNull(AViewInfo.GridRecord.Values[MainNotSold.Index]) and
    AViewInfo.GridRecord.Values[MainNotSold.Index] then
  begin
    ACanvas.Pen.Color := clRed;
    ACanvas.Rectangle(Rect(AViewInfo.Bounds.Left + 1, AViewInfo.Bounds.Top + 1,
      AViewInfo.Bounds.Right - 1, AViewInfo.Bounds.Bottom - 2));
  end;
  AText := AViewInfo.GridRecord.Values[AViewInfo.Item.Index];
  ACanvas.TextOut(Max(AViewInfo.Bounds.Left + 2, AViewInfo.Bounds.Right -
    ACanvas.TextWidth(AText) - 4), AViewInfo.Bounds.Top + 2, AText);
  ADone := True;
  // ACanvas.Font.Style :=  ACanvas.Font.Style + [fsStrikeOut];
end;

procedure TMainCashForm2.MainColNameCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  AText: string;
begin

  if not AViewInfo.Focused and UnitConfigCDS.Active then
  begin
    if (FormParams.ParamByName('SPKindId').Value = 4823010) and (AViewInfo.GridRecord.Values[MainPriceSaleOOC1303.Index] <> Null) and
      (AViewInfo.GridRecord.Values[MainPriceSaleOOC1303.Index] < MinCurr(AViewInfo.GridRecord.Values[MainColPrice.Index], AViewInfo.GridRecord.Values[MainPriceSale1303.Index])) and
      ((MinCurr(AViewInfo.GridRecord.Values[MainColPrice.Index], AViewInfo.GridRecord.Values[MainPriceSale1303.Index])/AViewInfo.GridRecord.Values[MainPriceSaleOOC1303.Index]*100.0 - 100) >
      UnitConfigCDS.FindField('DeviationsPrice1303').AsCurrency) then
      ACanvas.Brush.Color := TColor($0083D3FA);
  end;

  if AViewInfo.Focused then
  begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end else if (AViewInfo.GridRecord.Values[MainFixPercent.Index] <> Null) and (AViewInfo.GridRecord.Values[MainFixPercent.Index] <> 0) or
              (AViewInfo.GridRecord.Values[MainFixDiscount.Index] <> Null) and (AViewInfo.GridRecord.Values[MainFixDiscount.Index] <> 0) or
              (AViewInfo.GridRecord.Values[MainGridPriceChange.Index] <> Null) and (AViewInfo.GridRecord.Values[MainGridPriceChange.Index] <> 0) then
  begin
    ACanvas.Brush.Color := TColor($FFD784);
  end;

  ACanvas.FillRect(AViewInfo.Bounds);
  if not VarIsNull(AViewInfo.GridRecord.Values[MainisBanFiscalSale.Index]) and
    AViewInfo.GridRecord.Values[MainisBanFiscalSale.Index] then
  begin
    ACanvas.Pen.Color := TColor($00A5FF);
    ACanvas.Line(Point(AViewInfo.Bounds.Left + 1, AViewInfo.Bounds.Bottom - 5),
      Point(AViewInfo.Bounds.Right - 1, AViewInfo.Bounds.Bottom - 5));
  end;

  AText := AViewInfo.GridRecord.Values[AViewInfo.Item.Index];
  ACanvas.TextOut(AViewInfo.Bounds.Left + 2, AViewInfo.Bounds.Top + 2, AText);
  ADone := True;
end;

procedure TMainCashForm2.MainColPriceNightGetDisplayText
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  inherited;
  AText := FormatCurr(',0.00',
    CalcTaxUnitNightPriceGrid(ARecord.Values[MainColPrice.Index],
    ARecord.Values[MainColPrice.Index]));
end;

procedure TMainCashForm2.MainColReservedGetDisplayText
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

procedure TMainCashForm2.MainFixPercentStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if UnitConfigCDS.Active and
     (FormParams.ParamByName('SPKindId').Value = 4823010) and (ARecord.Values[MainPriceSaleOOC1303.Index] <> Null) and
     (ARecord.Values[MainPriceSaleOOC1303.Index] < MinCurr(ARecord.Values[MainColPrice.Index], ARecord.Values[MainPriceSale1303.Index])) and
     ((MinCurr(ARecord.Values[MainColPrice.Index], ARecord.Values[MainPriceSale1303.Index])/ARecord.Values[MainPriceSaleOOC1303.Index]*100.0 - 100) >
     UnitConfigCDS.FindField('DeviationsPrice1303').AsCurrency) then
     FStyle.Color := TColor($0083D3FA);

  if (ARecord.Values[MainFixPercent.Index] <> Null) AND (ARecord.Values[MainFixPercent.Index] <> 0) OR
     (ARecord.Values[MainFixDiscount.Index] <> Null) AND (ARecord.Values[MainFixDiscount.Index] <> 0) OR
     (ARecord.Values[MainGridPriceChange.Index] <> Null) AND (ARecord.Values[MainGridPriceChange.Index] <> 0) then
    FStyle.Color := TColor($FFD784);
  AStyle := FStyle;
end;

procedure TMainCashForm2.MainGridPriceChangeNightGetDisplayText
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  inherited;
  if ARecord.Values[MainGridPriceChange.Index] <> Null then
    AText := FormatCurr(',0.00',
      CalcTaxUnitNightPriceGrid(ARecord.Values[MainColPrice.Index],
      ARecord.Values[MainGridPriceChange.Index]));
end;

procedure TMainCashForm2.MainisGoodsAnalogGetProperties
  (Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := cxEditRepository1.Items[0].Properties;
end;

procedure TMainCashForm2.pm_CheckClick(Sender: TObject);
begin
  SetBlinkCheck(True);
  //
  if fBlinkCheck = True then
    actOpenCheckVIP_Error.Execute
  else
    actCheck.Execute;
end;

procedure TMainCashForm2.pm_CheckHelsiAllUnitClick(Sender: TObject);
begin
  with TCheckHelsiSignAllUnitForm.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainCashForm2.pm_CheckHelsiClick(Sender: TObject);
begin
  with TCheckHelsiSignForm.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainCashForm2.MainGridDBTableViewCanFocusRecord
  (Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  var AAllow: Boolean);
begin
  inherited;

  if AAllow and fBanCash then
    ShowMessage
      ('Уважаемые коллеги, вы не поставили отметку времени прихода и ухода в график (Ctrl+T), исходя из персонального графика работы (время вводится с шагом 30 мин)');
end;

procedure TMainCashForm2.MainGridDBTableViewFocusedRecordChanged
  (Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord
  : TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
  Cnt: Integer;
begin

  actSetFilterExecute(nil); // Установка фильтров для товара

  if MainGrid.IsFocused or lcName.IsFocused then
  begin
    if not RemainsCDS.isempty and
      (RemainsCDS.FieldByName('Color_calc').AsInteger <> 0) then
    begin
      edAmount.Style.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleDisabled.Color := RemainsCDS.FieldByName('Color_calc')
        .AsInteger;
      edAmount.StyleFocused.Color := RemainsCDS.FieldByName('Color_calc')
        .AsInteger;
      edAmount.StyleHot.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
    end
    else
    begin
      edAmount.Style.Color := clWhite;
      edAmount.StyleDisabled.Color := clBtnFace;
      edAmount.StyleFocused.Color := clWhite;
      edAmount.StyleHot.Color := clWhite;
    end;
  end;

  if MainGrid.IsFocused then
    exit;

  Cnt := Sender.ViewInfo.RecordsViewInfo.VisibleCount;
  Sender.Controller.TopRecordIndex := Sender.Controller.FocusedRecordIndex -
    Round((Cnt + 1) / 2);
end;

procedure TMainCashForm2.MainGridDBTableViewStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  FStyle.Assign(MainGridDBTableView.Styles.Content);
  if UnitConfigCDS.Active and
    ((FormParams.ParamByName('SPKindId').Value = 4823010) or (AItem.Index = MainPriceSaleOOC1303.Index) or (AItem.Index = MainPriceSale1303.Index)) and
    (ARecord.Values[MainPriceSaleOOC1303.Index] <> Null) and
    (ARecord.Values[MainPriceSaleOOC1303.Index] < MinCurr(ARecord.Values[MainColPrice.Index], ARecord.Values[MainPriceSale1303.Index])) and
    ((MinCurr(ARecord.Values[MainColPrice.Index], ARecord.Values[MainPriceSale1303.Index])/ARecord.Values[MainPriceSaleOOC1303.Index]*100.0 - 100) >
    UnitConfigCDS.FindField('DeviationsPrice1303').AsCurrency)
     then
    FStyle.Color := TColor($0083D3FA);
  AStyle := FStyle;
end;

// процедура обновляет параметры для введения нового чека
procedure TMainCashForm2.N10Click(Sender: TObject);
begin
  inherited;
  // отправка сообщения об обновлении только остатков
  PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 40);

end;

procedure TMainCashForm2.N1Click(Sender: TObject);
begin
  inherited;
  // отправка сообщения об обновлении всех данных
  PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 30);
end;

procedure TMainCashForm2.N22Click(Sender: TObject);
begin
  with TEmployeeScheduleCashForm.Create(nil) do
  try
    EmployeeScheduleCashExecute;
    SetBanCash(True);
  finally
    Free;
  end;
end;

procedure TMainCashForm2.NewCheck(ANeedRemainsRefresh: Boolean = True);
begin
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('CheckOldId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('ManagerName').Value := '';
  FormParams.ParamByName('BayerName').Value := '';
  FormParams.ParamByName('ManagerName').Value := '';
  // ***20.07.16
  FormParams.ParamByName('DiscountExternalId').Value := 0;
  FormParams.ParamByName('DiscountExternalName').Value := '';
  FormParams.ParamByName('DiscountCardNumber').Value := '';
  // ***16.08.16
  FormParams.ParamByName('BayerPhone').Value := '';
  FormParams.ParamByName('ConfirmedKindName').Value := '';
  FormParams.ParamByName('InvNumberOrder').Value := '';
  FormParams.ParamByName('ConfirmedKindClientName').Value := '';
  FormParams.ParamByName('UserSession').Value := gc_User.Session;
  FormParams.ParamByName('SummCard').Value := 0;
  // ***10.04.17
  FormParams.ParamByName('PartnerMedicalId').Value := 0;
  FormParams.ParamByName('PartnerMedicalName').Value := '';
  FormParams.ParamByName('Ambulance').Value := '';
  FormParams.ParamByName('MedicSP').Value := '';
  FormParams.ParamByName('InvNumberSP').Value := '';
  FormParams.ParamByName('OperDateSP').Value := Now;
  // ***15.06.17
  FormParams.ParamByName('SPTax').Value := 0;
  FormParams.ParamByName('SPKindId').Value := 0;
  FormParams.ParamByName('SPKindName').Value := '';
  FormParams.ParamByName('MedicalProgramSPId').Value := 0;
  // ***05.02.18
  FormParams.ParamByName('PromoCodeID').Value := 0;
  FormParams.ParamByName('PromoCodeGUID').Value := '';
  FormParams.ParamByName('PromoName').Value := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value := 0.0;
  // ***27.06.18
  FormParams.ParamByName('ManualDiscount').Value := 0;
  // ***02.11.18
  FormParams.ParamByName('SummPayAdd').Value := 0;
  // ***14.01.19
  FormParams.ParamByName('MemberSPID').Value := 0;
  FormParams.ParamByName('MemberSP').Value := '';
  // ***28.01.19
  FormParams.ParamByName('SiteDiscount').Value := 0;
  // ***20.02.19
  FormParams.ParamByName('BankPOSTerminal').Value := 0;
  // ***25.02.19
  FormParams.ParamByName('JackdawsChecksCode').Value := 0;
  // ***02.04.19
  FormParams.ParamByName('RoundingDown').Value := True;
  // ***25.04.19
  FormParams.ParamByName('HelsiID').Value := '';
  FormParams.ParamByName('HelsiIDList').Value := '';
  FormParams.ParamByName('HelsiName').Value := '';
  FormParams.ParamByName('HelsiQty').Value := 0;
  FormParams.ParamByName('HelsiProgramId').Value := '';
  FormParams.ParamByName('HelsiProgramName').Value := '';
  FormParams.ParamByName('ConfirmationCodeSP').Value := '';
  FormParams.ParamByName('HelsiPartialPrescription').Value := False;
  FormParams.ParamByName('HelsiSkipDispenseSign').Value := False;
  // **13.05.19
  FormParams.ParamByName('PartionDateKindId').Value := 0;
  // **07.11.19
  FormParams.ParamByName('LoyaltySignID').Value := 0;
  FormParams.ParamByName('LoyaltyText').Value := '';
  FormParams.ParamByName('LoyaltyChangeSumma').Value := 0;
  FormParams.ParamByName('LoyaltyShowMessage').Value := True;
  // **08.01.20
  FormParams.ParamByName('LoyaltySMID').Value := 0;
  FormParams.ParamByName('LoyaltySMText').Value := '';
  FormParams.ParamByName('LoyaltySMSumma').Value := 0;
  FormParams.ParamByName('Price1303').Value := 0;
  // ***16.08.20
  FormParams.ParamByName('DivisionPartiesID').Value := 0;
  FormParams.ParamByName('DivisionPartiesName').Value := '';
  // ***01.10.20
  FormParams.ParamByName('LoyaltyMovementId').Value := 0;
  FormParams.ParamByName('LoyaltyPresent').Value := False;
  FormParams.ParamByName('LoyaltyAmountPresent').Value := 0;
  FormParams.ParamByName('LoyaltyGoodsId').Value := 0;
  FormParams.ParamByName('AddPresent').Value := False;
  FormParams.ParamByName('MedicForSale').Value := '';
  FormParams.ParamByName('BuyerForSale').Value := '';
  FormParams.ParamByName('BuyerForSalePhone').Value := '';
  FormParams.ParamByName('DistributionPromoList').Value := '';
  FormParams.ParamByName('isBanAdd').Value := False;
  FormParams.ParamByName('MedicKashtanId').Value := 0;
  FormParams.ParamByName('MedicKashtanName').Value := '';
  FormParams.ParamByName('MemberKashtanId').Value := 0;
  FormParams.ParamByName('MemberKashtanName').Value := '';
  FormParams.ParamByName('isCorrectMarketing').Value := False;
  FormParams.ParamByName('isCorrectIlliquidAssets').Value := False;
  FormParams.ParamByName('isDoctors').Value := False;
  FormParams.ParamByName('isDiscountCommit').Value := False;
  FormParams.ParamByName('isManual').Value := False;
  FormParams.ParamByName('Category1303Id').Value := 0;
  FormParams.ParamByName('Category1303Name').Value := '';
  FormParams.ParamByName('isAutoVIPforSales').Value := False;
  FormParams.ParamByName('isPaperRecipeSP').Value := False;
  FormParams.ParamByName('MobileDiscount').Value := 0;

  FFiscalNumber := '';
  pnlVIP.Visible := false;
  edPrice.Value := 0.0;
  edPrice.Visible := false;
  edDiscountAmount.Value := 0.0;
  edDiscountAmount.Visible := false;
  lblPrice.Visible := false;
  lblAmount.Visible := false;
  pnlDiscount.Visible := false;
  pnlSP.Visible := false;
  btnGoodsSPReceiptList.Visible := false;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  ceSummCard.Value := 0;
  plSummCard.Visible := false;
  CheckCDS.DisableControls;
  chbNotMCS.Checked := false;
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  pnlPromoCodeLoyalty.Visible := false;
  lblPromoCodeLoyalty.Caption := '';
  edPromoCodeLoyaltySumm.Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  edPromoCode.Text := '';
  pnlSiteDiscount.Visible := false;
  edSiteDiscount.Value := 0;
  DiscountServiceForm.gCode := 0;
  DiscountServiceForm.isBeforeSale := False;
  pnlPosition.Visible := false;
  cbMorionFilter.Enabled := True;
  cbMorionFilter.Checked := False;
  pnlInfo.Visible := False;
  MessageByTime := False;

  pnlLoyaltySaveMoney.Visible := false;
  lblLoyaltySMBuyer.Caption := '';
  edLoyaltySMSummaRemainder.Value := 0;
  edLoyaltySMSumma.Value := 0;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;

  MainCashForm.SoldRegim := True;
  MainCashForm.actSpec.Checked := false;
  MainCashForm.actSpecCorr.Checked := false;
  MainCashForm.actDoctors.Checked := false;
  if Assigned(MainCashForm.Cash) AND MainCashForm.Cash.AlwaysSold then
    MainCashForm.Cash.AlwaysSold := false;

  if Self.Visible then
  Begin
    // ShowMessage('При работе');
  End
  else
  Begin
    // ShowMessage('При старте');
    actRefreshAllExecute(nil);
  End;
  CalcTotalSumm;
  edAmount.Text := '0';
  isScaner := false;
  ActiveControl := lcName;

  // Ночные скидки
  SetTaxUnitNight;
  // Отмена фильтров
  ClearFilterAll;
  // Если грузили СП
  MedicalProgramSPGoodsCDS.Close;
  // очистить рецепт
  ClearReceipt1303
end;

procedure TMainCashForm2.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if not CheckCDS.isempty then
  Begin
    CanClose := false;
    ShowMessage('Сначала обнулите чек.');
  End
  else
    CanClose := MessageDlg('Вы действительно хотите выйти?', mtConfirmation,
      [mbYes, mbCancel], 0) = mrYes;
  if CanClose then
  Begin
    EmployeeWorkLog_LogOut;
    try
      if not gc_User.Local then
      Begin
        actRefreshAllExecute(nil);
        spDelete_CashSession.Execute;
      End
      else
      begin
        WaitForSingleObject(MutexRemains, INFINITE);
        try
          SaveLocalData(RemainsCDS, Remains_lcl);
        finally
          ReleaseMutex(MutexRemains);
        end;
        // WaitForSingleObject(MutexAlternative, INFINITE);
        // try
        // SaveLocalData(AlternativeCDS,Alternative_lcl);
        // finally
        // ReleaseMutex(MutexAlternative);
        // end;
        WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
        try
          SaveLocalData(ExpirationDateCDS, GoodsExpirationDate_lcl);
        finally
          ReleaseMutex(MutexGoodsExpirationDate);
        end;
      end;
    Except
    end;
    PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 9); // только 2 форма
  End;

  if not gc_User.Local then
    UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TMainCashForm2.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  CloseMutex;
  FStyle.Free;
end;

procedure TMainCashForm2.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if fPrint then Exit;
  fPrint := True;
  try
    if (Key = VK_Tab) and (CheckGrid.IsFocused) then
      if isScaner = True then
        ActiveControl := ceScaner
      else
        ActiveControl := lcName;

    if (Key = VK_ADD) AND (Shift = []) {or ((Key = VK_RETURN) AND (ssShift in Shift))} then
    Begin
      Key := 0;
      fShift := ssShift in Shift;
      actPutCheckToCashExecute(nil);
    End;

  finally
    fPrint := False;
  end;
end;

procedure TMainCashForm2.ParentFormShow(Sender: TObject);
  procedure SetVIPCDS;
  var
    C: TComponent;
  Begin
    for C in VIPForm do
    begin
      if (C is TClientDataSet) then
      Begin
        with (C as TClientDataSet) do
        begin
          if sametext(Name, 'MasterCDS') then
            VipCDS := (C as TClientDataSet)
          else if sametext(Name, 'ClientDataSet1') then
            VIPListCDS := (C as TClientDataSet);
        end;
      End;
    end;
  End;

begin
  inherited;
  if not gc_User.Local then
  Begin
    VIPForm := TdsdFormStorageFactory.GetStorage.Load('TCheckVIPForm');
    WriteComponentResFile(VipDfm_lcl, VIPForm);
    SetVIPCDS;
  End
  else
  Begin
    Application.CreateForm(TParentForm, VIPForm);
    VIPForm.FormClassName := 'TCheckVIPForm';
    ReadComponentResFile(VipDfm_lcl, VIPForm);
    VIPForm.AddOnFormData.isAlwaysRefresh := false;
    VIPForm.AddOnFormData.isSingle := True;
    VIPForm.isAlreadyOpen := True;
    SetVIPCDS;
    VipCDS.LoadFromFile(vip_lcl);
    VIPListCDS.LoadFromFile(vipList_lcl);
  End;
  FPUSHEnd := Now;
  if FPUSHStart then
    TimerPUSH.Enabled := True;
  pm_CheckHelsiAllUnit.Visible := false;
  if not gc_User.Local then
  Begin
    spGet_User_IsAdmin.Execute;
    pm_CheckHelsiAllUnit.Visible := spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True;
    pmUser_expireDate.Visible := spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True;
  End;
  actOverdueJournal.Enabled := UnitConfigCDS.FieldByName('DividePartionDate').AsBoolean;
  actOverdueJournal.Visible := UnitConfigCDS.FieldByName('DividePartionDate').AsBoolean;
  SaveUnitConfig;
  if not UnitConfigCDS.FieldByName('isShowActiveAlerts').AsBoolean then
  begin
    lblActiveAlerts.Visible := False;
  end else TimerActiveAlerts.Enabled := True;
end;

// что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
procedure TMainCashForm2.Add_Log_XML(AMessage: String);
var
  F: TextFile;
begin
  try
    AssignFile(F, ChangeFileExt(Application.ExeName, '_log.xml'));
    if not fileExists(ChangeFileExt(Application.ExeName, '_log.xml')) then
    begin
      Rewrite(F);
      Writeln(F, '<?xml version="1.0" encoding="Windows-1251"?>');
    end
    else
      Append(F);
    //
    try
      Writeln(F, AMessage);
    finally
      CloseFile(F);
    end;
  except
  end;
end;

function TMainCashForm2.PutCheckToCash(SalerCash, SalerCashAdd: Currency;
  PaidType: TPaidType; var AZReport : Integer; var AFiscalNumber, ACheckNumber: String;
  APOSTerminalCode: Integer = 0; isFiscal: Boolean = True): Boolean;
var
  str_log_xml, cResult: String;
  Disc, nSumAll: Currency;
  I, PosDisc: Integer;
  pPosTerm: IPos;
  n : Int64;
  { ------------------------------------------------------------------------------ }
  function PutOneRecordToCash: Boolean; // Продажа одного наименования
  var
    сAccommodationName: string;
    nDisc: Currency;
  begin
    // посылаем строку в кассу и если все OK, то ставим метку о продаже
    if not Assigned(Cash) or Cash.AlwaysSold then
      Result := True
    else if not SoldParallel then
      with CheckCDS do
      begin
        if isFiscal or FieldByName('AccommodationName').IsNull then
          сAccommodationName := ''
        else
          сAccommodationName := ' ' + FieldByName('AccommodationName').Text;
        if ((FormParams.ParamByName('LoyaltyChangeSumma').Value +
          FormParams.ParamByName('LoyaltySMSumma').Value) > 0) or
          (Self.FormParams.ParamByName('InvNumberSP').Value = '') and
          (DiscountServiceForm.gCode = 0) and not UnitConfigCDS.FieldByName
          ('PermanentDiscountID').IsNull and
          (UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency > 0)
        then
        begin
          if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
          begin
            Result := Cash.SoldFromPC(FieldByName('GoodsCode').AsInteger,
              AnsiUpperCase(FieldByName('GoodsName').Text + сAccommodationName),
              FieldByName('UKTZED').AsString,
              FieldByName('Amount').asCurrency,
              FieldByName('PricePartionDate').asCurrency,
              FieldByName('NDS').asCurrency);
            nDisc := FieldByName('Summ').asCurrency -
              GetSummFull(FieldByName('Amount').asCurrency,
              FieldByName('PricePartionDate').asCurrency);
          end
          else
          begin

            Result := Cash.SoldFromPC(FieldByName('GoodsCode').AsInteger,
              AnsiUpperCase(FieldByName('GoodsName').Text + сAccommodationName),
              FieldByName('UKTZED').AsString,
              FieldByName('Amount').asCurrency,
              FieldByName('PriceSale').asCurrency,
              FieldByName('NDS').asCurrency);
            nDisc := FieldByName('Summ').asCurrency -
              GetSummFull(FieldByName('Amount').asCurrency,
              FieldByName('PriceSale').asCurrency);
          end;
          if nDisc <> 0 then
            Cash.DiscountGoods(nDisc);
        end
        else
          Result := Cash.SoldFromPC(FieldByName('GoodsCode').AsInteger,
            AnsiUpperCase(FieldByName('GoodsName').Text + сAccommodationName),
            FieldByName('UKTZED').AsString,
            FieldByName('Amount').asCurrency,
            FieldByName('Price').asCurrency,
            FieldByName('NDS').asCurrency);
      end
    else
      Result := True;
  end;

{ ------------------------------------------------------------------------------ }
begin
  Result := False;
  ACheckNumber := '';
  AZReport := 0;
  FErrorRRO := False;
  try
    try
      if Assigned(Cash) AND NOT Cash.AlwaysSold and isFiscal then
      begin
        AFiscalNumber := Cash.FiscalNumber;
        if not TryStrToInt64(AFiscalNumber, n) OR (Length(AFiscalNumber) < 10) then
        begin
          FErrorRRO := True;
          if ShowPUSHMessageCash('После проведения предыдущего чека возникла ошибка…'#13#10#13#10 +
                                 '!!! Повторите пробитие чека после перезагрузки РРО и ПК !!!'#13#10#13#10 +
                                 'Если не пройдет - сделайте X отчет и повторите пробитие или'#13#10 +
                                 'Аннулируйте или закройте чек через FpWinX (раздел Продажи) или'#13#10 +
                                 'Отсоедините/Подключите кабель соединяющий РРО с ПК при выключенном РРО', cResult) then actPutCheckToCashExecute(Nil);

          Exit;
        end;
        FErrorRRO := False;
      end
      else
        AFiscalNumber := '';
      Disc := 0;
      PosDisc := 0;
      if actSpec.Checked then
        isFiscal := false;
      if not isFiscal and Assigned(Cash) then
        Cash.AlwaysSold := false;

      // Контроль чека до печати
      if (FormParams.ParamByName('LoyaltyChangeSumma').Value +
        FormParams.ParamByName('LoyaltySMSumma').Value) <> 0 then
      begin
        nSumAll := 0;
        CheckCDS.First;
        while not CheckCDS.Eof do
        begin
          if not CheckCDS.FieldByName('isPresent').AsVariant then
          begin
            if CheckCDS.FieldByName('PricePartionDate').asCurrency > 0 then
              nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PricePartionDate').asCurrency,
                FormParams.ParamByName('RoundingDown').Value)
            else
              nSumAll := nSumAll + GetSumm(CheckCDS.FieldByName('Amount')
                .asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency,
                FormParams.ParamByName('RoundingDown').Value);
          end;
          CheckCDS.Next;
        end;
        if nSumAll < (FormParams.ParamByName('LoyaltyChangeSumma').Value +
          FormParams.ParamByName('LoyaltySMSumma').Value) then
        begin
          ShowMessage('Cумма отпускаемого товара ' + FormatCurr(',0.00',
            nSumAll) + ' должна быть больше суммы скидки ' + FormatCurr(',0.00',
            (FormParams.ParamByName('LoyaltyChangeSumma').Value +
            FormParams.ParamByName('LoyaltySMSumma').Value)) + '.');
          exit;
        end;

      end
      else if not((Self.FormParams.ParamByName('InvNumberSP').Value = '') and
        (DiscountServiceForm.gCode = 0) and not UnitConfigCDS.FieldByName
        ('PermanentDiscountID').IsNull and
        (UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency > 0))
      then
      begin
        with CheckCDS do
        begin
          // Определяем сумму скидки наценки (скидки)
          First;
          while not Eof do
          begin
            if not CheckCDS.FieldByName('isPresent').AsVariant then
            begin
              if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
                Disc := Disc + (FieldByName('Summ').asCurrency -
                  GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency));

              if (FieldByName('Multiplicity').asCurrency <> 0) and
                (FieldByName('Price').asCurrency <> FieldByName('PriceSale')
                .asCurrency) and
                (trunc(FieldByName('Amount').asCurrency /
                FieldByName('Multiplicity').asCurrency * 100) mod 100 <> 0) then
              begin
                ShowMessage('Для медикамента '#13#10 + FieldByName('GoodsName')
                  .AsString +
                  #13#10'установлена кратность при отпуске со скидкой.'#13#10#13#10
                  + 'Отпускать со скидкой разрешено кратно ' +
                  FieldByName('Multiplicity').AsString + ' упаковки.');
                exit;
              end;
            end;
            Next;
          end;

          // Если есть скидка находим товар с суммой больше скидки
          if Disc < 0 then
          begin
            Last;
            while not BOF do
            begin
              if not CheckCDS.FieldByName('isPresent').AsVariant then
              begin
                if (GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency) + Disc) > 0 then
                begin
                  PosDisc := RecNo;
                  Break;
                end;
              end;
              Prior;
            end;

            // Если есть скидка и нет товара с суммой больше скидки то ищем товар равный скидке
            if (Disc < 0) and (PosDisc = 0) then
            begin
              Last;
              while not BOF do
              begin
                if not CheckCDS.FieldByName('isPresent').AsVariant then
                begin
                  if (GetSummFull(FieldByName('Amount').asCurrency,
                    FieldByName('Price').asCurrency) + Disc) >= 0 then
                  begin
                    PosDisc := RecNo;
                    Break;
                  end;
                end;
                Prior;
              end;
            end;
          end
          else if Disc > 0 then
          begin
            Last;
            while not BOF do
            begin
              if CheckCDS.FieldByName('isPresent').AsVariant then
              begin
                if GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency) > Disc then
                begin
                  PosDisc := RecNo;
                  Break;
                end;
              end;
              Prior;
            end;
          end;

          if (Disc <> 0) and (PosDisc = 0) then
          begin
            ShowMessage('Сумма скидки (наценки) по чеку:' + FormatCurr('0.00',
              Disc) + #13#10 +
              'В чеке не найден товар на который можно применить скидку (наценку) по округлению копеек...');
            exit;
          end;
        end;
      end;

      // Подключились к POS-терминалу
      if (PaidType <> ptMoney) and (APOSTerminalCode <> 0) and
        (iniPosType(APOSTerminalCode) <> '') then
      begin
        try
          Add_Log('Подключение к POS терминалу');
          try
            pPosTerm := TPosFactory.GetPos(APOSTerminalCode);
          except
            ON E: Exception do
              Add_Log('Exception: ' + E.Message);
          end;

          if pPosTerm = Nil then
          begin
            ShowMessage
              ('Внимание! Программа не может подключиться к POS-терминалу.' +
              #13 + 'Проверьте подключение и повторите попытку печети!');
            exit;
          end;

          if not PayPosTerminal(pPosTerm, MainCashForm.ASalerCash) then
            exit;
        finally
          if pPosTerm <> Nil then
            pPosTerm := Nil;
        end;
      end;

      if isFiscal then
        Add_Check_History;
      if isFiscal then
        Start_Check_History(FTotalSumm, SalerCashAdd, PaidType);

      if isFiscal and not actSpec.Checked and not actSpecCorr.Checked then
        Check_Loyalty(FSummLoyalty);

      if isFiscal { and not actSpec.Checked and not actSpecCorr.Checked } then
        Check_LoyaltySM(FSummLoyalty);

      // Непосредственно печать чека
      str_log_xml := '';
      I := 0;
      Result := not Assigned(Cash) or Cash.AlwaysSold or
        Cash.OpenReceipt(isFiscal, actSpec.Checked);
      with CheckCDS do
      begin
        First;
        while not Eof do
        begin
          if Result and not CheckCDS.FieldByName('isPresent').AsVariant then
          begin
            if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
            begin
              // послали строку в кассу
              Result := PutOneRecordToCash;
              // сохранили строку в лог
              I := I + 1;
              if str_log_xml <> '' then
                str_log_xml := str_log_xml + #10 + #13;
              try
                str_log_xml := str_log_xml + '<Items num="' + IntToStr(I) + '">'
                  + '<GoodsCode>"' + FieldByName('GoodsCode').AsString +
                  '"</GoodsCode>' + '<GoodsName>"' +
                  AnsiUpperCase(FieldByName('GoodsName').Text) + '"</GoodsName>'
                  + '<Amount>"' + FloatToStr(FieldByName('Amount').asCurrency) +
                  '"</Amount>' + '<Price>"' +
                  FloatToStr(FieldByName('Price').asCurrency) + '"</Price>' +
                  '<List_UID>"' + FieldByName('List_UID').AsString +
                  '"</List_UID>' + '<Discount>"' +
                  CurrToStr(FieldByName('Summ').asCurrency -
                  GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency)) + '"</Discount>' +
                  '</Items>';
              except
                str_log_xml := str_log_xml + '<Items="' + IntToStr(I) + '">' +
                  '<GoodsCode>"' + FieldByName('GoodsCode').AsString +
                  '"</GoodsCode>' + '<GoodsName>"???"</GoodsName>' +
                  '<List_UID>"' + FieldByName('List_UID').AsString +
                  '"</List_UID>' + '<Discount>"' +
                  CurrToStr(FieldByName('Summ').asCurrency -
                  GetSummFull(FieldByName('Amount').asCurrency,
                  FieldByName('Price').asCurrency)) + '"</Discount>' +
                  '</Items>';
              end;
              if (Disc <> 0) and (PosDisc = RecNo) then
              begin
                if Assigned(Cash) and not Cash.AlwaysSold then
                  Cash.DiscountGoods(Disc);
                Disc := 0;
              end;
            end;
          end;
          Next;
        end;
        if Result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          if (Disc <> 0) and (PosDisc = 0) then
            Result := Cash.DiscountGoods(Disc);
          if not isFiscal or
            (Round(FTotalSumm * 100) = Round(Cash.SummaReceipt * 100)) then
          begin
            if Result then
              Result := Cash.SubTotal(True, True, 0, 0);
            if Result then
              Result := Cash.TotalSumm(SalerCash, SalerCashAdd, PaidType);
            if Result and (FormParams.ParamByName('LoyaltySignID').Value <> 0)
              and (FormParams.ParamByName('LoyaltyText').Value <> '') then
              Cash.PrintFiscalText(FormParams.ParamByName('LoyaltyText').Value);
            if Result and (FormParams.ParamByName('LoyaltySMID').Value <> 0) and
              (FormParams.ParamByName('LoyaltySMText').Value <> '') then
              Cash.PrintFiscalText
                (FormParams.ParamByName('LoyaltySMText').Value);
            if Result then
              Result := Cash.CloseReceiptEx(ACheckNumber); // Закрыли чек
            if Result then AZReport := Cash.ZReport;
            if Result and isFiscal then
              Finish_Check_History(FTotalSumm);
          end
          else
          begin
            Result := false;
            Add_Log_RRO('Ошибка. Сумма чека ' + CurrToStr(FTotalSumm) +
              ' не равна сумме товара в фискальном чеке ' +
              CurrToStr(Cash.SummaReceipt) + '.'#13#10 +
              'Чек анулирован...'#13#10'(Перезагрузите свой кассовый аппарат и перезайдите в программу, ' +
              'если перезагрузка РРО не помогла переключите USB кабель на стороне выключенного РРО, ' +
              'соединительный разьем имеет форму трапеции)');
            Cash.Anulirovt;
          end
        end
        else if not Result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          Add_Log_RRO('Ошибка печати фискального чека.'#13#10 +
            'Чек анулирован...');
          Cash.Anulirovt;
        end;
      end;
    except
      Result := false;
      raise;
    end;
  finally
    if Assigned(Cash) then
      Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  end;

  //
  // что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
  Add_Log_XML('<Head now="' + FormatDateTime('YYYY.MM.DD hh:mm:ss', Now) + '">'
    + #10 + #13 + '<CheckNumber>"' + ACheckNumber + '"</CheckNumber>' +
    '<FiscalNumber>"' + AFiscalNumber + '"</FiscalNumber>' + '<Summa>"' +
    FloatToStr(SalerCash) + '"</Summa>' + #10 + #13 + str_log_xml + #10 + #13 +
    '</Head>');
end;

// Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
function TMainCashForm2.fGetCheckAmountTotal(AGoodsId: Integer = 0;
  AAmount: Currency = 0): Currency;
var
  GoodsId: Integer;
begin
  Result := AAmount;
  // Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  if CheckCDS.isempty then
  Begin
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
    exit;
  End;

  // открючаем реакции
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;

  try
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if (CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) then
      Begin
        if (AAmount = 0) or
          ((AAmount < 0) AND (abs(AAmount) >= CheckCDS.FieldByName('Amount')
          .asCurrency)) then
          Result := 0
        else
          Result := CheckCDS.FieldByName('Amount').asCurrency + AAmount;
      End;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.Filtered := True;
    if AGoodsId <> 0 then
      CheckCDS.Locate('GoodsId', AGoodsId, []);
    CheckCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.UpdateRemainsFromCheck(AGoodsId: Integer = 0;
  APartionDateKindId: Integer = 0; ANDSKindId: Integer = 0; ADiscountExternalID: Integer = 0;
  ADivisionPartiesID: Integer = 0; AisPresent: Boolean = False;
  AAmount: Currency = 0; APriceSale: Currency = 0; ALoadVipCheck : Boolean = False);
var
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  nDelta: Currency;
  oldFilterExpirationDate: String;
  // lPriceSale : Currency;
begin
  // Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.Filtered := false;
  if CheckCDS.isempty then
  Begin
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
    exit;
  End;
  // открючаем реакции
  // AlternativeCDS.DisableControls;
  ExpirationDateCDS.DisableControls;
  oldFilterExpirationDate := ExpirationDateCDS.Filter;
  RemainsCDS.AfterScroll := Nil;
  GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
  PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
  NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
  DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
  DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := false;
  // AlternativeCDS.Filtered := False;
  try
    CheckCDS.First;
    if not ALoadVipCheck then
    while not CheckCDS.Eof do
    begin
      if (AGoodsId = 0) or ((CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId)
        and (CheckCDS.FieldByName('PartionDateKindId').AsInteger = APartionDateKindId)
        and (CheckCDS.FieldByName('NDSKindId').AsInteger = ANDSKindId)
        and (CheckCDS.FieldByName('DiscountExternalID').AsInteger = ADiscountExternalID)
        and (CheckCDS.FieldByName('DivisionPartiesID').AsInteger = ADivisionPartiesID)
        and (CheckCDS.FieldByName('PriceSale').asCurrency = APriceSale)
        and (CheckCDS.FieldByName('isPresent').AsBoolean = AisPresent)) then
      Begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindID').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        Begin

          if FormParams.ParamByName('isBanAdd').Value and
            ((CheckCDS.FieldByName('Amount').asCurrency + AAmount) > Ceil(CheckCDS.FieldByName('AmountOrder').asCurrency)) then
          begin
            ShowMessage('Увеличивать количество на целые значения запрещено, можно до ближайшего целого. Отпустите клиента отдельтным чеком.');
            Exit;
          end;

          RemainsCDS.Edit;
          if (AAmount = 0) or
            ((AAmount < 0) AND (abs(AAmount) >= CheckCDS.FieldByName('Amount')
            .asCurrency)) then
            RemainsCDS.FieldByName('Remains').asCurrency :=
              RemainsCDS.FieldByName('Remains').asCurrency +
              CheckCDS.FieldByName('Amount').asCurrency
          else
            RemainsCDS.FieldByName('Remains').asCurrency :=
              RemainsCDS.FieldByName('Remains').asCurrency - AAmount;
          RemainsCDS.Post;
        End;
      End;
      CheckCDS.Next;
    end;

    nDelta := AAmount;
    ExpirationDateCDS.Filter := 'ID = ' +
      IntToStr(CheckCDS.FieldByName('GoodsId').AsInteger) +
      ' and PartionDateKindId = ' +
      IntToStr(CheckCDS.FieldByName('PartionDateKindID').AsInteger);
    ExpirationDateCDS.First;
    while Not ExpirationDateCDS.Eof and (nDelta <> 0) do
    Begin
      if nDelta > 0 then
      begin
        if ExpirationDateCDS.FieldByName('Amount').asCurrency > 0 then
        begin
          ExpirationDateCDS.Edit;
          if nDelta > ExpirationDateCDS.FieldByName('Amount').asCurrency then
          begin
            nDelta := nDelta - ExpirationDateCDS.FieldByName('Amount')
              .asCurrency;
            ExpirationDateCDS.FieldByName('Amount').asCurrency := 0;
          end
          else
          begin
            ExpirationDateCDS.FieldByName('Amount').asCurrency :=
              ExpirationDateCDS.FieldByName('Amount').asCurrency - nDelta;
            nDelta := 0;
          end;
          ExpirationDateCDS.Post;
        end;
      end
      else
      begin
        ExpirationDateCDS.Edit;
        ExpirationDateCDS.FieldByName('Amount').asCurrency :=
          ExpirationDateCDS.FieldByName('Amount').asCurrency - nDelta;
        ExpirationDateCDS.Post;
        nDelta := 0;
      end;
      ExpirationDateCDS.Next;
    End;


    // AlternativeCDS.First;
    // while Not AlternativeCDS.eof do
    // Begin
    // if (AGoodsId = 0) or ((AlternativeCDS.FieldByName('Id').AsInteger = AGoodsId) and (AlternativeCDS.FieldByName('Price').AsFloat = APriceSale)) then
    // Begin
    // //if (AAmount < 0) and (CheckCDS.FieldByName('PriceSale').asCurrency > 0)
    // //then lPriceSale:= CheckCDS.FieldByName('PriceSale').asCurrency
    // //else lPriceSale:= AlternativeCDS.fieldByName('Price').asCurrency;
    //
    // if CheckCDS.locate('GoodsId;PriceSale',VarArrayOf([AlternativeCDS.fieldByName('Id').AsInteger,APriceSale]),[]) then
    // Begin
    // AlternativeCDS.Edit;
    // if (AAmount = 0) or
    // (
    // (AAmount < 0)
    // AND
    // (abs(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
    // ) then
    // AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
    // + CheckCDS.FieldByName('Amount').asCurrency
    // else
    // AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
    // - AAmount;
    // AlternativeCDS.Post;
    // End;
    // End;
    // AlternativeCDS.Next;
    // End;

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if ((AGoodsId = 0) or (CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId)
        and (CheckCDS.FieldByName('PartionDateKindId').AsInteger = APartionDateKindId)
        and (CheckCDS.FieldByName('NDSKindId').AsInteger = ANDSKindId)
        and (CheckCDS.FieldByName('DiscountExternalID').AsInteger = ADiscountExternalID)
        and (CheckCDS.FieldByName('DivisionPartiesID').AsInteger = ADivisionPartiesID)
        and (CheckCDS.FieldByName('PriceSale').AsCurrency = APriceSale)
        and (CheckCDS.FieldByName('isPresent').AsBoolean = AisPresent))
        and RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
        CheckCDS.FieldByName('PartionDateKindID').AsVariant,
        CheckCDS.FieldByName('NDSKindId').AsVariant,
        CheckCDS.FieldByName('DiscountExternalID').AsVariant,
        CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
      Begin
        CheckCDS.Edit;

        if (AAmount = 0) or
          ((AAmount < 0) AND (abs(AAmount) >= CheckCDS.FieldByName('Amount')
          .asCurrency)) then
          CheckCDS.FieldByName('Amount').asCurrency := 0
        else
          CheckCDS.FieldByName('Amount').asCurrency :=
            CheckCDS.FieldByName('Amount').asCurrency + AAmount;

        {
          //сначала допишем скидку, и изменим цену, надеюсь она сохранена правильно ***20.07.16
          if (FormParams.ParamByName('DiscountExternalId').Value > 0) and (AGoodsId <> 0)
          // На всяк случай условие
          and (DiscountServiceForm.gGoodsId = AGoodsId)
          and (DiscountServiceForm.gDiscountExternalId = FormParams.ParamByName('DiscountExternalId').Value)
          then begin
          // на всяк случай условие - восстановим если Цена СО скидкой была запонена
          if DiscountServiceForm.gPrice > 0
          then checkCDS.FieldByName('Price').asCurrency        :=DiscountServiceForm.gPrice;
          checkCDS.FieldByName('ChangePercent').asCurrency     :=DiscountServiceForm.gChangePercent;
          checkCDS.FieldByName('SummChangePercent').asCurrency :=DiscountServiceForm.gSummChangePercent;
          end
          else }
        if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
          (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
          (FormParams.ParamByName('Price1303').Value <> 0) then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            FormParams.ParamByName('Price1303').Value;
          CheckCDS.FieldByName('Price').asCurrency :=
            GetPrice(FormParams.ParamByName('Price1303').Value *
            (1 - Self.FormParams.ParamByName('SPTax').Value / 100), 0);
          // и УСТАНОВИМ скидку - с процентом SPTax
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            Self.FormParams.ParamByName('SPTax').Value;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if (Self.FormParams.ParamByName('SPTax').Value <> 0) and
          (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
            .asCurrency, RemainsCDS.FieldByName('Price').asCurrency) *
            (1 - Self.FormParams.ParamByName('SPTax').Value / 100), 0);
          // и УСТАНОВИМ скидку - с процентом SPTax
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            Self.FormParams.ParamByName('SPTax').Value;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if (RemainsCDS.FieldByName('isSP').AsBoolean = True) and
          (Self.FormParams.ParamByName('InvNumberSP').Value <> '') and
          (FormParams.ParamByName('HelsiSkipDispenseSign').Value = False) then
        begin

          if FormParams.ParamByName('MedicalProgramSPId').Value = RemainsCDS.FieldByName('MedicalProgramSPId').AsInteger  then
          begin
            // на всяк случай - УСТАНОВИМ скидку еще разок
            CheckCDS.FieldByName('PriceSale').asCurrency :=
              RemainsCDS.FieldByName('PriceSaleSP').asCurrency;
            CheckCDS.FieldByName('Price').asCurrency :=
              RemainsCDS.FieldByName('PriceSP').asCurrency;
            // и УСТАНОВИМ скидку
            CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              CheckCDS.FieldByName('Amount').asCurrency *
              (RemainsCDS.FieldByName('PriceSaleSP').asCurrency -
              RemainsCDS.FieldByName('PriceSP').asCurrency);
          end else
          begin
            LoadMedicalProgramSPGoods(RemainsCDS.FieldByName('Id').AsInteger);

            // на всяк случай - УСТАНОВИМ скидку еще разок
            CheckCDS.FieldByName('PriceSale').asCurrency :=
              MedicalProgramSPGoodsCDS.FieldByName('PriceSaleSP').asCurrency;
            CheckCDS.FieldByName('Price').asCurrency :=
              MedicalProgramSPGoodsCDS.FieldByName('PriceSP').asCurrency;
            // и УСТАНОВИМ скидку
            CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              CheckCDS.FieldByName('Amount').asCurrency *
              (MedicalProgramSPGoodsCDS.FieldByName('PriceSaleSP').asCurrency -
              MedicalProgramSPGoodsCDS.FieldByName('PriceSP').asCurrency);
          end;
        end
        else if (DiscountServiceForm.gCode <> 0) and edPrice.Visible and (abs(edPrice.Value) > 0.0001) then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency := edPrice.Value;
          // и УСТАНОВИМ скидку
          CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            CheckCDS.FieldByName('Amount').asCurrency *
            (RemainsCDS.FieldByName('Price').asCurrency - edPrice.Value);
        end
        else if (FormParams.ParamByName('LoyaltyChangeSumma').Value = 0) and
          (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
          CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID')
          .Value, SourceClientDataSet.FieldByName('Id').AsInteger) then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
            .asCurrency, RemainsCDS.FieldByName('Price').asCurrency),
            Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
            Self.FormParams.ParamByName('SiteDiscount').Value);
          // и УСТАНОВИМ скидку
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            Self.FormParams.ParamByName('PromoCodeChangePercent').Value +
            Self.FormParams.ParamByName('SiteDiscount').Value;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if (Self.FormParams.ParamByName('SiteDiscount').Value > 0) then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
            .asCurrency, RemainsCDS.FieldByName('Price').asCurrency),
            Self.FormParams.ParamByName('SiteDiscount').Value);
          // и УСТАНОВИМ скидку
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            Self.FormParams.ParamByName('SiteDiscount').Value;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if (Self.FormParams.ParamByName('ManualDiscount').Value > 0) then
        begin
          // на всяк случай - УСТАНОВИМ скидку еще разок
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
            .asCurrency, RemainsCDS.FieldByName('Price').asCurrency),
            Self.FormParams.ParamByName('ManualDiscount').Value);
          // и УСТАНОВИМ скидку
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            Self.FormParams.ParamByName('ManualDiscount').Value;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if (CheckCDS.FieldByName('TypeDiscount').AsVariant = 1) and
          (RemainsCDS.FieldByName('PriceChange').asCurrency <> 0) then
        begin
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency,
            RemainsCDS.FieldByName('PriceChange').asCurrency);
          CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
          // пересчитаем сумму скидки
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if CheckCDS.FieldByName('TypeDiscount').AsVariant = 2 then
        begin
          // пересчитаем сумму скидки
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency,
            IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
            RemainsCDS.FieldByName('Price').asCurrency),
            RemainsCDS.FieldByName('FixPercent').asCurrency);
          CheckCDS.FieldByName('ChangePercent').asCurrency :=
            RemainsCDS.FieldByName('FixPercent').asCurrency;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if CheckCDS.FieldByName('TypeDiscount').AsVariant = 3 then
        begin
          // пересчитаем сумму скидки
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency,
            IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
            RemainsCDS.FieldByName('Price').asCurrency) - RemainsCDS.FieldByName
            ('FixDiscount').asCurrency);
          CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);
        end
        else if CheckCDS.FieldByName('AmountOrder').asCurrency = 0 then     // Если это не заказ с сайта
        begin
          // на всяк случай условие - восстановим если Цена БЕЗ скидки была запонена
          // пересчитаем сумму скидки
          CheckCDS.FieldByName('PriceSale').asCurrency :=
            RemainsCDS.FieldByName('Price').asCurrency;
          CheckCDS.FieldByName('Price').asCurrency :=
            CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency,
            IfZero(RemainsCDS.FieldByName('PricePartionDate').asCurrency,
            RemainsCDS.FieldByName('Price').asCurrency));
          // и обнулим скидку
          CheckCDS.FieldByName('ChangePercent').asCurrency := 0;
          if CheckCDS.FieldByName('PriceSale').asCurrency = CheckCDS.FieldByName
            ('Price').asCurrency then
            CheckCDS.FieldByName('SummChangePercent').asCurrency := 0
          else
            CheckCDS.FieldByName('SummChangePercent').asCurrency :=
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency,
              FormParams.ParamByName('RoundingDown').Value) -
              GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('Price').asCurrency,
              FormParams.ParamByName('RoundingDown').Value);
        end;

        // Если скидка по сети и не установлены соц. приект и дисконтная программа
        if (Self.FormParams.ParamByName('InvNumberSP').Value = '') and
          (DiscountServiceForm.gCode = 0) and not UnitConfigCDS.FieldByName
          ('PermanentDiscountID').IsNull and
          (UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency > 0)
        then
        begin
          if CheckCDS.FieldByName('ChangePercent').asCurrency = 0 then
          begin
            if CheckCDS.FieldByName('Price').asCurrency = IfZero
              (RemainsCDS.FieldByName('PricePartionDate').asCurrency,
              RemainsCDS.FieldByName('Price').asCurrency) then
            begin
              CheckCDS.FieldByName('PriceSale').asCurrency :=
                RemainsCDS.FieldByName('Price').asCurrency;
              // и УСТАНОВИМ скидку
              CheckCDS.FieldByName('ChangePercent').asCurrency :=
                UnitConfigCDS.FieldByName('PermanentDiscountPercent')
                .asCurrency;

              CheckCDS.FieldByName('Price').asCurrency :=
                GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
                .asCurrency, RemainsCDS.FieldByName('Price').asCurrency),
                CheckCDS.FieldByName('ChangePercent').asCurrency);

            end
            else
              CheckCDS.FieldByName('Price').asCurrency :=
                GetPrice(CheckCDS.FieldByName('Price').asCurrency,
                UnitConfigCDS.FieldByName('PermanentDiscountPercent')
                .asCurrency);

          end
          else
          begin
            CheckCDS.FieldByName('PriceSale').asCurrency :=
              RemainsCDS.FieldByName('Price').asCurrency;
            // и УСТАНОВИМ скидку
            CheckCDS.FieldByName('ChangePercent').asCurrency :=
              CheckCDS.FieldByName('ChangePercent').asCurrency +
              UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency;

            CheckCDS.FieldByName('Price').asCurrency :=
              GetPrice(IfZero(RemainsCDS.FieldByName('PricePartionDate')
              .asCurrency, RemainsCDS.FieldByName('Price').asCurrency),
              CheckCDS.FieldByName('ChangePercent').asCurrency);
          end;

          CheckCDS.FieldByName('SummChangePercent').asCurrency :=
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('PriceSale').asCurrency,
            FormParams.ParamByName('RoundingDown').Value) -
            GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
            CheckCDS.FieldByName('Price').asCurrency,
            FormParams.ParamByName('RoundingDown').Value);

        end;

        CheckCDS.FieldByName('PriceDiscount').asCurrency :=
          CheckCDS.FieldByName('Price').asCurrency;
        CheckCDS.FieldByName('Summ').asCurrency :=
          GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
          CheckCDS.FieldByName('Price').asCurrency,
          FormParams.ParamByName('RoundingDown').Value);

        CheckCDS.Post;
      End;
      CheckCDS.Next;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
      VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
    RemainsCDS.EnableControls;
    // AlternativeCDS.Filtered := true;
    // AlternativeCDS.EnableControls;
    ExpirationDateCDS.Filter := oldFilterExpirationDate;
    ExpirationDateCDS.EnableControls;
    CheckCDS.Filtered := True;
    if AGoodsId <> 0 then
      CheckCDS.Locate('GoodsId', AGoodsId, []);
    CheckCDS.EnableControls;
  end;
end;

// Обрабатывает количество для ВИП чеков
procedure TMainCashForm2.UpdateRemainsFromVIPCheck(ALoadCheck, ASaveCheck  : Boolean);
var
  GoodsId: Integer;
  PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID: Variant;
  nDelta: Currency;
  oldFilterExpirationDate: String;
  // lPriceSale : Currency;
begin
  // Если пусто - ничего не делаем
  if ALoadCheck then
  begin
    mdVIPCheck.Close;
    CheckCDS.DisableControls;
    CheckCDS.Filtered := false;
    if CheckCDS.isempty then
    Begin
      CheckCDS.Filtered := True;
      CheckCDS.EnableControls;
      exit;
    End;
    mdVIPCheck.Open;
    // открючаем реакции
    RemainsCDS.AfterScroll := Nil;
    GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
    PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
    NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
    DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
    DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindID').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        Begin
          RemainsCDS.Edit;
          if RemainsCDS.FieldByName('Reserved').asCurrency >= CheckCDS.FieldByName('Amount').asCurrency then
            RemainsCDS.FieldByName('Reserved').asCurrency :=
              RemainsCDS.FieldByName('Reserved').asCurrency -
              CheckCDS.FieldByName('Amount').asCurrency
          else
            RemainsCDS.FieldByName('Reserved').asCurrency :=0;
          RemainsCDS.Post;
        End;

        if mdVIPCheck.Locate('ID;PDKINDID;NDSKINDId;DISCEXTID;DIVPARTID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindId').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
          mdVIPCheck.Edit
        else
        begin
          mdVIPCheck.Append;
          mdVIPCheck.FieldByName('ID').AsInteger := CheckCDS.FieldByName('GoodsId').AsInteger;
          mdVIPCheck.FieldByName('PDKINDID').AsVariant := CheckCDS.FieldByName('PartionDateKindId').AsVariant;
          mdVIPCheck.FieldByName('NDSKINDID').AsVariant := CheckCDS.FieldByName('NDSKindId').AsVariant;
          mdVIPCheck.FieldByName('DISCEXTID').AsVariant := CheckCDS.FieldByName('DiscountExternalID').AsVariant;
          mdVIPCheck.FieldByName('DIVPARTID').AsVariant := CheckCDS.FieldByName('DivisionPartiesID').AsVariant;
        end;
        mdVIPCheck.FieldByName('Amount').asCurrency := mdVIPCheck.FieldByName('Amount').asCurrency + CheckCDS.FieldByName('Amount').asCurrency;
        mdVIPCheck.Post;

        CheckCDS.Next;
      end;
      CheckCDS.First;

    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
      RemainsCDS.EnableControls;
      CheckCDS.Filtered := True;
      CheckCDS.EnableControls;
    end;
  end else if ASaveCheck = True then
  begin
    RemainsCDS.AfterScroll := Nil;
    GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
    PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
    NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
    DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
    DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindID').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Reserved').asCurrency :=
            RemainsCDS.FieldByName('Reserved').asCurrency +
              CheckCDS.FieldByName('Amount').asCurrency;
          RemainsCDS.Post;
        End;
        CheckCDS.Next;
      end;
    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
      RemainsCDS.EnableControls;
      mdVIPCheck.Close;
      mdVIPCheck.Open;
    end;
  end else
  begin
    if mdVIPCheck.isempty then exit;
    // открючаем реакции
    RemainsCDS.AfterScroll := Nil;
    GoodsId := RemainsCDS.FieldByName('Id').AsInteger;
    PartionDateKindId := RemainsCDS.FieldByName('PartionDateKindId').AsVariant;
    NDSKindId := RemainsCDS.FieldByName('NDSKindId').AsVariant;
    DiscountExternalID := RemainsCDS.FieldByName('DiscountExternalID').AsVariant;
    DivisionPartiesID := RemainsCDS.FieldByName('DivisionPartiesID').AsVariant;
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := false;
    try
      mdVIPCheck.First;
      while not mdVIPCheck.Eof do
      begin
        if RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([mdVIPCheck.FieldByName('Id').AsInteger,
          mdVIPCheck.FieldByName('PDKINDID').AsVariant,
          mdVIPCheck.FieldByName('NDSKINDID').AsVariant,
          mdVIPCheck.FieldByName('DISCEXTID').AsVariant,
          mdVIPCheck.FieldByName('DIVPARTID').AsVariant]), []) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Reserved').asCurrency :=
            RemainsCDS.FieldByName('Reserved').asCurrency +
            mdVIPCheck.FieldByName('AMOUNT').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency :=
              RemainsCDS.FieldByName('Remains').asCurrency -
              mdVIPCheck.FieldByName('AMOUNT').asCurrency;
          RemainsCDS.Post;
        End;

        mdVIPCheck.Next;
      end;

    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.Locate('Id;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
        VarArrayOf([GoodsId, PartionDateKindId, NDSKindId, DiscountExternalID, DivisionPartiesID]), []);
      RemainsCDS.EnableControls;
      mdVIPCheck.Close;
      mdVIPCheck.Open;
    end;
  end;
end;

procedure TMainCashForm2.UpdateRemainsGoodsToExpirationDate;
var
  ListGoodsCDS: TClientDataSet;
  nAmount: Currency;
begin
  if not fileExists(GoodsExpirationDate_lcl) then
    exit;

  CheckCDS.DisableControls;
  try

    ListGoodsCDS := TClientDataSet.Create(Nil);
    ListGoodsCDS.IndexFieldNames := 'ExpirationDate';

    WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
    try
      if fileExists(GoodsExpirationDate_lcl) then
        LoadLocalData(ListGoodsCDS, GoodsExpirationDate_lcl);
      if not ListGoodsCDS.Active then
        ListGoodsCDS.Open;

      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if CheckCDS.FieldByName('Amount').asCurrency > 0 then
        Begin

          nAmount := CheckCDS.FieldByName('Amount').asCurrency;
          ListGoodsCDS.Filter := 'Id = ' + CheckCDS.FieldByName
            ('GoodsId').AsString;
          ListGoodsCDS.Filtered := True;
          ListGoodsCDS.First;

          while (nAmount > 0) and not ListGoodsCDS.Eof do
          Begin
            if nAmount >= ListGoodsCDS.FieldByName('Amount').asCurrency then
            begin
              nAmount := nAmount - ListGoodsCDS.FieldByName('Amount')
                .asCurrency;
              ListGoodsCDS.Delete;
              ListGoodsCDS.First;
            end
            else
            begin
              ListGoodsCDS.Edit;
              ListGoodsCDS.FieldByName('Amount').asCurrency :=
                ListGoodsCDS.FieldByName('Amount').asCurrency - nAmount;
              ListGoodsCDS.Post;
              nAmount := 0;
            end;
          End;
        End;
        CheckCDS.Next;
      end;
      SaveLocalData(ListGoodsCDS, GoodsExpirationDate_lcl);
    finally
      ReleaseMutex(MutexGoodsExpirationDate);
    end;
  finally
    ListGoodsCDS.Free;
    CheckCDS.EnableControls;
  end;
end;

function TMainCashForm2.GetPartionDateKindId: Integer;
var
  nPartionDateKindId: Integer;
  nAmountMonth: Currency;
begin
  Result := 0;
  nPartionDateKindId := 0;
  nAmountMonth := 0;
  CheckCDS.DisableConstraints;
  try
    try
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if CheckCDS.FieldByName('PartionDateKindId').AsInteger > 0 then
        begin
          if (nPartionDateKindId = 0) or
            (nPartionDateKindId <> CheckCDS.FieldByName('PartionDateKindId')
            .AsInteger) and (nAmountMonth > CheckCDS.FieldByName('AmountMonth')
            .asCurrency) then
          begin
            nPartionDateKindId := CheckCDS.FieldByName('PartionDateKindId')
              .AsInteger;
            nAmountMonth := CheckCDS.FieldByName('AmountMonth').asCurrency;
          end;
        end;
        CheckCDS.Next;
      end;
    finally
      ReleaseMutex(MutexGoodsExpirationDate);
    end;
  finally
    CheckCDS.First;
    CheckCDS.EnableControls;
    Result := nPartionDateKindId;
  end;
end;

// Проверка и генерация промокода по Программе лояльности
procedure TMainCashForm2.Check_Loyalty(ASumma: Currency);
begin

  // Если уже получено повторно не делаем
  if FormParams.ParamByName('LoyaltySignID').Value <> 0 then
    exit;

  // Если локально то ничего не делаем
  if gc_User.Local then
    exit;

  // Если программы нет
  if not UnitConfigCDS.Active or
    not Assigned(UnitConfigCDS.FindField('LoyaltyID')) then
    exit;
  if UnitConfigCDS.FindField('LoyaltyID').IsNull then
    exit;
  if UnitConfigCDS.FindField('LoyaltySummCash').asCurrency > ASumma then
    exit;

  // Получаем новый GUID
  try
    spLoyaltyGUID.ParamByName('ioId').Value := 0;
    spLoyaltyGUID.ParamByName('inMovementId').Value :=
      UnitConfigCDS.FieldByName('LoyaltyID').AsInteger;
    spLoyaltyGUID.ParamByName('outGUID').Value := '';
    spLoyaltyGUID.ParamByName('outAmount').Value := 0;
    spLoyaltyGUID.ParamByName('outDateEnd').Value := '';
    spLoyaltyGUID.ParamByName('outMessage').Value := '';
    spLoyaltyGUID.ParamByName('inComment').Value := '';
    spLoyaltyGUID.Execute;

    if (spLoyaltyGUID.ParamByName('ioId').Value <> 0) and
      (spLoyaltyGUID.ParamByName('outAmount').AsFloat > 0) then
    begin
      FormParams.ParamByName('LoyaltySignID').Value :=
        spLoyaltyGUID.ParamByName('ioId').Value;
      FormParams.ParamByName('LoyaltyText').Value := 'Промокод ' +
        spLoyaltyGUID.ParamByName('outGUID').Value + ' на знижку ' +
        FormatCurr(',0.00', spLoyaltyGUID.ParamByName('outAmount').AsFloat) +
        ' грн. діє до ' + spLoyaltyGUID.ParamByName('outDateEnd').Value;
    end
    else
    begin
      FormParams.ParamByName('LoyaltySignID').Value := 0;
      FormParams.ParamByName('LoyaltyText').Value := '';
      FormParams.ParamByName('LoyaltyChangeSumma').Value := 0;
    end;

  except
    ON E: Exception do
      Add_Log('Check_Loyalty err=' + E.Message);
  end;

end;

// Проверка и генерация промокода по Программе лояльности
procedure TMainCashForm2.Check_LoyaltySumma(ASumma: Currency);
begin

  // Если локально то ничего не делаем
  if gc_User.Local then
    exit;

  // Если программы нет
  if not UnitConfigCDS.Active or
    not Assigned(UnitConfigCDS.FindField('LoyaltyID')) then
    exit;
  if UnitConfigCDS.FindField('LoyaltyID').IsNull then
    exit;
  if UnitConfigCDS.FindField('LoyaltySummCash').asCurrency > ASumma then
    exit;
  if not FormParams.ParamByName('LoyaltyShowMessage').Value then
    exit;

  // Получаем мнформацию
  try
    spLoyaltyStatus.ParamByName('inMovementId').Value :=
      UnitConfigCDS.FieldByName('LoyaltyID').asCurrency;
    spLoyaltyStatus.ParamByName('outMessage').Value := '';
    spLoyaltyStatus.Execute;

    if spLoyaltyStatus.ParamByName('outMessage').Value <> '' then
      ShowMessage(spLoyaltyStatus.ParamByName('outMessage').Value);
    FormParams.ParamByName('LoyaltyShowMessage').Value := false;

  except
    ON E: Exception do
      Add_Log('Check_LoyaltySumma err=' + E.Message);
  end;

end;

// Проверка и генерация промокода по Программе лояльности
procedure TMainCashForm2.Check_LoyaltySM(ASumma: Currency);
begin

  // Если не подключен покупател
  if FormParams.ParamByName('LoyaltySMID').Value = 0 then
    exit;

  // Если локально то ничего не делаем
  if gc_User.Local then
    exit;

  // Получаем текст для чека
  try
    spLoyaltySaveMoneyChekInfo.ParamByName('ioId').Value :=
      FormParams.ParamByName('LoyaltySMID').Value;
    spLoyaltySaveMoneyChekInfo.ParamByName('inSummaCheck').Value := ASumma;
    spLoyaltySaveMoneyChekInfo.ParamByName('inSumma').Value :=
      FormParams.ParamByName('LoyaltySMSumma').Value;
    spLoyaltySaveMoneyChekInfo.ParamByName('outText').Value := '';
    spLoyaltySaveMoneyChekInfo.Execute;

    if spLoyaltySaveMoneyChekInfo.ParamByName('outText').Value <> '' then
    begin
      FormParams.ParamByName('LoyaltySMText').Value :=
        spLoyaltySaveMoneyChekInfo.ParamByName('outText').Value;
    end
    else
    begin
      FormParams.ParamByName('LoyaltySMText').Value := '';
    end;

  except
    ON E: Exception do
      Add_Log('Check_LoyaltySM err=' + E.Message);
  end;

end;

function TMainCashForm2.SaveLocal(ADS: TClientDataSet; AManagerId: Integer;
  AManagerName: String; ABayerName, ABayerPhone, AConfirmedKindName,
  AInvNumberOrder, AConfirmedKindClientName: String;
  ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
  APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance,
  AMedicSP, AInvNumberSP: String; AOperDateSP: TDateTime; ASPKindId: Integer;
  ASPKindName: String; ASPTax: Currency; APromoCodeID, AManualDiscount: Integer;
  ASummPayAdd: Currency; AMemberSPID, ABankPOSTerminal, AJackdawsChecksCode: Integer;
  ASiteDiscount: Currency; ARoundingDown: Boolean;
  APartionDateKindId: Integer; AConfirmationCodeSP: string;
  ALoyaltySignID: Integer; ALoyaltySMID: Integer; ALoyaltySMSumma: Currency;
  ADivisionPartiesID: Integer; ADivisionPartiesName, AMedicForSale, ABuyerForSale, ABuyerForSalePhone,
  ADistributionPromoList: String; AMedicKashtanId, AMemberKashtanId : Integer;
  AisCorrectMarketing, AisCorrectIlliquidAssets, AisDoctors, AisDiscountCommit : Boolean;
  AMedicalProgramSPId: Integer; AisManual : Boolean; ACategory1303Id : Integer;
  ANeedComplete, AisErrorRRO, AisPaperRecipeSP: Boolean; AZReport : Integer; AFiscalCheckNumber: String;
  AID: Integer; out AUID: String): Boolean;
var
  NextVIPId: Integer;
  myVIPCDS, myVIPListCDS: TClientDataSet;
  str_log_xml: String;
  I: Integer;
begin
  // Для админа пропускаем
//  if gc_User.Session = '3' then Exit;

  // Если чек виповский и ещё не проведен - то сохраняем в таблицу випов
  if gc_User.Local And not ANeedComplete AND
    ((AManagerId <> 0) or (ABayerName <> '')) then
  Begin
    myVIPCDS := TClientDataSet.Create(nil);
    myVIPListCDS := TClientDataSet.Create(nil);
    AUID := GenerateGUID;
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(myVIPCDS, vip_lcl);
      LoadLocalData(myVIPListCDS, vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
    if not myVIPCDS.Locate('Id', AId, [])
    then
    Begin
      myVIPCDS.IndexFieldNames := 'Id';
      myVIPCDS.First;
      if myVIPCDS.FieldByName('Id').AsInteger > 0 then
        NextVIPId := -1
      else
        NextVIPId := myVIPCDS.FieldByName('Id').AsInteger - 1;

      myVIPCDS.Append;
      myVIPCDS.FieldByName('Id').AsInteger := NextVIPId;
      myVIPCDS.FieldByName('InvNumber').AsString := AUID;
      myVIPCDS.FieldByName('OperDate').AsDateTime := Now;
    end
    else
    Begin
      myVIPCDS.Edit;
      AUID := myVIPCDS.FieldByName('InvNumber').AsString;

    end;
    myVIPCDS.FieldByName('StatusId').AsInteger := StatusUnCompleteId;
    myVIPCDS.FieldByName('StatusCode').AsInteger := StatusUnCompleteCode;
    myVIPCDS.FieldByName('TotalCount').AsFloat := 0;
    myVIPCDS.FieldByName('TotalSumm').AsFloat := FTotalSumm;
    myVIPCDS.FieldByName('UnitName').AsString := '';
    myVIPCDS.FieldByName('CashRegisterName').AsString := '';
    myVIPCDS.FieldByName('CashMemberId').AsInteger := AManagerId;
    myVIPCDS.FieldByName('CashMember').AsString := AManagerName;
    myVIPCDS.FieldByName('Bayer').AsString := ABayerName;
    // ***20.07.16
    myVIPCDS.FieldByName('DiscountExternalId').AsInteger := ADiscountExternalId;
    myVIPCDS.FieldByName('DiscountExternalName').AsString := ADiscountExternalName;
    myVIPCDS.FieldByName('DiscountCardNumber').AsString := ADiscountCardNumber;
    // ***16.08.16
    myVIPCDS.FieldByName('BayerPhone').AsString := ABayerPhone;
    myVIPCDS.FieldByName('ConfirmedKindName').AsString := AConfirmedKindName;
    myVIPCDS.FieldByName('InvNumberOrder').AsString := AInvNumberOrder;
    myVIPCDS.FieldByName('ConfirmedKindClientName').AsString :=
      AConfirmedKindClientName;
    // ***10.04.17
    myVIPCDS.FieldByName('PartnerMedicalId').AsInteger := APartnerMedicalId;
    myVIPCDS.FieldByName('PartnerMedicalName').AsString := APartnerMedicalName;
    myVIPCDS.FieldByName('Ambulance').AsString := AAmbulance;
    myVIPCDS.FieldByName('MedicSP').AsString := AMedicSP;
    myVIPCDS.FieldByName('InvNumberSP').AsString := AInvNumberSP;
    myVIPCDS.FieldByName('OperDateSP').AsDateTime := AOperDateSP;
    // ***15.06.17
    myVIPCDS.FieldByName('SPTax').AsFloat := ASPTax;
    myVIPCDS.FieldByName('SPKindId').AsInteger := ASPKindId;
    myVIPCDS.FieldByName('SPKindName').AsString := ASPKindName;
    myVIPCDS.FieldByName('MedicalProgramSPId').AsInteger := AMedicalProgramSPId;
    // ***02.02.18
    myVIPCDS.FieldByName('PromoCodeID').Value := APromoCodeID; // Id промокода
    // ***27.06.18
    myVIPCDS.FieldByName('ManualDiscount').Value := AManualDiscount;
    // Ручная скидка
    // ***02.11.18
    myVIPCDS.FieldByName('MemberSPID').Value := AMemberSPID; // ФИО пациента
    // ***28.01.19
    myVIPCDS.FieldByName('SiteDiscount').Value := (ASiteDiscount > 0);
    // Дисконт через сайт
    // ***13.05.19
    myVIPCDS.FieldByName('PartionDateKindId').Value := APartionDateKindId;
    // ***25.08.21
    myVIPCDS.FieldByName('isDiscountCommit').Value := AisDiscountCommit;
    myVIPCDS.Post;
    AID := myVIPCDS.FieldByName('Id').AsInteger;

    myVIPListCDS.Filter := 'MovementId = ' + myVIPCDS.FieldByName('Id')
      .AsString;
    myVIPListCDS.Filtered := True;
    while not myVIPListCDS.Eof do
      myVIPListCDS.Delete;
    myVIPListCDS.Filtered := false;
    ADS.DisableControls;
    try
      ADS.Filtered := false;
      ADS.First;
      while not ADS.Eof do
      Begin
        myVIPListCDS.Append;
        myVIPListCDS.FieldByName('Id').Value := ADS.FieldByName('Id').AsInteger;
        myVIPListCDS.FieldByName('MovementId').Value :=
          myVIPCDS.FieldByName('Id').AsInteger;
        myVIPListCDS.FieldByName('GoodsId').Value := ADS.FieldByName('GoodsId')
          .AsInteger;
        myVIPListCDS.FieldByName('GoodsCode').Value :=
          ADS.FieldByName('GoodsCode').AsInteger;
        myVIPListCDS.FieldByName('GoodsName').Value :=
          ADS.FieldByName('GoodsName').AsString;
        myVIPListCDS.FieldByName('Amount').Value :=
          ADS.FieldByName('Amount').AsFloat;
        myVIPListCDS.FieldByName('Price').Value :=
          ADS.FieldByName('Price').AsFloat;
        myVIPListCDS.FieldByName('Summ').Value :=
          GetSumm(ADS.FieldByName('Amount').AsFloat, ADS.FieldByName('Price').AsFloat,
          FormParams.ParamByName('RoundingDown').Value);
        // ***20.07.16
        myVIPListCDS.FieldByName('PriceSale').asCurrency :=
          ADS.FieldByName('PriceSale').asCurrency;
        myVIPListCDS.FieldByName('ChangePercent').asCurrency :=
          ADS.FieldByName('ChangePercent').asCurrency;
        myVIPListCDS.FieldByName('SummChangePercent').asCurrency :=
          ADS.FieldByName('SummChangePercent').asCurrency;
        // ***19.08.16
        myVIPListCDS.FieldByName('AmountOrder').asCurrency :=
          ADS.FieldByName('AmountOrder').asCurrency;
        // ***10.08.16
        myVIPListCDS.FieldByName('List_UID').AsString :=
          ADS.FieldByName('List_UID').AsString;
        // ***02.06.19
        myVIPListCDS.FieldByName('PartionDateKindId').Value :=
          ADS.FieldByName('PartionDateKindId').AsVariant;
        myVIPListCDS.FieldByName('PartionDateKindName').Value :=
          ADS.FieldByName('PartionDateKindName').AsVariant;
        myVIPListCDS.FieldByName('PricePartionDate').Value :=
          ADS.FieldByName('PricePartionDate').AsVariant;
        myVIPListCDS.FieldByName('AmountMonth').Value :=
          ADS.FieldByName('AmountMonth').AsVariant;
        myVIPListCDS.FieldByName('NDS').Value := ADS.FieldByName('NDS')
          .AsVariant;
        myVIPListCDS.FieldByName('NDSKindId').Value :=
          ADS.FieldByName('NDSKindId').AsVariant;
        myVIPListCDS.FieldByName('DiscountExternalID').Value :=
          ADS.FieldByName('DiscountExternalID').AsVariant;
        myVIPListCDS.FieldByName('DiscountExternalName').Value :=
          ADS.FieldByName('DiscountExternalName').AsVariant;
        myVIPListCDS.FieldByName('DivisionPartiesID').Value :=
          ADS.FieldByName('DivisionPartiesID').AsVariant;
        myVIPListCDS.FieldByName('DivisionPartiesName').Value :=
          ADS.FieldByName('DivisionPartiesName').AsVariant;
        myVIPListCDS.FieldByName('UKTZED').Value :=
          ADS.FieldByName('UKTZED').AsVariant;
        myVIPListCDS.FieldByName('isGoodsPairSun').Value :=
          ADS.FieldByName('isGoodsPairSun').AsVariant;
        myVIPListCDS.FieldByName('GoodsPairSunMainId').Value :=
          ADS.FieldByName('GoodsPairSunMainId').AsVariant;
        myVIPListCDS.FieldByName('GoodsPairSunAmount').Value :=
          ADS.FieldByName('GoodsPairSunAmount').AsVariant;
        myVIPListCDS.FieldByName('isPresent').Value :=
          ADS.FieldByName('isPresent').AsVariant;
        myVIPListCDS.FieldByName('JuridicalId').Value :=
          ADS.FieldByName('JuridicalId').AsVariant;
        myVIPListCDS.Post;
        ADS.Next;
      End;
    finally
      ADS.Filtered := True;
      ADS.EnableControls;
    end;
    WaitForSingleObject(MutexVip, INFINITE);
    try
      SaveLocalData(myVIPCDS, vip_lcl);
      myVIPListCDS.Filtered := false;
      SaveLocalData(myVIPListCDS, vipList_lcl);
      myVIPCDS.Free;
      myVIPListCDS.Free;
    finally
      ReleaseMutex(MutexVip);
    end;
  End; // Если чек виповский и ещё не проведен - то сохраняем в таблицу випов

  // сохраняем в дбф
  Add_Log('Ожидаем MutexDBF');
  WaitForSingleObject(MutexDBF, INFINITE);
  Add_Log('Получили MutexDBF');
  try
    FLocalDataBaseHead.Active := True;
    FLocalDataBaseBody.Active := True;
    // сгенерили гуид для чека
    if AUID = '' then
      AUID := GenerateGUID;
    Result := True;

    // сохраняем шапку
    try
      if (AID = 0) or not FLocalDataBaseHead.Locate('ID', AID, []) then
      Begin
        FLocalDataBaseHead.AddRecord
          (VarArrayOf([AId, // id чека
          AUID, // uid чека
          Now, // дата/Время чека
          Integer(PaidType), // тип оплаты
          FFiscalNumber, // серийник аппарата
          AManagerId, // Id Менеджера (VIP)
          ABayerName, // Покупатель (VIP)
          false, // Распечатан на фискальном регистраторе
          false, // Сохранен в реальную базу данных
          ANeedComplete, // Необходимо проведение
          chbNotMCS.Checked, // Не участвует в расчете НТЗ
          AFiscalCheckNumber, // Номер фискального чека
          // ***20.07.16
          ADiscountExternalId, // Id Проекта дисконтных карт
          ADiscountExternalName, // Название Проекта дисконтных карт
          ADiscountCardNumber, // № Дисконтной карты
          // ***20.07.16
          ABayerPhone, // Контактный телефон (Покупателя) - BayerPhone
          AConfirmedKindName,
          // Статус заказа (Состояние VIP-чека) - ConfirmedKind
          AInvNumberOrder, // Номер заказа (с сайта) - InvNumberOrder
          AConfirmedKindClientName,
          // Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
          // ***24.01.17
          gc_User.Session, // Для сервиса - реальная сесия при продаже
          // ***08.04.17
          APartnerMedicalId, // Id Медицинское учреждение(Соц. проект)
          APartnerMedicalName, // Название Медицинское учреждение(Соц. проект)
          AAmbulance, // № амбулатории (Соц. проект)
          AMedicSP, // ФИО врача (Соц. проект)
          AInvNumberSP, // номер рецепта (Соц. проект)
          AOperDateSP, // дата рецепта (Соц. проект)
          // ***15.06.17
          ASPKindId, // Id Вид СП
          // ***02.02.18
          APromoCodeID, // Id промокода
          // ***27.06.18
          AManualDiscount, // Ручная скидка
          // ***02.11.18
          ASummPayAdd, // Доплата по чеку
          // ***14.01.19
          AMemberSPID, // ФИО пациента
          // ***28.01.19
          ASiteDiscount > 0,
          // ***20.02.19
          ABankPOSTerminal, // POS терминал
          // ***25.02.19
          AJackdawsChecksCode, // Галка
          // ***02.04.19
          ARoundingDown, // Округление в низ
          // ***13.05.19
          APartionDateKindId, // Тип срок/не срок
          AConfirmationCodeSP, // Код подтверждения рецепта
          // ***07.05.19
          ALoyaltySignID, // Регистрация программы лояльности
          // ***08.01.20
          ALoyaltySMID, // Регистрация программы лояльности накопительной
          ALoyaltySMSumma, // Скидка по программе лояльности накопительной
          AMedicForSale, // ФИО врача (на продажу)
          ABuyerForSale, // ФИО покупателя (на продажу)
          ABuyerForSalePhone, // Телефон покупателя (на продажу)
          ADistributionPromoList, // Раздача акционных материалов.
          AMedicKashtanId,        // ФИО врача (МИС «Каштан»)
          AMemberKashtanId,       // ФИО пациента (МИС «Каштан»)
          AisCorrectMarketing,    // Корректировка суммы маркетинг в ЗП по подразделению
          AisCorrectIlliquidAssets, // Корректировка суммы нелеквида в ЗП по подразделению
          AisDoctors,                // Врачи
          AisDiscountCommit,         // Дисконт проведен на сайте
          AZReport,                   // Номер Z отчета
          AMedicalProgramSPId,       // Медицинская программа соц. проектов
          AisManual,                  // ручной выбор медикаментов
          ACategory1303Id,            // Категория 1303
          AisErrorRRO,                 // ВИП чек по ошибке РРО
          AisPaperRecipeSP            // Бумажный рецепт по СП
          ]));
      End
      else
      Begin
        AUID := Trim(FLocalDataBaseHead.FieldByName('UID').Value); // uid чека
        FLocalDataBaseHead.Edit;
        FLocalDataBaseHead.FieldByName('DATE').Value := Now; // дата оплаты
        FLocalDataBaseHead.FieldByName('PAIDTYPE').Value := Integer(PaidType);
        // тип оплаты
        FLocalDataBaseHead.FieldByName('CASH').Value := FFiscalNumber;
        // серийник аппарата
        FLocalDataBaseHead.FieldByName('MANAGER').Value := AManagerId;
        // Id Менеджера (VIP)
        FLocalDataBaseHead.FieldByName('BAYER').Value := ABayerName;
        // Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('SAVE').Value := false;
        // Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('COMPL').Value := false;
        // Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('NEEDCOMPL').Value := ANeedComplete;
        // нужно провести документ
        FLocalDataBaseHead.FieldByName('NOTMCS').Value := chbNotMCS.Checked;
        // Не участвует в расчете НТЗ
        FLocalDataBaseHead.FieldByName('FISCID').Value := AFiscalCheckNumber;
        // Номер фискального чека
        // ***20.07.16
        FLocalDataBaseHead.FieldByName('DISCOUNTID').Value :=
          ADiscountExternalId; // Id Проекта дисконтных карт
        FLocalDataBaseHead.FieldByName('DISCOUNTN').Value :=
          ADiscountExternalName; // Название Проекта дисконтных карт
        FLocalDataBaseHead.FieldByName('DISCOUNT').Value := ADiscountCardNumber;
        // № Дисконтной карты
        // ***16.08.16
        FLocalDataBaseHead.FieldByName('BAYERPHONE').Value := ABayerPhone;
        // Контактный телефон (Покупателя) - BayerPhone
        FLocalDataBaseHead.FieldByName('CONFIRMED').Value := AConfirmedKindName;
        // Статус заказа (Состояние VIP-чека) - ConfirmedKind
        FLocalDataBaseHead.FieldByName('NUMORDER').Value := AInvNumberOrder;
        // Номер заказа (с сайта) - InvNumberOrder
        FLocalDataBaseHead.FieldByName('CONFIRMEDC').Value :=
          AConfirmedKindClientName;
        // Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
        // ***24.01.17
        FLocalDataBaseHead.FieldByName('USERSESION').Value := gc_User.Session;
        // Для сервиса - реальная сесия при продаже
        // ***08.04.17
        FLocalDataBaseHead.FieldByName('PMEDICALID').Value := APartnerMedicalId;
        // Id Медицинское учреждение(Соц. проект)
        FLocalDataBaseHead.FieldByName('PMEDICALN').Value :=
          APartnerMedicalName; // Название Медицинское учреждение(Соц. проект)
        FLocalDataBaseHead.FieldByName('AMBULANCE').Value := AAmbulance;
        // № амбулатории (Соц. проект)
        FLocalDataBaseHead.FieldByName('MEDICSP').Value := AMedicSP;
        // ФИО врача (Соц. проект)
        FLocalDataBaseHead.FieldByName('INVNUMSP').Value := AInvNumberSP;
        // номер рецепта (Соц. проект)
        FLocalDataBaseHead.FieldByName('OPERDATESP').Value := AOperDateSP;
        // дата рецепта (Соц. проект)
        // ***15.06.17
        FLocalDataBaseHead.FieldByName('SPKINDID').Value := ASPKindId;
        // Id Вид СП
        // ***02.02.18
        FLocalDataBaseHead.FieldByName('PROMOCODE').Value := APromoCodeID;
        // Id промокода
        // ***27.06.18
        FLocalDataBaseHead.FieldByName('MANUALDISC').Value := AManualDiscount;
        // Ручная скидка
        // ***02.11.18
        FLocalDataBaseHead.FieldByName('SUMMPAYADD').Value := ASummPayAdd;
        // Сумма доплаты
        // ***02.11.18
        FLocalDataBaseHead.FieldByName('MEMBERSPID').Value := AMemberSPID;
        // ФИО пациента
        // ***28.01.19
        FLocalDataBaseHead.FieldByName('SITEDISC').Value := (ASiteDiscount > 0);
        // Дисконт через сайт
        // ***20.02.19
        FLocalDataBaseHead.FieldByName('BANKPOS').Value := ABankPOSTerminal;
        // ***25.02.19
        FLocalDataBaseHead.FieldByName('JACKCHECK').Value := AJackdawsChecksCode;
        // ***02.04.19
        FLocalDataBaseHead.FieldByName('ROUNDDOWN').Value := ARoundingDown;
        // ***13.05.19
        FLocalDataBaseHead.FieldByName('PDKINDID').Value := APartionDateKindId;
        FLocalDataBaseHead.FieldByName('CONFCODESP').Value :=
          AConfirmationCodeSP;
        // ***07.05.19
        FLocalDataBaseHead.FieldByName('LOYALTYID').Value := ALoyaltySignID;
        // ***13.05.19
        // Регистрация программы лояльности накопительной
        FLocalDataBaseHead.FieldByName('LOYALTYSM').Value := ALoyaltySMID;
        // Скидка по программе лояльности накопительной
        FLocalDataBaseHead.FieldByName('LOYALSMSUM').Value := ALoyaltySMSumma;
        // ФИО врача (на продажу)
        FLocalDataBaseHead.FieldByName('MEDICFS').Value := AMedicForSale;
        // ФИО покупателя (на продажу)
        FLocalDataBaseHead.FieldByName('BUYERFS').Value := ABuyerForSale;
        // Телефон покупателя (на продажу)
        FLocalDataBaseHead.FieldByName('BUYERFSP').Value := ABuyerForSalePhone;
        // Раздача акционных материалов
        FLocalDataBaseHead.FieldByName('DISTPROMO').Value := ADistributionPromoList;
        // ФИО врача (МИС «Каштан»)
        FLocalDataBaseHead.FieldByName('MEDICKID').Value := AMedicKashtanId;
        // ФИО пациента (МИС «Каштан»)
        FLocalDataBaseHead.FieldByName('MEMBERKID').Value := AMemberKashtanId;
        // Корректировка суммы маркетинг в ЗП по подразделению
        FLocalDataBaseHead.FieldByName('ISCORRMARK').Value := AisCorrectMarketing;
        // Корректировка суммы Нелеквида в ЗП по подразделению
        FLocalDataBaseHead.FieldByName('ISCORRIA').Value := AisCorrectIlliquidAssets;
        // Врачи
        FLocalDataBaseHead.FieldByName('ISDOCTORS').Value := AisDoctors;
        //Дисконт проведен на сайте
        FLocalDataBaseHead.FieldByName('ISDISCCOM').Value := AisDiscountCommit;
        //Номер Z отчета
        FLocalDataBaseHead.FieldByName('ZREPORT').Value := AZReport;
        //Медицинская программа соц. проектов
        FLocalDataBaseHead.FieldByName('MEDPRSPID').Value := AMedicalProgramSPId;
        //Ручной выбор медикамента
        FLocalDataBaseHead.FieldByName('ISMANUAL').Value := AisManual;
        //Категория 1303
        FLocalDataBaseHead.FieldByName('CAT1303ID').Value := ACategory1303Id;
        //ВИП чек по ошибке РРО
        FLocalDataBaseHead.FieldByName('ISERRORRO').Value := AisErrorRRO;
        //Бумажный рецепт по СП
        FLocalDataBaseHead.FieldByName('ISPAPERRSP').Value := AisPaperRecipeSP;
        FLocalDataBaseHead.Post;
      End;
    except
      ON E: Exception do
      Begin
        Add_Log('Exception: ' + E.Message);
        Add_Log('GetLastError: ' + IntToStr(GetLastError) + ' - ' +
          SysErrorMessage(GetLastError));
        // что б отловить ошибки - запишим в лог
        Add_Log_XML('<Head err="' + E.Message + '">');

        Application.OnException(Application.MainForm, E);
        // ShowMessage('Ошибка локального сохранения чека: '+E.Message);
        Result := false;
        exit;
      End;
    end; // сохранили шапку

    // сохраняем тело
    ADS.DisableControls;
    try
      try
        ADS.Filtered := false;
        ADS.First;
        FLocalDataBaseBody.First;
        while not FLocalDataBaseBody.Eof do
        Begin
          if Trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = AUID then
            FLocalDataBaseBody.Delete;
          FLocalDataBaseBody.Next;
        End;
        FLocalDataBaseBody.Pack;
        str_log_xml := '';
        I := 0;
        while not ADS.Eof do
        Begin
          FLocalDataBaseBody.AddRecord
            (VarArrayOf([ADS.FieldByName('Id').AsInteger, // id записи
            AUID, // uid чека
            ADS.FieldByName('GoodsId').AsInteger, // ид товара
            ADS.FieldByName('GoodsCode').AsInteger, // Код товара
            ADS.FieldByName('GoodsName').AsString, // наименование товара
            ADS.FieldByName('NDS').asCurrency, // НДС товара
            ADS.FieldByName('Amount').asCurrency, // Кол-во
            ADS.FieldByName('Price').asCurrency,
            // Цена, с 20.07.16 если есть скидка по Проекту дисконта, здесь будет цена с учетом скидки
            // ***20.07.16
            ADS.FieldByName('PriceSale').asCurrency, // Цена без скидки
            ADS.FieldByName('ChangePercent').asCurrency, // % Скидки
            ADS.FieldByName('SummChangePercent').asCurrency, // Сумма Скидки
            // ***19.08.16
            ADS.FieldByName('AmountOrder').asCurrency, // Кол-во заявка
            // ***10.08.16
            ADS.FieldByName('List_UID').AsString, // UID строки продажи
            // ***03.06.19
            ADS.FieldByName('PartionDateKindId').asCurrency, // Тип срок/не срок
            // ***24.06.19
            ADS.FieldByName('PricePartionDate').asCurrency,
            // Отпускная цена согласно партии
            // ***03.06.19
            ADS.FieldByName('NDSKindId').AsInteger, // Ставка НДС
            // ***19.06.20
            ADS.FieldByName('DiscountExternalID').AsInteger, // Товар для проекта (дисконтные карты)
            // ***19.06.20
            ADS.FieldByName('DivisionPartiesID').AsInteger, // Разделение партий в кассе для продажи
            // ***02.10.20
            ADS.FieldByName('isPresent').AsBoolean, // Разделение партий в кассе для продажи
            // ***20.09.21
            ADS.FieldByName('JuridicalId').AsInteger // Товар поставщика
            ]));
          // сохранили отгруженные препараты для корректировки полных остатков
          if FSaveCheckToMemData then
          begin
            if mdCheck.Locate('ID;PDKINDID;NDSKINDId;DISCEXTID;DIVPARTID',
              VarArrayOf([ADS.FieldByName('GoodsId').AsInteger,
              ADS.FieldByName('PartionDateKindId').AsVariant,
              ADS.FieldByName('NDSKindId').AsVariant,
              ADS.FieldByName('DiscountExternalID').AsVariant,
              ADS.FieldByName('DivisionPartiesID').AsVariant]), []) then
              mdCheck.Edit
            else
            begin
              mdCheck.Append;
              mdCheck.FieldByName('ID').AsInteger := ADS.FieldByName('GoodsId')
                .AsInteger;
              mdCheck.FieldByName('PDKINDID').AsVariant :=
                ADS.FieldByName('PartionDateKindId').AsVariant;
              mdCheck.FieldByName('NDSKINDID').AsVariant :=
                ADS.FieldByName('NDSKindId').AsVariant;
              mdCheck.FieldByName('DISCEXTID').AsVariant :=
                ADS.FieldByName('DiscountExternalID').AsVariant;
              mdCheck.FieldByName('DIVPARTID').AsVariant :=
                ADS.FieldByName('DivisionPartiesID').AsVariant;
            end;
            mdCheck.FieldByName('Amount').asCurrency :=
              mdCheck.FieldByName('Amount').asCurrency +
              ADS.FieldByName('Amount').asCurrency;
            mdCheck.Post;
          end;
          // сохранили строку в лог
          I := I + 1;
          if str_log_xml <> '' then
            str_log_xml := str_log_xml + #10 + #13;
          try
            str_log_xml := str_log_xml + '<Items num="' + IntToStr(I) + '">' +
              '<GoodsCode>"' + ADS.FieldByName('GoodsCode').AsString + '"</GoodsCode>' +
              '<GoodsName>"' + AnsiUpperCase(ADS.FieldByName('GoodsName').Text) + '"</GoodsName>' +
              '<Amount>"' + FloatToStr(ADS.FieldByName('Amount').asCurrency) + '"</Amount>' +
              '<Price>"' + FloatToStr(ADS.FieldByName('Price').asCurrency) + '"</Price>' +
              '<List_UID>"' + ADS.FieldByName('List_UID').AsString + '"</List_UID>' +
              '<PartionDateKindId>"' + ADS.FieldByName('PartionDateKindId').AsString + '"</PartionDateKindId>' +
              '<NDSKindId>"' + ADS.FieldByName('NDSKindId').AsString + '"</NDSKindId>' +
              '<NDS>"' + ADS.FieldByName('NDS').AsString + '"</NDS>' +
              '<DiscountExternalID>"' + ADS.FieldByName('DiscountExternalID').AsString + '"</DiscountExternalID>' +
              '<DiscountExternalName>"' + ADS.FieldByName('DiscountExternalName').AsString + '"</DiscountExternalName>' +
              '<DivisionPartiesID>"' + ADS.FieldByName('DivisionPartiesID').AsString + '"</DivisionPartiesID>' +
              '<DivisionPartiesName>"' + ADS.FieldByName('DivisionPartiesName').AsString + '"</DivisionPartiesName>' +
              '</Items>';
          except
            str_log_xml := str_log_xml + '<Items num="' + IntToStr(I) + '">' +
              '<GoodsCode>"' + ADS.FieldByName('GoodsCode').AsString +
              '"</GoodsCode>' + '<GoodsName>"???"</GoodsName>' + '<List_UID>"' +
              ADS.FieldByName('List_UID').AsString + '"</List_UID>' +
              '</Items>';
          end;
          ADS.Next;
        End;

      Except
        ON E: Exception do
        Begin
          // что б отловить ошибки - запишим в лог
          Add_Log_XML('<Body err="' + E.Message + '">');

          Application.OnException(Application.MainForm, E);
          // ShowMessage('Ошибка локального сохранения содержимого чека: '+E.Message);
          Result := false;
          exit;
        End;
      end;
    finally
      ADS.Filtered := True;
      ADS.EnableControls;
      FLocalDataBaseBody.Filter := '';
      FLocalDataBaseBody.Filtered := True;
    end;
  finally
    FLocalDataBaseBody.Active := false;
    FLocalDataBaseHead.Active := false;
    ReleaseMutex(MutexDBF);
    PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 3); // только 2 форма
  end;

  // что б отловить ошибки - запишим в лог чек - во время СОХРАНЕНИЯ чека, т.е. ПОСЛЕ пробития через ЭККА
  Add_Log_XML('<Save now="' + FormatDateTime('YYYY.MM.DD hh:mm:ss', Now) + '">'
    + #10 + #13 + '<AUID>"' + AUID + '"</AUID>' + '<CheckNumber>"' +
    AFiscalCheckNumber + '"</CheckNumber>' + '<FiscalNumber>"' + FFiscalNumber +
    '"</FiscalNumber>' + #10 + #13 + str_log_xml + #10 + #13 + '</Save>');

  // update VIP
  if ((AManagerId <> 0) or (ABayerName <> '')) and (gc_User.Local) and ANeedComplete
  then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(VipCDS, vip_lcl);
      if (AId <> 0) then
      Begin
        if VipCDS.Locate('Id', AId, []) then VipCDS.Delete;
      End
      else if VipCDS.Locate('InvNumber', AUID, []) then VipCDS.Delete;
      SaveLocalData(VipCDS, vip_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp: TdsdStoredProc;
  ds: TClientDataSet;
begin // +
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Object_Member';
      sp.Params.Clear;
      sp.Params.AddParam('inIsShowAll', ftBoolean, ptInput, false);
      sp.Execute(false, false);
      WaitForSingleObject(MutexVip, INFINITE);
      // только для формы2;  защищаем так как есть в приложениее и сервисе
      SaveLocalData(ds, Member_lcl);
      ReleaseMutex(MutexVip); // только 2 форма

      sp.StoredProcName := 'gpSelect_Movement_CheckVIP';
      sp.Params.Clear;
      sp.Params.AddParam('inIsErased', ftBoolean, ptInput, false);
      sp.Execute(false, false);
      WaitForSingleObject(MutexVip, INFINITE);
      try
        SaveLocalData(ds, vip_lcl);
      finally
        ReleaseMutex(MutexVip);
      end;

      sp.StoredProcName := 'gpSelect_MovementItem_CheckDeferred';
      sp.Params.Clear;
      sp.Execute(false, false);
      WaitForSingleObject(MutexVip, INFINITE);
      try
        SaveLocalData(ds, vipList_lcl);
      finally
        ReleaseMutex(MutexVip);
      end;
    finally
      ds.Free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SetSoldRegim(const Value: Boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then
  begin
    actSold.Caption := 'Продажа';
    //edAmount.Text := '1'
  end
  else
  begin
    actSold.Caption := 'Возврат';
    //edAmount.Text := '-1';
  end;
end;

procedure TMainCashForm2.SetWorkMode(ALocal: Boolean);
begin
  actCheck.Enabled := not gc_User.Local;
  actGetMoneyInCash.Enabled := not gc_User.Local;
  actRefreshRemains.Enabled := not gc_User.Local;
  actOpenMCSForm.Enabled := not gc_User.Local;
  if not gc_User.Local then
  Begin
    spGet_User_IsAdmin.Execute;
    if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True then
      actCheck.FormNameParam.Value := 'TCheckJournalForm'
    Else
      actCheck.FormNameParam.Value := 'TCheckJournalUserForm';
  End
  else
  Begin
    if Assigned(VIPForm) then
    Begin
      VIPForm.AddOnFormData.isAlwaysRefresh := false;
      VIPForm.AddOnFormData.isSingle := True;
      VIPForm.isAlreadyOpen := True;
    End;
  End;
  actSelectLocalVIPCheck.Enabled := gc_User.Local;
  actSelectCheck.Enabled := not gc_User.Local;
  actRefreshLite.Enabled := not gc_User.Local;
  actUpdateRemains.Enabled := not gc_User.Local;
end;

procedure TMainCashForm2.Thread_Exception(var Msg: TMessage);
var
  spUserProtocol: TdsdStoredProc;
begin
  // Отключено только для MainCash, в форме MainCash2 сохранение ОШИБОК - ОСТАВИТЬ
  exit;

  spUserProtocol := TdsdStoredProc.Create(nil);
  try
    spUserProtocol.StoredProcName := 'gpInsert_UserProtocol';
    spUserProtocol.OutputType := otResult;
    spUserProtocol.Params.AddParam('inProtocolData', ftBlob, ptInput,
      ThreadErrorMessage);
    try
      spUserProtocol.Execute;
    except
    end;
  finally
    spUserProtocol.Free;
  end;
  // ShowMessage('Во время проведения чека возникла ошибка:'+#13+
  // ThreadErrorMessage+#13#13+
  // 'Проверьте состояние чека и, при необходимости, проведите чек вручную.');
end;

procedure TMainCashForm2.TimerActiveAlertsTimer(Sender: TObject);
   var Mes: TMessage; APoint : TPoint;
begin
  TimerActiveAlerts.Enabled := False;
  if Assigned(FHint) then FreeAndNil(FHint);
  try
    if gc_User.Local then
    begin
      FActiveAlerts := '';
      lblActiveAlerts.Style.Color := clLime;
      lblActiveAlerts.Caption := '';
      lblActiveAlerts.Hint := 'Тревоги нет';
    end else
    begin
      spActiveAlerts.ParamByName('outActiveAlerts').Value := '';
      spActiveAlerts.ParamByName('outstartDate').Value := Null;
      spActiveAlerts.Execute;

      if FActiveAlerts <> spActiveAlerts.ParamByName('outActiveAlerts').Value then
      begin
        if spActiveAlerts.ParamByName('outActiveAlerts').Value <> '' then
        begin
          FActiveAlertsDate := spActiveAlerts.ParamByName('outstartDate').Value;
          if FActiveAlerts = '' then
          begin
            lblActiveAlerts.Style.Color := clRed;
            lblActiveAlerts.Hint := '!! !! !! Увага! Оголошено тривогу, всім пройти в укриття !! !! !!'#13#13 + FormatDateTime('HH:NN', FActiveAlertsDate);
            lblActiveAlerts.Caption := '!!!';

            APoint := lblActiveAlerts.ClientToScreen(Point(0, btnVIP.ClientHeight));
            FHint := THintWindow.Create(Self);
            FHint.Canvas.Font.Size := FHint.Font.Size * 3 div 2;
            FHint.Canvas.Font.Style := FHint.Font.Style + [fsBold];
            FHint.ActivateHint(TRect.Create(APoint.X, APoint.Y, APoint.X + 400, APoint.Y + 100),  lblActiveAlerts.Hint);

            Application.Hint := lblActiveAlerts.Hint;
            Application.ActivateHint(APoint);
            Application.Hint := '';
          end;
          FActiveAlerts := spActiveAlerts.ParamByName('outActiveAlerts').Value;
        end else
        begin
          FActiveAlerts := '';

          lblActiveAlerts.Style.Color := clLime;
          lblActiveAlerts.Caption := '';
          lblActiveAlerts.Hint := 'Тревоги нет';

          APoint := lblActiveAlerts.ClientToScreen(Point(0, btnVIP.ClientHeight));
          FHint := THintWindow.Create(Self);
          FHint.Canvas.Font.Size := FHint.Font.Size * 3 div 2;
          FHint.Canvas.Font.Style := FHint.Font.Style + [fsBold];
          FHint.ActivateHint(TRect.Create(APoint.X, APoint.Y, APoint.X + 400, APoint.Y + 100),  'Увага! ВІДБІЙ ТРИВОГИ'#13#13 + FormatDateTime('HH:NN', Now));
        end;

      end;

    end;
  finally
    if not UnitConfigCDS.FieldByName('isShowActiveAlerts').AsBoolean then
    begin
      TimerActiveAlerts.Enabled := False;
      lblActiveAlerts.Visible := False;
      FActiveAlerts := '';
    end else TimerActiveAlerts.Enabled := True;
  end;
end;

procedure TMainCashForm2.TimerAnalogFilterTimer(Sender: TObject);
begin
  TimerAnalogFilter.Enabled := false;
  TimerAnalogFilter.Enabled := True;
  ProgressBar1.Position := ProgressBar1.Position + 10;
  if ProgressBar1.Position = 100 then
    edAnalogFilterExit(Sender);
end;

procedure TMainCashForm2.TimerBlinkBtnTimer(Sender: TObject);
begin
  TimerBlinkBtn.Enabled := false;
  try

    SetBlinkVIP(false);
    SetBlinkCheck(false);

    if fBlinkVIP = True then
    begin
      if btnVIP.Colors.NormalText <> clDefault then
      begin
        btnVIP.Colors.NormalText := clDefault;
        btnVIP.Colors.Default := clDefault;
      end
      else
      begin { Beep; }
        btnVIP.Colors.NormalText := clYellow;
        btnVIP.Colors.Default := clRed;
      end;

      btnVIP.Caption := '';
      if FIsVIP then btnVIP.Caption := 'VIP';
      if FIsTabletki then btnVIP.Caption := btnVIP.Caption + IfThen(btnVIP.Caption = '', '', '/') + 'Табл';
      if FIsLiki24 then btnVIP.Caption := btnVIP.Caption + IfThen(btnVIP.Caption = '', '', '/') + 'Liki';
      if btnVIP.Caption = '' then btnVIP.Caption := 'Vip/Табл/Liki';

    end else
    begin
      btnVIP.Colors.NormalText := clDefault;
      btnVIP.Colors.Default := clDefault;
      btnVIP.Caption := 'Vip/Табл/Liki';
    end;

    if fBlinkCheck = True then
      if btnCheck.Colors.NormalText <> clDefault then
      begin
        btnCheck.Colors.NormalText := clDefault;
        btnCheck.Colors.Default := clDefault;
      end
      else
      begin
        btnCheck.Colors.NormalText := clBlue;
        btnCheck.Colors.Default := clRed;
      end
    else
    begin
      btnCheck.Colors.NormalText := clDefault;
      btnCheck.Colors.Default := clDefault;
    end;
  finally
    TimerBlinkBtn.Enabled := True;
  end;

end;

procedure TMainCashForm2.TimerDroppedDownTimer(Sender: TObject);
begin
  lcName.DroppedDown := false;
  TimerDroppedDown.Enabled := false;
end;

procedure TMainCashForm2.SetBlinkVIP(isRefresh: Boolean);
var
  lMovementId_BlinkVIP, AResult: String;
begin
  if gc_User.Local then
    exit; // только 2 форма
  // если прошло > 100 сек - захардкодил
  if ((Now - time_onBlink) > 0.002) or (isRefresh = True) then

    try
      // сохранили время "последней" обработки ВСЕХ документов - с типом "Не подтвержден"
      time_onBlink := Now;

      // Получили список ВСЕХ документов - с типом "Не подтвержден"
      spGet_BlinkVIP.Execute;
      lMovementId_BlinkVIP := spGet_BlinkVIP.ParamByName('outMovementId_list').Value;
      FIsVIP := spGet_BlinkVIP.ParamByName('outIsVIP').Value;
      FIsTabletki := spGet_BlinkVIP.ParamByName('outIsTabletki').Value;
      FIsLiki24 := spGet_BlinkVIP.ParamByName('outIsLiki24').Value;

      if spGet_BlinkVIP.ParamByName('outIsOrderTabletki').Value and Self.Showing then
      begin
        ShowPUSHMessageCash('Обработайте заказ!'#13#10#13#10'На аптеку через  5 мин будет наложен штраф в размере 200 грн'#13#10'(пока в режиме тестирование, после анонса в группе штрафы будут реальными)', AResult, False,
                            'TCheckSiteForm', 'Просмотр чеков с сайта "Таблетки"');
        spGet_BlinkVIP.Execute;
      end;

      if UnitConfigCDS.Active and UnitConfigCDS.FindField('isExpressVIPConfirm').AsBoolean and Self.Showing and
         (spGet_BlinkVIP.ParamByName('outExpressVIPConfirm').Value > 0) and
         (spGet_BlinkVIP.ParamByName('outExpressVIPConfirm').Value <= UnitConfigCDS.FindField('ExpressVIPConfirm').AsInteger) then
      begin
        actExpressVIPConfirm.Execute;
        spGet_BlinkVIP.Execute;
        lMovementId_BlinkVIP := spGet_BlinkVIP.ParamByName('outMovementId_list').Value;
        FIsVIP := spGet_BlinkVIP.ParamByName('outIsVIP').Value;
        FIsTabletki := spGet_BlinkVIP.ParamByName('outIsTabletki').Value;
        FIsLiki24 := spGet_BlinkVIP.ParamByName('outIsLiki24').Value;
      end;


      // в этом случае кнопка будет мигать
      fBlinkVIP := lMovementId_BlinkVIP <> '';

      // если сюда дошли, значит ON-line режим режим для VIP-чеков
      FTextError := '';
      SetMainFormCaption;

      // если список изменился ИЛИ надо "по любому обновить" - запустим "не самое долгое" обновление грида
      if (lMovementId_BlinkVIP <> MovementId_BlinkVIP) or (isRefresh = True)
      then
      begin
        // Сохранили список ВСЕХ документов - с типом "Не подтвержден"
        MovementId_BlinkVIP := lMovementId_BlinkVIP;
        // "не самое долгое" обновление грида

      end;

      FError_Blink := 0;
    except
      Inc(FError_Blink);
      if FError_Blink > 3 then
      begin
        FTextError := ' - OFF-line режим для VIP-чеков - ';
        SetMainFormCaption;
      end;
    end;
end;

procedure TMainCashForm2.SetBlinkCheck(isRefresh: Boolean);
var
  lMovementId_BlinkCheck: String;

begin
  if gc_User.Local then
    exit; // только 2 форма
  // если прошло > 50 сек - захардкодил
  if ((Now - time_onBlinkCheck) > 0.003) or (isRefresh = True) then

    try
      // сохранили время "последней" обработки ВСЕХ документов - с "ошибка - расч/факт остаток"
      time_onBlinkCheck := Now;

      // Получили список ВСЕХ документов - с типом "Не подтвержден"
      spGet_BlinkCheck.Execute;
      lMovementId_BlinkCheck := spGet_BlinkCheck.ParamByName
        ('outMovementId_list').Value;

      // в этом случае кнопка будет мигать
      fBlinkCheck := lMovementId_BlinkCheck <> '';

      // если сюда дошли, значит ON-line режим режим для проверки "ошибка - расч/факт остаток"
      if fBlinkCheck = True then
        FTextError := ' - есть ошибки - расч/факт остаток - '
      else FTextError := '';
      SetMainFormCaption;

      FError_Blink := 0;
    except
      Inc(FError_Blink);
      if FError_Blink > 3 then
      begin
        FTextError := ' - OFF-line режим для чеков с ошибкой - ';
        SetMainFormCaption;
      end;
    end;
end;

procedure TMainCashForm2.SetBanCash(isRefresh: Boolean);
  var EmployeeScheduleCDS : TClientDataSet;
begin
  if isRefresh Then fBanCash := True;
  if fBanCash = False then Exit;

  if not gc_User.Local then
  Begin
    spGet_User_IsAdmin.Execute;
    if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True then
    begin
      fBanCash := False;
      Exit;
    end;

    try
      // Получили статус не отметился
      spGet_BanCash.Execute;
      fBanCash := spGet_BanCash.ParamByName('outBanCash').Value;
      if not fBanCash then Exit;
    except
      fBanCash := True;
    end;

  End else if gc_User.Session = '3' then
  begin
    fBanCash := False;
    Exit;
  end;

      // Получили статус не отметился
  if not FileExists(EmployeeSchedule_lcl) then
  begin
    fBanCash := True;
    Exit;
  end;

  EmployeeScheduleCDS :=  TClientDataSet.Create(Nil);
  WaitForSingleObject(MutexEmployeeSchedule, INFINITE);
  try
    LoadLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
    if EmployeeScheduleCDS.Active then
      fBanCash := not EmployeeScheduleCDS.Locate('UserID;Date', VarArrayOf([gc_User.Session, Date]), [])
    else fBanCash := True;

  finally
    if EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Close;
    EmployeeScheduleCDS.Free;
    ReleaseMutex(MutexEmployeeSchedule);
  end;

end;

procedure TMainCashForm2.pGet_OldSP(var APartnerMedicalId: Integer;
  var APartnerMedicalName, AMedicSP: String; var AOperDateSP: TDateTime);
begin

  APartnerMedicalId := 0;
  APartnerMedicalName := '';
  AMedicSP := '';
  //
  try
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Active := True;
      FLocalDataBaseHead.First;
      while not FLocalDataBaseHead.Eof do
      begin
        if (FLocalDataBaseHead.FieldByName('PMEDICALID').AsInteger <> 0) and
          not FLocalDataBaseHead.FieldByName('SAVE').AsBoolean then
        begin
          APartnerMedicalId := FLocalDataBaseHead.FieldByName('PMEDICALID')
            .AsInteger;
          APartnerMedicalName :=
            Trim(FLocalDataBaseHead.FieldByName('PMEDICALN').AsString);
          AMedicSP := Trim(FLocalDataBaseHead.FieldByName('MEDICSP').AsString);
          AOperDateSP := FLocalDataBaseHead.FieldByName('OPERDATESP')
            .asCurrency;
        end;

        FLocalDataBaseHead.Next;
      end;
    finally
      FLocalDataBaseBody.Active := false;
      ReleaseMutex(MutexDBF);
    end;
    //
  except
  end;

end;

function TMainCashForm2.pCheck_InvNumberSP(ASPKind: Integer;
  ANumber: string): Boolean;
begin

  Result := false;
  //
  try
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Active := True;
      FLocalDataBaseHead.First;
      while not FLocalDataBaseHead.Eof do
      begin
        if (FLocalDataBaseHead.FieldByName('SPKindId').AsInteger = ASPKind) and
          (FLocalDataBaseHead.FieldByName('INVNUMSP').AsString = ANumber) then
        begin
          Result := True;
          Break;
        end;

        FLocalDataBaseHead.Next;
      end;
    finally
      FLocalDataBaseBody.Active := false;
      ReleaseMutex(MutexDBF);
    end;
    //
  except
  end;

end;

procedure TMainCashForm2.TimerSaveAllTimer(Sender: TObject);
var
  fEmpt: Boolean;
  RCount: Integer;
begin
  if gc_User.Local then
    exit; // только 2 форма
  TimerSaveAll.Enabled := false;
  fEmpt := True;
  RCount := 0;
  //
  try
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Active := True;
      fEmpt := FLocalDataBaseHead.isempty;
      RCount := FLocalDataBaseHead.RecordCount;
      FLocalDataBaseBody.Active := false;
    finally
      FLocalDataBaseBody.Active := false;
      ReleaseMutex(MutexDBF);
    end;
    //
    // пишем протокол что связь с базой есть + сколько чеков еще не перенеслось
    try
      spUpdate_UnitForFarmacyCash.ParamByName('inAmount').Value := RCount;
      spUpdate_UnitForFarmacyCash.Execute;
    except
    end;
    //
  finally
    //
    TimerSaveAll.Enabled := True;
  end;
end;

procedure TMainCashForm2.TimerServiceRunTimer(Sender: TObject);
const
  SERVICE_RUN_INTERVAL = 1000 * 60 * 10;
begin
  inherited;
  if TimerServiceRun.Interval <> SERVICE_RUN_INTERVAL then
    TimerServiceRun.Interval := SERVICE_RUN_INTERVAL;
  actServiseRun.Execute; // запуск сервиса  // только 2 форма
end;

procedure TMainCashForm2.LoadFromLocalStorage;
var
  nRemainsID, nAlternativeID, nCheckId: Integer;
begin
  startSplash('Начало обновления данных с сервера !!');

  try
    MainGridDBTableView.BeginUpdate;
    RemainsCDS.DisableControls;
    // AlternativeCDS.DisableControls;
    ExpirationDateCDS.DisableControls;
    nRemainsID := 0;
    if RemainsCDS.Active and (RemainsCDS.RecordCount > 0) then
      nRemainsID := RemainsCDS.FieldByName('Id').AsInteger;
    nAlternativeID := 0;
    // if AlternativeCDS.Active and (AlternativeCDS.RecordCount > 0) then
    // nAlternativeID := AlternativeCDS.FieldByName('Id').asInteger;
    nCheckId := 0;
    if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
      nCheckId := CheckCDS.FieldByName('GoodsId').AsInteger;
    try
      if not fileExists(Remains_lcl) { or not FileExists(Alternative_lcl) } then
        ShowMessage('Нет локального хранилища.');

      WaitForSingleObject(MutexRemains, INFINITE);
      try
        LoadLocalData(RemainsCDS, Remains_lcl);
      finally
        ReleaseMutex(MutexRemains);
      end;
      // WaitForSingleObject(MutexAlternative, INFINITE);
      // try
      // LoadLocalData(AlternativeCDS, Alternative_lcl);
      // finally
      // ReleaseMutex(MutexAlternative);
      // end;
      WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
      try
        LoadLocalData(ExpirationDateCDS, GoodsExpirationDate_lcl);
      finally
        ReleaseMutex(MutexGoodsExpirationDate);
      end;
      UpdateImplementationPlanEmployee;
      // Заполнение шапки главной формы
      SetMainFormCaption;
      // корректируем новые остатки с учетом того, что уже было в чеке
      CheckCDS.First;
      while not CheckCDS.Eof do
      begin
        if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([CheckCDS.FieldByName('GoodsId').AsInteger,
          CheckCDS.FieldByName('PartionDateKindId').AsVariant,
          CheckCDS.FieldByName('NDSKindId').AsVariant,
          CheckCDS.FieldByName('DiscountExternalID').AsVariant,
          CheckCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
        begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').asCurrency :=
            RemainsCDS.FieldByName('Remains').asCurrency -
            CheckCDS.FieldByName('Amount').asCurrency;
          RemainsCDS.Post;
        end;
        CheckCDS.Next;
      end;
      // корректируем новые остатки с учетом того, что было отгружено во время получения остатков
      mdCheck.First;
      while not mdCheck.Eof do
      begin
        if RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
          VarArrayOf([mdCheck.FieldByName('Id').AsInteger,
          mdCheck.FieldByName('PDKINDID').AsVariant,
          mdCheck.FieldByName('NDSKINDId').AsVariant,
          mdCheck.FieldByName('DISCEXTID').AsVariant,
          mdCheck.FieldByName('DIVPARTID').AsVariant]), []) then
        begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').asCurrency :=
            RemainsCDS.FieldByName('Remains').asCurrency -
            mdCheck.FieldByName('AMOUNT').asCurrency;
          RemainsCDS.Post;
        end;
        mdCheck.Next;
      end;
      mdCheck.Close;
      mdCheck.Open;
    finally
      if nRemainsID <> 0 then
        RemainsCDS.Locate('Id', nRemainsID, []);
      // if nAlternativeID <> 0 then
      // AlternativeCDS.Locate('Id', nAlternativeID, []);
      if nCheckId <> 0 then
        CheckCDS.Locate('GoodsId', nCheckId, []);
      RemainsCDS.EnableControls;
      // AlternativeCDS.EnableControls;
      ExpirationDateCDS.EnableControls;
      MainGridDBTableView.EndUpdate;
    end;
  finally
    EndSplash;
  end;
end;

procedure TMainCashForm2.LoadBankPOSTerminal;
var
  nPos: Integer;
begin
  if not fileExists(BankPOSTerminal_lcl) then
    exit;

  BankPOSTerminalCDS.DisableControls;
  try
    if BankPOSTerminalCDS.Active then
      nPos := BankPOSTerminalCDS.RecNo
    else
      nPos := 0;
    WaitForSingleObject(MutexBankPOSTerminal, INFINITE);
    try
      LoadLocalData(BankPOSTerminalCDS, BankPOSTerminal_lcl);
    finally
      ReleaseMutex(MutexBankPOSTerminal);
    end;
  finally
    if (nPos <> 0) and BankPOSTerminalCDS.Active and
      (BankPOSTerminalCDS.RecordCount >= nPos) then
      BankPOSTerminalCDS.RecNo := nPos;
    BankPOSTerminalCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.LoadGoodsExpirationDate;
begin
  if not fileExists(GoodsExpirationDate_lcl) then
    exit;

  ExpirationDateCDS.DisableControls;
  try
    WaitForSingleObject(MutexGoodsExpirationDate, INFINITE);
    try
      LoadLocalData(ExpirationDateCDS, GoodsExpirationDate_lcl);
    finally
      ReleaseMutex(MutexGoodsExpirationDate);
    end;
  finally
    ExpirationDateCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.LoadUnitConfig;
var
  nPos: Integer;
  bOverload, bGetHardwareData, bRemovingPrograms : Boolean;
begin
  if not fileExists(UnitConfig_lcl) then
    exit;

  WaitForSingleObject(MutexUnitConfig, INFINITE);
  try

    if UnitConfigCDS.Active then
    begin
      bOverload := True;
      bGetHardwareData := UnitConfigCDS.FindField('isGetHardwareData').AsBoolean;
      bRemovingPrograms := UnitConfigCDS.FindField('isRemovingPrograms').AsBoolean;
    end else bOverload := False;

    UnitConfigCDS.Close;
    LoadLocalData(UnitConfigCDS, UnitConfig_lcl);

    if bOverload then
    begin
      UnitConfigCDS.Edit;
      UnitConfigCDS.FindField('isGetHardwareData').AsBoolean := bGetHardwareData;
      UnitConfigCDS.FindField('isRemovingPrograms').AsBoolean := bRemovingPrograms;
      UnitConfigCDS.Post;
    end;

    if UnitConfigCDS.Active and Assigned(UnitConfigCDS.FindField('isSpotter'))
    then
    begin
      actNotTransferTime.Enabled := UnitConfigCDS.FindField('isSpotter')
        .AsBoolean;
      actNotTransferTime.Visible := UnitConfigCDS.FindField('isSpotter')
        .AsBoolean;
    end;

    if UnitConfigCDS.Active and
      Assigned(UnitConfigCDS.FindField('PermanentDiscountID')) and
      not UnitConfigCDS.FieldByName('PermanentDiscountID').IsNull and
      (UnitConfigCDS.FieldByName('PermanentDiscountPercent').asCurrency > 0)
    then
    begin
      Label24.Visible := True;
      edPermanentDiscount.Text := UnitConfigCDS.FieldByName
        ('PermanentDiscountPercent').AsString + ' %';
    end
    else
      Label24.Visible := false;
    edPermanentDiscount.Visible := Label24.Visible;
    actPromoCodeDoctor.Enabled := UnitConfigCDS.FieldByName('isPromoCodeDoctor')
      .AsBoolean;
    pmPromoCodeDoctor.Visible := UnitConfigCDS.FieldByName('isPromoCodeDoctor')
      .AsBoolean;
    pmTechnicalRediscount.Visible := UnitConfigCDS.FieldByName
      ('isTechnicalRediscount').AsBoolean;
    pmTechnicalRediscountCashier.Visible := UnitConfigCDS.FieldByName
      ('isTechnicalRediscount').AsBoolean;
    actOpenLayoutFile.Enabled := UnitConfigCDS.FieldByName('LayoutFileCount').AsInteger > 0;
    actOpenLayoutFile.Visible := actOpenLayoutFile.Enabled;
    actOpenFilesToCheck.Enabled := UnitConfigCDS.FieldByName('FilesToCheckCount').AsInteger > 0;
    actOpenFilesToCheck.Visible := actOpenFilesToCheck.Enabled;
    actAddGoodsSupplement.Enabled := UnitConfigCDS.FieldByName('isSupplementAddCash').AsBoolean;
    actAddGoodsSupplement.Visible := actAddGoodsSupplement.Enabled;

    if not UnitConfigCDS.FieldByName('isShowActiveAlerts').AsBoolean then
    begin
      TimerActiveAlerts.Enabled := False;
      lblActiveAlerts.Visible := False;
      FActiveAlerts := '';
    end else
    begin
      TimerActiveAlerts.Enabled := True;
      lblActiveAlerts.Visible := True;
      FActiveAlerts := '';
    end;

  finally
    ReleaseMutex(MutexUnitConfig);
  end;
end;

procedure TMainCashForm2.LoadTaxUnitNight;
var
  nPos: Integer;
begin
  if not fileExists(TaxUnitNight_lcl) then
    exit;

  WaitForSingleObject(MutexTaxUnitNight, INFINITE);
  try
    LoadLocalData(TaxUnitNightCDS, TaxUnitNight_lcl);
  finally
    ReleaseMutex(MutexTaxUnitNight);
  end;
end;

function TMainCashForm2.GetAmount: Currency;
var
  nAmount: Currency;
  nOne: Extended;
  nOut, nPack, nOst: Integer;
begin
  Result := 0;

  if edAmount.Text = '' then
  begin
    if edAmount.Enabled then ActiveControl := edAmount;
    ShowMessage
      ('Ошибка. Не заполнено количество.'#13#10'Должно быть или дробь:'#13#10'Количество продажи / Количество в упаковке');
  end;

  if FormParams.ParamByName('isDiscountCommit').Value = True then
  begin
    ShowMessage('По текущему чеку Дисконт проведен на сайте!');
    exit;
  end;

  if DiscountServiceForm.isPrepared then
  begin
    ShowMessage('В текущем чеке запрошена возможность продажи. Произведите продажу или очистите чек!');
    exit;
  end;

  if Pos('/', edAmount.Text) > 0 then
  begin
    if not TryStrToInt(Copy(edAmount.Text, 1, Pos('/', edAmount.Text) - 1),
      nOut) or (nOut = 0) then
    begin
      ActiveControl := edAmount;
      ShowMessage('Ошибка. Не заполнено количество единиц продажи.');
    end;

    if not TryStrToInt(Copy(edAmount.Text, Pos('/', edAmount.Text) + 1,
      Length(edAmount.Text)), nPack) or (nPack = 0) then
    begin
      ActiveControl := edAmount;
      ShowMessage('Ошибка. Не заполнено количество единиц в упаковке.');
    end;

    nOut := abs(nOut);
    nAmount := RoundTo(nOut / nPack, -3);
    nOne := 1 / nPack;

    if SoldRegim then
    begin

      if abs(frac(RemainsCDS.FieldByName('Remains').asCurrency) -
        Round(frac(RemainsCDS.FieldByName('Remains').asCurrency) / nOne) * nOne)
        / nOne * 100 >= 2 then
      begin
        ShowMessage('Остаток не соответствует введеной делимости.');
        exit;
      end;

      if (frac(nAmount) = (frac(RemainsCDS.FieldByName('Remains').asCurrency) +
        0.001)) and (nPack < 500) then
        nAmount := nAmount - 0.001
      else if (frac(nAmount) = (frac(RemainsCDS.FieldByName('Remains')
        .asCurrency) - 0.001)) and (nPack < 500) then
        nAmount := nAmount + 0.001
      else if frac(nAmount) <> frac(RemainsCDS.FieldByName('Remains').asCurrency)
      then
      begin
        if frac(RemainsCDS.FieldByName('Remains').asCurrency) = 0 then
          nOst := nPack - (nOut mod nPack)
        else
          nOst := Round(frac(RemainsCDS.FieldByName('Remains').asCurrency) /
            nOne) - (nOut mod nPack);
        if nOst = 0 then
          nAmount := nAmount +
            (frac(RemainsCDS.FieldByName('Remains').asCurrency) - frac(nAmount))
        else if frac(RemainsCDS.FieldByName('Remains').asCurrency) = 0 then
          nAmount := nAmount + (1 - RoundTo(nOst * nOne, -3) - frac(nAmount))
        else
          nAmount := nAmount +
            (frac(RemainsCDS.FieldByName('Remains').asCurrency) -
            RoundTo(nOst * nOne, -3) - frac(nAmount));
      end;
    end
    else
    begin

      if abs(frac(CheckCDS.FieldByName('Amount').asCurrency) -
        Round(frac(CheckCDS.FieldByName('Amount').asCurrency) / nOne) * nOne) /
        nOne * 100 >= 2 then
      begin
        ShowMessage('Остаток не соответствует введеной делимости.');
        exit;
      end;

      if Pos('-', edAmount.Text) = 1 then
      begin
        if (frac(nAmount) = (frac(CheckCDS.FieldByName('Amount').asCurrency) +
          0.001)) and (nPack < 500) then
          nAmount := nAmount - 0.001
        else if (frac(nAmount) = (frac(CheckCDS.FieldByName('Amount')
          .asCurrency) - 0.001)) and (nPack < 500) then
          nAmount := nAmount + 0.001
        else if frac(nAmount) <> frac(CheckCDS.FieldByName('Amount').asCurrency)
        then
        begin
          if frac(CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nOst := nPack - (nOut mod nPack)
          else
            nOst := Round(frac(CheckCDS.FieldByName('Amount').asCurrency) /
              nOne) - (nOut mod nPack);
          if nOst = 0 then
            nAmount := nAmount +
              (frac(CheckCDS.FieldByName('Amount').asCurrency) - frac(nAmount))
          else if frac(CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nAmount := nAmount + (1 - RoundTo(nOst * nOne, -3) - frac(nAmount))
          else
            nAmount := nAmount +
              (frac(CheckCDS.FieldByName('Amount').asCurrency) -
              RoundTo(nOst * nOne, -3) - frac(nAmount));
        end;
        nAmount := -nAmount;
      end
      else
      begin
        if (frac(nAmount) = (frac(CheckCDS.FieldByName('Remains').asCurrency -
          CheckCDS.FieldByName('Amount').asCurrency) + 0.001)) and (nPack < 500)
        then
          nAmount := nAmount - 0.001
        else if (frac(nAmount) = (frac(CheckCDS.FieldByName('Remains')
          .asCurrency - CheckCDS.FieldByName('Amount').asCurrency) - 0.001)) and
          (nPack < 500) then
          nAmount := nAmount + 0.001
        else if frac(nAmount) <> frac(CheckCDS.FieldByName('Remains').asCurrency
          - CheckCDS.FieldByName('Amount').asCurrency) then
        begin
          if frac(CheckCDS.FieldByName('Remains').asCurrency -
            CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nOst := nPack - (nOut mod nPack)
          else
            nOst := Round(frac(CheckCDS.FieldByName('Remains').asCurrency -
              CheckCDS.FieldByName('Amount').asCurrency) / nOne) -
              (nOut mod nPack);
          if nOst = 0 then
            nAmount := nAmount +
              (frac(CheckCDS.FieldByName('Remains').asCurrency -
              CheckCDS.FieldByName('Amount').asCurrency) - frac(nAmount))
          else if frac(CheckCDS.FieldByName('Remains').asCurrency -
            CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nAmount := nAmount + (1 - RoundTo(nOst * nOne, -3) - frac(nAmount))
          else
            nAmount := nAmount +
              (frac(CheckCDS.FieldByName('Remains').asCurrency -
              CheckCDS.FieldByName('Amount').asCurrency) - RoundTo(nOst * nOne,
              -3) - frac(nAmount));
        end;
      end;
    end;

    Result := nAmount;
  end
  else
  begin
    if not TryStrToCurr(edAmount.Text, nAmount) then
    begin
      if edAmount.Enabled then ActiveControl := edAmount;
      ShowMessage('Ошибка. Невозможно преобразовать строку "' + edAmount.Text +
        '" в число.');
    end
    else
      Result := RoundTo(nAmount, -3);
  end;
end;

// Сохранение чеков в CSV по дням
procedure TMainCashForm2.Add_Check_History;
var
  F: TextFile;
  cName, S: string;
  bNew: Boolean;
  I: Integer;
  SR: TSearchRec;
  FileList: TStringList;
begin
  try
    if not ForceDirectories(ExtractFilePath(Application.ExeName) +
      'CheckHistory') then
    begin
      ShowMessage
        ('Ошибка создания директории для сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору...');
      exit;
    end;

    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\' +
      FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F, cName);
    if not fileExists(cName) then
    begin

      { FileList := TStringList.Create;
        try
        if FindFirst(ExtractFilePath(Application.ExeName) + 'CheckHistory\*.CSV', faAnyFile, SR) = 0 then
        repeat
        if SR.Name < FormatDateTime('YYYY-MM-DD', IncMonth(Date, -1)) + '.CSV' then
        FileList.Add(ExtractFilePath(Application.ExeName) + 'CheckHistory\' + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR);

        for I := 0 to FileList.Count - 1 do DeleteFile(FileList.Strings[I]);
        finally
        FileList.Free;
        end; }

      Rewrite(F);
      bNew := True;
    end
    else
    begin
      Append(F);
      bNew := false;
    end;

    try
      if bNew then
        Writeln(F,
          'Тип;Дата и время;Подразделение;Касса;Кассир;Код;Наименование товара;Кол-во;Цена;Сумма');
      bNew := True;
      if pnlVIP.Visible then
        S := 'Вип'
      else
        S := '';
      if pnlVIP.Visible and pnlSP.Visible then
        S := S + ',';
      if pnlSP.Visible then
        S := S + 'Сп.';

      // Содержимое чека
      with CheckCDS do
      begin
        First;
        while not Eof do
        begin
          if bNew then
            Writeln(F, S + ';' + DateTimeToStr(Now) + ';' + iniLocalUnitNameGet
              + ';' + IntToStr(iniCashID) + ';' + gc_User.Login + ';' +
              FieldByName('GoodsCode').AsString + ';' +
              StringReplace(FieldByName('GoodsName').AsString, ';', ',',
              [rfReplaceAll]) + ';' + FieldByName('Amount').AsString + ';' +
              FieldByName('Price').AsString + ';' +
              FieldByName('Summ').AsString)
          else
            Writeln(F, ';;;;;' + FieldByName('GoodsCode').AsString + ';' +
              StringReplace(FieldByName('GoodsName').AsString, ';', ',',
              [rfReplaceAll]) + ';' + FieldByName('Amount').AsString + ';' +
              FieldByName('Price').AsString + ';' + FieldByName('Summ')
              .AsString);
          Next;
          bNew := false;
        end;
        First;
      end;
    finally
      CloseFile(F);
    end;
  except
    on E: Exception do
      ShowMessage
        ('Ошибка сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору: '
        + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.Start_Check_History(SalerCash, SalerCashAdd: Currency;
  PaidType: TPaidType);
var
  F: TextFile;
  cName, S: string;
  bNew: Boolean;
  I: Integer;
  SR: TSearchRec;
  FileList: TStringList;
begin
  try
    if not ForceDirectories(ExtractFilePath(Application.ExeName) +
      'CheckHistory') then
    begin
      ShowMessage
        ('Ошибка создания директории для сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору...');
      exit;
    end;

    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\ListCheck' +
      FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F, cName);
    if not fileExists(cName) then
    begin

      FileList := TStringList.Create;
      try
        if FindFirst(ExtractFilePath(Application.ExeName) +
          'CheckHistory\ListCheck*.CSV', faAnyFile, SR) = 0 then
          repeat
            if SR.Name < 'ListCheck' + FormatDateTime('YYYY-MM-DD',
              IncMonth(Date, -1)) + '.CSV' then
              FileList.Add(ExtractFilePath(Application.ExeName) +
                'CheckHistory\' + SR.Name);
          until FindNext(SR) <> 0;
        FindClose(SR);

        for I := 0 to FileList.Count - 1 do
          DeleteFile(FileList.Strings[I]);
      finally
        FileList.Free;
      end;

      Rewrite(F);
      bNew := True;
    end
    else
    begin
      Append(F);
      bNew := false;
    end;

    try
      if bNew then
        Write(F, 'Тип;Дата и время;Подразделение;Касса;Кассир;Сумма нал;Сумма карта;Сумма закрытия');
      bNew := True;
      if pnlVIP.Visible then
        S := 'Вип'
      else
        S := '';
      if pnlVIP.Visible and pnlSP.Visible then
        S := S + ',';
      if pnlSP.Visible then
        S := S + 'Сп.';
      Writeln(F, '');
      Write(F, S + ';' + DateTimeToStr(Now) + ';' + iniLocalUnitNameGet + ';' +
        IntToStr(iniCashID) + ';' + gc_User.Login + ';');
      case PaidType of
        ptMoney:
          Write(F, CurrToStr(SalerCash) + ';;');
        ptCard:
          Write(F, ';' + CurrToStr(SalerCash) + ';');
        ptCardAdd:
          Write(F, CurrToStr(SalerCashAdd) + ';' +
            CurrToStr(SalerCash - SalerCashAdd) + ';');
      end;
    finally
      CloseFile(F);
    end;
  except
    on E: Exception do
      ShowMessage
        ('Ошибка сохранения перечня чеков на локальном компьютере. Покажите это окно системному администратору: '
        + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.Finish_Check_History(SalerCash: Currency);
var
  F: TextFile;
  cName: string;
begin
  try
    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\ListCheck' +
      FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F, cName);
    if fileExists(cName) then
    begin
      Append(F);
      try
        Write(F, CurrToStr(SalerCash));
      finally
        CloseFile(F);
      end;
    end;
  except
    on E: Exception do
      ShowMessage
        ('Ошибка сохранения перечня чеков на локальном компьютере. Покажите это окно системному администратору: '
        + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.SetTaxUnitNight;
var
  bThereIs, bActive: Boolean;
begin
  bThereIs := false;
  bActive := false;
  if UnitConfigCDS.Active and (UnitConfigCDS.RecordCount = 1) and
    TaxUnitNightCDS.Active and UnitConfigCDS.FieldByName('TaxUnitNight').AsBoolean
  then
  begin
    bThereIs := UnitConfigCDS.FieldByName('TaxUnitNight').AsBoolean;
    bActive := bThereIs and
      ((TimeOf(UnitConfigCDS.FieldByName('TaxUnitStartDate').AsDateTime) < Time)
      or (TimeOf(UnitConfigCDS.FieldByName('TaxUnitEndDate')
      .AsDateTime) > Time));
  end;

  pnlTaxUnitNight.Visible := bActive;
  if pnlTaxUnitNight.Visible then
    edTaxUnitNight.Text := 'C ' + FormatDateTime('HH:NN',
      UnitConfigCDS.FieldByName('TaxUnitStartDate').AsDateTime) + ' по ' +
      FormatDateTime('HH:NN', UnitConfigCDS.FieldByName('TaxUnitEndDate')
      .AsDateTime)
  else
    edTaxUnitNight.Text := '';

  MainColPriceNight.Visible := bThereIs;
  MainGridPriceChangeNight.Visible := bThereIs;
end;

// Процент ночной скидки по цене
function TMainCashForm2.CalcTaxUnitNightPercent(ABasePrice: Currency): Currency;
begin
  Result := 0;
  if TaxUnitNightCDS.Active then
    try
      TaxUnitNightCDS.Filter := 'PriceTaxUnitNight < ' + CurrToStr(ABasePrice);
      TaxUnitNightCDS.Filtered := True;
      TaxUnitNightCDS.Last;
      if TaxUnitNightCDS.RecordCount > 0 then
        Result := TaxUnitNightCDS.FieldByName('ValueTaxUnitNight').asCurrency;
    finally
      TaxUnitNightCDS.Filtered := false;
      TaxUnitNightCDS.Filter := '';
    end;
end;

// Расчет ночной цены
function TMainCashForm2.CalcTaxUnitNightPrice(ABasePrice, APrice: Currency;
  APercent: Currency = 0): Currency;
var
  nPercent: Currency;
begin
  if pnlTaxUnitNight.Visible then
    nPercent := CalcTaxUnitNightPercent(ABasePrice)
  else
    nPercent := 0;
  if APercent = 0 then
  begin
    if nPercent = 0 then
      Result := APrice
    else
      Result := GetPrice(APrice, -nPercent)
  end
  else
  begin
    if nPercent = 0 then
      Result := GetPrice(APrice, APercent)
    else
      Result := GetPrice(APrice, APercent - nPercent);
  end;
end;

function TMainCashForm2.CalcTaxUnitNightPriceGrid(ABasePrice, APrice: Currency)
  : Currency;
var
  nPercent: Currency;
begin
  nPercent := CalcTaxUnitNightPercent(ABasePrice);
  if nPercent = 0 then
    Result := APrice
  else
    Result := GetPrice(APrice, -nPercent);
end;

// Расчет цены, скидок
procedure TMainCashForm2.CalcPriceSale(var APriceSale, APrice,
  AChangePercent: Currency; APriceBase, APercent: Currency;
  APriceChange: Currency = 0);
var
  nPercent: Currency;
begin

  // цена БЕЗ скидки
  APriceSale := APriceBase;

  if APriceChange <> 0 then
  begin
    if pnlTaxUnitNight.Visible then
    begin
      nPercent := CalcTaxUnitNightPercent(APriceBase);
      // цена СО скидкой
      APrice := GetPrice(APriceChange, -nPercent);
      // процент скидки
      AChangePercent := -nPercent;
    end
    else
    begin
      // цена СО скидкой
      APrice := APriceChange;
      // процент скидки
      AChangePercent := 0
    end;
  end
  else
  begin
    if pnlTaxUnitNight.Visible then
    begin
      nPercent := CalcTaxUnitNightPercent(APriceBase);
      // цена СО скидкой
      APrice := GetPrice(APriceBase, APercent - nPercent);
      // процент скидки
      AChangePercent := APercent - nPercent;
    end
    else
    begin
      // цена СО скидкой
      APrice := GetPrice(APriceBase, APercent);
      // процент скидки
      AChangePercent := APercent;
    end;
  end;
end;


procedure TMainCashForm2.ClearDistributionPromo;
begin
  SetLength(aDistributionPromoId, 0);
  SetLength(aDistributionPromoAmount, 0);
  SetLength(aDistributionPromoSum, 0);
end;

procedure TMainCashForm2.AddDistributionPromo(AID : Integer; AAmount, ASumm : Currency);
  var I : Integer;
begin

  for I := Low(aDistributionPromoId) to High(aDistributionPromoId) do
    if aDistributionPromoId[I] = AID then
  begin
    aDistributionPromoAmount[I] := aDistributionPromoAmount[I] + AAmount;
    aDistributionPromoSum[I] := aDistributionPromoSum[I] + ASumm;
    Exit;
  end;

  SetLength(aDistributionPromoId, Length(aDistributionPromoId) + 1);
  SetLength(aDistributionPromoAmount, Length(aDistributionPromoAmount) + 1);
  SetLength(aDistributionPromoSum, Length(aDistributionPromoSum) + 1);

  aDistributionPromoId[High(aDistributionPromoId)] := AID;
  aDistributionPromoAmount[High(aDistributionPromoAmount)] := AAmount;
  aDistributionPromoSum[High(aDistributionPromoSum)] := ASumm;

end;

function TMainCashForm2.ShowDistributionPromo : Boolean;
  var DistributionPromoCDS: TClientDataSet;I : Integer;
begin
  Result := True;
  FormParams.ParamByName('DistributionPromoList').Value := '';

  if Length(aDistributionPromoId) = 0 then Exit;

  if not fileExists(DistributionPromo_lcl) then
    exit;

  try

    DistributionPromoCDS := TClientDataSet.Create(Nil);
    DistributionPromoCDS.IndexFieldNames := 'ID';

    WaitForSingleObject(MutexDistributionPromo, INFINITE);
    try
      if fileExists(GoodsExpirationDate_lcl) then
        LoadLocalData(DistributionPromoCDS, DistributionPromo_lcl);
      if not DistributionPromoCDS.Active then
        DistributionPromoCDS.Open;

      for I := Low(aDistributionPromoId) to High(aDistributionPromoId) do
        if DistributionPromoCDS.Locate('Id', aDistributionPromoId[I], []) then
      begin
        if (DistributionPromoCDS.FieldByName('StartPromo').AsDateTime <= Date) and (DistributionPromoCDS.FieldByName('EndPromo').AsDateTime >= Date) and
           ((DistributionPromoCDS.FieldByName('Amount').AsCurrency > 0) and (DistributionPromoCDS.FieldByName('Amount').AsCurrency <= aDistributionPromoAmount[I]) OR
           (DistributionPromoCDS.FieldByName('SummRepay').AsCurrency > 0) and (DistributionPromoCDS.FieldByName('SummRepay').AsCurrency <= aDistributionPromoSum[I]) OR
           (DistributionPromoCDS.FieldByName('Amount').AsCurrency = 0) and (DistributionPromoCDS.FieldByName('SummRepay').AsCurrency = 0)) then
        begin

          if FormParams.ParamByName('DistributionPromoList').Value <> '' then
            FormParams.ParamByName('DistributionPromoList').Value := FormParams.ParamByName('DistributionPromoList').Value + ',';
          FormParams.ParamByName('DistributionPromoList').Value := DistributionPromoCDS.FieldByName('Id').AsString + ',';

          if ShowPUSHMessage(DistributionPromoCDS.FieldByName('Message').AsString) then
            FormParams.ParamByName('DistributionPromoList').Value := FormParams.ParamByName('DistributionPromoList').Value + '1'
          else FormParams.ParamByName('DistributionPromoList').Value := FormParams.ParamByName('DistributionPromoList').Value + '0';
        end;
      end;


    finally
      ReleaseMutex(MutexDistributionPromo);
    end;
  finally
    DistributionPromoCDS.Free;
  end;
end;

procedure TMainCashForm2.spLayoutFileFTPParamsAfterExecute(Sender: TObject);
begin
  inherited;

end;

// Пропись выполнения плана по сотруднику
procedure TMainCashForm2.UpdateImplementationPlanEmployee;
  var S : string; F : boolean;
begin

  // Очищаем данные по выполнению плана сотрудника
  RemainsCDS.First;
  while not RemainsCDS.Eof do
  begin
    if RemainsCDS.FieldByName('Color_IPE').AsInteger <> 0 then
    begin
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('Color_IPE').AsInteger := 0;
      RemainsCDS.Post;
    end;
    RemainsCDS.Next;
  end;

  // Загрузка ImplementationPlanEmployee_lcl по выполнению плана сотрудника
  if FileExists(ImplementationPlanEmployee_lcl) then
  begin
    WaitForSingleObject(MutexImplementationPlanEmployee, INFINITE);
    try
      try

        PlanEmployeeCDS.Close;
        LoadLocalData(PlanEmployeeCDS, ImplementationPlanEmployee_lcl);
        if not PlanEmployeeCDS.Active then PlanEmployeeCDS.Open;

        PlanEmployeeCDS.First;
        if PlanEmployeeCDS.IsEmpty then Exit
        else if PlanEmployeeCDS.FieldByName('UserId').AsString <> gc_User.Session then
        begin
          PlanEmployeeCDS.Close;
          Exit;
        end;

        S := RemainsCDS.Filter;
        F := RemainsCDS.Filtered;
        try
          while not PlanEmployeeCDS.Eof do
          begin

            RemainsCDS.Filtered := False;
            RemainsCDS.Filter := 'GoodsCode = ' + PlanEmployeeCDS.FieldByName('GoodsCode').AsString;
            RemainsCDS.Filtered := True;
            RemainsCDS.First;
            while not RemainsCDS.Eof do
            begin
              if RemainsCDS.FieldByName('Color_IPE').AsInteger <> PlanEmployeeCDS.FieldByName('Color').AsInteger then
              begin
                RemainsCDS.Edit;
                RemainsCDS.FieldByName('Color_IPE').AsInteger := PlanEmployeeCDS.FieldByName('Color').AsInteger;
                RemainsCDS.Post;
              end;
              RemainsCDS.Next;
            end;
            PlanEmployeeCDS.Next;
          end;
        finally
          RemainsCDS.Filter := S;
          RemainsCDS.Filtered := F;
        end;

      Except ON E:Exception do
        Add_Log('Ошибка загрузки выполнения плана сотрудника:' + E.Message);
      end;
    finally
      ReleaseMutex(MutexImplementationPlanEmployee);
    end;
  end;

end;

// Заполнение шапки главной формы
procedure TMainCashForm2.SetMainFormCaption;
  var ds : TClientDataSet;
begin

  Self.Caption := 'Продажа (' + GetFileVersionString(ParamStr(0)) + ')' +  FTextError +
          ' <' + IniUtils.gUnitName + '>' + ' <' + IntToStr(IniUtils.gUserCode) + '>'  + ' - <' + IniUtils.gUserName + '>';

  // Пропись итогов выполнения плана по сотруднику
  if UnitConfigCDS.Active and UnitConfigCDS.FieldByName('isShowPlanEmployeeUser').AsBoolean and FileExists(ImplementationPlanEmployeeUser_lcl) then
  begin
    ds := TClientDataSet.Create(nil);
    try
      WaitForSingleObject(MutexImplementationPlanEmployeeUser, INFINITE);
      try
        try

          LoadLocalData(ds, ImplementationPlanEmployeeUser_lcl);
          if not ds.Active then ds.Open;

          if ds.IsEmpty then Exit;
          if (ds.FieldByName('UserID').AsString = gc_User.Session) or (gc_User.Session = '3') then
          begin
             Self.Caption := Self.Caption + ' <Маркетинг: ' + FormatFloat(',0.00', ds.FieldByName('Total').AsCurrency) + '>'
          end;

        Except ON E:Exception do
          Add_Log('Ошибка загрузки итогов выполнения плана сотрудника:' + E.Message);
        end;
      finally
        ReleaseMutex(MutexImplementationPlanEmployeeUser);
      end;
    finally
      freeAndNil(ds);
    end;
  end;

end;

procedure TMainCashForm2.ClearAll;
begin
  UpdateRemainsFromCheck;
  CheckCDS.EmptyDataSet;
  NewCheck(True);
end;

procedure TMainCashForm2.LoadMedicalProgramSPGoods(AGoodsId : Integer);
begin

  if (FormParams.ParamByName('isPaperRecipeSP').Value = True) and
     (FormParams.ParamByName('MedicalProgramSPId').Value = 0) then
  begin
    MedicalProgramSPGoodsCDS.Close;
    spGetMedicalProgramSP.ParamByName('inSPKindId').Value := FormParams.ParamByName('SPKindId').Value;
    spGetMedicalProgramSP.ParamByName('inGoodsId').Value := AGoodsId;
    spGetMedicalProgramSP.ParamByName('inCashSessionId').Value := iniLocalGUIDGet;
    spGetMedicalProgramSP.Execute;

    if MedicalProgramSPGoodsCDS.IsEmpty then
    begin
      raise Exception.Create('Ошибка получения медицинской программы медикамента. Возможно к вашей аптеке она не подключена.');
    end else if MedicalProgramSPGoodsCDS.RecordCount = 1 then
    begin
      FormParams.ParamByName('MedicalProgramSPId').Value := MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPId').AsInteger;
      lblMemberSP.Caption := MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPName').AsString;
    end else
    begin
      if ChoiceMedicalProgramSPExecute then
      begin
        FormParams.ParamByName('MedicalProgramSPId').Value := MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPId').AsInteger;
        lblMemberSP.Caption := MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPName').AsString;
      end else raise Exception.Create('Ошибка не выбрана медицинская программа.');
    end;
    MedicalProgramSPGoodsCDS.Close;
  end;

  if not MedicalProgramSPGoodsCDS.Active or
    (MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPID').AsInteger <> FormParams.ParamByName('MedicalProgramSPId').Value) then
  begin
    MedicalProgramSPGoodsCDS.Close;
    spMedicalProgramSP_Goods.ParamByName('inSPKindId').Value := FormParams.ParamByName('SPKindId').Value;
    spMedicalProgramSP_Goods.ParamByName('inMedicalProgramSPId').Value := FormParams.ParamByName('MedicalProgramSPId').Value;
    spMedicalProgramSP_Goods.ParamByName('inCashSessionId').Value := iniLocalGUIDGet;
    spMedicalProgramSP_Goods.Execute;
  end;

  if not MedicalProgramSPGoodsCDS.Active or not MedicalProgramSPGoodsCDS.Locate('GoodsId', AGoodsId, []) or
    (MedicalProgramSPGoodsCDS.FieldByName('MedicalProgramSPID').AsInteger <> FormParams.ParamByName('MedicalProgramSPId').Value) then
    raise Exception.Create('Ошибка получения данных по программе для медикамента. Покажите это окно системному администратору');

end;

procedure TMainCashForm2.MoveLogFile;
  var s, p: string; sl : TStringList;  i : integer;
begin

  if DayOf(Date) <> 1 then Exit;

  sl := TStringList.Create;
  try

    p := ExtractFilePath(Application.ExeName);

    if not ForceDirectories(p + 'LogArchive\') then
    begin
      Add_Log('Error crete path: ' + p + 'LogArchive\');
      Exit;
    end;

    try

      for s in TDirectory.GetFiles(p, '*.log') do sl.Add(TPath.GetFileName(s));

      for i := 0 to sl.Count - 1 do if (GetFileSizeByName(p + sl.Strings[i]) > 5000000) and not
        FileExists(p + 'LogArchive\' + TPath.GetFileNameWithoutExtension(sl.Strings[i]) + '_' + FormatDateTime('yyyy-mm-dd', Date) + TPath.GetExtension(sl.Strings[i])) then
      begin
        TFile.Copy(p + sl.Strings[i], p + 'LogArchive\' + TPath.GetFileNameWithoutExtension(sl.Strings[i]) + '_' + FormatDateTime('yyyy-mm-dd', Date) + TPath.GetExtension(sl.Strings[i]), true);
        TFile.Delete(p + sl.Strings[i]);
      end;

      sl.Clear;

      for s in TDirectory.GetFiles(p, '*log.xml') do sl.Add(TPath.GetFileName(s));

      for i := 0 to sl.Count - 1 do if (GetFileSizeByName(p + sl.Strings[i]) > 5000000) and not
        FileExists(p + 'LogArchive\' + TPath.GetFileNameWithoutExtension(sl.Strings[i]) + '_' + FormatDateTime('yyyy-mm-dd', Date) + TPath.GetExtension(sl.Strings[i])) then
      begin
        TFile.Copy(p + sl.Strings[i], p + 'LogArchive\' + TPath.GetFileNameWithoutExtension(sl.Strings[i]) + '_' + FormatDateTime('yyyy-mm-dd', Date) + TPath.GetExtension(sl.Strings[i]), true);
        TFile.Delete(p + sl.Strings[i]);
      end;

    except
      ON E: Exception do Add_Log('MoveLogFile err=' + E.Message);
    end;


  finally
    sl.Free;
  end;
end;

procedure TMainCashForm2.SaveUnitConfig;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    try
      ds := TClientDataSet.Create(nil);
      try
        sp.OutputType := otDataSet;
        sp.DataSet := ds;

        sp.StoredProcName := 'gpSelect_Cash_UnitConfig';
        sp.Params.Clear;
        sp.Params.AddParam('inCashRegister', ftString, ptInput, iniLocalCashRegisterGet);
        sp.Execute;
        Add_Log('Start MutexUnitConfig');
        WaitForSingleObject(MutexUnitConfig, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          SaveLocalData(ds,UnitConfig_lcl);
        finally
          Add_Log('End MutexUnitConfig');
          ReleaseMutex(MutexUnitConfig);
        end;

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        Add_Log('SaveUnitConfig Exception: ' + E.Message);
        Exit;
      end;
    end;
  finally
    freeAndNil(sp);
    LoadUnitConfig;
  end;
end;

{ TSaveRealThread }
{ TRefreshDiffThread }
{ TSaveRealAllThread }
initialization

RegisterClass(TMainCashForm2);
FLocalDataBaseHead := TVKSmartDBF.Create(nil);
FLocalDataBaseBody := TVKSmartDBF.Create(nil);
FLocalDataBaseDiff := TVKSmartDBF.Create(nil); // только 2 форма
InitializeCriticalSection(csCriticalSection);
InitializeCriticalSection(csCriticalSection_Save);
InitializeCriticalSection(csCriticalSection_All);
FM_SERVISE := RegisterWindowMessage('FarmacyCashMessage'); // только 2 форма

finalization

FLocalDataBaseHead.Free;
FLocalDataBaseBody.Free;
FLocalDataBaseDiff.Free; // только 2 форма
DeleteCriticalSection(csCriticalSection);
DeleteCriticalSection(csCriticalSection_Save);
DeleteCriticalSection(csCriticalSection_All);

end.
