unit MainCash2;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
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
  ActiveX,  Math, ShellApi,
  VKDBFDataSet, FormStorage, CommonData, ParentForm, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, LocalStorage, cxGridExportLink,
  cxButtonEdit, PosInterface, PosFactory, PayPosTermProcess;

type
  THeadRecord = record
    ID: Integer;//id чека
    PAIDTYPE:Integer; //тип оплаты
    MANAGER:Integer; //Id Менеджера (VIP)
    NOTMCS:Boolean; //Не для НТЗ
    COMPL:Boolean; //Напечатан
    SAVE:Boolean; //Сохранен
    NEEDCOMPL: Boolean; //Необходимо проведение
    DATE: TDateTime; //дата/Время чека
    UID: String[50];//uid чека
    CASH: String[20]; //серийник аппарата
    BAYER:String[254]; //Покупатель (VIP)
    FISCID:String[50]; //Номер фискального чека
    //***20.07.16
    DISCOUNTID : Integer;     //Id Проекта дисконтных карт
    DISCOUNTN  : String[254]; //Название Проекта дисконтных карт
    DISCOUNT   : String[50];  //№ Дисконтной карты
    //***16.08.16
    BAYERPHONE  : String[50];  //Контактный телефон (Покупателя) - BayerPhone
    CONFIRMED   : String[50];  //Статус заказа (Состояние VIP-чека) - ConfirmedKind
    NUMORDER    : String[50];  //Номер заказа (с сайта) - InvNumberOrder
    CONFIRMEDC  : String[50];  //Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
    //***24.01.17
    USERSESION: string[50]; //Для сервиса - реальная сесия при продаже
    //***08.04.17
    PMEDICALID  : Integer;       //Id Медицинское учреждение(Соц. проект)
    PMEDICALN   : String[254];   //Название Медицинское учреждение(Соц. проект)
    AMBULANCE   : String[50];    //№ амбулатории (Соц. проект)
    MEDICSP     : String[254];   //ФИО врача (Соц. проект)
    INVNUMSP    : String[50];    //номер рецепта (Соц. проект)
    OPERDATESP  : TDateTime;     //дата рецепта (Соц. проект)
    //***15.06.17
    SPKINDID    : Integer;       //Id Вид СП
    //***05.02.18
    PROMOCODE : Integer;       //Id промокода
  end;
  TBodyRecord = record
    ID: Integer;            //ид записи
    GOODSID: Integer;       //ид товара
    GOODSCODE: Integer;     //Код товара
    NDS: Currency;          //НДС товара
    AMOUNT: Currency;       //Кол-во
    PRICE: Currency;        //Цена, с 20.07.16 если есть скидка по Проекту дисконта, здесь будет цена с учетом скидки
    CH_UID: String[50];     //uid чека
    GOODSNAME: String[254]; //наименование товара
    //***20.07.16
    PRICESALE: Currency;    // Цена без скидки
    CHPERCENT: Currency;    // % Скидки
    SUMMCH: Currency;       // Сумма Скидки
    //***19.08.16
    AMOUNTORD: Currency;    // Кол-во заявка
    //***10.08.16
    LIST_UID: String[50]    // UID строки продажи
  end;
  TBodyArr = Array of TBodyRecord;

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
    spSelectRemains: TdsdStoredProc;
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
    GoodsId_main: TcxGridDBColumn;    
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
    actSaveCashSesionIdToFile: TAction; // только 2 форма
    actServiseRun: TAction; // только 2 форма
    MainColIsSP: TcxGridDBColumn;
    MainColPriceSP: TcxGridDBColumn;
    actSetSP: TAction;
    pnlSP: TPanel;
    Label4: TLabel;
    lblPartnerMedicalName: TLabel;
    Label7: TLabel;
    lblMedicSP: TLabel;
    miSetSP: TMenuItem;
    MainColPriceSaleSP: TcxGridDBColumn;
    DiffSP1: TcxGridDBColumn;
    DiffSP2: TcxGridDBColumn;
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
    MorionCode: TcxGridDBColumn;
    actSetMemdataFromDBF: TAction; // только 2 форма
    actSetUpdateFromMemdata: TAction; // только 2 форма
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
    AccommodationName: TcxGridDBColumn;
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
    actOpenMovementSP: TMultiAction;
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
    cxCheckBox1: TcxCheckBox;
    actSpecCorr: TAction;
    TimerPUSH: TTimer;
    spGet_PUSH_Cash: TdsdStoredProc;
    PUSHDS: TClientDataSet;
    actDoesNotShare: TAction;
    actUpdateRemainsCDS1: TMenuItem;
    spDoesNotShare: TdsdStoredProc;
    spInsert_MovementItem_PUSH: TdsdStoredProc;
    Multiplicity: TcxGridDBColumn;
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN);
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountExit(Sender: TObject);
    procedure actPutCheckToCashExecute(Sender: TObject);           {********************}
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
    procedure MainGridDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure TimerSaveAllTimer(Sender: TObject);
    procedure lcNameEnter(Sender: TObject);
    procedure TimerMoneyInCashTimer(Sender: TObject);
    procedure ParentFormShow(Sender: TObject);
    procedure actSelectLocalVIPCheckExecute(Sender: TObject);
    procedure actCheckConnectionExecute(Sender: TObject);
    procedure actSetDiscountExternalExecute(Sender: TObject);  //***20.07.16
    procedure CheckCDSBeforePost(DataSet: TDataSet);
    procedure TimerBlinkBtnTimer(Sender: TObject);
    procedure actSetConfirmedKind_CompleteExecute(Sender: TObject);
    procedure actSetConfirmedKind_UnCompleteExecute(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure ParentFormDestroy(Sender: TObject);
    procedure ceScanerKeyPress(Sender: TObject; var Key: Char); 
  	procedure actSetSPExecute(Sender: TObject);
    procedure actAddDiffMemdataExecute(Sender: TObject); // только 2 форма
    procedure actSetRimainsFromMemdataExecute(Sender: TObject); // только 2 форма
    procedure actSaveCashSesionIdToFileExecute(Sender: TObject); // только 2 форма
    procedure actServiseRunExecute(Sender: TObject); // только 2 форма
    procedure actSetMemdataFromDBFExecute(Sender: TObject); // только 2 форма
    procedure actSetUpdateFromMemdataExecute(Sender: TObject); //***10.08.16 // только 2 форма
	procedure actGetJuridicalListExecute(Sender: TObject);
    procedure actGetJuridicalListUpdate(Sender: TObject);
    procedure miMCSAutoClick(Sender: TObject); //***10.08.16
    procedure N1Click(Sender: TObject);
    procedure N10Click(Sender: TObject); //***10.08.16
    procedure actSetFilterExecute(Sender: TObject); //***10.08.16
    procedure actSetPromoCodeExecute(Sender: TObject); //***05.02.18
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
    procedure CheckGridDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actSetSiteDiscountExecute(Sender: TObject);
    procedure MainGridPriceChangeNightGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure MainColPriceNightGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure actSpecCorrExecute(Sender: TObject);
    procedure TimerPUSHTimer(Sender: TObject);
    procedure actDoesNotShareExecute(Sender: TObject);
  private
    isScaner: Boolean;
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Currency;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    ThreadErrorMessage:String;
    ASalerCash: Currency;
    ASalerCashAdd: Currency;
    PaidType: TPaidType;
    FiscalNumber: String;
    difUpdate: Boolean;  // только 2 форма
    VipCDS, VIPListCDS: TClientDataSet;
    VIPForm: TParentForm;
    // для мигания кнопки
    fBlinkVIP, fBlinkCheck : Boolean;
    time_onBlink, time_onBlinkCheck :TDateTime;
    MovementId_BlinkVIP:String;
    FSaveCheckToMemData: boolean;
    FShowMessageCheckConnection: boolean;
    FNeedFullRemains: boolean;

    FPUSHStart: boolean;
    FPUSHEnd: TDateTime;
    FLoadPUSH: Integer;

    procedure SetBlinkVIP (isRefresh : boolean);
    procedure SetBlinkCheck (isRefresh : boolean);

    procedure SetSoldRegim(const Value: boolean);
    // процедура обновляет параметры для введения нового чека
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    // Изменение тела чека
    procedure InsertUpdateBillCheckItems;
    //Обновить остаток согласно пришедшей разнице
    procedure UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
    //Возвращает товар в верхний грид
    procedure UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0; APriceSale: Currency = 0);

    //Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
    function fGetCheckAmountTotal(AGoodsId: Integer = 0; AAmount: Currency = 0) : Currency;

    // Обновляет сумму по чеку
    procedure CalcTotalSumm;
    // что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
    procedure Add_Log_XML(AMessage: String);
    // Пробивает чек через ЭККА
    function PutCheckToCash(SalerCash, SalerCashAdd: Currency; PaidType: TPaidType;
      out AFiscalNumber, ACheckNumber: String; APOSTerminalCode : Integer = 0; isFiscal: boolean = true): boolean;
    //подключение к локальной базе данных
    function InitLocalStorage: Boolean;
    procedure LoadFromLocalStorage;
    procedure LoadBankPOSTerminal;
    procedure LoadUnitConfig;
    procedure LoadTaxUnitNight;
    //Сохранение чека в локальной базе. возвращает УИД
    function SaveLocal(ADS :TClientDataSet; AManagerId: Integer; AManagerName: String;
      ABayerName, ABayerPhone, AConfirmedKindName, AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP : String;
      AOperDateSP : TDateTime;
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency; APromoCodeID, AManualDiscount : Integer;
      ASummPayAdd : Currency;  AMemberSPID, ABankPOSTerminal, AJackdawsChecksCode : integer; ASiteDiscount : Currency;
      NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;

    //проверили что есть остаток
    function fCheck_RemainsError : Boolean;

    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
    procedure Thread_Exception(var Msg: TMessage); message UM_THREAD_EXCEPTION;
    procedure ConnectionModeChange(var Msg: TMessage); message UM_LOCAL_CONNECTION;
    procedure SetWorkMode(ALocal: Boolean);
    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);  // только 2 форма
    function GetAmount : currency;

    // Сохранение чеков в CSV по дням
    procedure Add_Check_History;
    procedure Start_Check_History(SalerCash, SalerCashAdd: Currency; PaidType: TPaidType);
    procedure Finish_Check_History(SalerCash: Currency);
    // Очистка фильтров
    procedure ClearFilterAll;
    // Загружает VIP чек
    procedure LoadVIPCheck;
    procedure SetSiteDiscount(ASiteDiscount : Currency);

    // Установка отмена ночной скидки
    procedure SetTaxUnitNight;
    // Процент ночной скидки по цене
    function CalcTaxUnitNightPercent(ABasePrice : Currency) : Currency;
    // Расчет ночной цены
    function CalcTaxUnitNightPrice(ABasePrice, APrice : Currency; APercent : Currency = 0) : Currency;
    function CalcTaxUnitNightPriceGrid(ABasePrice, APrice : Currency) : Currency;

    // Расчет цены, скидок
    procedure CalcPriceSale(var APriceSale, APrice, AChangePercent : Currency;
                                APriceBase, APercent : Currency; APriceChange : Currency = 0);

  public
    procedure pGet_OldSP(var APartnerMedicalId: Integer; var APartnerMedicalName, AMedicSP: String; var AOperDateSP : TDateTime);
    procedure SetPromoCode(APromoCodeId: Integer; APromoName, APromoCodeGUID: String;
      APromoCodeChangePercent: currency);
  end;



var
  MainCashForm: TMainCashForm2;
  FLocalDataBaseHead : TVKSmartDBF;
  FLocalDataBaseBody : TVKSmartDBF;
  FLocalDataBaseDiff : TVKSmartDBF;  // только 2 форма
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection,
  csCriticalSection_Save,
  csCriticalSection_All: TRTLCriticalSection;

  MutexDBF, MutexDBFDiff, MutexVip, MutexRemains, MutexAlternative, MutexAllowedConduct,
  MutexDiffKind, MutexDiffCDS, MutexEmployeeWorkLog, MutexBankPOSTerminal,
  MutexUnitConfig, MutexTaxUnitNight : THandle;  // MutexAllowedConduct только 2 форма

  LastErr: Integer;
  FM_SERVISE: Integer;  // для передачи сообщений между приложение и сервисом // только 2 форма
  function GetPrice(Price, Discount:currency): currency;
  function GetSumm(Amount,Price:currency): currency;
  function GetSummFull(Amount,Price:currency): currency;
  function GenerateGUID: String;
  procedure Add_Log(AMessage: String);

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, DiscountDialog, SPDialog, CashWork, MessagesUnit,
     LocalWorkUnit, Splash, DiscountService, MainCash, UnilWin, ListDiff, ListGoods,
	   MediCard.Intf, PromoCodeDialog, ListDiffAddGoods, TlHelp32, EmployeeWorkLog;

const
  StatusUnCompleteCode = 1;
  StatusCompleteCode = 2;
  StatusUnCompleteId = 14;
  StatusCompleteId = 15;

// что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
procedure Add_Log(AMessage: String);
var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F,DateTimeToStr(Now) + ': ' + AMessage);
    finally CloseFile(F);
    end;
  except on E: Exception do
    ShowMessage('Ошибка сохранения в лог файл. Покажите это окно системному администратору: ' + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);  // только 2 форма
begin
  Handled := (Msg.hwnd = Application.Handle) and (Msg.message = FM_SERVISE);

  if Handled and (Msg.wParam = 1) then   //   WPARAM = 1 значит сообщения от сервиса в приложения  WPARAM = 2 от приложения в сервис
    case Msg.lParam of
      1: // получено сообщение на обновление diff разницы из дбф
        if difUpdate then
        begin
          difUpdate:=false;
          actAddDiffMemdata.Execute;   // вычитывает дбф в мемдату
          actSetRimainsFromMemdata.Execute; // обновляем остатки в товарах и чеках с учетом пришедших остатков в мемдате
          LoadBankPOSTerminal;
          LoadUnitConfig;
          LoadTaxUnitNight;
          SetTaxUnitNight;
        end;
      2:  // получен запрос на сохранение CashSessionId в  CashSessionId.ini
        begin
          actSaveCashSesionIdToFile.Execute;
        end;
      3:  // получен запрос на обновление всего
        begin
          LoadFromLocalStorage;
          LoadBankPOSTerminal;
          LoadUnitConfig;
          LoadTaxUnitNight;
          SetTaxUnitNight;
        end;
      4:  // получен запрос на сохранение в отдельную таблицу отгруженных чеков
        begin
          FSaveCheckToMemData := true;
        end;
      5:  // получен запрос на отмену сохранения в отдельную таблицу отгруженных чеков
        begin
          FSaveCheckToMemData := false;
        end;
      6: // служба перешла в онлайн режим
        begin
          FShowMessageCheckConnection := false;
          try
            actCheckConnection.Execute;
          finally
            FShowMessageCheckConnection := true;
          end;
        end;
    end;
end;

function GetPrice(Price, Discount:currency): currency;
var
  D, P, RI: Cardinal;
  S1: String;
begin
  if (Price = 0) then
  Begin
    result := 0;
    exit;
  End;
  D := trunc(Discount * 100);
  P := trunc(Price * 100);
  RI := P * (10000 - D);
  S1 := IntToStr(RI);
  if Length(S1) < 5 then
    RI := 0
  else
    RI := StrToInt(Copy(S1,1,length(S1)-4));
  if (Length(S1)>=4) AND
     (StrToint(S1[length(S1)-3])>=5) then
    RI := RI + 1;
  Result := (RI / 100);
end;

function GetSumm(Amount,Price:currency): currency;
var
  A, P, RI: Cardinal;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A*P;
  S1 := IntToStr(RI);
  if Length(S1) <= 4 then
    RI := 0
  else
    RI := StrToInt(Copy(S1,1,length(S1)-4));
  if (Length(S1)>=4) AND
     (StrToint(S1[length(S1)-3])>=5) then
    RI := RI + 1;
  Result := (RI / 10);
end;

function GetSummFull(Amount,Price:currency): currency;
var
  A, P, RI: Cardinal;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A*P;
  S1 := IntToStr(RI);
  if Length(S1) < 4 then
    RI := 0
  else
    RI := StrToInt(Copy(S1,1,length(S1)-3));
  if (Length(S1)>=3) AND
     (StrToint(S1[length(S1)-2])>=5) then
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
    RemainsCDS.FieldByName('AccommodationId').AsVariant     := actOpenAccommodation.GuiParams.ParamByName('Key').Value;
    RemainsCDS.FieldByName('AccommodationName').AsVariant   := actOpenAccommodation.GuiParams.ParamByName('TextValue').Value;
    RemainsCDS.Post;
    spUpdate_Accommodation.Execute;
  finally
    RemainsCDS.EnableControls;
  end;

end;

procedure TMainCashForm2.actAddDiffMemdataExecute(Sender: TObject);  // только 2 форма
begin
//  ShowMessage('memdat-begin');
  Add_Log('Ждем заполнения Memdata');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  Add_Log('Начало заполнения Memdata');
  try
    FLocalDataBaseDiff.Open;
    if not MemData.Active then
    MemData.Open;
    MemData.DisableControls;
    FLocalDataBaseDiff.First;
      while not FLocalDataBaseDiff.Eof  do
       begin
        MemData.Append;
        MemData.FieldByName('ID').AsInteger:=FLocalDataBaseDiff.FieldByName('ID').AsInteger;
        MemData.FieldByName('GOODSCODE').AsInteger:=FLocalDataBaseDiff.FieldByName('GOODSCODE').AsInteger;
        MemData.FieldByName('GOODSNAME').AsString:=FLocalDataBaseDiff.FieldByName('GOODSNAME').AsString;
        MemData.FieldByName('PRICE').AsFloat:=FLocalDataBaseDiff.FieldByName('PRICE').AsFloat;
        MemData.FieldByName('REMAINS').AsFloat:=FLocalDataBaseDiff.FieldByName('REMAINS').AsFloat;
        MemData.FieldByName('MCSVALUE').AsFloat:=FLocalDataBaseDiff.FieldByName('MCSVALUE').AsFloat;
        MemData.FieldByName('RESERVED').AsFloat:=FLocalDataBaseDiff.FieldByName('RESERVED').AsFloat;
        MemData.FieldByName('NEWROW').AsBoolean:=FLocalDataBaseDiff.FieldByName('NEWROW').AsBoolean;
        MemData.FieldByName('ACCOMID').AsVariant:=FLocalDataBaseDiff.FieldByName('ACCOMID').AsVariant;
        MemData.FieldByName('ACCOMNAME').AsVariant:=FLocalDataBaseDiff.FieldByName('ACCOMNAME').AsVariant;
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

procedure TMainCashForm2.actCalcTotalSummExecute(Sender: TObject);
begin
  CalcTotalSumm;
end;

procedure TMainCashForm2.actCashWorkExecute(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, RemainsCDS, FormParams.ParamByName('ZReportName').Value) do begin
    ShowModal;
    Free;
  end;
end;

procedure TMainCashForm2.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
begin
  if MainGrid.IsFocused then
  Begin
    if RemainsCDS.isempty then exit;
    if RemainsCDS.FieldByName('Remains').asCurrency>0 then begin
       SourceClientDataSet := RemainsCDS;
       SoldRegim := true;
       lcName.Text := RemainsCDS.FieldByName('GoodsName').asString;
       edAmount.Enabled := true;
       edAmount.Text := '1';
       ActiveControl := edAmount;
    end
  end
  else
  if AlternativeGrid.IsFocused then
  Begin
    if AlternativeCDS.isempty then exit;
    if AlternativeCDS.FieldByName('Remains').asCurrency>0 then begin
       SourceClientDataSet := AlternativeCDS;
       SoldRegim := true;
       lcName.Text := AlternativeCDS.FieldByName('GoodsName').asString;
       edAmount.Enabled := true;
       edAmount.Text := '1';
       ActiveControl := edAmount;
    end
  End
  else
  Begin
    if CheckCDS.isEmpty then exit;
    if CheckCDS.FieldByName('Amount').asCurrency>0 then begin
       SourceClientDataSet := CheckCDS;
       SoldRegim := False;
       lcName.Text := CheckCDS.FieldByName('GoodsName').asString;
       edAmount.Enabled := true;
       edAmount.Text := '-1';
       ActiveControl := edAmount;
    end;
  End;
end;

procedure TMainCashForm2.actClearAllExecute(Sender: TObject);
begin
  //if CheckCDS.IsEmpty then exit;
  if MessageDlg('Очистить все?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  Add_Log('Clear all');
  //Вернуть товар в верхний грид
  FormParams.ParamByName('CheckId').Value   := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('BayerName').Value := '';
  //***20.07.16
  FormParams.ParamByName('DiscountExternalId').Value   := 0;
  FormParams.ParamByName('DiscountExternalName').Value := '';
  FormParams.ParamByName('DiscountCardNumber').Value   := '';
  //***16.08.16
  FormParams.ParamByName('BayerPhone').Value              := '';
  FormParams.ParamByName('ConfirmedKindName').Value       := '';
  FormParams.ParamByName('InvNumberOrder').Value          := '';
  FormParams.ParamByName('ConfirmedKindClientName').Value := '';
  //***10.04.17
  FormParams.ParamByName('PartnerMedicalId').Value   := 0;
  FormParams.ParamByName('PartnerMedicalName').Value := '';
  FormParams.ParamByName('Ambulance').Value          := '';
  FormParams.ParamByName('MedicSP').Value            := '';
  FormParams.ParamByName('InvNumberSP').Value        := '';
  FormParams.ParamByName('OperDateSP').Value         := NOW;
  //***15.06.17
  FormParams.ParamByName('SPTax').Value      := 0;
  FormParams.ParamByName('SPKindId').Value   := 0;
  FormParams.ParamByName('SPKindName').Value := '';
  //***05.02.18
  FormParams.ParamByName('PromoCodeID').Value               := 0;
  FormParams.ParamByName('PromoCodeGUID').Value             := '';
  FormParams.ParamByName('PromoName').Value                 := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value    := 0.0;
  //***27.06.18
  FormParams.ParamByName('ManualDiscount').Value            := 0;
  //***02.11.18
  FormParams.ParamByName('SummPayAdd').Value                := 0;
  //***14.01.19
  FormParams.ParamByName('MemberSPID').Value                := 0;
  //***28.01.19
  FormParams.ParamByName('SiteDiscount').Value              := 0;
  //***20.02.19
  FormParams.ParamByName('BankPOSTerminal').Value           := 0;
  //***25.02.19
  FormParams.ParamByName('JackdawsChecksCode').Value        := 0;

  ClearFilterAll;

  FiscalNumber := '';
  pnlVIP.Visible := False;
  edPrice.Value := 0.0;
  edPrice.Visible := False;
  edDiscountAmount.Value := 0.0;
  edDiscountAmount.Visible := False;
  lblPrice.Visible := False;
  lblAmount.Visible := False;
  pnlDiscount.Visible := False;
  pnlSP.Visible := False;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  chbNotMCS.Checked := False;
  UpdateRemainsFromCheck;
  CheckCDS.EmptyDataSet;
  MCDesigner.CasualCache.Clear;
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  edPromoCode.Text := '';
  pnlSiteDiscount.Visible := false;
  edSiteDiscount.Value := 0;

  // Ночные скидки
  SetTaxUnitNight;
end;

procedure TMainCashForm2.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm2.actDeleteAccommodationExecute(Sender: TObject);
begin
  if RemainsCDS.FieldByName('AccommodationID').IsNull then
  begin
    ShowMessage('Медикамент не привязан к размещению!');
    Exit;
  end;

  if MessageDlg('Удалить привязку медикамента к размещению?',mtConfirmation,[mbYes,mbCancel], 0) <> mrYes then Exit;

  spDelete_Accommodation.Execute;

  try
    RemainsCDS.DisableControls;
    RemainsCDS.Edit;
    RemainsCDS.FieldByName('AccommodationId').AsVariant     := Null;
    RemainsCDS.FieldByName('AccommodationName').AsVariant   := Null;
    RemainsCDS.Post;
  finally
    RemainsCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.LoadVIPCheck;
  var lMsg: String; nRecNo : integer; APoint : TPoint;
begin
  inherited;

  //обновим "нужные" параметры-Main ***20.07.16
  DiscountServiceForm.pGetDiscountExternal (FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);
  // ***20.07.16
  if FormParams.ParamByName('DiscountExternalId').Value > 0 then
  begin
       //проверка карты + сохраним "текущие" параметры-Main
       if not DiscountServiceForm.fCheckCard (lMsg
                                             ,DiscountServiceForm.gURL
                                             ,DiscountServiceForm.gService
                                             ,DiscountServiceForm.gPort
                                             ,DiscountServiceForm.gUserName
                                             ,DiscountServiceForm.gPassword
                                             ,FormParams.ParamByName('DiscountCardNumber').Value
                                             ,FormParams.ParamByName('DiscountExternalId').Value
                                             )
       then begin
          // обнулим, пусть фармацевт начнет заново
          FormParams.ParamByName('DiscountExternalId').Value:= 0;
          // обнулим "нужные" параметры-Item
          //DiscountServiceForm.pSetParamItemNull;
       end;

  end;
  //
  if FormParams.ParamByName('InvNumberSP').Value = ''
  then begin
      // Update Дисконт в CDS - по всем "обновим" Дисконт
      DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);
      //
      CalcTotalSumm;
  end;

  //***20.07.16
  lblDiscountExternalName.Caption:= '  ' + FormParams.ParamByName('DiscountExternalName').Value + '  ';
  lblDiscountCardNumber.Caption  := '  ' + FormParams.ParamByName('DiscountCardNumber').Value + '  ';
  pnlDiscount.Visible            := FormParams.ParamByName('DiscountExternalId').Value > 0;

  lblPartnerMedicalName.Caption:= '  ' + FormParams.ParamByName('PartnerMedicalName').Value; // + '  /  № амб. ' + FormParams.ParamByName('Ambulance').Value;
  lblMedicSP.Caption:= '  ' + FormParams.ParamByName('MedicSP').Value + '  /  № '+FormParams.ParamByName('InvNumberSP').Value+'  от ' + DateToStr(FormParams.ParamByName('OperDateSP').Value);
  if FormParams.ParamByName('SPTax').Value <> 0 then lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FloatToStr(FormParams.ParamByName('SPTax').Value) + '% : ' + FormParams.ParamByName('SPKindName').Value
  else lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FormParams.ParamByName('SPKindName').Value;
  pnlSP.Visible:= FormParams.ParamByName('InvNumberSP').Value <> '';

  lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString;
  if (FormParams.ParamByName('ConfirmedKindName').AsString <> '')
  then lblCashMember.Caption := lblCashMember.Caption + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString;
  if (FormParams.ParamByName('InvNumberOrder').AsString <> '')
  then lblCashMember.Caption := lblCashMember.Caption + ' * ' + '№ ' + FormParams.ParamByName('InvNumberOrder').AsString;

  lblBayer.Caption := FormParams.ParamByName('BayerName').AsString;
  if (FormParams.ParamByName('BayerPhone').AsString <> '')
  then lblBayer.Caption := lblBayer.Caption + ' * ' + FormParams.ParamByName('BayerPhone').AsString;


  if FormParams.ParamByName('PromoCodeId').Value <> 0 then
    SetPromoCode(FormParams.ParamByName('PromoCodeId').Value,
      FormParams.ParamByName('PromoName').AsString,
      FormParams.ParamByName('PromoCodeGUID').AsString,
      FormParams.ParamByName('PromoCodeChangePercent').Value);
  if FormParams.ParamByName('SiteDiscount').Value > 0 then SetSiteDiscount(FormParams.ParamByName('SiteDiscount').Value);

  //***30.06.18
  if FormParams.ParamByName('ManualDiscount').Value > 0 then
  begin

    pnlManualDiscount.Visible := True;
    edManualDiscount.Value := FormParams.ParamByName('ManualDiscount').Value;

    CheckCDS.DisableControls;
    CheckCDS.Filtered := False;
    nRecNo := CheckCDS.RecNo;
    try

      CheckCDS.First;
      while not CheckCDS.Eof do
      begin

        if checkCDS.FieldByName('ChangePercent').asCurrency <> FormParams.ParamByName('ManualDiscount').Value then
        begin
          checkCDS.Edit;
          checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                  Self.FormParams.ParamByName('ManualDiscount').Value);
          checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('ManualDiscount').Value;
          CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
          checkCDS.FieldByName('SummChangePercent').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,
              CheckCDS.FieldByName('PriceSale').asCurrency) - CheckCDS.FieldByName('Summ').asCurrency;
          checkCDS.Post;
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

          //***04.09.18
  CheckCDS.DisableControls;
  CheckCDS.Filtered := False;
  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := False;
  nRecNo := RemainsCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if RemainsCDS.Locate('GoodsCode', checkCDS.FieldByName('GoodsCode').AsInteger,[]) and
        (((checkCDS.FieldByName('Amount').asCurrency + checkCDS.FieldByName('Remains').asCurrency) <>
        RemainsCDS.FieldByName('Remains').asCurrency) or
        (checkCDS.FieldByName('Color_calc').AsInteger <> RemainsCDS.FieldByName('Color_calc').asInteger) or
        (checkCDS.FieldByName('Color_ExpirationDate').AsInteger <> RemainsCDS.FieldByName('Color_ExpirationDate').asInteger) or
        (checkCDS.FieldByName('AccommodationName').AsVariant <> RemainsCDS.FieldByName('AccommodationName').AsVariant) or
        (checkCDS.FieldByName('Multiplicity').AsVariant <> RemainsCDS.FieldByName('Multiplicity').AsVariant)) then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency +
          checkCDS.FieldByName('Amount').asCurrency;
        if RemainsCDS.FieldByName('Color_calc').asInteger <> 0 then
        begin
          checkCDS.FieldByName('Color_calc').AsInteger:=RemainsCDS.FieldByName('Color_calc').asInteger;
          checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=RemainsCDS.FieldByName('Color_ExpirationDate').asInteger;
        end else
        begin
          checkCDS.FieldByName('Color_calc').AsInteger:=clWhite;
          checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=clBlack;
        end;
        checkCDS.FieldByName('AccommodationName').AsVariant:=RemainsCDS.FieldByName('AccommodationName').AsVariant;
        if checkCDS.FieldByName('Price').asCurrency <> checkCDS.FieldByName('PriceSale').asCurrency then
           checkCDS.FieldByName('Multiplicity').AsVariant:=RemainsCDS.FieldByName('Multiplicity').AsVariant;
        checkCDS.Post;
      end;
      CheckCDS.Next;
    end;
    CheckCDS.First;
  finally
    RemainsCDS.RecNo := nRecNo;
    CheckCDS.Filtered := True;
    CheckCDS.EnableControls;
    RemainsCDS.Filtered := True;
    RemainsCDS.EnableControls;
  end;

  pnlVIP.Visible := true;
end;

procedure TMainCashForm2.pm_VIP1Click(Sender: TObject);
begin
  inherited;
  case TMenuItem(Sender).Tag of
    0 : if actLoadVIP.Execute and (FormParams.ParamByName('CheckId').Value > 0) then LoadVIPCheck;
    1 : if actLoadVIP_Search.Execute and (FormParams.ParamByName('CheckId').Value > 0) then LoadVIPCheck;
  end;

  //
  SetBlinkVIP(true);
  //
  if not gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      SaveLocalData(VIPCDS,vip_lcl);
      SaveLocalData(VIPListCDS,vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
end;

procedure TMainCashForm2.actExecuteLoadVIPExecute(Sender: TObject);
  var lMsg: String; nRecNo : integer; APoint : TPoint;
begin
  inherited;

  if not CheckCDS.IsEmpty then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;
  if gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(vipCDS, Vip_lcl);
      LoadLocalData(vipListCDS, VipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
  APoint := btnVIP.ClientToScreen(Point(0, btnVIP.ClientHeight));
  pm_OpenVIP.Popup(APoint.X, APoint.Y);
end;

procedure TMainCashForm2.ClearFilterAll;
begin
  if pnlExpirationDateFilter.Visible then
  begin
    RemainsCDS.DisableControls;
    RemainsCDS.Filtered := False;
    try
      RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0';
      pnlExpirationDateFilter.Visible := False;
    finally
      RemainsCDS.Filtered := True;
      RemainsCDS.EnableControls;
      edlExpirationDateFilter.Text := '';
    end;
  end;
end;

procedure TMainCashForm2.actExpirationDateFilterExecute(Sender: TObject);
  var S : string; I : integer;
begin

  if pnlExpirationDateFilter.Visible then
  begin
    ClearFilterAll;
    Exit;
  end;

  S := '';
  while True do
  begin
    if not InputQuery('Фильтр по сроку годности остатка', 'Введите количество месяцев: ', S) then Exit;
    if S = '' then Exit;
    if not TryStrToInt(S, I) or (I < 1) then
    begin
      ShowMessage('Количество месяцев должно быть не менее одного.');
    end else Break;
  end;

  RemainsCDS.DisableControls;
  RemainsCDS.Filtered := False;
  try
    try
      RemainsCDS.Filter := '(Remains <> 0 or Reserved <> 0) and MinExpirationDate <= ' +
        QuotedStr(FormatDateTime(FormatSettings.ShortDateFormat, IncMonth(Date, I)));
      edlExpirationDateFilter.Text := FormatDateTime(FormatSettings.ShortDateFormat, IncMonth(Date, I));
      pnlExpirationDateFilter.Visible := True;
    except
      RemainsCDS.Filter := 'Remains <> 0 or Reserved <> 0';
      pnlExpirationDateFilter.Visible := False;
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
    spGet_JuridicalList.ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').AsInteger;
    spGet_JuridicalList.ParamByName('inAmount').Value := edDiscountAmount.Value;
    ShowMessage(spGet_JuridicalList.Execute());
  end;
end;

procedure TMainCashForm2.actGetJuridicalListUpdate(Sender: TObject);
begin
  actGetJuridicalList.Enabled := edDiscountAmount.Visible and (edDiscountAmount.Value > 0);
end;

procedure TMainCashForm2.actGetMoneyInCashExecute(Sender: TObject);
begin
  if gc_User.local then exit;

  spGet_Password_MoneyInCash.Execute;
  //временно будем без пароля
  //if InputBox('Пароль','Введите пароль:','') <> spGet_Password_MoneyInCash.ParamByName('outPassword').AsString then exit;
  //
  spGetMoneyInCash.ParamByName('inDate').Value := Date;
  spGetMoneyInCash.Execute;
  lblMoneyInCash.Caption := FormatFloat(',0.00',spGetMoneyInCash.ParamByName('outTotalSumm').AsFloat);
  //
  TimerMoneyInCash.Enabled:=True;
end;

procedure TMainCashForm2.TimerMoneyInCashTimer(Sender: TObject);
begin
 TimerMoneyInCash.Enabled:=False;
 try
  lblMoneyInCash.Caption := '0.00';
  TimerMoneyInCash.Enabled:=False;
 finally
   TimerMoneyInCash.Enabled:=True;
 end;
end;

procedure TMainCashForm2.TimerPUSHTimer(Sender: TObject);

  procedure Load_PUSH(ARun : boolean);
  begin
    if ARun or (FLoadPUSH > 15) then
    begin
      FLoadPUSH := 0;

      if not gc_User.Local then
      try
        spGet_PUSH_Cash.Execute;
        TimerPUSH.Interval := 1000;
      except ON E:Exception do Add_Log('Load_PUSH err=' + E.Message);
      end;
    end else Inc(FLoadPUSH);
  end;

begin
  TimerPUSH.Enabled := False;
  TimerPUSH.Interval := 60 * 1000;
  if TimeOf(FPUSHEnd) > TimeOf(Now) then FPUSHEnd := Now;
  try
    if FPUSHStart then
    begin
      ShowMessage('Уважаемые коллеги!'#13#10 +
                  '1. Сделайте Х-отчет, убедитесь, что он пустой 0,00.'#13#10 +
                  '   Форс-Мажор РРО: звоним в любое время Татьяна (099-641-59-21), Юлия (0957767101)'#13#10 +
                  '2. Сделайте нулевой чек, проверьте дату и время.'#13#10 +
                  '3. Сделайте внесение 100,00 грн.');
      Load_PUSH(True);
    end else if UnitConfigCDS.Active and Assigned(UnitConfigCDS.FindField('TimePUSHFinal1')) and (
      not UnitConfigCDS.FieldByName('TimePUSHFinal1').IsNull and (TimeOf(FPUSHEnd) < TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal1').AsDateTime)) and
      (TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal1').AsDateTime) < TimeOf(Now)) or
      not UnitConfigCDS.FieldByName('TimePUSHFinal2').IsNull and (TimeOf(FPUSHEnd) < TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal2').AsDateTime)) and
      (TimeOf(UnitConfigCDS.FieldByName('TimePUSHFinal2').AsDateTime) < TimeOf(Now))) then
    begin
      ShowMessage('Уважаемые коллеги!'#13#10 +
                  '1. Не забудьте сделать X-отчет!!! Вынесите необходимую сумму наличных средств из кассы согласно Х-отчета за минусом 100,00 грн !!!'#13#10 +
                  '2. Еще раз сделайте х-отчет!!! Убедитесь, что наличных в кассе 100,00 грн!!!'#13#10 +
                  '3. Сделайте z-отчет!!!'#13#10 +
                  '4. Убедитесь, что Ваш z-отчет отправился в бухгалтерию!!!'#13#10 +
                  '5. Форс-Мажор РРО: звоним в любое время : Татьяна (099-641-59-21), Юлия (0957767101)'#13#10 +
                  '6. Сделайте запись в книге РРО!!!');
      FPUSHEnd := Now;
    end else if (CheckCDS.RecordCount = 0) and PUSHDS.Active and (PUSHDS.RecordCount > 0) then
    begin
      PUSHDS.First;
      try
        TimerPUSH.Interval := 1000;
        if PUSHDS.FieldByName('Id').AsInteger > 1000 then
        begin
          if MessageDlg(PUSHDS.FieldByName('Text').AsString, mtConfirmation, mbOKCancel, 0) = mrOk then
          begin
            try
              spInsert_MovementItem_PUSH.ParamByName('inMovement').Value := PUSHDS.FieldByName('Id').AsInteger;
              spInsert_MovementItem_PUSH.Execute;
            except ON E:Exception do Add_Log('Marc_PUSH err=' + E.Message);
            end;
          end;
        end else if Trim(PUSHDS.FieldByName('Text').AsString) <> '' then ShowMessage(PUSHDS.FieldByName('Text').AsString);
      finally
         PUSHDS.Delete;
      end;
    end;
    Load_PUSH(False);
  finally
    FPUSHStart := False;
    TimerPUSH.Enabled := True;
  end;
end;

procedure TMainCashForm2.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if GetAmount <> 0 then begin //ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
    if not Assigned(SourceClientDataSet) then
      SourceClientDataSet := RemainsCDS;

    if SoldRegim AND (SourceClientDataSet.FieldByName('Price').asCurrency = 0) then begin
       ShowMessage('Нельзя продать товар с 0 ценой! Свяжитесь с менеджером');
       exit;
    end;

    InsertUpdateBillCheckItems;
  end;
  SoldRegim := true;
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

procedure TMainCashForm2.actListDiffAddGoodsExecute(Sender: TObject);
begin

  if not RemainsCDS.Active  then Exit;
  if RemainsCDS.RecordCount < 1  then Exit;

  with TListDiffAddGoodsForm.Create(nil) do
  try
    ListGoodsCDS := RemainsCDS;
    ShowModal;
  finally
     Free;
  end;
end;

procedure TMainCashForm2.actListGoodsExecute(Sender: TObject);
  var S : string;
begin
  if not FileExists(Goods_lcl) then
  begin
    ShowMessage('Справочник медикаментов не найден обратитесь к администратору...');
    Exit;
  end;

  if Self.ActiveControl is TcxGridSite then
    S := MainGridDBTableView.DataController.Search.SearchText
  else if ActiveControl is TcxCustomComboBoxInnerEdit then
    S := Copy(lcName.Text, 1, Length(lcName.Text) - Length(lcName.SelText))
  else S := '';;

  with TListGoodsForm.Create(nil) do
  try
    if S <> '' then SetFilter(S);

    ShowModal
  finally
    Free;
  end;
end;

procedure TMainCashForm2.actManualDiscountExecute(Sender: TObject);
  var S : string; I, nRecNo : integer;
begin
  if not (Sender is tcxButton) then
  begin

    if (Self.FormParams.ParamByName('SPTax').Value <> 0)
       and (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
    begin
      ShowMessage('Применен соц проект.'#13#10'Для променениея ручной скидки обнулите чек и набрать позиции заново..');
      Exit;
    end;

    if (DiscountServiceForm.gCode = 2) then
    begin
      ShowMessage('Применен дисконт.'#13#10'Для променениея ручной скидки обнулите чек и набрать позиции заново..');
      Exit;
    end;

    if FormParams.ParamByName('PromoCodeGUID').Value <> '' then
    begin
      ShowMessage('Установлен промокод.'#13#10'Для променениея ручной скидки обнулите промокод..');
      Exit;
    end;

    if FormParams.ParamByName('SiteDiscount').Value <> 0
     then
    begin
      ShowMessage('Установлена скидка через сайт.'#13#10'Для променениея ручной скидки обнулите скидку через сайт..');
      Exit;
    end;

    S := '';
    while True do
    begin
      if not InputQuery('Ручная скидка', 'Процент скидки: ', S) then Exit;
      if S = '' then Exit;
      if not TryStrToInt(S, I) or (I < 0) or (I > 50) then
      begin
        ShowMessage('Должно быть число от 0 до 50.');
      end else Break;
    end;
  end else I := 0;

  FormParams.ParamByName('ManualDiscount').Value := I;
  pnlManualDiscount.Visible := FormParams.ParamByName('ManualDiscount').Value > 0;
  edManualDiscount.Value := FormParams.ParamByName('ManualDiscount').Value;

  FormParams.ParamByName('PromoCodeID').Value             := 0;
  FormParams.ParamByName('PromoCodeGUID').Value           := '';
  FormParams.ParamByName('PromoName').Value               := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value  := 0;

  pnlPromoCode.Visible          := False;
  lblPromoName.Caption          := '';
  lblPromoCode.Caption          := '';
  edPromoCodeChangePrice.Value  := 0;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := False;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if checkCDS.FieldByName('ChangePercent').asCurrency <> FormParams.ParamByName('ManualDiscount').Value then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                Self.FormParams.ParamByName('ManualDiscount').Value);
        checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('ManualDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('PriceSale').asCurrency) -
          CheckCDS.FieldByName('Summ').asCurrency;
        checkCDS.Post;
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

//проверили что есть остаток
function TMainCashForm2.fCheck_RemainsError : Boolean;
var GoodsId_list, Amount_list : String;
    B:TBookmark;
begin
  Result:=false;
  //
  GoodsId_list:= '';
  Amount_list:= '';
  //
  //формируется список товаров
  with CheckCDS do
  begin
    B:= GetBookmark;
    DisableControls;
    try
      First;
      while Not Eof do
      Begin
        if GoodsId_list <> '' then begin GoodsId_list :=  GoodsId_list + ';'; Amount_list :=  Amount_list + ';';end;
        GoodsId_list:= GoodsId_list + IntToStr(FieldByName('GoodsId').AsInteger);
        Amount_list:= Amount_list + FloatToStr(FieldByName('Amount').asCurrency);
        Next;
      End;
      GotoBookmark(B);
      FreeBookmark(B);
    finally
      EnableControls;
    end;
  end;
  //
  //теперь вызов
  with spCheck_RemainsError do
  try
      ParamByName('inGoodsId_list').Value := GoodsId_list;
      ParamByName('inAmount_list').Value := Amount_list;
      Execute;
      Result:=ParamByName('outMessageText').Value = '';
      //if not Result then ShowMessage(ParamByName('outMessageText').Value);
  except
       //т.е. нет связи и это не является ошибкой
       Result:=true;
  end;
  if not Result then
  begin actShowMessage.MessageText:= spCheck_RemainsError.ParamByName('outMessageText').Value;
        actShowMessage.Execute;
  end;
end;

procedure TMainCashForm2.actPutCheckToCashExecute(Sender: TObject);
var
  UID,CheckNumber: String;
  lMsg: String;
  fErr: Boolean;
  dsdSave: TdsdStoredProc;
  nBankPOSTerminal : integer;
  nPOSTerminalCode : integer;
begin
  if CheckCDS.RecordCount = 0 then exit;

  if (FormParams.ParamByName('CheckId').Value <> 0) and
    (FormParams.ParamByName('ConfirmedKindName').AsString = 'Не подтвержден') then
  begin
    ShowMessage('Ошибка.VIP-чек <Не подтвержден>.');
    Exit;
  end;

  if (FormParams.ParamByName('CheckId').Value = 0) and (FormParams.ParamByName('SiteDiscount').Value > 0) then
  begin
    ShowMessage('Ошибка.Установлен признак <Скидка через сайт> необходимо установить VIP-чек.');
    Exit;
  end;

  // Контроль чека до печати
  with CheckCDS do
  begin
    First;
    while not EOF do
    begin

      if (FieldByName('Multiplicity').AsCurrency <> 0) and (FieldByName('Price').asCurrency <> FieldByName('PriceSale').asCurrency) and
        (Trunc(FieldByName('Amount').AsCurrency / FieldByName('Multiplicity').AsCurrency * 100) mod 100 <> 0) then
      begin
        ShowMessage('Для медикамента '#13#10 + FieldByName('GoodsName').AsString + #13#10'установлена кратность при отпуске со скидкой.'#13#10#13#10 +
          'Отпускать со скидкой разрешено кратно ' + FieldByName('Multiplicity').AsString + ' упаковки.');
        Exit;
      end;
      Next;
    end;
  end;

  Add_Log('PutCheckToCash');
  PaidType:=ptMoney;
  //спросили сумму и тип оплаты
  if not fShift then
  begin// если с Shift, то считаем, что дали без сдачи
    if not CashCloseDialogExecute(FTotalSumm,ASalerCash,ASalerCashAdd,PaidType,nBankPOSTerminal,nPOSTerminalCode) then
    Begin
      if Self.ActiveControl <> edAmount then
        Self.ActiveControl := MainGrid;
      exit;
    End;
    //***02.11.18
    FormParams.ParamByName('SummPayAdd').Value := ASalerCashAdd;
    //***20.02.19
    FormParams.ParamByName('BankPOSTerminal').Value := nBankPOSTerminal;
  end
  else
    ASalerCash:=FTotalSumm;

  //показали что началась печать
  ShapeState.Brush.Color := clYellow;
  ShapeState.Repaint;
  application.ProcessMessages;

  //проверили что есть остаток
  if not gc_User.Local then
  if fCheck_RemainsError = false then exit;


 //проверили что этот чек Не был проведен другой кассой - 04.02.2017
  if not gc_User.Local and (FormParams.ParamByName('CheckId').Value <> 0) then
  begin
    dsdSave := TdsdStoredProc.Create(nil);
    try
       //Проверить в каком состоянии документ.
       dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
       dsdSave.OutputType := otResult;
       dsdSave.Params.Clear;
       dsdSave.Params.AddParam('inId',ftInteger,ptInput,FormParams.ParamByName('CheckId').Value);
       dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
       dsdSave.Execute(False,False);
       if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //проведен
       Begin
            ShowMessage ('Ошибка.Данный чек уже сохранен другой кассой.Для продолжения - необходимо обнулить чек и набрать позиции заново.');
            Add_Log('Ошибка.Данный чек уже сохранен другой кассой.Для продолжения - необходимо обнулить чек и набрать позиции заново.');
            exit;
       End;
    finally
       freeAndNil(dsdSave);
    end;
  end;

  //послали на печать
  try

    Add_Log('Печать чека');
    if PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd, MainCashForm.PaidType, FiscalNumber, CheckNumber, nPOSTerminalCode) then
    Begin
      Add_Log('Печать чека завершена');
      if (FormParams.ParamByName('DiscountExternalId').Value > 0)
      then fErr:= not DiscountServiceForm.fCommitCDS_Discount (CheckNumber, CheckCDS, lMsg , FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value)
      else fErr:= false;

      if fErr = true
      then ShowMessage ('Ошибка.Чек распечатан.Продажа не сохранена')
      else begin
      Add_Log('Сохранение чека');
      ShapeState.Brush.Color := clRed;
      ShapeState.Repaint;
        if SaveLocal(CheckCDS,
                   FormParams.ParamByName('ManagerId').Value,
                   FormParams.ParamByName('ManagerName').Value,
                   FormParams.ParamByName('BayerName').Value,
                   //***16.08.16
                   FormParams.ParamByName('BayerPhone').Value,
                   FormParams.ParamByName('ConfirmedKindName').Value,
                   FormParams.ParamByName('InvNumberOrder').Value,
                   FormParams.ParamByName('ConfirmedKindClientName').Value,
                   //***20.07.16
                   FormParams.ParamByName('DiscountExternalId').Value,
                   FormParams.ParamByName('DiscountExternalName').Value,
                   FormParams.ParamByName('DiscountCardNumber').Value,
                   //***08.04.17
                   FormParams.ParamByName('PartnerMedicalId').Value,
                   FormParams.ParamByName('PartnerMedicalName').Value,
                   FormParams.ParamByName('Ambulance').Value,
                   FormParams.ParamByName('MedicSP').Value,
                   FormParams.ParamByName('InvNumberSP').Value,
                   FormParams.ParamByName('OperDateSP').Value,
                   //***15.06.17
                   FormParams.ParamByName('SPKindId').Value,
                   FormParams.ParamByName('SPKindName').Value,
                   FormParams.ParamByName('SPTax').Value,
                   //***05.02.18
                   FormParams.ParamByName('PromoCodeID').Value,
                   //***27.06.18
                   FormParams.ParamByName('ManualDiscount').Value,
                   //***02.11.18
                   FormParams.ParamByName('SummPayAdd').Value,
                   //***14.01.19
                   FormParams.ParamByName('MemberSPID').Value,
                   //***20.02.19
                   FormParams.ParamByName('BankPOSTerminal').Value,
                   //***25.02.19
                   FormParams.ParamByName('JackdawsChecksCode').Value,
                   //***28.01.19
                   FormParams.ParamByName('SiteDiscount').Value,

                   True,         // NeedComplete
                   CheckNumber,  // FiscalCheckNumber
                   UID           // out AUID
                  )
      then Begin
        Add_Log('Чек сохранен');
        NewCheck(false);
      End;
           end; // else if fErr = true
    End;
  finally
    ShapeState.Brush.Color := clGreen;
    ShapeState.Repaint;
  end;
end;

procedure TMainCashForm2.actRefreshAllExecute(Sender: TObject);
var
  lMsg: String;
begin
  startSplash('Начало обновления данных с сервера');
  try
    // во 2-1 форме возможен только оффлайн режим
    if true then
    begin
//      ShowMessage('Загрузка из Remains');
      MainGridDBTableView.BeginUpdate;
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        if not FileExists(Remains_lcl) or
           not FileExists(Alternative_lcl) then
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
        WaitForSingleObject(MutexAlternative, INFINITE);
        try
          LoadLocalData(AlternativeCDS, Alternative_lcl);
        finally
          ReleaseMutex(MutexAlternative);
        end;
      finally
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
        MainGridDBTableView.EndUpdate;
      end;
      ChangeStatus('Загрузка приходных накладных от дистрибьютора в медреестр Pfizer МДМ');
      lMsg:= '';
      if not DiscountServiceForm.fPfizer_Send(lMsg) then
      begin
           ChangeStatus('Ошибка в медреестре Pfizer МДМ :' + lMsg);
           sleep(3000);
      end
      else
      begin
           ChangeStatus('Накладные зарегистрированы в медреестре Pfizer МДМ успешно :' + lMsg);
           sleep(2000);
      end;
    end
    else
    if   not gc_User.Local then
    Begin
	//а1 начало - только 2 форма
        MutexAllowedConduct := CreateMutex(nil, false, 'farmacycashMutexAlternative');
        LastErr := GetLastError;
//        ShowMessage(inttostr(LastErr));
        if LastErr = 183 then
         begin
          WaitForSingleObject(MutexAllowedConduct, INFINITE);


         end
          else
          begin
            // отправка сообщения о прикращении работы проведения чеков
            PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 10);
            WaitForSingleObject(MutexAllowedConduct, INFINITE);  // ожидаем разлочки в сервисе

          end;
    //а1 конец - только 2 форма

      MainGridDBTableView.BeginUpdate;
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        ChangeStatus('Загрузка приходных накладных от дистрибьютора в медреестр Pfizer МДМ');
        lMsg:= '';
        if not DiscountServiceForm.fPfizer_Send(lMsg) then
        begin
             ChangeStatus('Ошибка в медреестре Pfizer МДМ :' + lMsg);
             sleep(3000);
        end
        else
        begin
             ChangeStatus('Накладные зарегистрированы в медреестре Pfizer МДМ успешно :' + lMsg);
             sleep(2000);
        end;


        ChangeStatus('Получение остатков');
        actRefresh.Execute;

        ChangeStatus('Сохранение остатков в локальной базе');
        WaitForSingleObject(MutexRemains, INFINITE);
        try
          SaveLocalData(RemainsCDS,Remains_lcl);
        finally
          ReleaseMutex(MutexRemains);
        end;
        WaitForSingleObject(MutexAlternative, INFINITE);
        try
          SaveLocalData(AlternativeCDS,Alternative_lcl);
        finally
          ReleaseMutex(MutexAlternative);
        end;

        ChangeStatus('Получение ВИП чеков');

        SaveLocalVIP;
        ChangeStatus('Сохранение ВИП чеков в локальной базе');
      finally
        ChangeStatus('Перезагрузка данных в окне программы');
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
        MainGridDBTableView.EndUpdate;
      end;

      // начало   проходим по дбф и изменяем остатки в гриде

      actSetMemdataFromDBF.Execute; // только 2 форма

      actSetUpdateFromMemdata.Execute; // только 2 форма


      ReleaseMutex(MutexAllowedConduct); // только 2 форма
      // конец    проходим по дбф и изменяем остатки в гриде


    End;
  finally
    EndSplash;
  end;
end;

procedure TMainCashForm2.actRefreshRemainsExecute(Sender: TObject);
begin
 // StartRefreshDiffThread; // оставлено для коректной синхронизации двух форм  
end;
{ synh1 } // для коректной синхронизации двух форм 

procedure TMainCashForm2.actSaveCashSesionIdToFileExecute(Sender: TObject);  // только 2 форма
var
  myFile : TextFile;
  text   : string;

begin
//  // Попытка открыть Test.txt файл для записи
//  AssignFile(myFile, 'CashSessionId.ini');
//  ReWrite(myFile);
//  // Запись нескольких известных слов в этот файл
//  WriteLn(myFile, FormParams.ParamByName('CashSessionId').Value);
//  // Закрытие файла
//  CloseFile(myFile);
//  PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 2);  // отправляем сообщение что можно забирать вайлс с кешсешнид
end;



procedure TMainCashForm2.actSelectLocalVIPCheckExecute(Sender: TObject);
var
  vip,vipList: TClientDataSet; nRecNo : integer;
begin
  inherited;
  vip := TClientDataSet.Create(Nil);
  vipList := TClientDataSet.Create(nil);
  try
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(vip,vip_lcl);
      LoadLocalData(vipList,vipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
    Add_Log('Select VIP - '+ VarToStr(FormParams.ParamByName('CheckId').Value));
    if VIP.Locate('Id',FormParams.ParamByName('CheckId').Value,[]) then
    Begin
      vipList.Filter := 'MovementId = '+FormParams.ParamByName('CheckId').AsString;
      vipList.Filtered := True;
      vipList.First;
      While not vipList.Eof do
      Begin
        CheckCDS.Append;
        CheckCDS.FieldByName('Id').AsInteger := VipList.FieldByName('Id').AsInteger;
        CheckCDS.FieldByName('GoodsId').AsInteger := VipList.FieldByName('GoodsId').AsInteger;
        CheckCDS.FieldByName('GoodsCode').AsInteger := VipList.FieldByName('GoodsCode').AsInteger;
        CheckCDS.FieldByName('GoodsName').AsString := VipList.FieldByName('GoodsName').AsString;
        CheckCDS.FieldByName('Amount').AsFloat := 0;//VipList.FieldByName('Amount').AsFloat; //маленькая ошибочка, поставил 0, ***20.07.16
        CheckCDS.FieldByName('Price').AsFloat := VipList.FieldByName('Price').AsFloat;
        CheckCDS.FieldByName('Summ').AsFloat := VipList.FieldByName('Summ').AsFloat;
        CheckCDS.FieldByName('NDS').AsFloat := VipList.FieldByName('NDS').AsFloat;
        //***20.07.16
        checkCDS.FieldByName('PriceSale').asCurrency         :=VipList.FieldByName('PriceSale').asCurrency;
        checkCDS.FieldByName('ChangePercent').asCurrency     :=VipList.FieldByName('ChangePercent').asCurrency;
        checkCDS.FieldByName('SummChangePercent').asCurrency :=VipList.FieldByName('SummChangePercent').asCurrency;
        //***19.08.16
        checkCDS.FieldByName('AmountOrder').asCurrency :=VipList.FieldByName('AmountOrder').asCurrency;
        //***10.08.16
        checkCDS.FieldByName('List_UID').AsString := VipList.FieldByName('List_UID').AsString;
        //***21.10.18
        RemainsCDS.DisableControls;
        RemainsCDS.Filtered := False;
        nRecNo := RemainsCDS.RecNo;
        try
          if RemainsCDS.Locate('GoodsCode', checkCDS.FieldByName('GoodsCode').AsInteger,[]) then
          begin
            checkCDS.FieldByName('Remains').asCurrency:=SourceClientDataSet.FieldByName('Remains').asCurrency;
            checkCDS.FieldByName('Color_calc').AsInteger:=RemainsCDS.FieldByName('Color_calc').asInteger;
            checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=RemainsCDS.FieldByName('Color_ExpirationDate').asInteger;
          end else
          begin
            checkCDS.FieldByName('Remains').asCurrency:=0;
            checkCDS.FieldByName('Color_calc').AsInteger := clWhite;
            checkCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
          end;
        finally
          RemainsCDS.RecNo := nRecNo;
          RemainsCDS.Filtered := True;
          RemainsCDS.EnableControls;
        end;
        //***05.11.18
        checkCDS.FieldByName('AccommodationName').AsVariant:=RemainsCDS.FieldByName('AccommodationName').AsVariant;
        //***15.03.19
        if checkCDS.FieldByName('Price').asCurrency <> checkCDS.FieldByName('PriceSale').asCurrency then
          checkCDS.FieldByName('Multiplicity').AsVariant:=RemainsCDS.FieldByName('Multiplicity').AsVariant;
        CheckCDS.Post;
        Add_Log('Id - '+ VipList.FieldByName('Id').AsString +
                ' GoodsCode - ' + VipList.FieldByName('GoodsCode').AsString +
                ' GoodsName - ' + VipList.FieldByName('GoodsName').AsString +
                ' AmountOrder - '+ VipList.FieldByName('AmountOrder').AsString +
                ' Price - '+  VipList.FieldByName('Price').AsString);
        if FormParams.ParamByName('CheckId').Value > 0 then
          //UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger, CheckCDS.FieldByName('Amount').AsFloat);
          //маленькая ошибочка, попробуем с VipList, ***20.07.16
          UpdateRemainsFromCheck(VipList.FieldByName('GoodsId').AsInteger, VipList.FieldByName('Amount').AsFloat, VipList.FieldByName('PriceSale').asCurrency);
        vipList.Next;
      End;
    End;

  finally
    vip.Close;
    vip.Free;
    vipList.Close;
    vipList.Free;
  end;
end;
procedure TMainCashForm2.actSetFilterExecute(Sender: TObject);
begin
  inherited;
 // if RemainsCDS.Active and AlternativeCDS.Active then

//a1  код из события RemainsCDSAfterScroll для ускорения работы приложения
 if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
//a1
end;

procedure TMainCashForm2.actServiseRunExecute(Sender: TObject);  // только 2 форма
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
    Result := False;
    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
        UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
        UpperCase(ExeFileName))) then
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
    Exit;
  end;

  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do
    begin
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := Application.Handle;
      lpFile := PChar(ExecuteFile);
      ParamString:='"'+IniUtils.gUserName+'" "'+iniutils.gPassValue+'"'; // Кавычки обязательно

      // ParamString:= gc_User.Session;
      {ParamString can contain theapplication parameters.}
       lpParameters := PChar(ParamString);
      {StartInString specifies thename of the working
      directory.If ommited, the current directory is used.}
      // lpDirectory := PChar(StartInString);
      nShow := SW_SHOWNORMAL;
    end;

    if ShellExecuteEx(@SEInfo) then
    begin
      FNeedFullRemains := false;
//      repeat Application.HandleMessage;
//        GetExitCodeProcess(SEInfo.hProcess, ExitCode);
//      until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
//     ShowMessage('Программа отработала');
    end
    else
      ShowMessage('Ошибка запуска сервиса');
end;

procedure TMainCashForm2.actSetFocusExecute(Sender: TObject);
begin
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

procedure TMainCashForm2.actSetMemdataFromDBFExecute(Sender: TObject); // только 2 форма
begin
//  ShowMessage('actSetMemdataFromDBFExecute-begin');
  Add_Log('Ожидание заполнения Memdata');
  WaitForSingleObject(MutexDBF, INFINITE);
  Add_Log('Начало заполнения Memdata');
  try
    FLocalDataBaseBody.Open;
    FLocalDataBaseHead.Open;
    if not MemData.Active then
    MemData.Open;
    MemData.DisableControls;
    FLocalDataBaseHead.First;
    while not  FLocalDataBaseHead.Eof do
      begin
          FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.Eof  do
             begin
               if FLocalDataBaseHead.FieldByName('UID').AsString = FLocalDataBaseBody.FieldByName('CH_UID').AsString then
               begin

                  MemData.Append;
                  MemData.FieldByName('ID').AsInteger:=FLocalDataBaseBody.FieldByName('GOODSID').AsInteger;
                  MemData.FieldByName('GOODSCODE').AsInteger:=FLocalDataBaseBody.FieldByName('GOODSCODE').AsInteger;
                  MemData.FieldByName('GOODSNAME').AsString:=FLocalDataBaseBody.FieldByName('GOODSNAME').AsString;
                  MemData.FieldByName('PRICE').AsFloat:=FLocalDataBaseBody.FieldByName('PRICE').AsFloat;


                  if (FLocalDataBaseHead.FieldByName('MANAGER').AsInteger<> 0) or (Trim(FLocalDataBaseHead.FieldByName('BAYER').AsString)<>'')   then
                   begin
                    MemData.FieldByName('REMAINS').asCurrency:=0;
                    MemData.FieldByName('RESERVED').asCurrency:=FLocalDataBaseBody.FieldByName('AMOUNT').asCurrency;

                   end
                  else
                   begin
                    MemData.FieldByName('REMAINS').asCurrency:=FLocalDataBaseBody.FieldByName('AMOUNT').asCurrency;
                    MemData.FieldByName('RESERVED').asCurrency:=0;
                   end;


                  MemData.FieldByName('NEWROW').AsBoolean:=False;
                  MemData.Post;

               end;
              FLocalDataBaseBody.Next;
             end;


       FLocalDataBaseHead.Next;
      end;

    FLocalDataBaseBody.Close;
    FLocalDataBaseHead.Close;
    MemData.EnableControls;
  finally
    ReleaseMutex(MutexDBF);
    Add_Log('Конец заполнения Memdata');
  end;

//  ShowMessage('actSetMemdataFromDBFExecute-end');
//  ShowMessage('MemData.RecordCount - ' +  inttostr(MemData.RecordCount));

end;

procedure TMainCashForm2.SetPromoCode(APromoCodeId: Integer; APromoName, APromoCodeGUID: String;
  APromoCodeChangePercent: currency);
var
  nRecNo: Integer;
begin

  if APromoCodeId = 0 then
  begin
    FormParams.ParamByName('PromoCodeID').Value             := 0;
    FormParams.ParamByName('PromoCodeGUID').Value           := '';
    FormParams.ParamByName('PromoName').Value               := '';
    FormParams.ParamByName('PromoCodeChangePercent').Value  := 0;

    pnlPromoCode.Visible          := False;
    lblPromoName.Caption          := '';
    lblPromoCode.Caption          := '';
    edPromoCodeChangePrice.Value  := 0;
  end else
  begin
    FormParams.ParamByName('PromoCodeID').Value             := APromoCodeId;
    FormParams.ParamByName('PromoCodeGUID').Value           := APromoCodeGUID;
    FormParams.ParamByName('PromoName').Value               := APromoName;
    FormParams.ParamByName('PromoCodeChangePercent').Value  := APromoCodeChangePercent;
    //***27.06.18

    FormParams.ParamByName('ManualDiscount').Value          := 0;

    pnlPromoCode.Visible          := APromoCodeId > 0;
    lblPromoName.Caption          := '  ' + APromoName + '  ';
    lblPromoCode.Caption          := '  ' + APromoCodeGUID + '  ';
    edPromoCodeChangePrice.Value  := APromoCodeChangePercent;
  end;

  FormParams.ParamByName('ManualDiscount').Value            := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := False;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
        CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, checkCDS.FieldByName('GoodsId').AsInteger) then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value);
        checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('PriceSale').asCurrency) -
          CheckCDS.FieldByName('Summ').asCurrency;
        checkCDS.Post;
      end else if Self.FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                Self.FormParams.ParamByName('SiteDiscount').Value);
        checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('PriceSale').asCurrency) -
          CheckCDS.FieldByName('Summ').asCurrency;
        checkCDS.Post;
      end else
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := checkCDS.FieldByName('PriceSale').asCurrency;
        checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  0;
        checkCDS.Post;
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
  PromoName, PromoCodeGUID: String;
  PromoCodeChangePercent: currency;
begin

  with TPromoCodeDialogForm.Create(nil) do
  try
     PromoCodeId            := Self.FormParams.ParamByName('PromoCodeID').Value;
     PromoCodeGUID          := Self.FormParams.ParamByName('PromoCodeGUID').Value;
     PromoName              := Self.FormParams.ParamByName('PromoName').Value;
     PromoCodeChangePercent := Self.FormParams.ParamByName('PromoCodeChangePercent').Value;
     if not PromoCodeDialogExecute(PromoCodeId, PromoCodeGUID, PromoName, PromoCodeChangePercent)
     then exit;
  finally
     Free;
  end;

  SetPromoCode(PromoCodeId, PromoName, PromoCodeGUID, PromoCodeChangePercent);
end;

procedure TMainCashForm2.edPromoCodeExit(Sender: TObject);
begin
  if Length(trim(edPromoCode.Text)) = 8 then
  begin
    try
      FormParams.ParamByName('PromoCodeGUID').Value := trim(edPromoCode.Text);
      spGet_PromoCode_by_GUID.Execute;
      SetPromoCode(FormParams.ParamByName('PromoCodeID').Value,
        FormParams.ParamByName('PromoName').Value,
        FormParams.ParamByName('PromoCodeGUID').Value,
        FormParams.ParamByName('PromoCodeChangePercent').Value);
        ActiveControl := MainGrid;
    Except ON E:Exception do
      Begin
        ShowMessage('Ошибка: ' + E.Message);
        ActiveControl := edPromoCode;
      End;
    end;
  end
  else
  begin
    if Length(trim(edPromoCode.Text)) <> 0 then
    begin
      ActiveControl := edPromoCode;
      ShowMessage ('Ошибка. Значение <Промокод> не определено. Длина промокода должна быть 8 символов');
    end else SetPromoCode(0, '', '', 0);
  end;
end;

procedure TMainCashForm2.edPromoCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) then
    case Key of
      VK_RETURN : PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
      VK_ESCAPE :
        begin
          edPromoCode.Text := FormParams.ParamByName('PromoCodeGUID').Value;
          PostMessage(Handle, CM_DIALOGKEY, VK_Tab, 0);
        end;
    end;
end;

procedure TMainCashForm2.edPromoCodeKeyPress(Sender: TObject; var Key: Char);
begin
{  if not CharInSet(Key, [#8, '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'a', 'b', 'c', 'd', 'e', 'f',
    'A', 'B', 'C', 'D', 'E', 'F']) then Key:= #0;}
end;

procedure TMainCashForm2.actSetRimainsFromMemdataExecute(Sender: TObject);  // только 2 форма
var
  GoodsId, nCheckId: Integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
//  ShowMessage('actSetRimainsFromMemdataExecute - begin');
  Add_Log('Начало заполнения с Memdata');
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  nCheckId := 0;
  if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
    nCheckId := CheckCDS.FieldByName('GoodsId').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  CheckCDS.DisableControls;
  oldFilter:= CheckCDS.Filter;
  oldFiltered:= CheckCDS.Filtered;
  try
    MemData.First;
    while not MemData.eof do
    begin
          // сначала найдем кол-во в чеках
          CheckCDS.Filter:='GoodsId = ' + IntToStr(MemData.FieldByName('Id').AsInteger);
          CheckCDS.Filtered:=true;
          CheckCDS.First;
          Amount_find:=0;
          while not CheckCDS.EOF do begin
              Amount_find:= Amount_find + CheckCDS.FieldByName('Amount').asCurrency;
              CheckCDS.Next;
          end;
          CheckCDS.Filter := oldFilter;
          CheckCDS.Filtered:= oldFiltered;

      if not RemainsCDS.Locate('Id',MemData.FieldByName('Id').AsInteger,[]) and  MemData.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := MemData.FieldByName('Id').AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger := MemData.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString := MemData.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency := MemData.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('Remains').asCurrency := MemData.FieldByName('Remains').asCurrency;
        RemainsCDS.FieldByName('MCSValue').asCurrency := MemData.FieldByName('MCSValue').asCurrency;
        RemainsCDS.FieldByName('Reserved').asCurrency := MemData.FieldByName('Reserved').asCurrency;
        RemainsCDS.FieldByName('AccommodationID').AsVariant := MemData.FieldByName('ACCOMID').AsVariant;
        RemainsCDS.FieldByName('AccommodationName').AsVariant := MemData.FieldByName('ACCOMNAME').AsVariant;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id',MemData.FieldByName('Id').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency := MemData.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency := MemData.FieldByName('Remains').asCurrency;
          RemainsCDS.FieldByName('MCSValue').asCurrency := MemData.FieldByName('MCSValue').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency := MemData.FieldByName('Reserved').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
                                                        - Amount_find;
          RemainsCDS.FieldByName('AccommodationID').AsVariant := MemData.FieldByName('ACCOMID').AsVariant;
          RemainsCDS.FieldByName('AccommodationName').AsVariant := MemData.FieldByName('ACCOMNAME').AsVariant;
          RemainsCDS.Post;
        End;
      End;
      MemData.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if MemData.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').asCurrency <> MemData.FieldByName('Remains').asCurrency then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').asCurrency := MemData.FieldByName('Remains').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
                                                            - Amount_find;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;
    MemData.Close;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    AlternativeCDS.Filtered := true;
    AlternativeCDS.EnableControls;
    if nCheckId <> 0 then
      CheckCDS.Locate('GoodsId', nCheckId, []);
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
    difUpdate:=true;
    Add_Log('Конец заполнения с Memdata');
  end;

//  ShowMessage('actSetRimainsFromMemdataExecute - end');

end;

procedure TMainCashForm2.actSetUpdateFromMemdataExecute(Sender: TObject);  // только 2 форма
var
  GoodsId: Integer;
  nCheckId: integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
//  ShowMessage('actSetUpdateFromMemdataExecute - begin');
  Add_Log('Начало обновления с Memdata');
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  nCheckId := 0;
  if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
    nCheckId := CheckCDS.FieldByName('GoodsId').AsInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  CheckCDS.DisableControls;
  oldFilter:= CheckCDS.Filter;
  oldFiltered:= CheckCDS.Filtered;
  try
    MemData.First;
    while not MemData.eof do
    begin
          // сначала найдем кол-во в чеках
          CheckCDS.Filter:='GoodsId = ' + IntToStr(MemData.FieldByName('Id').AsInteger);
          CheckCDS.Filtered:=true;
          CheckCDS.First;
          Amount_find:=0;
          while not CheckCDS.EOF do begin
              Amount_find:= Amount_find + CheckCDS.FieldByName('Amount').asCurrency;
              CheckCDS.Next;
          end;
          CheckCDS.Filter := oldFilter;
          CheckCDS.Filtered:= oldFiltered;

      if not RemainsCDS.Locate('Id',MemData.FieldByName('Id').AsInteger,[]) and  MemData.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := MemData.FieldByName('Id').AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger := MemData.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString := MemData.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency := MemData.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency - MemData.FieldByName('Remains').asCurrency - MemData.FieldByName('Reserved').asCurrency;
        RemainsCDS.FieldByName('Reserved').asCurrency :=  RemainsCDS.FieldByName('Reserved').asCurrency + MemData.FieldByName('Reserved').asCurrency;
        RemainsCDS.FieldByName('AccommodationID').AsVariant := MemData.FieldByName('ACCOMID').AsVariant;
        RemainsCDS.FieldByName('AccommodationName').AsVariant := MemData.FieldByName('ACCOMNAME').AsVariant;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id',MemData.FieldByName('Id').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency := MemData.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency - MemData.FieldByName('Remains').asCurrency -  MemData.FieldByName('Reserved').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency := RemainsCDS.FieldByName('Reserved').asCurrency + MemData.FieldByName('Reserved').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
                                                        - Amount_find;
          RemainsCDS.FieldByName('AccommodationID').AsVariant := MemData.FieldByName('ACCOMID').AsVariant;
          RemainsCDS.FieldByName('AccommodationName').AsVariant := MemData.FieldByName('ACCOMNAME').AsVariant;
          RemainsCDS.Post;
        End;
      End;
      MemData.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if MemData.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').asCurrency <> MemData.FieldByName('Remains').asCurrency then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency - MemData.FieldByName('Remains').asCurrency -  MemData.FieldByName('Reserved').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          AlternativeCDS.FieldByName('Remains').asCurrency :=  AlternativeCDS.FieldByName('Remains').asCurrency
                                                            - Amount_find;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;
    MemData.Close;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    AlternativeCDS.Filtered := true;
    AlternativeCDS.EnableControls;
    if nCheckId <> 0 then
      CheckCDS.Locate('GoodsId', nCheckId, []);
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
    difUpdate:=true;
    Add_Log('Конец обновления с Memdata');
  end;

//  ShowMessage('actSetUpdateFromMemdataExecute - end');


end;

procedure TMainCashForm2.actSetConfirmedKind_CompleteExecute(Sender: TObject);
var UID: String;
    lConfirmedKindName:String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
       ShowMessage('Ошибка.VIP-чек не загружен.');
       exit
  end;

  // Изменили <Статус заказа> и получили его название
  with spUpdate_ConfirmedKind do
  try
      ParamByName('inMovementId').Value := FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_Complete';
      Execute;
      lConfirmedKindName:=ParamByName('ouConfirmedKindName').Value;
  except
        ShowMessage('Ошибка.Нет связи с сервером');
  end;

  if spUpdate_ConfirmedKind.ParamByName('outMessageText').Value <> '' then
  begin actShowMessage.MessageText:= spUpdate_ConfirmedKind.ParamByName('outMessageText').Value;
        actShowMessage.Execute;
  end;

  if lConfirmedKindName = '' then
  begin
        ShowMessage('Ошибка.Нельзя изменить статус чека');
        exit;
  end;

  FormParams.ParamByName('ConfirmedKindName').Value:= lConfirmedKindName;

  if SaveLocal(CheckCDS
              ,FormParams.ParamByName('ManagerId').Value
              ,FormParams.ParamByName('ManagerName').Value
              ,FormParams.ParamByName('BayerName').Value
               //***16.08.16
              ,FormParams.ParamByName('BayerPhone').Value
              ,lConfirmedKindName
              ,FormParams.ParamByName('InvNumberOrder').Value
              ,FormParams.ParamByName('ConfirmedKindClientName').Value
               //***20.07.16
              ,FormParams.ParamByName('DiscountExternalId').Value
              ,FormParams.ParamByName('DiscountExternalName').Value
              ,FormParams.ParamByName('DiscountCardNumber').Value
               //***08.04.17
              ,FormParams.ParamByName('PartnerMedicalId').Value
              ,FormParams.ParamByName('PartnerMedicalName').Value
              ,FormParams.ParamByName('Ambulance').Value
              ,FormParams.ParamByName('MedicSP').Value
              ,FormParams.ParamByName('InvNumberSP').Value
              ,FormParams.ParamByName('OperDateSP').Value
               //***15.06.17
              ,FormParams.ParamByName('SPKindId').Value
              ,FormParams.ParamByName('SPKindName').Value
              ,FormParams.ParamByName('SPTax').Value
              //***05.02.18
              ,FormParams.ParamByName('PromoCodeID').Value
              //***27.06.18
              ,FormParams.ParamByName('ManualDiscount').Value
              //***02.11.18
              ,FormParams.ParamByName('SummPayAdd').Value
              //***14.01.19
              ,FormParams.ParamByName('MemberSPID').Value
              //***20.02.19
              ,FormParams.ParamByName('BankPOSTerminal').Value
              //***25.02.19
              ,FormParams.ParamByName('JackdawsChecksCode').Value
              //***28.01.19
              ,FormParams.ParamByName('SiteDiscount').Value


              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin

    //
    NewCheck(False);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString
                   + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString
                   + ' * ' + '№ ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP (true);
end;

procedure TMainCashForm2.actSetConfirmedKind_UnCompleteExecute(Sender: TObject);
var UID: String;
    lConfirmedKindName:String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
       ShowMessage('Ошибка.VIP-чек не загружен.');
       exit
  end;

  // Изменили <Статус заказа> и получили его название
  with spUpdate_ConfirmedKind do
  try
      ParamByName('inMovementId').Value := FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_UnComplete';
      Execute;
      lConfirmedKindName:=ParamByName('ouConfirmedKindName').Value;
  except
        ShowMessage('Ошибка.Нет связи с сервером');
  end;

  if lConfirmedKindName = '' then
  begin
        ShowMessage('Ошибка.Нельзя изменить статус чека');
        exit;
  end;

  FormParams.ParamByName('ConfirmedKindName').Value:= lConfirmedKindName;

  if SaveLocal(CheckCDS
              ,FormParams.ParamByName('ManagerId').Value
              ,FormParams.ParamByName('ManagerName').Value
              ,FormParams.ParamByName('BayerName').Value
               //***16.08.16
              ,FormParams.ParamByName('BayerPhone').Value
              ,lConfirmedKindName
              ,FormParams.ParamByName('InvNumberOrder').Value
              ,FormParams.ParamByName('ConfirmedKindClientName').Value
               //***20.07.16
              ,FormParams.ParamByName('DiscountExternalId').Value
              ,FormParams.ParamByName('DiscountExternalName').Value
              ,FormParams.ParamByName('DiscountCardNumber').Value
               //***08.04.17
              ,FormParams.ParamByName('PartnerMedicalId').Value
              ,FormParams.ParamByName('PartnerMedicalName').Value
              ,FormParams.ParamByName('Ambulance').Value
              ,FormParams.ParamByName('MedicSP').Value
              ,FormParams.ParamByName('InvNumberSP').Value
              ,FormParams.ParamByName('OperDateSP').Value
               //***15.06.17
              ,FormParams.ParamByName('SPKindId').Value
              ,FormParams.ParamByName('SPKindName').Value
              ,FormParams.ParamByName('SPTax').Value
              //***05.02.18
              ,FormParams.ParamByName('PromoCodeID').Value
              //***27.06.18
              ,FormParams.ParamByName('ManualDiscount').Value
              //***02.11.18
              ,FormParams.ParamByName('SummPayAdd').Value
              //***14.01.19
              ,FormParams.ParamByName('MemberSPID').Value
              //***20.02.19
              ,FormParams.ParamByName('BankPOSTerminal').Value
              //***25.02.19
              ,FormParams.ParamByName('JackdawsChecksCode').Value
              //***28.01.19
              ,FormParams.ParamByName('SiteDiscount').Value


              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin

    //
    NewCheck(False);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString
                   + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString
                   + ' * ' + '№ ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP (true);
end;

//***20.07.16
procedure TMainCashForm2.actSetDiscountExternalExecute(Sender: TObject);
var
  DiscountExternalId:Integer;
  DiscountExternalName,DiscountCardNumber: String;
  lMsg: String;
begin

  if pnlManualDiscount.Visible or pnlPromoCode.Visible or pnlSiteDiscount.Visible then
  Begin
    ShowMessage('В текущем чеке применена скидка. Сначала очистите чек!');
    exit;
  End;

  with TDiscountDialogForm.Create(nil) do
  try
     DiscountExternalId  := Self.FormParams.ParamByName('DiscountExternalId').Value;
     DiscountExternalName:= Self.FormParams.ParamByName('DiscountExternalName').Value;
     DiscountCardNumber  := Self.FormParams.ParamByName('DiscountCardNumber').Value;
     if not DiscountDialogExecute(DiscountExternalId,DiscountExternalName,DiscountCardNumber)
     then exit;
  finally
     Free;
  end;
  //
  FormParams.ParamByName('DiscountExternalId').Value := DiscountExternalId;
  FormParams.ParamByName('DiscountExternalName').Value := DiscountExternalName;
  FormParams.ParamByName('DiscountCardNumber').Value := DiscountCardNumber;
  // update DataSet - еще раз по всем "обновим" Дисконт
  DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);
  //
  CalcTotalSumm;
  //
  pnlDiscount.Visible    := DiscountExternalId > 0;
  lblDiscountExternalName.Caption:= '  ' + DiscountExternalName + '  ';
  lblDiscountCardNumber.Caption  := '  ' + DiscountCardNumber + '  ';
  lblPrice.Visible := (DiscountServiceForm.gCode = 2);
  edPrice.Visible := lblPrice.Visible;
  lblAmount.Visible := lblPrice.Visible;
  edDiscountAmount.Visible := lblAmount.Visible;
end;

//***28.01.19

procedure TMainCashForm2.SetSiteDiscount(ASiteDiscount : Currency);
  var nRecNo : Integer;
begin

  FormParams.ParamByName('SiteDiscount').Value := ASiteDiscount;
  pnlSiteDiscount.Visible := FormParams.ParamByName('SiteDiscount').Value > 0;
  edSiteDiscount.Value := FormParams.ParamByName('SiteDiscount').Value;

  CheckCDS.DisableControls;
  CheckCDS.Filtered := False;
  nRecNo := CheckCDS.RecNo;
  try

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin

      if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
        CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, checkCDS.FieldByName('GoodsId').AsInteger) then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value);
        checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('PriceSale').asCurrency) -
          CheckCDS.FieldByName('Summ').asCurrency;
        checkCDS.Post;
      end else if FormParams.ParamByName('SiteDiscount').Value > 0 then
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := GetPrice(checkCDS.FieldByName('PriceSale').asCurrency,
                                                                Self.FormParams.ParamByName('SiteDiscount').Value);
        checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('SiteDiscount').Value;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('PriceSale').asCurrency) -
          CheckCDS.FieldByName('Summ').asCurrency;
        checkCDS.Post;
      end else
      begin
        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency    := checkCDS.FieldByName('PriceSale').asCurrency;
        checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        checkCDS.FieldByName('SummChangePercent').asCurrency :=  0;
        checkCDS.Post;
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
  var nRecNo : Integer; nSiteDiscount : Currency;
begin
  if (Self.FormParams.ParamByName('SPTax').Value <> 0)
     and (Self.FormParams.ParamByName('InvNumberSP').Value <> '') then
  begin
    ShowMessage('Применен соц проект.'#13#10'Для променениея скидка через сайт обнулите чек и набрать позиции заново..');
    Exit;
  end;

  if (DiscountServiceForm.gCode = 2) then
  begin
    ShowMessage('Применен дисконт.'#13#10'Для променениея скидка через сайт обнулите чек и набрать позиции заново..');
    Exit;
  end;

  nSiteDiscount := 0;
  if pnlSiteDiscount.Visible then
  begin
    if MessageDlg('Убрать скидку через сайт?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  end else
  begin
    try
      spGlobalConst_SiteDiscount.Execute;
      if spGlobalConst_SiteDiscount.Params.Items[0].Value <> Null then
        nSiteDiscount := spGlobalConst_SiteDiscount.Params.Items[0].AsFloat
      else nSiteDiscount := 0;
    except on E: Exception do
      ShowMessage('Ошибка получения скидки через сайт: ' + #13#10 + E.Message);
    end;

    if nSiteDiscount = 0 then
    begin
      ShowMessage('Операция недоступна.'#13#10'Процент скидки через сайт не установлен.');
      Exit;
    end;
  end;

  SetSiteDiscount(nSiteDiscount);
end;

procedure TMainCashForm2.actSetSPExecute(Sender: TObject);
var
  PartnerMedicalId, SPKindId, MemberSPID : Integer;
  PartnerMedicalName, MedicSP, Ambulance, InvNumberSP, SPKindName: String;
  OperDateSP : TDateTime;
  SPTax : Currency;
begin
  if (not CheckCDS.IsEmpty) and (Self.FormParams.ParamByName('InvNumberSP').Value = '') or
    pnlManualDiscount.Visible or pnlPromoCode.Visible or pnlSiteDiscount.Visible then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;
  //
  with TSPDialogForm.Create(nil) do
  try
     PartnerMedicalId  := Self.FormParams.ParamByName('PartnerMedicalId').Value;
     PartnerMedicalName:= Self.FormParams.ParamByName('PartnerMedicalName').Value;
     Ambulance    := Self.FormParams.ParamByName('Ambulance').Value;
     MedicSP      := Self.FormParams.ParamByName('MedicSP').Value;
     InvNumberSP  := Self.FormParams.ParamByName('InvNumberSP').Value;
     SPTax        := Self.FormParams.ParamByName('SPTax').Value;
     SPKindId     := Self.FormParams.ParamByName('SPKindId').Value;
     SPKindName   := Self.FormParams.ParamByName('SPKindName').Value;
     MemberSPID   := Self.FormParams.ParamByName('MemberSPID').Value;

     //
     if Self.FormParams.ParamByName('PartnerMedicalId').Value > 0
     then OperDateSP   := Self.FormParams.ParamByName('OperDateSP').Value
     else OperDateSP   := NOW;
     if not DiscountDialogExecute(PartnerMedicalId, SPKindId, PartnerMedicalName, Ambulance, MedicSP, InvNumberSP, SPKindName, OperDateSP, SPTax, MemberSPID)
     then exit;
  finally
     Free;
  end;
  //
  FormParams.ParamByName('PartnerMedicalId').Value := PartnerMedicalId;
  FormParams.ParamByName('PartnerMedicalName').Value := PartnerMedicalName;
  FormParams.ParamByName('Ambulance').Value := Ambulance;
  FormParams.ParamByName('MedicSP').Value := MedicSP;
  FormParams.ParamByName('InvNumberSP').Value := InvNumberSP;
  FormParams.ParamByName('OperDateSP').Value := OperDateSP;
  FormParams.ParamByName('SPTax').Value     := SPTax;
  FormParams.ParamByName('SPKindId').Value  := SPKindId;
  FormParams.ParamByName('SPKindName').Value:= SPKindName;
  Self.FormParams.ParamByName('MemberSPID').Value := MemberSPID;
  //
  pnlSP.Visible := InvNumberSP <> '';
  lblPartnerMedicalName.Caption:= '  ' + PartnerMedicalName; // + '  /  № амб. ' + Ambulance;
  lblMedicSP.Caption  := '  ' + MedicSP + '  /  № '+InvNumberSP+'  от ' + DateToStr(OperDateSP);
  if SPTax <> 0 then lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FloatToStr(SPTax) + '% : ' + SPKindName
  else lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + SPKindName;

end;

procedure TMainCashForm2.actSetVIPExecute(Sender: TObject);
var
  ManagerID:Integer;
  ManagerName,BayerName: String;
  ConfirmedKindName_calc: String;
  UID: String;
begin
 // ShowMessage('actSetVIPExecute');
   if CheckCDS.IsEmpty then
   Begin
    ShowMessage('Текущий чек пустой!');
    exit;
   End;
  if not VIPDialogExecute(ManagerID,ManagerName,BayerName) then exit;
  //
  FormParams.ParamByName('ManagerId').Value   := ManagerId;
  FormParams.ParamByName('ManagerName').Value := ManagerName;
  FormParams.ParamByName('BayerName').Value   := BayerName;
  if FormParams.ParamByName('ConfirmedKindName').Value = ''
  then FormParams.ParamByName('ConfirmedKindName').Value:= 'подтвержден';
  ConfirmedKindName_calc:=FormParams.ParamByName('ConfirmedKindName').Value;
  //
  if SaveLocal(CheckCDS,ManagerId,ManagerName,BayerName
               //***16.08.16
              ,FormParams.ParamByName('BayerPhone').Value
              ,ConfirmedKindName_calc
              ,FormParams.ParamByName('InvNumberOrder').Value
              ,FormParams.ParamByName('ConfirmedKindClientName').Value
               //***20.07.16
              ,FormParams.ParamByName('DiscountExternalId').Value
              ,FormParams.ParamByName('DiscountExternalName').Value
              ,FormParams.ParamByName('DiscountCardNumber').Value
               //***08.04.17
              ,FormParams.ParamByName('PartnerMedicalId').Value
              ,FormParams.ParamByName('PartnerMedicalName').Value
              ,FormParams.ParamByName('Ambulance').Value
              ,FormParams.ParamByName('MedicSP').Value
              ,FormParams.ParamByName('InvNumberSP').Value
              ,FormParams.ParamByName('OperDateSP').Value
               //***15.06.17
              ,FormParams.ParamByName('SPKindId').Value
              ,FormParams.ParamByName('SPKindName').Value
              ,FormParams.ParamByName('SPTax').Value
              //***05.02.18
              ,FormParams.ParamByName('PromoCodeID').Value
              //***27.06.18
              ,FormParams.ParamByName('ManualDiscount').Value
              //***02.11.18
              ,FormParams.ParamByName('SummPayAdd').Value
              //***14.01.19
              ,FormParams.ParamByName('MemberSPID').Value
              //***20.02.19
              ,FormParams.ParamByName('BankPOSTerminal').Value
              //***25.02.19
              ,FormParams.ParamByName('JackdawsChecksCode').Value
              //***14.01.19
              ,FormParams.ParamByName('SiteDiscount').Value

              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin
    NewCheck(False);

  End;
end;

procedure TMainCashForm2.actShowListDiffExecute(Sender: TObject);
begin
  inherited;
  if not FileExists(ListDiff_lcl) then
  begin
    ShowMessage('Данных для просмотра нет...');
    Exit;
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
  SoldRegim:= not SoldRegim;
  edAmount.Enabled := false;
  lcName.Text := '';
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

procedure TMainCashForm2.actSpecCorrExecute(Sender: TObject);
begin
  if actSpec.Checked then actSpec.Checked := False;
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  if actSpecCorr.Checked then FormParams.ParamByName('JackdawsChecksCode').Value := 2
  else FormParams.ParamByName('JackdawsChecksCode').Value := 0;
end;

procedure TMainCashForm2.actSpecExecute(Sender: TObject);
begin
  if actSpecCorr.Checked then actSpecCorr.Checked := False;
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  if actSpec.Checked then FormParams.ParamByName('JackdawsChecksCode').Value := 1
  else FormParams.ParamByName('JackdawsChecksCode').Value := 0;
end;

procedure TMainCashForm2.actDoesNotShareExecute(Sender: TObject);
begin
  if not RemainsCDS.Active  then Exit;
  if RemainsCDS.RecordCount < 1  then Exit;

  try
    if gc_User.Local then
    begin
      if RemainsCDS.FieldByName('DoesNotShare').AsBoolean then
      begin
        if MessageDlg('В автономно режиме снять признак блокировки деления медикамента можно только на время текущего сеанса.'#13#10#13#10 +
        'Снять признак блокировки деления медикамента"'#13#10 + RemainsCDS.FieldByName('GoodsName').AsString + #13#10' на время сеанса?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;
        RemainsCDS.Edit;
        RemainsCDS.FieldByName('DoesNotShare').AsBoolean := False;
        RemainsCDS.Post;
      end else ShowMessage('В автономно режиме установка признака невозможно.');
      Exit;
    end;

    if RemainsCDS.FieldByName('DoesNotShare').AsBoolean then
    begin
      if MessageDlg('Снять с медикамента'#13#10 + RemainsCDS.FieldByName('GoodsName').AsString + #13#10'признак блокировки деления медикамента?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;

      spDoesNotShare.ParamByName('inDoesNotShare').Value := False;
      spDoesNotShare.Execute;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('DoesNotShare').AsBoolean := False;
      RemainsCDS.Post;

    end else
    begin
      if MessageDlg('Установить на медикамент'#13#10 + RemainsCDS.FieldByName('GoodsName').AsString + #13#10'признак блокировки деления медикамента?', mtConfirmation, mbYesNo, 0) <> mrYes then Exit;

      spDoesNotShare.ParamByName('inDoesNotShare').Value := True;
      spDoesNotShare.Execute;
      RemainsCDS.Edit;
      RemainsCDS.FieldByName('DoesNotShare').AsBoolean := True;
      RemainsCDS.Post;

    end;
  except ON E:Exception do
    begin
      Add_Log('Error set DoesNotShare = ' + E.Message);
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TMainCashForm2.actUpdateRemainsExecute(Sender: TObject);
begin
  Exit;
  UpdateRemainsFromDiff(nil);
end;

procedure TMainCashForm2.btnCheckClick(Sender: TObject);
begin
  SetBlinkCheck(true);
  //
  if fBlinkCheck = true
  then actOpenCheckVIP_Error.Execute
  else actCheck.Execute;
end;

procedure TMainCashForm2.ceAmountExit(Sender: TObject);
begin
  edAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm2.ceScanerKeyPress(Sender: TObject; var Key: Char);
const zc_BarCodePref_Object : String = '20100';
var isFind : Boolean;
    Key2 : Word;
    str_add, str_old : String;
    nID : integer;
begin
   isFind:= false;
   isScaner:= true;
   //
   if Key = #13 then
   begin
       //
       RemainsCDS.AfterScroll := nil;
       RemainsCDS.DisableControls;
       try
           // ЭТО Ш/К - ПРОИЗВОДИТЕЛЯ
           if zc_BarCodePref_Object <> Copy(ceScaner.Text,1, LengTh(zc_BarCodePref_Object))
           then begin

              //потом покажем
              str_add:= '(произв)';

              str_old := RemainsCDS.Filter;
              nID := RemainsCDS.FieldByName('ID').AsInteger;
              RemainsCDS.Filtered := False;
              try
                try
                  if str_old <> '' then RemainsCDS.Filter := '(' + str_old + ')';
                  RemainsCDS.Filter := RemainsCDS.Filter + ' and BarCode like ''%' + trim(ceScaner.Text) + '%''';
                  RemainsCDS.Filtered := True;
                  RemainsCDS.First;
                   //проверили что равно...
                  isFind:= Pos(trim(ceScaner.Text), RemainsCDS.FieldByName('BarCode').AsString) > 0;
                  if isFind then nID := RemainsCDS.FieldByName('ID').AsInteger;
                except
                end;
              finally
                RemainsCDS.Filtered := False;
                RemainsCDS.Filter := str_old;
                RemainsCDS.Filtered := True;
                RemainsCDS.Locate('ID', nID, []);
              end;
           end

           // ЭТО Ш/К - НАШ ID
           else begin
                 //потом покажем
                 str_add:= '(НАШ)';

                 // Сначала определим наш ID
                 StrToInt(Copy(ceScaner.Text,4, 9));
                 //нашли
                 isFind:= RemainsCDS.Locate('GoodsId_main', StrToInt(Copy(ceScaner.Text,4, 9)), []);
                 //еще проверили что равно...
                 isFind:= (isFind) and (RemainsCDS.FieldByName('GoodsId_main').AsInteger = StrToInt(Copy(ceScaner.Text,4, 9)));

                 //если не нашли - попробуем по всей строке - зачем ?
                 if not isFind then
                 begin
                   isFind:= RemainsCDS.Locate('BarCode', Trim(ceScaner.Text), []);
                   //еще проверили что равно...
                   isFind:= (isFind) and (Trim(RemainsCDS.FieldByName('BarCode').AsString) = Trim(ceScaner.Text));
                 end;
            end;

            //
            if isFind
            then
               lbScaner.Caption:='найдено ' + str_add + ' ' + ceScaner.Text
            else
               lbScaner.Caption:='не найдено ' + str_add + ' ' + ceScaner.Text;

            // всегда очистим
            ceScaner.Text:='';

       except
            lbScaner.Caption:='Ошибка в Ш/К';
       end;
       //
       RemainsCDS.EnableControls;

   end;

   if isFind = true then
   begin
        isScaner:=true;
        //
        lcName.Text:= RemainsCDS.FieldByName('GoodsName').AsString;
        Key2:= VK_Return;
        lcNameKeyDown(Self, Key2, []);
    end;

end;

procedure TMainCashForm2.actCheckConnectionExecute(Sender: TObject);
begin
  try
    spGet_User_IsAdmin.Execute;
    gc_User.Local := False;
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
end;

procedure TMainCashForm2.CheckGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;

  if CheckGrid.IsFocused then
  begin
    if not CheckCDS.IsEmpty then
    begin
      edAmount.Style.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleDisabled.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleFocused.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleHot.Color := CheckCDS.FieldByName('Color_calc').AsInteger;
    end else
    begin
      edAmount.Style.Color := clWhite;
      edAmount.StyleDisabled.Color := clBtnFace;
      edAmount.StyleFocused.Color := clWhite;
      edAmount.StyleHot.Color := clWhite;
    end;
  end;

end;

procedure TMainCashForm2.ConnectionModeChange(var Msg: TMessage);
begin
  SetWorkMode(gc_User.Local);
end;

procedure TMainCashForm2.edAmountExit(Sender: TObject);
begin
  edAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm2.edAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm2.edAmountKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '/', FormatSettings.DecimalSeparator, #8]) or
    CharInSet(Key, ['/', FormatSettings.DecimalSeparator]) and
    ((Pos(FormatSettings.DecimalSeparator, edAmount.Text) > 0) or (Pos('/', edAmount.Text) > 0)) or
    (Key = '-') and (edAmount.SelStart <> 0) or
    (Pos(FormatSettings.DecimalSeparator, edAmount.Text) > 0) and CharInSet(Key, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and
    (edAmount.SelStart >= Pos(FormatSettings.DecimalSeparator, edAmount.Text)) and((Length(edAmount.Text) - Pos(FormatSettings.DecimalSeparator, edAmount.Text)) >= 3)
    then Key:= #0;
end;

procedure TMainCashForm2.miMCSAutoClick(Sender: TObject);
begin
  if RemainsCDS.State in dsEditModes then RemainsCDS.Post;
  //
  edDays.Value:=7;
  PanelMCSAuto.Visible:= not PanelMCSAuto.Visible;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName('MCSValue').Index].Options.Editing:= PanelMCSAuto.Visible;
end;
procedure TMainCashForm2.miPrintNotFiscalCheckClick(Sender: TObject);
var CheckNumber: string;
begin
  PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd, MainCashForm.PaidType, FiscalNumber, CheckNumber, 0, false);
end;

procedure TMainCashForm2.mmSaveToExcelClick(Sender: TObject);
begin
  inherited;
  SaveExcelDialog.FileName := 'Список товаров.xls';
  if not SaveExcelDialog.Execute then Exit;
  try
    if not pnlExpirationDateFilter.Visible then RemainsCDS.Filtered := false;
    ExportGridToExcel(SaveExcelDialog.FileName, MainGrid);
  finally
    RemainsCDS.Filtered := true;
  end;
end;

procedure TMainCashForm2.FormCreate(Sender: TObject);
var
  F: String;
begin
  inherited;

  Application.OnMessage := AppMsgHandler;   // только 2 форма
  // мемдата для сохранения отгруженных чеков во время получение полных остатков
  FSaveCheckToMemData := false;
  FShowMessageCheckConnection := true;
  mdCheck.Active := true;
  isScaner:= false;
  difUpdate := true;
  FPUSHStart := True;
  //
  edDays.Value:=7;
  PanelMCSAuto.Visible:=false;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName('MCSValue').Index].Options.Editing:= False;
  //для
  // создаем мутексы если не созданы
  MutexDBF := CreateMutex(nil, false, 'farmacycashMutexDBF');
  LastErr := GetLastError;
  MutexDBFDiff := CreateMutex(nil, false, 'farmacycashMutexDBFDiff');
  LastErr := GetLastError;
  MutexVip := CreateMutex(nil, false, 'farmacycashMutexVip');
  LastErr := GetLastError;
  MutexRemains := CreateMutex(nil, false, 'farmacycashMutexRemains');
  LastErr := GetLastError;
  MutexAlternative := CreateMutex(nil, false, 'farmacycashMutexAlternative');
  LastErr := GetLastError;
  MutexDiffKind := CreateMutex(nil, false, 'farmacycashMutexDiffKind');
  LastErr := GetLastError;
  MutexDiffCDS := CreateMutex(nil, false, 'farmacycashMutexDiffCDS');
  LastErr := GetLastError;
  MutexEmployeeWorkLog := CreateMutex(nil, false, 'farmacycashMutexEmployeeWorkLog');
  LastErr := GetLastError;
  MutexBankPOSTerminal := CreateMutex(nil, false, 'farmacycashMutexBankPOSTerminal');
  LastErr := GetLastError;
  MutexUnitConfig := CreateMutex(nil, false, 'farmacycashMutexUnitConfig');
  LastErr := GetLastError;
  MutexTaxUnitNight := CreateMutex(nil, false, 'farmacycashMutexTaxUnitNight');
  LastErr := GetLastError;
  DiscountServiceForm:= TDiscountServiceForm.Create(Self);

  //сгенерили гуид для определения сессии
  ChangeStatus('Установка первоначальных параметров');
  // CashSessionId только в службе
  FormParams.ParamByName('CashSessionId').Value := iniLocalGUIDGet;
  FormParams.ParamByName('ZReportName').Value := iniLocalUnitNameGet;
  actSaveCashSesionIdToFile.Execute;  // только 2 форма
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
  //
  //Временно убрал
  //UserSettingsStorageAddOn.LoadUserSettings;
  //
  try
    ChangeStatus('Инициализация оборудования');
    Cash:=TCashFactory.GetCash(iniCashType);

    if (Cash <> nil) AND (Cash.FiscalNumber = '') AND (iniCashType = 'FP320') then
    Begin
      MessageDlg('Ошибка инициализации кассового аппарата. Дальнейшая работа программы невозможна.' + #13#10 +
                 'Для кассового апарата типа "DATECS FP-320" ' + #13#10 +
                 'необходимо внести его серийный номер в файл настроек' + #13#10 +
                 '(Секция [TSoldWithCompMainForm] параметр "FP320SERIAL")', mtError, [mbOK], 0);

      Application.Terminate;
      exit;
    End;

  except
    Begin
      ShowMessage('Внимание! Программа не может подключиться к фискальному аппарату.'+#13+
                  'Дальнейшая работа программы возможна только в нефискальном режиме!');
    End;
  end;

  if (Cash <> nil) and (Cash.FiscalNumber <> '') then
  begin
    iniLocalCashRegisterSave(Cash.FiscalNumber);
  end;

  //а2 начало -  только 2 форма
  ChangeStatus('Удаление файла остатков');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  try
    if  FileExists(iniLocalDataBaseDiff) then
      DeleteFile(iniLocalDataBaseDiff);
  finally
    ReleaseMutex(MutexDBFDiff);
  end;
  //а2 конец -  только 2 форма
  ChangeStatus('Инициализация локального хранилища');
  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;

  SetWorkMode(gc_User.Local);

  SoldParallel:=iniSoldParallel;
  CheckCDS.CreateDataSet;
  ChangeStatus('Подготовка нового чека');
  NewCheck;
  OnCLoseQuery := ParentFormCloseQuery;
  OnShow := ParentFormShow;

  EmployeeWorkLog_LogIn;
  SetBlinkVIP (true);
  SetBlinkCheck (true);
  TimerBlinkBtn.Enabled := true;
  FNeedFullRemains := true;
  TimerServiceRun.Enabled := true;

  LoadBankPOSTerminal;
  LoadUnitConfig;
  LoadTaxUnitNight;
  SetTaxUnitNight;
end;

function TMainCashForm2.InitLocalStorage: Boolean;
begin
  Result := False;

  WaitForSingleObject(MutexDBF, INFINITE);
  WaitForSingleObject(MutexDBFDiff, INFINITE);

  try
    Result := InitLocalDataBaseHead(Self, FLocalDataBaseHead) and
      InitLocalDataBaseBody(Self, FLocalDataBaseBody) and
      InitLocalDataBaseDiff(Self, FLocalDataBaseDiff);

    if Result then
    begin
      FLocalDataBaseHead.Active := False;
      FLocalDataBaseBody.Active := False;
      FLocalDataBaseDiff.Active := False;
    end;
  finally
    ReleaseMutex(MutexDBF);
    ReleaseMutex(MutexDBFDiff);
  end;
end;

procedure TMainCashForm2.InsertUpdateBillCheckItems;
var lQuantity, lPrice, lPriceSale, lChangePercent, lSummChangePercent, nAmount : Currency;
    lMsg : String;
    lGoodsId_bySoldRegim, nRecNo : Integer;
    lPriceSale_bySoldRegim, lPrice_bySoldRegim, nMultiplicity : Currency;
begin

  // Ночные скидки
  SetTaxUnitNight;
  nMultiplicity := 0;

  nAmount := GetAmount;
  if nAmount = 0 then
     exit;
  if not assigned(SourceClientDataSet) then
    SourceClientDataSet := RemainsCDS;
  if SoldRegim AND
     (nAmount > 0) and
     (nAmount > SourceClientDataSet.FieldByName('Remains').AsCurrency) then
  begin
    ShowMessage('Не хватает количества для продажи!');
    exit;
  end;
  if not SoldRegim AND
     (nAmount < 0) and
     (abs(nAmount) > abs(CheckCDS.FieldByName('Amount').AsCurrency)) then
  begin
    ShowMessage('Не хватает количества для возврата!');
    exit;
  end;
  if RemainsCDS.FieldByName('DoesNotShare').AsBoolean and (nAmount <> Round(nAmount)) then
  begin
    ShowMessage('Деление медикамента заблокировано!');
    exit;
  end;

  //
  if SoldRegim = TRUE then
  begin
      if  (Self.FormParams.ParamByName('InvNumberSP').Value <> '')
       and(Self.FormParams.ParamByName('SPTax').Value = 0)
       and(SourceClientDataSet.FieldByName('isSP').asBoolean = FALSE)
      then begin
        ShowMessage('Ошибка.Выбранный код товара не участвует в Соц.проекте!');
        exit;
      end;
      //
      //23.01.2018 - Нужно опять вернуть  проверку, чтобы в один чек пробивался только один пр-т
      if  (Self.FormParams.ParamByName('InvNumberSP').Value <> '')
       and(CheckCDS.RecordCount >= 1)
      then begin
        ShowMessage('Ошибка.В чеке для Соц.проекта уже есть <'+IntToStr(CheckCDS.RecordCount)+'> Товар.Запрещено больше чем <1>.');
        exit;
      end;
  end;

  //
  // потому что криво, надо правильно определить ТОВАР + цена БЕЗ скидки
  if SoldRegim = TRUE
  then //это ПРОДАЖА
       begin

             lGoodsId_bySoldRegim   := SourceClientDataSet.FieldByName('Id').asInteger;

             if (Self.FormParams.ParamByName('SPTax').Value <> 0)
                 and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
             then begin
                       // цена БЕЗ скидки
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
                       // цена СО скидкой - с процентом SPTax
                       lPrice_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency * (1 - Self.FormParams.ParamByName('SPTax').Value/100);
             end else
             if (SourceClientDataSet.FieldByName('isSP').asBoolean = TRUE)
                 and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
             then begin
                       // цена БЕЗ скидки
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('PriceSaleSP').asCurrency;
                       // цена СО скидкой
                       lPrice_bySoldRegim := SourceClientDataSet.FieldByName('PriceSP').asCurrency;
             end else
             if (DiscountServiceForm.gCode = 2) and (Abs(edPrice.Value) > 0.0001) then
             begin
               // цена БЕЗ скидки
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // цена СО скидкой
               lPrice_bySoldRegim := edPrice.Value;
             end else
             if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
                 CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, SourceClientDataSet.FieldByName('Id').asInteger)
             then
             begin
               // цена БЕЗ скидки
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // цена СО скидкой
               lPrice_bySoldRegim := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency,
                 Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value);
             end else if (Self.FormParams.ParamByName('ManualDiscount').Value > 0) then
             begin
               // цена БЕЗ скидки
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // цена СО скидкой
               lPrice_bySoldRegim := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency, Self.FormParams.ParamByName('ManualDiscount').Value);
             end else if (Self.FormParams.ParamByName('SiteDiscount').Value > 0) then
             begin
               // цена БЕЗ скидки
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // цена СО скидкой
               lPrice_bySoldRegim := GetPrice(SourceClientDataSet.FieldByName('Price').asCurrency, Self.FormParams.ParamByName('SiteDiscount').Value);
             end else
             begin

                  // Если есть цена со скидкой
                if SourceClientDataSet.FieldByName('PriceChange').asCurrency > 0 then
                begin

                  case MessageDlg('Подтверждение цены со скидкой препарата'#13#10#13#10 +
                    'Yes - Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('PriceChange').asCurrency)) + #13#10 +
                    'No - Цена БЕЗ скидки: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('Price').asCurrency))
                    ,mtConfirmation,[mbYes,mbNo,mbCancel], 0) of
                    mrNo :
                      begin
                         CalcPriceSale(lPriceSale_bySoldRegim, lPrice_bySoldRegim, lChangePercent,
                           SourceClientDataSet.FieldByName('Price').asCurrency, 0);
                      end;
                    mrYes :
                      begin

                         nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').AsCurrency;
                         if SourceClientDataSet.FieldByName('Multiplicity').AsCurrency <> 0 then
                           ShowMessage('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10 +
                             'Отпускать со скидкой разрешено кратно ' + SourceClientDataSet.FieldByName('Multiplicity').AsString + ' упаковки.');

                         CalcPriceSale(lPriceSale_bySoldRegim, lPrice_bySoldRegim, lChangePercent,
                           SourceClientDataSet.FieldByName('Price').asCurrency, 0,
                           SourceClientDataSet.FieldByName('PriceChange').asCurrency);
                      end;
                     mrCancel : Exit;
                  end;
                end else
                  // Если есть процент скидки
                if SourceClientDataSet.FieldByName('FixPercent').asCurrency > 0 then
                begin

                  case MessageDlg('Подтверждение цены со скидкой препарата'#13#10#13#10 +
                    'Yes - Цена со скидкой: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('FixPercent').asCurrency)) + #13#10 +
                    'No - Цена БЕЗ скидки: ' + CurrToStr(CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('Price').asCurrency))
                    ,mtConfirmation,[mbYes,mbNo,mbCancel], 0) of
                    mrNo :
                      begin
                         CalcPriceSale(lPriceSale_bySoldRegim, lPrice_bySoldRegim, lChangePercent,
                           SourceClientDataSet.FieldByName('Price').asCurrency, 0);
                      end;
                    mrYes :
                      begin

                         nMultiplicity := SourceClientDataSet.FieldByName('Multiplicity').AsCurrency;
                         if SourceClientDataSet.FieldByName('Multiplicity').AsCurrency <> 0 then
                           ShowMessage('Для медикамента установлена кратность при отпуске со скидкой.'#13#10#13#10 +
                             'Отпускать со скидкой разрешено кратно ' + SourceClientDataSet.FieldByName('Multiplicity').AsString + ' упаковки.');

                         CalcPriceSale(lPriceSale_bySoldRegim, lPrice_bySoldRegim, lChangePercent,
                           SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('FixPercent').asCurrency);
                      end;
                     mrCancel : Exit;
                  end;
                end else
                begin
                   CalcPriceSale(lPriceSale_bySoldRegim, lPrice_bySoldRegim, lChangePercent,
                     SourceClientDataSet.FieldByName('Price').asCurrency, 0);
                end;
             end
       end
  else //это ВОЗВРАТ
       begin lGoodsId_bySoldRegim   := CheckCDS.FieldByName('GoodsId').AsInteger;
             if CheckCDS.FieldByName('PriceSale').asCurrency > 0 // !!!на всяк случай, временно
             then lPriceSale_bySoldRegim := CheckCDS.FieldByName('PriceSale').asCurrency
             else lPriceSale_bySoldRegim := CheckCDS.FieldByName('Price').asCurrency;
             // ?цена СО скидкой в этом случае такая же?
             lPrice_bySoldRegim:= lPriceSale_bySoldRegim;
             // Кратность упаковки
             nMultiplicity := CheckCDS.FieldByName('Multiplicity').AsCurrency;
       end;
  {
  //Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
  lQuantity := fGetCheckAmountTotal (lGoodsId_bySoldRegim, edAmount.Value);
  //если установлен Проект (дисконтные карты) ***20.07.16
  if (FormParams.ParamByName('DiscountExternalId').Value > 0)
    and (lQuantity > 0)
  then begin
         // цена БЕЗ скидки
         lPriceSale := lPriceSale_bySoldRegim;
         // попробуем получить Дисконт
         if not DiscountServiceForm.fGetSale (lMsg, lPrice, lChangePercent, lSummChangePercent
                                            , FormParams.ParamByName('DiscountCardNumber').Value
                                            , FormParams.ParamByName('DiscountExternalId').Value
                                            , lGoodsId_bySoldRegim
                                            , lQuantity // для "ИТОГО" кол-во
                                            , lPriceSale
                                            , SourceClientDataSet.FieldByName('GoodsCode').asInteger
                                            , SourceClientDataSet.FieldByName('GoodsName').AsString
                                             )
         then if lMsg = ''
              then // не найден штрих код и сохраним БЕЗ скидки
              else exit // !!!выход ???и еще раз ругнуться
         else // все хорошо и сохраним скидку
  end
  else} begin
         lPrice             := lPrice_bySoldRegim; //lPriceSale_bySoldRegim;
         lPriceSale         := lPriceSale_bySoldRegim;
         if (Self.FormParams.ParamByName('SPTax').Value <> 0)
         and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
         //and(1=0) // временно - не будем сохранять
         then begin
                 lChangePercent     := Self.FormParams.ParamByName('SPTax').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim) * 0;
              end
         else if (Self.FormParams.ParamByName('PromoCodeID').Value > 0)
         then begin
                 lChangePercent     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else  if (Self.FormParams.ParamByName('ManualDiscount').Value > 0) then
              begin
                 lChangePercent     := Self.FormParams.ParamByName('ManualDiscount').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else  if (Self.FormParams.ParamByName('SiteDiscount').Value > 0) then
              begin
                 lChangePercent     := Self.FormParams.ParamByName('SiteDiscount').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else if Assigned(SourceClientDataSet.FindField('PriceChange')) and
                 (SourceClientDataSet.FieldByName('PriceChange').asCurrency > 0) and
                 (lPrice_bySoldRegim =
                 CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('PriceChange').asCurrency)) then
              begin
                lChangePercent     := 0;
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else if Assigned(SourceClientDataSet.FindField('FixPercent')) and
                 (SourceClientDataSet.FieldByName('FixPercent').asCurrency > 0) and
                 (lPrice_bySoldRegim =
                 CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('Price').asCurrency,
                 SourceClientDataSet.FieldByName('FixPercent').asCurrency)) then
              begin
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else if pnlTaxUnitNight.Visible and (lPrice_bySoldRegim =
                 CalcTaxUnitNightPrice(SourceClientDataSet.FieldByName('Price').asCurrency, SourceClientDataSet.FieldByName('Price').asCurrency)) then
              begin
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else begin
                lChangePercent     := 0;
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim) * 0;
              end;
         // обнулим "нужные" параметры-Item
         //DiscountServiceForm.pSetParamItemNull;
  end; // else если установлен Проект (дисконтные карты) ***20.07.16
  //
  //
  if SoldRegim AND (nAmount > 0) then
  Begin
    CheckCDS.DisableControls;
    try
      CheckCDS.Filtered := False;
      // попытка добавить препарат с другой ценой. обновляем цену у уже существующего и обнуляем суммы для пересчета
      if checkCDS.Locate('GoodsId',VarArrayOf([SourceClientDataSet.FieldByName('Id').asInteger]),[])
        and (checkCDS.FieldByName('PriceSale').asCurrency <> lPriceSale) then
      Begin
        if (FormParams.ParamByName('DiscountExternalId').Value > 0) and
          (SourceClientDataSet.FindField('MorionCode') <> nil) then
        begin
          if DiscountServiceForm.gCode = 3 then
            MCDesigner.CasualCache.Delete(SourceClientDataSet.FieldByName('Id').AsInteger, checkCDS.FieldByName('PriceSale').asCurrency);
          if DiscountServiceForm.gCode = 3 then
            MCDesigner.CasualCache.Save(SourceClientDataSet.FieldByName('Id').AsInteger, lPriceSale);
        end;

        checkCDS.Edit;
        checkCDS.FieldByName('Price').asCurrency             := lPrice;
        checkCDS.FieldByName('Summ').asCurrency              := 0;
        checkCDS.FieldByName('PriceSale').asCurrency         := lPriceSale;
        checkCDS.FieldByName('ChangePercent').asCurrency     := lChangePercent;
        checkCDS.FieldByName('SummChangePercent').asCurrency := 0;
        checkCDS.Post;
      End
      else if not checkCDS.Locate('GoodsId;PriceSale',VarArrayOf([SourceClientDataSet.FieldByName('Id').asInteger,lPriceSale]),[]) then
      Begin
        checkCDS.Append;
        checkCDS.FieldByName('Id').AsInteger:=0;
        checkCDS.FieldByName('ParentId').AsInteger:=0;
        checkCDS.FieldByName('GoodsId').AsInteger:=SourceClientDataSet.FieldByName('Id').asInteger;
        checkCDS.FieldByName('GoodsCode').AsInteger:=SourceClientDataSet.FieldByName('GoodsCode').asInteger;
        checkCDS.FieldByName('GoodsName').AsString:=SourceClientDataSet.FieldByName('GoodsName').AsString;
        checkCDS.FieldByName('Amount').asCurrency:= 0;
        checkCDS.FieldByName('Price').asCurrency:= lPrice;
        checkCDS.FieldByName('Summ').asCurrency:=0;
        checkCDS.FieldByName('NDS').asCurrency:=SourceClientDataSet.FieldByName('NDS').asCurrency;
        checkCDS.FieldByName('isErased').AsBoolean:=False;
        //***20.07.16
        checkCDS.FieldByName('PriceSale').asCurrency         :=lPriceSale;
        checkCDS.FieldByName('ChangePercent').asCurrency     :=lChangePercent;
        checkCDS.FieldByName('SummChangePercent').asCurrency :=lSummChangePercent;
        //***19.08.16
        checkCDS.FieldByName('AmountOrder').asCurrency       :=0;
        //***10.08.16
        checkCDS.FieldByName('List_UID').AsString := GenerateGUID;
        //***04.09.18
        checkCDS.FieldByName('Remains').asCurrency:=SourceClientDataSet.FieldByName('Remains').asCurrency;
        //***21.10.18
        if not Assigned(SourceClientDataSet.FindField('Color_calc')) then
        begin
          RemainsCDS.DisableControls;
          RemainsCDS.Filtered := False;
          nRecNo := RemainsCDS.RecNo;
          try
            if RemainsCDS.Locate('GoodsCode', checkCDS.FieldByName('GoodsCode').AsInteger,[]) and
              (RemainsCDS.FieldByName('Color_calc').asInteger  <> 0) then
            begin
              checkCDS.FieldByName('Color_calc').AsInteger:=RemainsCDS.FieldByName('Color_calc').asInteger;
              checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=RemainsCDS.FieldByName('Color_ExpirationDate').asInteger;
              checkCDS.FieldByName('AccommodationName').AsVariant:=SourceClientDataSet.FieldByName('AccommodationName').AsVariant;
            end else
            begin
              checkCDS.FieldByName('Color_calc').AsInteger := clWhite;
              checkCDS.FieldByName('Color_ExpirationDate').AsInteger := clBlack;
            end;
          finally
            RemainsCDS.RecNo := nRecNo;
            RemainsCDS.Filtered := True;
            RemainsCDS.EnableControls;
          end;
        end else
        begin
          if SourceClientDataSet.FieldByName('Color_calc').asInteger <> 0 then
          begin
            checkCDS.FieldByName('Color_calc').AsInteger:=SourceClientDataSet.FieldByName('Color_calc').asInteger;
            checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=SourceClientDataSet.FieldByName('Color_ExpirationDate').asInteger;
          end else
          begin
            checkCDS.FieldByName('Color_calc').AsInteger:=clWhite;
            checkCDS.FieldByName('Color_ExpirationDate').AsInteger:=clBlack;
          end;
        end;
        if Assigned(SourceClientDataSet.FindField('AccommodationName')) then
          checkCDS.FieldByName('AccommodationName').AsVariant:=SourceClientDataSet.FieldByName('AccommodationName').AsVariant;
        checkCDS.FieldByName('Multiplicity').AsVariant:=nMultiplicity;
        checkCDS.Post;

        if (FormParams.ParamByName('DiscountExternalId').Value > 0) and
          (SourceClientDataSet.FindField('MorionCode') <> nil) then
        begin
          DiscountServiceForm.SaveMorionCode(SourceClientDataSet.FieldByName('Id').AsInteger,
            SourceClientDataSet.FieldByName('MorionCode').AsInteger);

          if DiscountServiceForm.gCode = 3 then
            MCDesigner.CasualCache.Save(SourceClientDataSet.FieldByName('Id').AsInteger, lPriceSale);
        end;
      End;
    finally
      CheckCDS.Filtered := True;
      CheckCDS.EnableControls;
    end;
    UpdateRemainsFromCheck(SourceClientDataSet.FieldByName('Id').asInteger,nAmount, lPriceSale);
    //Update Дисконт в CDS - по всем "обновим" Дисконт
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if not SoldRegim AND (nAmount <> 0) then
  Begin

    if (nAmount > 0) then
    begin
      if (nAmount + CheckCDS.FieldByName('Amount').AsCurrency) > CheckCDS.FieldByName('Remains').AsCurrency then
      begin
        ShowMessage('Не хватает количества для продажи!');
        exit;
      end;
    end;

    UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger,nAmount,CheckCDS.FieldByName('PriceSale').asCurrency);
    //Update Дисконт в CDS - по всем "обновим" Дисконт
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if SoldRegim AND (nAmount < 0) then
    ShowMessage('Для продажи можно указывать только количество больше 0!')
  else
  if not SoldRegim AND (nAmount = 0) then
    ShowMessage('При изменении количества можно указывать значения не равные 0!');
end;

{------------------------------------------------------------------------------}

procedure TMainCashForm2.UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
var
  GoodsId: Integer;
  nCheckId: integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
  //Если нет расхождений - ничего не делаем
  if ADiffCDS = nil then
    ADiffCDS := DiffCDS;
  if ADIffCDS.IsEmpty then
    exit;
  //отключаем реакции

  Add_Log('Начало обновления остатков');
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  nCheckId := 0;
  if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
    nCheckId := CheckCDS.FieldByName('GoodsId').AsInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  ADIffCDS.DisableControls;
  CheckCDS.DisableControls;
  oldFilter:= CheckCDS.Filter;
  oldFiltered:= CheckCDS.Filtered;

  try
    ADIffCDS.First;
    while not ADIffCDS.eof do
    begin
          // сначала найдем кол-во в чеках
          CheckCDS.Filter:='GoodsId = ' + IntToStr(ADIffCDS.FieldByName('Id').AsInteger);
          CheckCDS.Filtered:=true;
          CheckCDS.First;
          Amount_find:=0;
          while not CheckCDS.EOF do begin
              Amount_find:= Amount_find + CheckCDS.FieldByName('Amount').asCurrency;
              CheckCDS.Next;
          end;
          CheckCDS.Filter := oldFilter;
          CheckCDS.Filtered:= oldFiltered;

      if ADIffCDS.FieldByName('NewRow').AsBoolean then
      Begin
        RemainsCDS.Append;
        RemainsCDS.FieldByName('Id').AsInteger := ADIffCDS.FieldByName('Id').AsInteger;
        RemainsCDS.FieldByName('GoodsCode').AsInteger := ADIffCDS.FieldByName('GoodsCode').AsInteger;
        RemainsCDS.FieldByName('GoodsName').AsString := ADIffCDS.FieldByName('GoodsName').AsString;
        RemainsCDS.FieldByName('Price').asCurrency := ADIffCDS.FieldByName('Price').asCurrency;
        RemainsCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
        RemainsCDS.FieldByName('MCSValue').asCurrency := ADIffCDS.FieldByName('MCSValue').asCurrency;
        RemainsCDS.FieldByName('Reserved').asCurrency := ADIffCDS.FieldByName('Reserved').asCurrency;
        RemainsCDS.Post;
      End
      else
      Begin
        if RemainsCDS.Locate('Id',ADIffCDS.FieldByName('Id').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Price').asCurrency := ADIffCDS.FieldByName('Price').asCurrency;
          RemainsCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
          RemainsCDS.FieldByName('MCSValue').asCurrency := ADIffCDS.FieldByName('MCSValue').asCurrency;
          RemainsCDS.FieldByName('Reserved').asCurrency := ADIffCDS.FieldByName('Reserved').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
                                                        - Amount_find;
          RemainsCDS.Post;
        End;
      End;
      ADIffCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if ADIffCDS.locate('Id',AlternativeCDS.fieldByName('Id').AsInteger,[]) then
      Begin
        if AlternativeCDS.FieldByName('Remains').asCurrency <> ADIffCDS.FieldByName('Remains').asCurrency then
        Begin
          AlternativeCDS.Edit;
          AlternativeCDS.FieldByName('Remains').asCurrency := ADIffCDS.FieldByName('Remains').asCurrency;
          {12.10.2016 - сделал по другому, т.к. в CheckCDS теперь могут повторяться GoodsId
          if CheckCDS.Locate('GoodsId',ADIffCDS.FieldByName('Id').AsInteger,[]) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - CheckCDS.FieldByName('Amount').asCurrency;}
          AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
                                                            - Amount_find;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    AlternativeCDS.Filtered := true;
    AlternativeCDS.EnableControls;
    if nCheckId <> 0 then
      CheckCDS.Locate('GoodsId', nCheckId, []);
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
    Add_Log('Конец обновления остатков');
  end;
end;

procedure TMainCashForm2.CalcTotalSumm;
var
  B:TBookmark;
Begin
  FTotalSumm := 0;
  WITH CheckCDS DO
  Begin
    B:= GetBookmark;
    DisableControls;
    try
      First;
      while Not Eof do
      Begin
        FTotalSumm := FTotalSumm + FieldByName('Summ').asCurrency;
        Next;
      End;
      GotoBookmark(B);
      FreeBookmark(B);
    finally
      EnableControls;
    end;
  End;
  lblTotalSumm.Caption := FormatFloat(',0.00',FTotalSumm);
End;

procedure TMainCashForm2.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_TAB) and (ActiveControl=lcName) then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm2.lcNameEnter(Sender: TObject);
begin
  inherited;
  SourceClientDataSet := nil;
  isScaner:= false;
end;

procedure TMainCashForm2.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then begin
     ActiveControl:=CheckGrid;
     exit
  end;
  if GetKeyState(VK_TAB)<0 then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm2.lcNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_Return)
     and
     (
       (
         SoldRegim
         AND
         (lcName.Text = RemainsCDS.FieldByName('GoodsName').AsString)
       )
       or
       (
         not SoldRegim
         AND
         (lcName.Text = CheckCDS.FieldByName('GoodsName').AsString)
       )
     ) then begin
     edAmount.Enabled := true;
     if SoldRegim then
        edAmount.Text := '1'
     else
        edAmount.Text := '-1';
     ActiveControl := edAmount;
  end;
  if Key = VK_TAB then
    ActiveControl:=MainGrid;
end;

procedure TMainCashForm2.MainColPriceNightGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  inherited;
  AText := FormatCurr(',0.00', CalcTaxUnitNightPriceGrid(ARecord.Values[MainColPrice.Index], ARecord.Values[MainColPrice.Index]));
end;

procedure TMainCashForm2.MainColReservedGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

procedure TMainCashForm2.MainGridPriceChangeNightGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  inherited;
  if ARecord.Values[MainGridPriceChange.Index] <> Null then
    AText := FormatCurr(',0.00', CalcTaxUnitNightPriceGrid(ARecord.Values[MainColPrice.Index], ARecord.Values[MainGridPriceChange.Index]));
end;

procedure TMainCashForm2.MainGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
 Cnt: integer;
begin

  actSetFilterExecute(nil); // Установка фильтров для товара

  if MainGrid.IsFocused or lcName.IsFocused then
  begin
    if not RemainsCDS.IsEmpty and (RemainsCDS.FieldByName('Color_calc').AsInteger <> 0) then
    begin
      edAmount.Style.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleDisabled.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleFocused.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
      edAmount.StyleHot.Color := RemainsCDS.FieldByName('Color_calc').AsInteger;
    end else
    begin
      edAmount.Style.Color := clWhite;
      edAmount.StyleDisabled.Color := clBtnFace;
      edAmount.StyleFocused.Color := clWhite;
      edAmount.StyleHot.Color := clWhite;
    end;
  end;

  if MainGrid.IsFocused then exit;

  Cnt := Sender.ViewInfo.RecordsViewInfo.VisibleCount;
  Sender.Controller.TopRecordIndex := Sender.Controller.FocusedRecordIndex - Round((Cnt+1)/2);
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

procedure TMainCashForm2.NewCheck(ANeedRemainsRefresh: Boolean = True);
begin
  FormParams.ParamByName('CheckId').Value := 0;
  FormParams.ParamByName('ManagerId').Value := 0;
  FormParams.ParamByName('ManagerName').Value := '';
  FormParams.ParamByName('BayerName').Value := '';
  //***20.07.16
  FormParams.ParamByName('DiscountExternalId').Value := 0;
  FormParams.ParamByName('DiscountExternalName').Value := '';
  FormParams.ParamByName('DiscountCardNumber').Value := '';
  //***16.08.16
  FormParams.ParamByName('BayerPhone').Value        := '';
  FormParams.ParamByName('ConfirmedKindName').Value := '';
  FormParams.ParamByName('InvNumberOrder').Value    := '';
  FormParams.ParamByName('ConfirmedKindClientName').Value := '';
  FormParams.ParamByName('UserSession').Value:=gc_User.Session;
  //***10.04.17
  FormParams.ParamByName('PartnerMedicalId').Value   := 0;
  FormParams.ParamByName('PartnerMedicalName').Value := '';
  FormParams.ParamByName('Ambulance').Value          := '';
  FormParams.ParamByName('MedicSP').Value            := '';
  FormParams.ParamByName('InvNumberSP').Value        := '';
  FormParams.ParamByName('OperDateSP').Value         := NOW;
  //***15.06.17
  FormParams.ParamByName('SPTax').Value      := 0;
  FormParams.ParamByName('SPKindId').Value   := 0;
  FormParams.ParamByName('SPKindName').Value := '';
  //***05.02.18
  FormParams.ParamByName('PromoCodeID').Value               := 0;
  FormParams.ParamByName('PromoCodeGUID').Value             := '';
  FormParams.ParamByName('PromoName').Value                 := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value    := 0.0;
  //***27.06.18
  FormParams.ParamByName('ManualDiscount').Value            := 0;
  //***02.11.18
  FormParams.ParamByName('SummPayAdd').Value                := 0;
  //***14.01.19
  FormParams.ParamByName('MemberSPID').Value                := 0;
  //***28.01.19
  FormParams.ParamByName('SiteDiscount').Value              := 0;
  //***20.02.19
  FormParams.ParamByName('BankPOSTerminal').Value           := 0;
  //***25.02.19
  FormParams.ParamByName('JackdawsChecksCode').Value        := 0;

  FiscalNumber := '';
  pnlVIP.Visible := False;
  edPrice.Value := 0.0;
  edPrice.Visible := False;
  edDiscountAmount.Value := 0.0;
  edDiscountAmount.Visible := False;
  lblPrice.Visible := False;
  lblAmount.Visible := False;
  pnlDiscount.Visible := False;
  pnlSP.Visible := False;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  CheckCDS.DisableControls;
  chbNotMCS.Checked := False;
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  pnlManualDiscount.Visible := false;
  edManualDiscount.Value := 0;
  edPromoCode.Text := '';
  pnlSiteDiscount.Visible := false;
  edSiteDiscount.Value := 0;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;
  MCDesigner.CasualCache.Clear;

  MainCashForm.SoldRegim := true;
  MainCashForm.actSpec.Checked := false;
  MainCashForm.actSpecCorr.Checked := false;
  if Assigned(MainCashForm.Cash) AND MainCashForm.Cash.AlwaysSold then
    MainCashForm.Cash.AlwaysSold := False;

  if Self.Visible then
   Begin
//     ShowMessage('При работе');
   End
  else
  Begin
//    ShowMessage('При старте');
    actRefreshAllExecute(nil);
  End;
  CalcTotalSumm;
  edAmount.Text := '0';
  isScaner:=false;
  ActiveControl := lcName;

  // Ночные скидки
  SetTaxUnitNight;
end;

procedure TMainCashForm2.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    CanClose := False;
    ShowMessage('Сначала обнулите чек.');
  End
  else
    CanClose := MessageDlg('Вы действительно хотите выйти?',mtConfirmation,[mbYes,mbCancel], 0) = mrYes;
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
          SaveLocalData(RemainsCDS,remains_lcl);
        finally
          ReleaseMutex(MutexRemains);
        end;
        WaitForSingleObject(MutexAlternative, INFINITE);
        try
          SaveLocalData(AlternativeCDS,Alternative_lcl);
        finally
          ReleaseMutex(MutexAlternative);
        end;
      end;
    Except
    end;
        PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 9); // только 2 форма
  End;
  //
  //Временно убрал
  //UserSettingsStorageAddOn.SaveUserSettings;
  //
end;

procedure TMainCashForm2.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  CloseHandle(MutexDBF);
  CloseHandle(MutexDBFDiff);
  CloseHandle(MutexVip);
  CloseHandle(MutexRemains);
  CloseHandle(MutexAlternative);
  CloseHandle(MutexDiffKind);
  CloseHandle(MutexDiffCDS);
  CloseHandle(MutexEmployeeWorkLog);
  CloseHandle(MutexBankPOSTerminal);
  CloseHandle(MutexUnitConfig);
  CloseHandle(MutexTaxUnitNight);
end;

procedure TMainCashForm2.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_Tab) and (CheckGrid.IsFocused)
  then if isScaner = true
       then ActiveControl := ceScaner
       else ActiveControl := lcName;

  if (Key = VK_ADD) or ((Key = VK_Return) AND (ssShift in Shift)) then
  Begin
    Key := 0;
    fShift := ssShift in Shift;
    actPutCheckToCashExecute(nil);
  End;
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
            VIPCDS := (C as TClientDataSet)
          else
          if sametext(Name, 'ClientDataSet1') then
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
    WriteComponentResFile(VipDfm_lcl,VIPForm);
    SetVIPCDS;
  End
  else
  Begin
    Application.CreateForm(TParentForm, VIPForm);
    VIPForm.FormClassName := 'TCheckVIPForm';
    ReadComponentResFile(VipDfm_lcl, VIPForm);
    VIPForm.AddOnFormData.isAlwaysRefresh := False;
    VIPForm.AddOnFormData.isSingle := true;
    VIPForm.isAlreadyOpen := True;
    SetVIPCDS;
    VipCDS.LoadFromFile(Vip_lcl);
    VIPListCDS.LoadFromFile(VipList_lcl);
  End;
  FPUSHEnd := Now;
  if FPUSHStart then TimerPUSH.Enabled := True;
end;

// что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
procedure TMainCashForm2.Add_Log_XML(AMessage: String);
var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_log.xml'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_log.xml')) then
    begin
      Rewrite(F);
      Writeln(F,'<?xml version="1.0" encoding="Windows-1251"?>');
    end
    else
      Append(F);
    //
    try  Writeln(F,AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;

function TMainCashForm2.PutCheckToCash(SalerCash,SalerCashAdd: Currency;
  PaidType: TPaidType; out AFiscalNumber, ACheckNumber: String; APOSTerminalCode : Integer = 0; isFiscal: boolean = true): boolean;
var str_log_xml : String; Disc: Currency;
    i, PosDisc : Integer; pPosTerm : IPos;
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //Продажа одного наименования
    var сAccommodationName : string;
  begin
     // посылаем строку в кассу и если все OK, то ставим метку о продаже
     if not Assigned(Cash) or Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do
         begin
            if isFiscal or FieldByName('AccommodationName').IsNull then сAccommodationName := ''
            else сAccommodationName := ' ' + FieldByName('AccommodationName').Text;
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text + сAccommodationName),
                                      FieldByName('Amount').asCurrency,
                                      FieldByName('Price').asCurrency,
                                      FieldByName('NDS').asCurrency);
         end
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  ACheckNumber := '';
  try
    try
      if Assigned(Cash) AND NOT Cash.AlwaysSold and isFiscal then
        AFiscalNumber := Cash.FiscalNumber
      else
        AFiscalNumber := '';
      Disc:= 0; PosDisc:= 0;
      if actSpec.Checked then isFiscal := False;
      if not isFiscal then Cash.AlwaysSold := False;

      // Контроль чека до печати
      with CheckCDS do
      begin
        // Определяем сумму скидки наценки (скидки)
        First;
        while not EOF do
        begin
          if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
              Disc := Disc + (FieldByName('Summ').asCurrency - GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency));

          if (FieldByName('Multiplicity').AsCurrency <> 0) and (FieldByName('Price').asCurrency <> FieldByName('PriceSale').asCurrency) and
            (Trunc(FieldByName('Amount').AsCurrency / FieldByName('Multiplicity').AsCurrency * 100) mod 100 <> 0) then
          begin
            ShowMessage('Для медикамента '#13#10 + FieldByName('GoodsName').AsString + #13#10'установлена кратность при отпуске со скидкой.'#13#10#13#10 +
              'Отпускать со скидкой разрешено кратно ' + FieldByName('Multiplicity').AsString + ' упаковки.');
            Exit;
          end;
          Next;
        end;

        // Если есть скидка находим товар с суммой больше скидки
        if Disc < 0 then
        begin
          Last;
          while not BOF do
          begin
            if (GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency) + Disc) > 0 then
            begin
              PosDisc:= RecNo;
              Break;
            end;
            Prior;
          end;

          // Если есть скидка и нет товара с суммой больше скидки то ищем товар равный скидке
          if (Disc < 0) and (PosDisc = 0) then
          begin
            Last;
            while not BOF do
            begin
              if (GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency) + Disc) >= 0 then
              begin
                PosDisc:= RecNo;
                Break;
              end;
              Prior;
            end;
          end;
        end else if Disc > 0 then
        begin
          Last;
          while not BOF do
          begin
            if GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency) > Disc then
            begin
              PosDisc:= RecNo;
              Break;
            end;
            Prior;
          end;
        end;

        if (Disc <> 0) and (PosDisc = 0) then
        begin
          ShowMessage('Сумма скидки (наценки) по чеку:' + FormatCurr('0.00', Disc) + #13#10 +
            'В чеке не найден товар на который можно применить скидку (наценку) по округлению копеек...');
          Exit;
        end;
      end;

      // Подключились к POS-терминалу
      if (PaidType <> ptMoney) and (APOSTerminalCode <> 0) and (iniPosType(APOSTerminalCode) <> '') then
      begin
        try
          Add_Log('Подключение к POS терминалу');
          try
            pPosTerm:=TPosFactory.GetPos(APOSTerminalCode);
          except ON E:Exception do Add_Log('Exception: ' + E.Message);
          end;

          if pPosTerm = Nil then
          begin
            ShowMessage('Внимание! Программа не может подключиться к POS-терминалу.'+#13+
                        'Проверьте подключение и повторите попытку печети!');
            Exit;
          end;

          if not PayPosTerminal(pPosTerm, MainCashForm.ASalerCash) then Exit;
        finally
          if pPosTerm <> Nil then pPosTerm := Nil;
        end;
      end;



      if isFiscal then Add_Check_History;
      if isFiscal then Start_Check_History(FTotalSumm, SalerCashAdd, PaidType);

      // Непосредственно печать чека
      str_log_xml:=''; i:=0;
      result := not Assigned(Cash) or Cash.AlwaysSold or Cash.OpenReceipt(isFiscal, actSpec.Checked);
      with CheckCDS do
      begin
        First;
        while not EOF do
        begin
          if result then
             begin
               if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
                begin
                    //послали строку в кассу
                    result := PutOneRecordToCash;
                    //сохранили строку в лог
                    i:= i + 1;
                    if str_log_xml<>'' then str_log_xml:=str_log_xml + #10 + #13;
                    try
                    str_log_xml:= str_log_xml
                                + '<Items num="' +IntToStr(i)+ '">'
                                + '<GoodsCode>"' + FieldByName('GoodsCode').asString + '"</GoodsCode>'
                                + '<GoodsName>"' + AnsiUpperCase(FieldByName('GoodsName').Text) + '"</GoodsName>'
                                + '<Amount>"' + FloatToStr(FieldByName('Amount').asCurrency) + '"</Amount>'
                                + '<Price>"' + FloatToStr(FieldByName('Price').asCurrency) + '"</Price>'
                                + '<List_UID>"' + FieldByName('List_UID').AsString + '"</List_UID>'
                                + '<Discount>"' + CurrToStr(FieldByName('Summ').asCurrency - GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency)) + '"</Discount>'
                                + '</Items>';
                    except
                    str_log_xml:= str_log_xml
                                + '<Items="' +IntToStr(i)+ '">'
                                + '<GoodsCode>"' + FieldByName('GoodsCode').asString + '"</GoodsCode>'
                                + '<GoodsName>"???"</GoodsName>'
                                + '<List_UID>"' + FieldByName('List_UID').AsString + '"</List_UID>'
                                + '<Discount>"' + CurrToStr(FieldByName('Summ').asCurrency - GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency)) + '"</Discount>'
                                + '</Items>';
                    end;
                    if (Disc <> 0) and (PosDisc = RecNo) then
                    begin
                      if Assigned(Cash) and not Cash.AlwaysSold then Cash.DiscountGoods(Disc);
                      Disc := 0;
                    end;
                end;
             end;
          Next;
        end;
        if result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          if (Disc <> 0) and (PosDisc = 0) then result := Cash.DiscountGoods(Disc);
          if not isFiscal or (Round(FTotalSumm * 100) = Round(Cash.SummaReceipt * 100)) then
          begin
            if result then result := Cash.SubTotal(true, true, 0, 0);
            if result then result := Cash.TotalSumm(SalerCash, SalerCashAdd, PaidType);
            if result then result := Cash.CloseReceiptEx(ACheckNumber); //Закрыли чек
            if result and isFiscal then Finish_Check_History(FTotalSumm);
          end else
          begin
            result := False;
            ShowMessage('Ошибка. Сумма чека ' + CurrToStr(FTotalSumm) + ' не равна сумме товара в фискальном чеке ' + CurrToStr(Cash.SummaReceipt) + '.'#13#10 +
              'Чек анулирован...');
            Cash.Anulirovt;
          end
        end else if not result and Assigned(Cash) AND not Cash.AlwaysSold then
        begin
          ShowMessage('Ошибка печати фискального чека.'#13#10 + 'Чек анулирован...');
          Cash.Anulirovt;
        end;
      end;
    except
      result := false;
      raise;
    end;
  finally
    if Assigned(Cash) then Cash.AlwaysSold := actSpecCorr.Checked or actSpec.Checked;
  end;

  //
  // что б отловить ошибки - запишим в лог чек - во время пробития чека через ЭККА
  Add_Log_XML('<Head now="'+FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+'">'
     +#10+#13+'<CheckNumber>"'  + ACheckNumber  + '"</CheckNumber>'
             +'<FiscalNumber>"' + AFiscalNumber + '"</FiscalNumber>'
             +'<Summa>"' + FloatToStr(SalerCash) + '"</Summa>'
     +#10+#13+str_log_xml
     +#10+#13+'</Head>'
             );
end;

//Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
function TMainCashForm2.fGetCheckAmountTotal(AGoodsId: Integer = 0; AAmount: Currency = 0) : Currency;
var
  GoodsId: Integer;
begin
  Result :=AAmount;
  //Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //открючаем реакции
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;

  try
    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if (CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) then
      Begin
        if (AAmount = 0) or
           (
             (AAmount < 0)
             AND
             (ABS(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
           ) then
          Result := 0
        else
          Result := CheckCDS.FieldByName('Amount').asCurrency + AAmount;
      End;
      CheckCDS.Next;
    end;
  finally
    CheckCDS.Filtered := True;
    if AGoodsId <> 0 then
      CheckCDS.Locate('GoodsId',AGoodsId,[]);
    CheckCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0; APriceSale: Currency = 0);
var
  GoodsId: Integer;
  //lPriceSale : Currency;
begin
  //Если пусто - ничего не делаем
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;
  //открючаем реакции
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
  RemainsCDS.Filtered := False;
  AlternativeCDS.Filtered := False;
  try
    CheckCDS.First;
    while not CheckCDS.eof do
    begin
      if (AGoodsId = 0) or ((CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) and (CheckCDS.FieldByName('PriceSale').AsCurrency = APriceSale)) then
      Begin
        if RemainsCDS.Locate('Id',CheckCDS.FieldByName('GoodsId').AsInteger,[]) then
        Begin
          RemainsCDS.Edit;
          if (AAmount = 0)
             or
             (
               (AAmount < 0)
               AND
               (ABS(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
             ) then
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              + CheckCDS.FieldByName('Amount').asCurrency
          else
            RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
              - AAmount;
          RemainsCDS.Post;
        End;
      End;
      CheckCDS.Next;
    end;

    AlternativeCDS.First;
    while Not AlternativeCDS.eof do
    Begin
      if (AGoodsId = 0) or ((AlternativeCDS.FieldByName('Id').AsInteger = AGoodsId) and (AlternativeCDS.FieldByName('Price').AsFloat = APriceSale)) then
      Begin
        //if (AAmount < 0) and (CheckCDS.FieldByName('PriceSale').asCurrency > 0)
        //then lPriceSale:= CheckCDS.FieldByName('PriceSale').asCurrency
        //else lPriceSale:= AlternativeCDS.fieldByName('Price').asCurrency;

        if CheckCDS.locate('GoodsId;PriceSale',VarArrayOf([AlternativeCDS.fieldByName('Id').AsInteger,APriceSale]),[]) then
        Begin
          AlternativeCDS.Edit;
          if (AAmount = 0) or
             (
               (AAmount < 0)
               AND
               (abs(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
             ) then
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              + CheckCDS.FieldByName('Amount').asCurrency
          else
            AlternativeCDS.FieldByName('Remains').asCurrency := AlternativeCDS.FieldByName('Remains').asCurrency
              - AAmount;
          AlternativeCDS.Post;
        End;
      End;
      AlternativeCDS.Next;
    End;

    CheckCDS.First;
    while not CheckCDS.Eof do
    begin
      if (AGoodsId = 0) or ((CheckCDS.FieldByName('GoodsId').AsInteger = AGoodsId) and (CheckCDS.FieldByName('PriceSale').asCurrency = APriceSale)) then
      Begin
        CheckCDS.Edit;

        if (AAmount = 0) or
           (
             (AAmount < 0)
             AND
             (ABS(AAmount) >= CheckCDS.FieldByName('Amount').asCurrency)
           ) then
          CheckCDS.FieldByName('Amount').asCurrency := 0
        else
          CheckCDS.FieldByName('Amount').asCurrency := CheckCDS.FieldByName('Amount').asCurrency
            + AAmount;


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
        else}
        if (Self.FormParams.ParamByName('SPTax').Value <> 0)
          and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
        then begin
            // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := RemainsCDS.FieldByName('Price').asCurrency * (1 - Self.FormParams.ParamByName('SPTax').Value/100);
            // и УСТАНОВИМ скидку - с процентом SPTax
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('SPTax').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * RemainsCDS.FieldByName('Price').asCurrency * (Self.FormParams.ParamByName('SPTax').Value/100);
        end else
        if (RemainsCDS.FieldByName('isSP').asBoolean = TRUE)
          and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
        then begin
            // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('PriceSaleSP').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := RemainsCDS.FieldByName('PriceSP').asCurrency;
            // и УСТАНОВИМ скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * (RemainsCDS.FieldByName('PriceSaleSP').asCurrency - RemainsCDS.FieldByName('PriceSP').asCurrency);
        end else
        if (DiscountServiceForm.gCode = 2) and (Abs(edPrice.Value) > 0.0001) then
        begin
            // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := edPrice.Value;
            // и УСТАНОВИМ скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * (RemainsCDS.FieldByName('Price').asCurrency - edPrice.Value);
        end else
        if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
           CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, SourceClientDataSet.FieldByName('Id').asInteger)
        then
        begin
           // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := GetPrice(RemainsCDS.FieldByName('Price').asCurrency,
                                                                    Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value);
            // и УСТАНОВИМ скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value + Self.FormParams.ParamByName('SiteDiscount').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else
        if (Self.FormParams.ParamByName('SiteDiscount').Value > 0) then
        begin
           // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := GetPrice(RemainsCDS.FieldByName('Price').asCurrency,
                                                                   Self.FormParams.ParamByName('SiteDiscount').Value);
            // и УСТАНОВИМ скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('SiteDiscount').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else
        if (Self.FormParams.ParamByName('ManualDiscount').Value > 0) then
        begin
           // на всяк случай - УСТАНОВИМ скидку еще разок
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := GetPrice(RemainsCDS.FieldByName('Price').asCurrency,
                                                                   Self.FormParams.ParamByName('ManualDiscount').Value);
            // и УСТАНОВИМ скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('ManualDiscount').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else if (checkCDS.FieldByName('PriceSale').asCurrency <> checkCDS.FieldByName('Price').asCurrency) and
          (RemainsCDS.FieldByName('PriceChange').asCurrency <> 0) and (checkCDS.FieldByName('Price').asCurrency =
          CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency, RemainsCDS.FieldByName('PriceChange').asCurrency)) then
        begin
            // пересчитаем сумму скидки
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else if (checkCDS.FieldByName('PriceSale').asCurrency <> checkCDS.FieldByName('Price').asCurrency) and
          (RemainsCDS.FieldByName('FixPercent').asCurrency > 0) and  (checkCDS.FieldByName('Price').asCurrency =
          CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency, RemainsCDS.FieldByName('Price').asCurrency,
          RemainsCDS.FieldByName('FixPercent').asCurrency)) then
        begin
            // пересчитаем сумму скидки
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else if pnlTaxUnitNight.Visible and (checkCDS.FieldByName('Price').asCurrency =
          CalcTaxUnitNightPrice(RemainsCDS.FieldByName('Price').asCurrency, RemainsCDS.FieldByName('Price').asCurrency)) then
        begin
            // пересчитаем сумму скидки
            checkCDS.FieldByName('SummChangePercent').asCurrency :=
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('PriceSale').asCurrency) -
                GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);
        end else
        begin
            // на всяк случай условие - восстановим если Цена БЕЗ скидки была запонена
            if checkCDS.FieldByName('PriceSale').asCurrency > 0
            then checkCDS.FieldByName('Price').asCurrency        := checkCDS.FieldByName('PriceSale').asCurrency;
            // и обнулим скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := 0;
        end;

        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency, CheckCDS.FieldByName('Price').asCurrency);

        CheckCDS.Post;
      End;
      CheckCDS.Next;
    end;
  finally
    RemainsCDS.Filtered := True;
    RemainsCDS.Locate('Id',GoodsId,[]);
    RemainsCDS.EnableControls;
    AlternativeCDS.Filtered := true;
    AlternativeCDS.EnableControls;
    CheckCDS.Filtered := True;
    if AGoodsId <> 0 then
      CheckCDS.Locate('GoodsId',AGoodsId,[]);
    CheckCDS.EnableControls;
  end;
end;

function TMainCashForm2.SaveLocal(ADS :TClientDataSet; AManagerId: Integer; AManagerName: String;
      ABayerName, ABayerPhone, AConfirmedKindName, AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP : String;
      AOperDateSP : TDateTime;
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency; APromoCodeID, AManualDiscount : Integer;
      ASummPayAdd : Currency; AMemberSPID, ABankPOSTerminal, AJackdawsChecksCode : Integer; ASiteDiscount : currency;
      NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;
var
  NextVIPId: integer;
  myVIPCDS, myVIPListCDS: TClientDataSet;
  str_log_xml : String;
  i : Integer;
begin
  //Если чек виповский и ещё не проведен - то сохраняем в таблицу випов
  if gc_User.Local And not NeedComplete AND ((AManagerId <> 0) or (ABayerName <> '')) then
  Begin
    myVIPCDS := TClientDataSet.Create(nil);
    myVIPListCDS := TClientDataSet.Create(nil);
    AUID := GenerateGUID;
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(MyVipCDS, Vip_lcl);
      LoadLocalData(MyVipListCDS, VipList_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
    if not MyVipCDS.Locate('Id',FormParams.ParamByName('CheckId').Value,[]) then
    Begin
      MyVipCDS.IndexFieldNames := 'Id';
      MyVipCDS.First;
      if MyVipCDS.FieldByName('Id').AsInteger > 0 then
        NextVIPID := -1
      else
        NextVIPId := MyVipCDS.FieldByName('Id').AsInteger - 1;

      MyVipCDS.Append;
      MyVipCDS.FieldByName('Id').AsInteger := NextVIPId;
      MyVipCDS.FieldByName('InvNumber').AsString := AUID;
      MyVipCDS.FieldByName('OperDate').AsDateTime := Now;
    end
    else
    Begin
      MyVipCDS.Edit;
      AUID := MyVipCDS.FieldByName('InvNumber').AsString;

    end;
    MyVipCDS.FieldByName('StatusId').AsInteger := StatusUncompleteID;
    MyVipCDS.FieldByName('StatusCode').AsInteger := StatusUncompleteCode;
    MyVipCDS.FieldByName('TotalCount').AsFloat := 0;
    MyVipCDS.FieldByName('TotalSumm').AsFloat := FTotalSumm;
    MyVipCDS.FieldByName('UnitName').AsString := '';
    MyVipCDS.FieldByName('CashRegisterName').AsString := '';
    MyVipCDS.FieldByName('CashMemberId').AsInteger := AManagerId;
    MyVipCDS.FieldByName('CashMember').AsString := AManagerName;
    MyVipCDS.FieldByName('Bayer').AsString := ABayerName;
    //***20.07.16
    MyVipCDS.FieldByName('DiscountExternalId').AsInteger  := ADiscountExternalId;
    MyVipCDS.FieldByName('DiscountExternalName').AsString := ADiscountExternalName;
    MyVipCDS.FieldByName('DiscountCardNumber').AsString   := ADiscountCardNumber;
    //***16.08.16
    MyVipCDS.FieldByName('BayerPhone').AsString        := ABayerPhone;
    MyVipCDS.FieldByName('ConfirmedKindName').AsString := AConfirmedKindName;
    MyVipCDS.FieldByName('InvNumberOrder').AsString    := AInvNumberOrder;
    MyVipCDS.FieldByName('ConfirmedKindClientName').AsString := AConfirmedKindClientName;
    //***10.04.17
    MyVipCDS.FieldByName('PartnerMedicalId').AsInteger  := APartnerMedicalId;
    MyVipCDS.FieldByName('PartnerMedicalName').AsString := APartnerMedicalName;
    MyVipCDS.FieldByName('Ambulance').AsString          := AAmbulance;
    MyVipCDS.FieldByName('MedicSP').AsString            := AMedicSP;
    MyVipCDS.FieldByName('InvNumberSP').AsString        := AInvNumberSP;
    MyVipCDS.FieldByName('OperDateSP').AsDateTime       := AOperDateSP;
    //***15.06.17
    MyVipCDS.FieldByName('SPTax').AsFloat       := ASPTax;
    MyVipCDS.FieldByName('SPKindId').AsInteger  := ASPKindId;
    MyVipCDS.FieldByName('SPKindName').AsString := ASPKindName;

    MyVipCDS.Post;

    MyVipListCDS.Filter := 'MovementId = '+MyVipCDS.FieldByName('Id').AsString;
    MyVipListCDS.Filtered := True;
    while not MyVipListCDS.eof do
      MyVipListCDS.Delete;
    MyVipListCDS.Filtered := False;
    ADS.DisableControls;
    try
      ADS.Filtered := False;
      ADS.First;
      while not ADS.Eof do
      Begin
        MyVipListCDS.Append;
        MyVipListCDS.FieldByname('Id').Value := ADS.FieldByName('Id').AsInteger;
        MyVipListCDS.FieldByname('MovementId').Value := MyVipCDS.FieldByName('Id').AsInteger;
        MyVipListCDS.FieldByname('GoodsId').Value := ADS.FieldByName('GoodsId').AsInteger;
        MyVipListCDS.FieldByname('GoodsCode').Value := ADS.FieldByName('GoodsCode').AsInteger;
        MyVipListCDS.FieldByname('GoodsName').Value := ADS.FieldByName('GoodsName').AsString;
        MyVipListCDS.FieldByname('Amount').Value := ADS.FieldByName('Amount').AsFloat;
        MyVipListCDS.FieldByname('Price').Value := ADS.FieldByName('Price').AsFloat;
        MyVipListCDS.FieldByname('Summ').Value := GetSumm(ADS.FieldByName('Amount').AsFloat,ADS.FieldByName('Price').AsFloat);
        //***20.07.16
        MyVipListCDS.FieldByName('PriceSale').asCurrency         := ADS.FieldByName('PriceSale').asCurrency;
        MyVipListCDS.FieldByName('ChangePercent').asCurrency     := ADS.FieldByName('ChangePercent').asCurrency;
        MyVipListCDS.FieldByName('SummChangePercent').asCurrency := ADS.FieldByName('SummChangePercent').asCurrency;
        //***19.08.16
        MyVipListCDS.FieldByName('AmountOrder').asCurrency       := ADS.FieldByName('AmountOrder').asCurrency;
        //***10.08.16
        MyVipListCDS.FieldByName('List_UID').asString := ADS.FieldByName('List_UID').AsString;

        MyVipListCDS.Post;
        ADS.Next;
      End;
    finally
      ADS.Filtered := true;
      ADS.EnableControls;
    end;
    WaitForSingleObject(MutexVip, INFINITE);
    try
      SaveLocalData(MyVipCDS, vip_lcl);
      MyVipListCDS.Filtered := False;
      SaveLocalData(MyVipListCDS, vipList_lcl);
      MyVipCDS.Free;
      MyVIPListCDS.Free;
    finally
      ReleaseMutex(MutexVip);
    end;
  End;  //Если чек виповский и ещё не проведен - то сохраняем в таблицу випов

  //сохраняем в дбф
  Add_Log('Ожидаем MutexDBF');
  WaitForSingleObject(MutexDBF, INFINITE);
  Add_Log('Получили MutexDBF');
  try
    FLocalDataBaseHead.Active:=True;
    FLocalDataBaseBody.Active:=True;
    //сгенерили гуид для чека
    if AUID = '' then
      AUID := GenerateGUID;
    Result := True;
    //сохраняем шапку
    try
      if (FormParams.ParamByName('CheckId').Value = 0) or
         not FLocalDataBaseHead.Locate('ID',FormParams.ParamByName('CheckId').Value,[]) then
      Begin
        FLocalDataBaseHead.AppendRecord([FormParams.ParamByName('CheckId').Value, //id чека
                                         AUID,                                    //uid чека
                                         Now,                                     //дата/Время чека
                                         Integer(PaidType),                       //тип оплаты
                                         FiscalNumber,                            //серийник аппарата
                                         AManagerId,                              //Id Менеджера (VIP)
                                         ABayerName,                              //Покупатель (VIP)
                                         False,                                   //Распечатан на фискальном регистраторе
                                         False,                                   //Сохранен в реальную базу данных
                                         NeedComplete,                            //Необходимо проведение
                                         chbNotMCS.Checked,                       //Не участвует в расчете НТЗ
                                         FiscalCheckNumber,                       //Номер фискального чека
                                         //***20.07.16
                                         ADiscountExternalId,      //Id Проекта дисконтных карт
                                         ADiscountExternalName,    //Название Проекта дисконтных карт
                                         ADiscountCardNumber,      //№ Дисконтной карты
                                         //***20.07.16
                                         ABayerPhone,              //Контактный телефон (Покупателя) - BayerPhone
                                         AConfirmedKindName,       //Статус заказа (Состояние VIP-чека) - ConfirmedKind
                                         AInvNumberOrder,          //Номер заказа (с сайта) - InvNumberOrder
                                         AConfirmedKindClientName, //Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
                                         //***24.01.17
                                         gc_User.Session,          //Для сервиса - реальная сесия при продаже
                                         //***08.04.17
                                         APartnerMedicalId,        //Id Медицинское учреждение(Соц. проект)
                                         APartnerMedicalName,      //Название Медицинское учреждение(Соц. проект)
                                         AAmbulance,               //№ амбулатории (Соц. проект)
                                         AMedicSP,                 //ФИО врача (Соц. проект)
                                         AInvNumberSP,             //номер рецепта (Соц. проект)
                                         AOperDateSP,              //дата рецепта (Соц. проект)
                                         //***15.06.17
                                         ASPKindId,                //Id Вид СП
                                         //***02.02.18
                                         APromoCodeID,             //Id промокода
                                         //***27.06.18
                                         AManualDiscount,          //Ручная скидка
                                         //***02.11.18
                                         ASummPayAdd,              //Доплата по чеку
                                         //***14.01.19
                                         AMemberSPID,              //ФИО пациента
                                         //***28.01.19
                                         ASiteDiscount > 0,
                                         //***20.02.19
                                         ABankPOSTerminal,         // POS терминал
                                         //***25.02.19
                                         AJackdawsChecksCode       // Галка
                                        ]);
      End
      else
      Begin
        AUID := FLocalDataBaseHead.FieldByName('UID').Value;//uid чека
        FLocalDataBaseHead.Edit;
        FLocalDataBaseHead.FieldByName('DATE').Value := Now; //дата оплаты
        FLocalDataBaseHead.FieldByName('PAIDTYPE').Value := Integer(PaidType); //тип оплаты
        FLocalDataBaseHead.FieldByName('CASH').Value := FiscalNumber; //серийник аппарата
        FLocalDataBaseHead.FieldByName('MANAGER').Value := AManagerId; //Id Менеджера (VIP)
        FLocalDataBaseHead.FieldByName('BAYER').Value := ABayerName; //Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('SAVE').Value := False; //Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('COMPL').Value := False; //Покупатель (VIP)
        FLocalDataBaseHead.FieldByName('NEEDCOMPL').Value := NeedComplete; //нужно провести документ
        FLocalDataBaseHead.FieldByName('NOTMCS').Value := chbNotMCS.Checked; //Не участвует в расчете НТЗ
        FLocalDataBaseHead.FieldByName('FISCID').Value := FiscalCheckNumber; //Номер фискального чека
        //***20.07.16
        FLocalDataBaseHead.FieldByName('DISCOUNTID').Value := ADiscountExternalId;   //Id Проекта дисконтных карт
        FLocalDataBaseHead.FieldByName('DISCOUNTN').Value  := ADiscountExternalName; //Название Проекта дисконтных карт
        FLocalDataBaseHead.FieldByName('DISCOUNT').Value   := ADiscountCardNumber;   //№ Дисконтной карты
        //***16.08.16
        FLocalDataBaseHead.FieldByName('BAYERPHONE').Value := ABayerPhone;              //Контактный телефон (Покупателя) - BayerPhone
        FLocalDataBaseHead.FieldByName('CONFIRMED').Value  := AConfirmedKindName;       //Статус заказа (Состояние VIP-чека) - ConfirmedKind
        FLocalDataBaseHead.FieldByName('NUMORDER').Value   := AInvNumberOrder;          //Номер заказа (с сайта) - InvNumberOrder
        FLocalDataBaseHead.FieldByName('CONFIRMEDC').Value := AConfirmedKindClientName; //Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
        //***24.01.17
        FLocalDataBaseHead.FieldByName('USERSESION').Value := gc_User.Session;  //Для сервиса - реальная сесия при продаже
        //***08.04.17
        FLocalDataBaseHead.FieldByName('PMEDICALID').Value := APartnerMedicalId;   //Id Медицинское учреждение(Соц. проект)
        FLocalDataBaseHead.FieldByName('PMEDICALN').Value  := APartnerMedicalName; //Название Медицинское учреждение(Соц. проект)
        FLocalDataBaseHead.FieldByName('AMBULANCE').Value  := AAmbulance;          //№ амбулатории (Соц. проект)
        FLocalDataBaseHead.FieldByName('MEDICSP').Value    := AMedicSP;            //ФИО врача (Соц. проект)
        FLocalDataBaseHead.FieldByName('INVNUMSP').Value   := AInvNumberSP;        //номер рецепта (Соц. проект)
        FLocalDataBaseHead.FieldByName('OPERDATESP').Value := AOperDateSP;         //дата рецепта (Соц. проект)
        //***15.06.17
        FLocalDataBaseHead.FieldByName('SPKINDID').Value   := ASPKindId;  //Id Вид СП
        //***02.02.18
        FLocalDataBaseHead.FieldByName('PROMOCODE').Value  := APromoCodeID;  //Id промокода
        //***27.06.18
        FLocalDataBaseHead.FieldByName('MANUALDISC').Value := AManualDiscount; // Ручная скидка
        //***02.11.18
        FLocalDataBaseHead.FieldByName('SUMMPAYADD').Value := ASummPayAdd; // Сумма доплаты
        //***02.11.18
        FLocalDataBaseHead.FieldByName('MEMBERSPID').Value := AMemberSPID; // ФИО пациента
        //***28.01.19
        FLocalDataBaseHead.FieldByName('SITEDISC').Value := (ASiteDiscount > 0); // Дисконт через сайт
        //***20.02.19
        FLocalDataBaseHead.FieldByName('BANKPOS').Value := ABankPOSTerminal;
        //***25.02.19
        FLocalDataBaseHead.FieldByName('JACKCHECK').Value := AJackdawsChecksCode;

        FLocalDataBaseHead.Post;
      End;
    except ON E:Exception do
      Begin
        Add_Log('Exception: ' + E.Message);
        Add_Log('GetLastError: ' + IntToStr(GetLastError) + ' - ' + SysErrorMessage(GetLastError));
        // что б отловить ошибки - запишим в лог
        Add_Log_XML('<Head err="'+E.Message+'">');

        Application.OnException(Application.MainForm,E);
//        ShowMessage('Ошибка локального сохранения чека: '+E.Message);
        result := False;
        exit;
      End;
    end; //сохранили шапку

    //сохраняем тело
    ADS.DisableControls;
    try
      try
        ADS.Filtered := False;
        ADS.First;
        FLocalDataBaseBody.First;
        while not FLocalDataBaseBody.eof do
        Begin
          if trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = AUID then
            FLocalDataBaseBody.Delete;
          FLocalDataBaseBody.Next;
        End;
        FLocalDataBaseBody.Pack;
        str_log_xml:=''; i:=0;
        while not ADS.Eof do
        Begin
          FLocalDataBaseBody.AppendRecord([ADS.FieldByName('Id').AsInteger,         //id записи
                                           AUID,                                    //uid чека
                                           ADS.FieldByName('GoodsId').AsInteger,    //ид товара
                                           ADS.FieldByName('GoodsCode').AsInteger,  //Код товара
                                           ADS.FieldByName('GoodsName').AsString,   //наименование товара
                                           ADS.FieldByName('NDS').asCurrency,          //НДС товара
                                           ADS.FieldByName('Amount').asCurrency,       //Кол-во
                                           ADS.FieldByName('Price').asCurrency,        //Цена, с 20.07.16 если есть скидка по Проекту дисконта, здесь будет цена с учетом скидки
                                           //***20.07.16
                                           ADS.FieldByName('PriceSale').asCurrency,         // Цена без скидки
                                           ADS.FieldByName('ChangePercent').asCurrency,     // % Скидки
                                           ADS.FieldByName('SummChangePercent').asCurrency, // Сумма Скидки
                                           //***19.08.16
                                           ADS.FieldByName('AmountOrder').asCurrency, // Кол-во заявка
                                           //***10.08.16
                                           ADS.FieldByName('List_UID').AsString // UID строки продажи
                                           ]);
          // сохранили отгруженные препараты для корректировки полных остатков
          if FSaveCheckToMemData then
          begin
            if mdCheck.Locate('ID', ADS.FieldByName('GoodsId').AsInteger, []) then
              mdCheck.Edit
            else
            begin
              mdCheck.Append;
              mdCheck.FieldByName('ID').AsInteger := ADS.FieldByName('GoodsId').AsInteger;
            end;
            mdCheck.FieldByName('Amount').AsCurrency := mdCheck.FieldByName('Amount').AsCurrency
                                                        + ADS.FieldByName('Amount').asCurrency;
            mdCheck.Post;
          end;
                  //сохранили строку в лог
                  i:= i + 1;
                  if str_log_xml<>'' then str_log_xml:=str_log_xml + #10 + #13;
                  try
                  str_log_xml:= str_log_xml
                              + '<Items num="' +IntToStr(i)+ '">'
                              + '<GoodsCode>"' + ADS.FieldByName('GoodsCode').asString + '"</GoodsCode>'
                              + '<GoodsName>"' + AnsiUpperCase(ADS.FieldByName('GoodsName').Text) + '"</GoodsName>'
                              + '<Amount>"' + FloatToStr(ADS.FieldByName('Amount').asCurrency) + '"</Amount>'
                              + '<Price>"' + FloatToStr(ADS.FieldByName('Price').asCurrency) + '"</Price>'
                              + '<List_UID>"' + ADS.FieldByName('List_UID').AsString + '"</List_UID>'
                              + '</Items>';
                  except
                  str_log_xml:= str_log_xml
                              + '<Items num="' +IntToStr(i)+ '">'
                              + '<GoodsCode>"' + ADS.FieldByName('GoodsCode').asString + '"</GoodsCode>'
                              + '<GoodsName>"???"</GoodsName>'
                              + '<List_UID>"' + ADS.FieldByName('List_UID').AsString + '"</List_UID>'
                              + '</Items>';
                  end;
          ADS.Next;
        End;

      Except ON E:Exception do
        Begin
        // что б отловить ошибки - запишим в лог
        Add_Log_XML('<Body err="'+E.Message+'">');

        Application.OnException(Application.MainForm,E);
//          ShowMessage('Ошибка локального сохранения содержимого чека: '+E.Message);
          result := False;
          exit;
        End;
      end;
    finally
      ADS.Filtered := true;
      ADS.EnableControls;
      FLocalDataBaseBody.Filter := '';
      FLocalDataBaseBody.Filtered := True;
    end;
  finally
    FLocalDataBaseBody.Active:=False;
    FLocalDataBaseHead.Active:=False;
    ReleaseMutex(MutexDBF);
    PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 3);  // только 2 форма
  end;

  // что б отловить ошибки - запишим в лог чек - во время СОХРАНЕНИЯ чека, т.е. ПОСЛЕ пробития через ЭККА
  Add_Log_XML('<Save now="'+FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+'">'
     +#10+#13+'<AUID>"'  + AUID  + '"</AUID>'
             +'<CheckNumber>"'  + FiscalCheckNumber  + '"</CheckNumber>'
             +'<FiscalNumber>"' + FiscalNumber + '"</FiscalNumber>'
     +#10+#13+str_log_xml
     +#10+#13+'</Save>'
             );

  // update VIP
  if ((AManagerId <> 0) or (ABayerName <> '')) and
     (gc_User.Local) and NeedComplete then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    try
      LoadLocalData(VipCDS, Vip_lcl);
      if (FormParams.ParamByName('CheckId').AsString <> '') and
         (StrToInt(FormParams.ParamByName('CheckId').AsString) <> 0) then
      Begin
        if VipCDS.Locate('Id', FormParams.ParamByName('CheckId').Value, []) then
          VipCDS.Delete;
      End
      else
      if VipCDS.Locate('InvNumber', AUID, []) then
        VipCDS.Delete;
      SaveLocalData(VipCDS,vip_lcl);
    finally
      ReleaseMutex(MutexVip);
    end;
  End;
end;

procedure TMainCashForm2.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin  //+
  sp := TdsdStoredProc.Create(nil);
  try
    ds := TClientDataSet.Create(nil);
    try
      sp.OutputType := otDataSet;
      sp.DataSet := ds;

      sp.StoredProcName := 'gpSelect_Object_Member';
      sp.Params.Clear;
      sp.Params.AddParam('inIsShowAll',ftBoolean,ptInput,False);
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);  // только для формы2;  защищаем так как есть в приложениее и сервисе
      SaveLocalData(ds,Member_lcl);
      ReleaseMutex(MutexVip); // только 2 форма

      sp.StoredProcName := 'gpSelect_Movement_CheckVIP';
      sp.Params.Clear;
      sp.Params.AddParam('inIsErased',ftBoolean,ptInput,False);
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);
      try
        SaveLocalData(ds,Vip_lcl);
      finally
        ReleaseMutex(MutexVip);
      end;

      sp.StoredProcName := 'gpSelect_MovementItem_CheckDeferred';
      sp.Params.Clear;
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);
      try
        SaveLocalData(ds,VipList_lcl);
      finally
        ReleaseMutex(MutexVip);
      end;
    finally
      ds.free;
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure TMainCashForm2.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := 'Продажа';
     edAmount.Text := '1';
  end
  else begin
     actSold.Caption := 'Возврат';
     edAmount.Text := '-1';
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
      VIPForm.AddOnFormData.isAlwaysRefresh := False;
      VIPForm.AddOnFormData.isSingle := true;
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
  spUserProtocol : TdsdStoredProc;
begin
  // Отключено только для MainCash, в форме MainCash2 сохранение ОШИБОК - ОСТАВИТЬ
  exit;

  spUserProtocol := TdsdStoredProc.Create(nil);
  try
    spUserProtocol.StoredProcName := 'gpInsert_UserProtocol';
    spUserProtocol.OutputType := otResult;
    spUserProtocol.Params.AddParam('inProtocolData', ftBlob, ptInput, ThreadErrorMessage);
    try
      spUserProtocol.Execute;
    except
    end;
  finally
    spUserProtocol.free;
  end;
//  ShowMessage('Во время проведения чека возникла ошибка:'+#13+
//              ThreadErrorMessage+#13#13+
//              'Проверьте состояние чека и, при необходимости, проведите чек вручную.');
end;


procedure TMainCashForm2.TimerBlinkBtnTimer(Sender: TObject);
begin
 TimerBlinkBtn.Enabled:=False;
 try

  SetBlinkVIP (false);
  SetBlinkCheck (false);


  if fBlinkVIP = true
  then if btnVIP.Colors.NormalText <> clDefault
       then begin btnVIP.Colors.NormalText:= clDefault; btnVIP.Colors.Default := clDefault; end
       else begin {Beep;} btnVIP.Colors.NormalText:= clYellow; btnVIP.Colors.Default := clRed; end
  else begin btnVIP.Colors.NormalText := clDefault; btnVIP.Colors.Default := clDefault; end;

  if fBlinkCheck = true
  then if btnCheck.Colors.NormalText <> clDefault
       then begin btnCheck.Colors.NormalText:= clDefault; btnCheck.Colors.Default := clDefault; end
       else begin btnCheck.Colors.NormalText:= clBlue; btnCheck.Colors.Default := clRed; end
  else begin btnCheck.Colors.NormalText := clDefault; btnCheck.Colors.Default := clDefault; end;
 finally
   TimerBlinkBtn.Enabled:=True;
 end;

end;

procedure TMainCashForm2.SetBlinkVIP (isRefresh : boolean);
var lMovementId_BlinkVIP : String;
begin
  if gc_User.Local then Exit;   // только 2 форма
  // если прошло > 100 сек - захардкодил
  if ((now - time_onBlink) > 0.002) or(isRefresh = true) then

  try
      //сохранили время "последней" обработки ВСЕХ документов - с типом "Не подтвержден"
      time_onBlink:= now;

      //Получили список ВСЕХ документов - с типом "Не подтвержден"
      spGet_BlinkVIP.Execute;
      lMovementId_BlinkVIP:=spGet_BlinkVIP.ParamByName('outMovementId_list').Value;

      // в этом случае кнопка будет мигать
      fBlinkVIP:= lMovementId_BlinkVIP <> '';

      // если сюда дошли, значит ON-line режим режим для VIP-чеков
      Self.Caption := 'Продажа ('+GetFileVersionString(ParamStr(0))+')' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>';

      //если список изменился ИЛИ надо "по любому обновить" - запустим "не самое долгое" обновление грида
      if (lMovementId_BlinkVIP <> MovementId_BlinkVIP) or(isRefresh = true)
      then begin
                // Сохранили список ВСЕХ документов - с типом "Не подтвержден"
                MovementId_BlinkVIP:= lMovementId_BlinkVIP;
                // "не самое долгое" обновление грида

      end;

  except
        Self.Caption := 'Продажа ('+GetFileVersionString(ParamStr(0))+') - OFF-line режим для VIP-чеков' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
  end;
end;

procedure TMainCashForm2.SetBlinkCheck (isRefresh : boolean);
var lMovementId_BlinkCheck : String;

begin
 if gc_User.Local then Exit;  // только 2 форма
  // если прошло > 50 сек - захардкодил
  if ((now - time_onBlinkCheck) > 0.003) or(isRefresh = true) then

  try
      //сохранили время "последней" обработки ВСЕХ документов - с "ошибка - расч/факт остаток"
      time_onBlinkCheck:= now;

      //Получили список ВСЕХ документов - с типом "Не подтвержден"
      spGet_BlinkCheck.Execute;
      lMovementId_BlinkCheck:=spGet_BlinkCheck.ParamByName('outMovementId_list').Value;

      // в этом случае кнопка будет мигать
      fBlinkCheck:= lMovementId_BlinkCheck <> '';

      // если сюда дошли, значит ON-line режим режим для проверки "ошибка - расч/факт остаток"
      if fBlinkCheck = True
      then Self.Caption := 'Продажа ('+GetFileVersionString(ParamStr(0))+') : есть ошибки - расч/факт остаток' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
      else Self.Caption := 'Продажа ('+GetFileVersionString(ParamStr(0))+')' + ' <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>';

  except
        Self.Caption := 'Продажа ('+GetFileVersionString(ParamStr(0))+') - OFF-line режим для чеков с ошибкой' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
  end;
end;


procedure TMainCashForm2.pGet_OldSP(var APartnerMedicalId: Integer; var APartnerMedicalName, AMedicSP: String; var AOperDateSP : TDateTime);
begin

 APartnerMedicalId:=0;
 APartnerMedicalName:='';
 AMedicSP:='';
 //
 try
     WaitForSingleObject(MutexDBF, INFINITE);
     try
       FLocalDataBaseHead.Active:=True;
       FLocalDataBaseHead.First;
       while not FLocalDataBaseHead.EOF do
       begin
            if (FLocalDataBaseHead.FieldByName('PMEDICALID').AsInteger <> 0) and
               not FLocalDataBaseHead.FieldByName('SAVE').AsBoolean then
            begin
              APartnerMedicalId   := FLocalDataBaseHead.FieldByName('PMEDICALID').AsInteger;
              APartnerMedicalName := trim(FLocalDataBaseHead.FieldByName('PMEDICALN').AsString);
              AMedicSP            := trim(FLocalDataBaseHead.FieldByName('MEDICSP').AsString);
              AOperDateSP         := FLocalDataBaseHead.FieldByName('OPERDATESP').AsCurrency;
            end;

            FLocalDataBaseHead.Next;
       end;
     finally
       FLocalDataBaseBody.Active:=False;
       ReleaseMutex(MutexDBF);
     end;
     //
  except
  end;

end;

procedure TMainCashForm2.TimerSaveAllTimer(Sender: TObject);
var fEmpt  : Boolean;
    RCount : Integer;
begin
  if gc_User.Local then Exit; // только 2 форма
   TimerSaveAll.Enabled:=False;
   fEmpt:= true;
   RCount:= 0;
   //
  try
    WaitForSingleObject(MutexDBF, INFINITE);
    try
      FLocalDataBaseHead.Active:=True;
      fEmpt:= FLocalDataBaseHead.IsEmpty;
      RCount:= FLocalDataBaseHead.RecordCount;
      FLocalDataBaseBody.Active:=False;
    finally
      FLocalDataBaseBody.Active:=False;
      ReleaseMutex(MutexDBF);
    end;
    //
    //пишем протокол что связь с базой есть + сколько чеков еще не перенеслось
    try spUpdate_UnitForFarmacyCash.ParamByName('inAmount').Value:= RCount;
        spUpdate_UnitForFarmacyCash.Execute;
    except end;
    //
  finally
     //
     TimerSaveAll.Enabled:=True;
  end;
end;

procedure TMainCashForm2.TimerServiceRunTimer(Sender: TObject);
const SERVICE_RUN_INTERVAL = 1000 * 60 * 10;
begin
  inherited;
  if TimerServiceRun.Interval <> SERVICE_RUN_INTERVAL then
    TimerServiceRun.Interval := SERVICE_RUN_INTERVAL;
  actServiseRun.Execute; // запуск сервиса  // только 2 форма
end;

procedure TMainCashForm2.LoadFromLocalStorage;
var
  nRemainsID, nAlternativeID, nCheckID: integer;
begin
  startSplash('Начало обновления данных с сервера !!');

  try
    MainGridDBTableView.BeginUpdate;
    RemainsCDS.DisableControls;
    AlternativeCDS.DisableControls;
    nRemainsID := 0;
    if RemainsCDS.Active and (RemainsCDS.RecordCount > 0) then
      nRemainsID := RemainsCDS.FieldByName('Id').asInteger;
    nAlternativeID := 0;
    if AlternativeCDS.Active and (AlternativeCDS.RecordCount > 0) then
      nAlternativeID := AlternativeCDS.FieldByName('Id').asInteger;
    nCheckID := 0;
    if CheckCDS.Active and (CheckCDS.RecordCount > 0) then
      nCheckID := CheckCDS.FieldByName('GoodsId').asInteger;
    try
      if not FileExists(Remains_lcl) or not FileExists(Alternative_lcl) then
        ShowMessage('Нет локального хранилища.');

      WaitForSingleObject(MutexRemains, INFINITE);
      try
        LoadLocalData(RemainsCDS, Remains_lcl);
      finally
        ReleaseMutex(MutexRemains);
      end;
      WaitForSingleObject(MutexAlternative, INFINITE);
      try
        LoadLocalData(AlternativeCDS, Alternative_lcl);
      finally
        ReleaseMutex(MutexAlternative);
      end;
      // корректируем новые остатки с учетом того, что уже было в чеке
      CheckCDS.First;
      while not CheckCDS.EOF do
      begin
        if RemainsCDS.Locate('Id', CheckCDS.FieldByName('GoodsId').asInteger, []) then
        begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
                                                        - CheckCDS.FieldByName('Amount').asCurrency;
          RemainsCDS.Post;
        end;
        CheckCDS.Next;
      end;
      // корректируем новые остатки с учетом того, что было отгружено во время получения остатков
      mdCheck.First;
      while not mdCheck.EOF do
      begin
        if RemainsCDS.Locate('Id', mdCheck.FieldByName('ID').asInteger, []) then
        begin
          RemainsCDS.Edit;
          RemainsCDS.FieldByName('Remains').asCurrency := RemainsCDS.FieldByName('Remains').asCurrency
                                                        - mdCheck.FieldByName('AMOUNT').asCurrency;
          RemainsCDS.Post;
        end;
        mdCheck.Next;
      end;
      mdCheck.Close;
      mdCheck.Open;
    finally
      if nRemainsID <> 0 then
        RemainsCDS.Locate('Id', nRemainsID, []);
      if nAlternativeID <> 0 then
        AlternativeCDS.Locate('Id', nAlternativeID, []);
      if nCheckID <> 0 then
        CheckCDS.Locate('GoodsId', nCheckID, []);
      RemainsCDS.EnableControls;
      AlternativeCDS.EnableControls;
      MainGridDBTableView.EndUpdate;
    end;
  finally
    EndSplash;
  end;
end;

procedure TMainCashForm2.LoadBankPOSTerminal;
  var nPos : integer;
begin
  if not FileExists(BankPOSTerminal_lcl) then Exit;

  BankPOSTerminalCDS.DisableControls;
  try
    if BankPOSTerminalCDS.Active then
      nPos := BankPOSTerminalCDS.RecNo
    else nPos := 0;
    WaitForSingleObject(MutexBankPOSTerminal, INFINITE);
    try
      LoadLocalData(BankPOSTerminalCDS, BankPOSTerminal_lcl);
    finally
      ReleaseMutex(MutexBankPOSTerminal);
    end;
  finally
    if (nPos <> 0) and BankPOSTerminalCDS.Active and
      (BankPOSTerminalCDS.RecordCount >= nPos) then BankPOSTerminalCDS.RecNo := nPos;
    BankPOSTerminalCDS.EnableControls;
  end;
end;

procedure TMainCashForm2.LoadUnitConfig;
  var nPos : integer;
begin
  if not FileExists(UnitConfig_lcl) then Exit;

  WaitForSingleObject(MutexUnitConfig, INFINITE);
  try
    LoadLocalData(UnitConfigCDS, UnitConfig_lcl);
  finally
    ReleaseMutex(MutexUnitConfig);
  end;
end;

procedure TMainCashForm2.LoadTaxUnitNight;
  var nPos : integer;
begin
  if not FileExists(TaxUnitNight_lcl) then Exit;

  WaitForSingleObject(MutexTaxUnitNight, INFINITE);
  try
    LoadLocalData(TaxUnitNightCDS, TaxUnitNight_lcl);
  finally
    ReleaseMutex(MutexTaxUnitNight);
  end;
end;

function TMainCashForm2.GetAmount : currency;
  var nAmount : Currency; nOne : Extended; nOut, nPack, nOst : Integer;
begin
  Result := 0;

  if edAmount.Text = '' then
  begin
    ActiveControl := edAmount;
    ShowMessage ('Ошибка. Не заполнено количество.'#13#10'Должно быть или дробь:'#13#10'Количество продажи / Количество в упаковке');
  end;

  if Pos('/', edAmount.Text) > 0 then
  begin
    if not TryStrToInt(Copy(edAmount.Text, 1, Pos('/', edAmount.Text) - 1), nOut) or (nOut = 0) then
    begin
      ActiveControl := edAmount;
      ShowMessage ('Ошибка. Не заполнено количество едениц продажи.');
    end;

    if not TryStrToInt(Copy(edAmount.Text, Pos('/', edAmount.Text) + 1, Length(edAmount.Text)),  nPack) or (nPack = 0) then
    begin
      ActiveControl := edAmount;
      ShowMessage ('Ошибка. Не заполнено количество едениц в упаковке.');
    end;

    nOut := Abs(nOut);
    nAmount := RoundTo(nOut / nPack, - 3);
    nOne := 1 / nPack;

    if SoldRegim then
    begin

      if Abs(Frac(RemainsCDS.FieldByName('Remains').asCurrency) -
        Round(Frac(RemainsCDS.FieldByName('Remains').asCurrency) / nOne) * nOne) / nOne * 100 >= 2 then
      begin
        ShowMessage('Остаток не соответствует введеной делимости.');
        Exit;
      end;

      if (Frac(nAmount) = (Frac(RemainsCDS.FieldByName('Remains').asCurrency) + 0.001)) and (nPack < 500) then
        nAmount := nAmount - 0.001
      else if (Frac(nAmount) = (Frac(RemainsCDS.FieldByName('Remains').asCurrency) - 0.001)) and (nPack < 500) then
        nAmount := nAmount + 0.001
      else if Frac(nAmount) <> Frac(RemainsCDS.FieldByName('Remains').asCurrency) then
      begin
        if Frac(RemainsCDS.FieldByName('Remains').asCurrency) = 0 then nOst := nPack - (nOut mod nPack)
        else nOst := Round(Frac(RemainsCDS.FieldByName('Remains').asCurrency) / nOne) - (nOut mod nPack);
        if nOst = 0 then
          nAmount := nAmount + (Frac(RemainsCDS.FieldByName('Remains').asCurrency) - Frac(nAmount))
        else if Frac(RemainsCDS.FieldByName('Remains').asCurrency) = 0 then
          nAmount := nAmount + (1 - RoundTo(nOst * nOne, - 3) - Frac(nAmount))
        else nAmount := nAmount + (Frac(RemainsCDS.FieldByName('Remains').asCurrency) - RoundTo(nOst * nOne, - 3) - Frac(nAmount));
      end;
    end else
    begin

      if Abs(Frac(CheckCDS.FieldByName('Amount').asCurrency) -
        Round(Frac(CheckCDS.FieldByName('Amount').asCurrency) / nOne) * nOne) / nOne * 100 >= 2 then
      begin
        ShowMessage('Остаток не соответствует введеной делимости.');
        Exit;
      end;

      if Pos('-', edAmount.Text) = 1 then
      begin
        if (Frac(nAmount) = (Frac(CheckCDS.FieldByName('Amount').asCurrency) + 0.001)) and (nPack < 500) then
          nAmount := nAmount - 0.001
        else if (Frac(nAmount) = (Frac(CheckCDS.FieldByName('Amount').asCurrency) - 0.001)) and (nPack < 500) then
          nAmount := nAmount + 0.001
        else if Frac(nAmount) <> Frac(CheckCDS.FieldByName('Amount').asCurrency) then
        begin
          if Frac(CheckCDS.FieldByName('Amount').asCurrency) = 0 then nOst := nPack - (nOut mod nPack)
          else nOst := Round(Frac(CheckCDS.FieldByName('Amount').asCurrency) / nOne) - (nOut mod nPack);
          if nOst = 0 then
            nAmount := nAmount + (Frac(CheckCDS.FieldByName('Amount').asCurrency) - Frac(nAmount))
          else if Frac(CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nAmount := nAmount + (1 - RoundTo(nOst * nOne, - 3) - Frac(nAmount))
          else nAmount := nAmount + (Frac(CheckCDS.FieldByName('Amount').asCurrency) - RoundTo(nOst * nOne, - 3) - Frac(nAmount));
        end;
        nAmount := - nAmount;
      end else
      begin
        if (Frac(nAmount) = (Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) + 0.001)) and (nPack < 500) then
          nAmount := nAmount - 0.001
        else if (Frac(nAmount) = (Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) - 0.001)) and (nPack < 500) then
          nAmount := nAmount + 0.001
        else if Frac(nAmount) <> Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) then
        begin
          if Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) = 0 then nOst := nPack - (nOut mod nPack)
          else nOst := Round(Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) / nOne) - (nOut mod nPack);
          if nOst = 0 then
            nAmount := nAmount + (Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) - Frac(nAmount))
          else if Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) = 0 then
            nAmount := nAmount + (1 - RoundTo(nOst * nOne, - 3) - Frac(nAmount))
          else nAmount := nAmount + (Frac(CheckCDS.FieldByName('Remains').asCurrency - CheckCDS.FieldByName('Amount').asCurrency) - RoundTo(nOst * nOne, - 3) - Frac(nAmount));
        end;
      end;
    end;

    Result := nAmount;
  end else
  begin
    if not TryStrToCurr(edAmount.Text, nAmount) then
    begin
      ActiveControl := edAmount;
      ShowMessage ('Ошибка. Невозможно преобразовать строку "' + edAmount.Text + '" в число.');
    end else Result := RoundTo(nAmount, - 3);
  end;
end;

// Сохранение чеков в CSV по дням
procedure TMainCashForm2.Add_Check_History;
  var F: TextFile; cName, S : string;  bNew : boolean;
      I : integer; SR: TSearchRec; FileList: TStringList;
begin
  try
    if not ForceDirectories(ExtractFilePath(Application.ExeName) + 'CheckHistory') then
    begin
      ShowMessage('Ошибка создания директории для сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору...');
      Exit;
    end;

    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\' + FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F,cName);
    if not fileExists(cName) then
    begin

{      FileList := TStringList.Create;
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
      end;}

      Rewrite(F);
      bNew := True;
    end else
    begin
      Append(F);
      bNew := False;
    end;

    try
      if bNew then Writeln(F, 'Тип;Дата и время;Подразделение;Касса;Кассир;Код;Наименование товара;Кол-во;Цена;Сумма');
      bNew := True;
      if pnlVIP.Visible then S := 'Вип' else S := '';
      if pnlVIP.Visible and pnlSP.Visible then S := S + ',';
      if pnlSP.Visible  then S := S + 'Сп.';

        // Содержимое чека
      with CheckCDS do
      begin
        First;
        while not EOF do
        begin
          if bNew then
            Writeln(F, S + ';' +
              DateTimeToStr(Now) + ';' +
              iniLocalUnitNameGet + ';' +
              IntToStr(iniCashID) + ';' +
              gc_User.Login + ';' +
              FieldByName('GoodsCode').AsString + ';' +
              StringReplace(FieldByName('GoodsName').AsString, ';', ',', [rfReplaceAll]) + ';' +
              FieldByName('Amount').AsString + ';' +
              FieldByName('Price').asString + ';' +
              FieldByName('Summ').asString)
          else Writeln(F, ';;;;;' +
            FieldByName('GoodsCode').AsString + ';' +
            StringReplace(FieldByName('GoodsName').AsString, ';', ',', [rfReplaceAll]) + ';' +
            FieldByName('Amount').AsString + ';' +
            FieldByName('Price').asString + ';' +
            FieldByName('Summ').asString);
          Next;
          bNew := False;
        end;
        First;
      end;
    finally
      CloseFile(F);
    end;
  except on E: Exception do
    ShowMessage('Ошибка сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору: ' + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.Start_Check_History(SalerCash, SalerCashAdd: Currency; PaidType: TPaidType);
  var F: TextFile; cName, S : string;  bNew : boolean;
      I : integer; SR: TSearchRec; FileList: TStringList;
begin
  try
    if not ForceDirectories(ExtractFilePath(Application.ExeName) + 'CheckHistory') then
    begin
      ShowMessage('Ошибка создания директории для сохранения истории чеков на локальном компьютере. Покажите это окно системному администратору...');
      Exit;
    end;

    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\ListCheck' + FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F,cName);
    if not fileExists(cName) then
    begin

      FileList := TStringList.Create;
      try
        if FindFirst(ExtractFilePath(Application.ExeName) + 'CheckHistory\ListCheck*.CSV', faAnyFile, SR) = 0 then
        repeat
          if SR.Name < 'ListCheck' + FormatDateTime('YYYY-MM-DD', IncMonth(Date, -1)) + '.CSV' then
            FileList.Add(ExtractFilePath(Application.ExeName) + 'CheckHistory\' + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR);

        for I := 0 to FileList.Count - 1 do DeleteFile(FileList.Strings[I]);
      finally
        FileList.Free;
      end;

      Rewrite(F);
      bNew := True;
    end else
    begin
      Append(F);
      bNew := False;
    end;

    try
      if bNew then Write(F, 'Тип;Дата и время;Подразделение;Касса;Кассир;Сумма нал;Сумма карта;Сумма закрытия');
      bNew := True;
      if pnlVIP.Visible then S := 'Вип' else S := '';
      if pnlVIP.Visible and pnlSP.Visible then S := S + ',';
      if pnlSP.Visible  then S := S + 'Сп.';
      Writeln(F, '');
      Write(F, S + ';' +
              DateTimeToStr(Now) + ';' +
              iniLocalUnitNameGet + ';' +
              IntToStr(iniCashID) + ';' +
              gc_User.Login + ';');
      case PaidType of
        ptMoney : Write(F, CurrToStr(SalerCash) + ';;');
        ptCard : Write(F, ';' + CurrToStr(SalerCash) + ';');
        ptCardAdd : Write(F, CurrToStr(SalerCashAdd) + ';' + CurrToStr(SalerCash - SalerCashAdd) + ';');
      end;
    finally
      CloseFile(F);
    end;
  except on E: Exception do
    ShowMessage('Ошибка сохранения перечня чеков на локальном компьютере. Покажите это окно системному администратору: ' + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.Finish_Check_History(SalerCash: Currency);
  var F: TextFile; cName : string;
begin
  try
    cName := ExtractFilePath(Application.ExeName) + 'CheckHistory\ListCheck' + FormatDateTime('YYYY-MM-DD', Date) + '.CSV';

    AssignFile(F,cName);
    if fileExists(cName) then
    begin
      Append(F);
      try
        Write(F, CurrToStr(SalerCash));
      finally
        CloseFile(F);
      end;
    end;
  except on E: Exception do
    ShowMessage('Ошибка сохранения перечня чеков на локальном компьютере. Покажите это окно системному администратору: ' + #13#10 + E.Message);
  end;
end;

procedure TMainCashForm2.SetTaxUnitNight;
  var bThereIs, bActive : boolean;
begin
  bThereIs := False;
  bActive := False;
  if UnitConfigCDS.Active and (UnitConfigCDS.RecordCount = 1) and TaxUnitNightCDS.Active and
    UnitConfigCDS.FieldByName('TaxUnitNight').AsBoolean then
  begin
    bThereIs := UnitConfigCDS.FieldByName('TaxUnitNight').AsBoolean;
    bActive := bThereIs and ((TimeOf(UnitConfigCDS.FieldByName('TaxUnitStartDate').AsDateTime) < Time) or
             (TimeOf(UnitConfigCDS.FieldByName('TaxUnitEndDate').AsDateTime) > Time));
  end;

  pnlTaxUnitNight.Visible := bActive;
  if pnlTaxUnitNight.Visible then edTaxUnitNight.Text := 'C ' +
     FormatDateTime('HH:NN', UnitConfigCDS.FieldByName('TaxUnitStartDate').AsDateTime) + ' по ' +
     FormatDateTime('HH:NN', UnitConfigCDS.FieldByName('TaxUnitEndDate').AsDateTime)
  else edTaxUnitNight.Text := '';

  MainColPriceNight.Visible := bThereIs;
  MainGridPriceChangeNight.Visible := bThereIs;
end;

    // Процент ночной скидки по цене
function TMainCashForm2.CalcTaxUnitNightPercent(ABasePrice : Currency) : Currency;
begin
  Result := 0;
  if TaxUnitNightCDS.Active then
  try
    TaxUnitNightCDS.Filter := 'PriceTaxUnitNight < ' + CurrToStr(ABasePrice);
    TaxUnitNightCDS.Filtered := True;
    TaxUnitNightCDS.Last;
    if TaxUnitNightCDS.RecordCount > 0 then Result := TaxUnitNightCDS.FieldByName('ValueTaxUnitNight').AsCurrency;
  finally
    TaxUnitNightCDS.Filtered := False;
    TaxUnitNightCDS.Filter := '';
  end;
end;

    // Расчет ночной цены
function TMainCashForm2.CalcTaxUnitNightPrice(ABasePrice, APrice : Currency; APercent : Currency = 0) : Currency;
  var nPercent : Currency;
begin
  if pnlTaxUnitNight.Visible then
    nPercent :=  CalcTaxUnitNightPercent(ABasePrice)
  else nPercent := 0;
  if APercent = 0 then
  begin
    if nPercent = 0 then Result := APrice
    else Result := GetPrice(APrice, - nPercent)
  end else
  begin
    if nPercent = 0 then Result := GetPrice(APrice, APercent)
    else Result := GetPrice(APrice, APercent - nPercent);
  end;
end;

function TMainCashForm2.CalcTaxUnitNightPriceGrid(ABasePrice, APrice : Currency) : Currency;
  var nPercent : Currency;
begin
  nPercent :=  CalcTaxUnitNightPercent(ABasePrice);
  if nPercent = 0 then Result := APrice
  else Result := GetPrice(APrice, - nPercent);
end;

    // Расчет цены, скидок
procedure TMainCashForm2.CalcPriceSale(var APriceSale, APrice, AChangePercent : Currency;
                                           APriceBase, APercent : Currency; APriceChange : Currency = 0);
  var nPercent : Currency;
begin

  // цена БЕЗ скидки
  APriceSale := APriceBase;

  if APriceChange <> 0 then
  begin
    if pnlTaxUnitNight.Visible then
    begin
      nPercent :=  CalcTaxUnitNightPercent(APriceBase);
      // цена СО скидкой
      APrice := GetPrice(APriceChange, - nPercent);
      // процент скидки
      AChangePercent :=  - nPercent;
    end else
    begin
      // цена СО скидкой
      APrice := APriceChange;
      // процент скидки
      AChangePercent := 0
    end;
  end else
  begin
    if pnlTaxUnitNight.Visible then
    begin
      nPercent :=  CalcTaxUnitNightPercent(APriceBase);
      // цена СО скидкой
      APrice := GetPrice(APriceBase, APercent - nPercent);
      // процент скидки
      AChangePercent := APercent - nPercent;
    end else
    begin
      // цена СО скидкой
      APrice := GetPrice(APriceBase, APercent);
      // процент скидки
      AChangePercent := APercent;
    end;
  end;
end;

{ TSaveRealThread }
{ TRefreshDiffThread }
{ TSaveRealAllThread }
initialization
  RegisterClass(TMainCashForm2);
  FLocalDataBaseHead := TVKSmartDBF.Create(nil);
  FLocalDataBaseBody := TVKSmartDBF.Create(nil);
  FLocalDataBaseDiff := TVKSmartDBF.Create(nil);  // только 2 форма
  InitializeCriticalSection(csCriticalSection);
  InitializeCriticalSection(csCriticalSection_Save);
  InitializeCriticalSection(csCriticalSection_All);
  FM_SERVISE := RegisterWindowMessage('FarmacyCashMessage');  // только 2 форма
finalization
  FLocalDataBaseHead.Free;
  FLocalDataBaseBody.Free;
  FLocalDataBaseDiff.Free;  // только 2 форма
  DeleteCriticalSection(csCriticalSection);
  DeleteCriticalSection(csCriticalSection_Save);
  DeleteCriticalSection(csCriticalSection_All);
end.
