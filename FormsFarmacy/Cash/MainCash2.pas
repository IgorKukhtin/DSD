unit MainCash2;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
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
  dxSkinsDefaultPainters, dxSkinscxPCPainter, LocalStorage;

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
    ceAmount: TcxCurrencyEdit;
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
    edAmount: TcxCurrencyEdit;
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
    procedure WM_KEYDOWN(var Msg: TWMKEYDOWN);
    procedure FormCreate(Sender: TObject);
    procedure actChoiceGoodsInRemainsGridExecute(Sender: TObject);
    procedure lcNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actSoldExecute(Sender: TObject);
    procedure actInsertUpdateCheckItemsExecute(Sender: TObject);
    procedure ceAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  private
    isScaner: Boolean;
    FSoldRegim: boolean;
    fShift: Boolean;
    FTotalSumm: Currency;
    Cash: ICash;
    SoldParallel: Boolean;
    SourceClientDataSet: TClientDataSet;
    ThreadErrorMessage:String;
    ASalerCash{,ASdacha}: Currency;
    PaidType: TPaidType;
    FiscalNumber: String;
    difUpdate: Boolean;  // только 2 форма
    VipCDS, VIPListCDS: TClientDataSet;
    VIPForm: TParentForm;
    // для мигания кнопки
    fBlinkVIP, fBlinkCheck : Boolean;
    time_onBlink, time_onBlinkCheck :TDateTime;
    MovementId_BlinkVIP:String;
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
    function PutCheckToCash(SalerCash: Currency; PaidType: TPaidType;
      out AFiscalNumber, ACheckNumber: String): boolean;
    //подключение к локальной базе данных
    function InitLocalStorage: Boolean;
    procedure LoadFromLocalStorage;
    //Сохранение чека в локальной базе. возвращает УИД
    function SaveLocal(ADS :TClientDataSet; AManagerId: Integer; AManagerName: String;
      ABayerName, ABayerPhone, AConfirmedKindName, AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP : String;
      AOperDateSP : TDateTime;
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency;
      NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;

    //проверили что есть остаток
    function fCheck_RemainsError : Boolean;

    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
    procedure Thread_Exception(var Msg: TMessage); message UM_THREAD_EXCEPTION;
    procedure ConnectionModeChange(var Msg: TMessage); message UM_LOCAL_CONNECTION;
    procedure SetWorkMode(ALocal: Boolean);
    procedure AppMsgHandler(var Msg: TMsg; var Handled: Boolean);  // только 2 форма
  public
    procedure pGet_OldSP(var APartnerMedicalId: Integer; var APartnerMedicalName, AMedicSP: String; var AOperDateSP : TDateTime);
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

  MutexDBF, MutexDBFDiff, MutexVip, MutexRemains, MutexAlternative, MutexAllowedConduct : THandle;  // MutexAllowedConduct только 2 форма
  LastErr: Integer;
  FM_SERVISE: Integer;  // для передачи сообщений между приложение и сервисом // только 2 форма
  function GetSumm(Amount,Price:currency): currency;
  function GenerateGUID: String;

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, DiscountDialog, SPDialog, CashWork, MessagesUnit,
     LocalWorkUnit, Splash, DiscountService, MainCash, UnilWin,
	 MediCard.Intf;

const
  StatusUnCompleteCode = 1;
  StatusCompleteCode = 2;
  StatusUnCompleteId = 14;
  StatusCompleteId = 15;

procedure TMainCashForm2.AppMsgHandler(var Msg: TMsg; var Handled: Boolean);  // только 2 форма
begin
  Handled := (Msg.hwnd = Application.Handle) and (Msg.message = FM_SERVISE);

  if Handled and (Msg.wParam = 1) then   //   WPARAM = 1 значит сообщения от сервиса в приложения  WPARAM = 2 от приложения в сервис
    case Msg.lParam of
      1: // получино сообщение на обновление diff разницы из дбф
        if difUpdate then
        begin
          difUpdate:=false;
          actAddDiffMemdata.Execute;   // вычитывает дбф в мемдату
          actSetRimainsFromMemdata.Execute; // обновляем остатки в товарах и чеках с учетом пришедших остатков в мемдате
        end;
      2:  // получен запрос на сохранение CashSessionId в  CashSessionId.ini
        begin
          actSaveCashSesionIdToFile.Execute;
        end;
      3:  // получен запрос на обновление всего
        begin
          LoadFromLocalStorage;
        end;
    end;
end;



function GetSumm(Amount,Price:currency): currency;
var
  A, P, RI: Cardinal;
  S1,S2:String;
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



procedure TMainCashForm2.actAddDiffMemdataExecute(Sender: TObject);  // только 2 форма
begin
//  ShowMessage('memdat-begin');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
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
      FLocalDataBaseDiff.Edit;
      FLocalDataBaseDiff.DeleteRecord;
      FLocalDataBaseDiff.Post;
      MemData.Post;
      FLocalDataBaseDiff.Next;
     end;
  FLocalDataBaseDiff.Pack;
  FLocalDataBaseDiff.Close;
  MemData.EnableControls;
  ReleaseMutex(MutexDBFDiff);
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
  with TCashWorkForm.Create(Cash, RemainsCDS) do begin
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
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
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
       ceAmount.Enabled := true;
       ceAmount.Value := 1;
       ActiveControl := ceAmount;
    end
  End
  else
  Begin
    if CheckCDS.isEmpty then exit;
    if CheckCDS.FieldByName('Amount').asCurrency>0 then begin
       SourceClientDataSet := CheckCDS;
       SoldRegim := False;
       lcName.Text := CheckCDS.FieldByName('GoodsName').asString;
       ceAmount.Enabled := true;
       ceAmount.Value := -1;
       ActiveControl := ceAmount;
    end;
  End;
end;

procedure TMainCashForm2.actClearAllExecute(Sender: TObject);
begin
  //if CheckCDS.IsEmpty then exit;
  if MessageDlg('Очистить все?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
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

  FiscalNumber := '';
  pnlVIP.Visible := False;
  edPrice.Value := 0.0;
  edPrice.Visible := False;
  edAmount.Value := 0.0;
  edAmount.Visible := False;
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
end;

procedure TMainCashForm2.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm2.actExecuteLoadVIPExecute(Sender: TObject);
var lMsg: String;
begin
  inherited;
  //
  SetBlinkVIP(true);
  //
  if not CheckCDS.IsEmpty then
  Begin
    ShowMessage('Текущий чек не пустой. Сначала очистите чек!');
    exit;
  End;
  if gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    LoadLocalData(vipCDS, Vip_lcl);
    LoadLocalData(vipListCDS, VipList_lcl);
    ReleaseMutex(MutexVip);
  End;
  if actLoadVIP.Execute then
  Begin
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

    pnlVIP.Visible := true;
  End;
  if not gc_User.Local then
  Begin
    WaitForSingleObject(MutexVip, INFINITE);
    SaveLocalData(VIPCDS,vip_lcl);
    SaveLocalData(VIPListCDS,vipList_lcl);
    ReleaseMutex(MutexVip);
  End;
end;

procedure TMainCashForm2.actGetJuridicalListExecute(Sender: TObject);
begin
  if edAmount.Visible and (edAmount.Value > 0.0) then
  begin
    spGet_JuridicalList.ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').AsInteger;
    spGet_JuridicalList.ParamByName('inAmount').Value := edAmount.Value;
    ShowMessage(spGet_JuridicalList.Execute());
  end;
end;

procedure TMainCashForm2.actGetJuridicalListUpdate(Sender: TObject);
begin
  actGetJuridicalList.Enabled := edAmount.Visible and (edAmount.Value > 0);
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

procedure TMainCashForm2.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //ЕСЛИ введенное кол-во 0 то просто переходим к следующему коду
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
begin
  if CheckCDS.RecordCount = 0 then exit;
  PaidType:=ptMoney;
  //спросили сумму и тип оплаты
  if not fShift then
  begin// если с Shift, то считаем, что дали без сдачи
    if not CashCloseDialogExecute(FTotalSumm,ASalerCash,PaidType) then
    Begin
      if Self.ActiveControl <> ceAmount then
        Self.ActiveControl := MainGrid;
      exit;
    End;
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
  if not gc_User.Local then
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
            exit;
       End;
    finally
       freeAndNil(dsdSave);
    end;
  end;
  //послали на печать
  try
    if PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.PaidType, FiscalNumber, CheckNumber) then
    Begin

      if (FormParams.ParamByName('DiscountExternalId').Value > 0)
      then fErr:= not DiscountServiceForm.fCommitCDS_Discount (CheckNumber, CheckCDS, lMsg , FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value)
      else fErr:= false;

      if fErr = true
      then ShowMessage ('Ошибка.Чек распечатан.Продажа не сохранена')
      else begin

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

                   True,         // NeedComplete
                   CheckNumber,  // FiscalCheckNumber
                   UID           // out AUID
                  )
      then Begin

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
    if gc_User.Local AND RemainsCDS.IsEmpty then
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
        LoadLocalData(RemainsCDS, Remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        LoadLocalData(AlternativeCDS, Alternative_lcl);
        ReleaseMutex(MutexAlternative);
      finally
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
        MainGridDBTableView.EndUpdate;
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
             sleep(10000);
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
        SaveLocalData(RemainsCDS,Remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        SaveLocalData(AlternativeCDS,Alternative_lcl);
        ReleaseMutex(MutexAlternative);

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
  // Попытка открыть Test.txt файл для записи
  AssignFile(myFile, 'CashSessionId.ini');
  ReWrite(myFile);
  // Запись нескольких известных слов в этот файл
  WriteLn(myFile, FormParams.ParamByName('CashSessionId').Value);
  // Закрытие файла
  CloseFile(myFile);
  PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 2);  // отправляем сообщение что можно забирать вайлс с кешсешнид
end;



procedure TMainCashForm2.actSelectLocalVIPCheckExecute(Sender: TObject);
var
  vip,vipList: TClientDataSet;
begin
  inherited;
  vip := TClientDataSet.Create(Nil);
  vipList := TClientDataSet.Create(nil);
  try
    WaitForSingleObject(MutexVip, INFINITE);
    LoadLocalData(vip,vip_lcl);
    LoadLocalData(vipList,vipList_lcl);
    ReleaseMutex(MutexVip);
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

        CheckCDS.Post;
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
begin
// if gc_User.Local then Exit;

  ExecuteFile := 'FarmacyCashServise.exe';
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
  WaitForSingleObject(MutexDBF, INFINITE);
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
  ReleaseMutex(MutexDBF);
//  ShowMessage('actSetMemdataFromDBFExecute-end');
//  ShowMessage('MemData.RecordCount - ' +  inttostr(MemData.RecordCount));

end;

procedure TMainCashForm2.actSetRimainsFromMemdataExecute(Sender: TObject);  // только 2 форма
var
  GoodsId: Integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
//  ShowMessage('actSetRimainsFromMemdataExecute - begin');
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
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
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
    difUpdate:=true;
  end;

//  ShowMessage('actSetRimainsFromMemdataExecute - end');

end;

procedure TMainCashForm2.actSetUpdateFromMemdataExecute(Sender: TObject);  // только 2 форма
var
  GoodsId: Integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
//  ShowMessage('actSetUpdateFromMemdataExecute - begin');
  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
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
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
    difUpdate:=true;
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
  edAmount.Visible := lblAmount.Visible;
end;

//***20.04.17
procedure TMainCashForm2.actSetSPExecute(Sender: TObject);
var
  PartnerMedicalId, SPKindId : Integer;
  PartnerMedicalName, MedicSP, Ambulance, InvNumberSP, SPKindName: String;
  OperDateSP : TDateTime;
  SPTax : Currency;
begin
  if (not CheckCDS.IsEmpty) and (Self.FormParams.ParamByName('InvNumberSP').Value = '') then
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

     //
     if Self.FormParams.ParamByName('PartnerMedicalId').Value > 0
     then OperDateSP   := Self.FormParams.ParamByName('OperDateSP').Value
     else OperDateSP   := NOW;
     if not DiscountDialogExecute(PartnerMedicalId, SPKindId, PartnerMedicalName, Ambulance, MedicSP, InvNumberSP, SPKindName, OperDateSP, SPTax)
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

              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin
    NewCheck(False);

  End;
end;

procedure TMainCashForm2.actSoldExecute(Sender: TObject);
begin
  SoldRegim:= not SoldRegim;
  ceAmount.Enabled := false;
  lcName.Text := '';
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

procedure TMainCashForm2.actSpecExecute(Sender: TObject);
begin
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpec.Checked;
end;

procedure TMainCashForm2.actUpdateRemainsExecute(Sender: TObject);
begin
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
  ceAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm2.ceAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm2.ceScanerKeyPress(Sender: TObject; var Key: Char);
const zc_BarCodePref_Object : String = '20100';
var isFind : Boolean;
    Key2 : Word;
    str_add : String;
begin
   isFind:= false;
   isScaner:= true;
   //
   if Key = #13 then
   begin
       //
       RemainsCDS.AfterScroll := nil;
       RemainsCDS.DisableConstraints;
       try
           // ЭТО Ш/К - ПРОИЗВОДИТЕЛЯ
           if zc_BarCodePref_Object <> Copy(ceScaner.Text,1, LengTh(zc_BarCodePref_Object))
           then begin
                 //потом покажем
                 str_add:= '(произв)';
                 //нашли
                 isFind:= RemainsCDS.Locate('BarCode', trim(ceScaner.Text), []);
                 //еще проверили что равно...
                 isFind:= (isFind) and (RemainsCDS.FieldByName('BarCode').AsString = trim(ceScaner.Text));
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
       RemainsCDS.EnableConstraints;

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
    ShowMessage('Режим работы: В сети');
  except
    Begin
      gc_User.Local := True;
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

procedure TMainCashForm2.ConnectionModeChange(var Msg: TMessage);
begin
  SetWorkMode(gc_User.Local);
end;

procedure TMainCashForm2.miMCSAutoClick(Sender: TObject);
begin
  if RemainsCDS.State in dsEditModes then RemainsCDS.Post;
  //
  edDays.Value:=7;
  PanelMCSAuto.Visible:= not PanelMCSAuto.Visible;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName('MCSValue').Index].Options.Editing:= PanelMCSAuto.Visible;
end;
procedure TMainCashForm2.FormCreate(Sender: TObject);
var
  F: String;
begin
  inherited;

  Application.OnMessage := AppMsgHandler;   // только 2 форма
  isScaner:= false;
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
  DiscountServiceForm:= TDiscountServiceForm.Create(Self);

  //сгенерили гуид для определения сессии
  ChangeStatus('Установка первоначальных параметров');
  FormParams.ParamByName('CashSessionId').Value := GenerateGUID;
  actSaveCashSesionIdToFile.Execute;  // только 2 форма
  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;
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

    if (Cash <> nil) AND (Cash.FiscalNumber = '') then
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
  //а2 начало -  только 2 форма
  ChangeStatus('Удаление файла остатков');
  WaitForSingleObject(MutexDBFDiff, INFINITE);
  if  FileExists(iniLocalDataBaseDiff) then
    DeleteFile(iniLocalDataBaseDiff);
  ReleaseMutex(MutexDBFDiff);
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



  SetBlinkVIP (true);
  SetBlinkCheck (true);
  TimerBlinkBtn.Enabled := true;
  actServiseRun.Execute; // запуск сервиса  // только 2 форма
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
var lQuantity, lPrice, lPriceSale, lChangePercent, lSummChangePercent : Currency;
    lMsg : String;
    lGoodsId_bySoldRegim : Integer;
    lPriceSale_bySoldRegim, lPrice_bySoldRegim : Currency;
begin
  if ceAmount.Value = 0 then
     exit;
  if not assigned(SourceClientDataSet) then
    SourceClientDataSet := RemainsCDS;
  if SoldRegim AND
     (ceAmount.Value > 0) and
     (ceAmount.Value > SourceClientDataSet.FieldByName('Remains').asFloat) then
  begin
    ShowMessage('Не хватает количества для продажи!');
    exit;
  end;
  if not SoldRegim AND
     (ceAmount.Value < 0) and
     (abs(ceAmount.Value) > abs(CheckCDS.FieldByName('Amount').asFloat)) then
  begin
    ShowMessage('Не хватает количества для возврата!');
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
       begin lGoodsId_bySoldRegim   := SourceClientDataSet.FieldByName('Id').asInteger;
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
             end
             else begin
                       // цена БЕЗ скидки
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
                       // цена СО скидкой в этом случае такая же
                       lPrice_bySoldRegim := lPriceSale_bySoldRegim;
                  end
       end
  else //это ВОЗВРАТ
       begin lGoodsId_bySoldRegim   := CheckCDS.FieldByName('GoodsId').AsInteger;
             if CheckCDS.FieldByName('PriceSale').asCurrency > 0 // !!!на всяк случай, временно
             then lPriceSale_bySoldRegim := CheckCDS.FieldByName('PriceSale').asCurrency
             else lPriceSale_bySoldRegim := CheckCDS.FieldByName('Price').asCurrency;
             // ?цена СО скидкой в этом случае такая же?
             lPrice_bySoldRegim:= lPriceSale_bySoldRegim;
       end;
  {
  //Находится "ИТОГО" кол-во - сколько уже набрали в продаже и к нему плюсуется или минусуется "новое" кол-во
  lQuantity := fGetCheckAmountTotal (lGoodsId_bySoldRegim, ceAmount.Value);
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
         else begin
                lChangePercent     := 0;
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim) * 0;
              end;
         // обнулим "нужные" параметры-Item
         //DiscountServiceForm.pSetParamItemNull;
  end; // else если установлен Проект (дисконтные карты) ***20.07.16
  //
  //
  if SoldRegim AND (ceAmount.Value > 0) then
  Begin
    CheckCDS.DisableControls;
    try
      CheckCDS.Filtered := False;
      if not checkCDS.Locate('GoodsId;PriceSale',VarArrayOf([SourceClientDataSet.FieldByName('Id').asInteger,lPriceSale]),[]) then
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
    UpdateRemainsFromCheck(SourceClientDataSet.FieldByName('Id').asInteger,ceAmount.Value, lPriceSale);
    //Update Дисконт в CDS - по всем "обновим" Дисконт
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if not SoldRegim AND (ceAmount.Value < 0) then
  Begin
    UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger,ceAmount.Value,CheckCDS.FieldByName('PriceSale').asCurrency);
    //Update Дисконт в CDS - по всем "обновим" Дисконт
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if SoldRegim AND (ceAmount.Value < 0) then
    ShowMessage('Для продажи можно указывать только количество больше 0!')
  else
  if not SoldRegim AND (ceAmount.Value > 0) then
    ShowMessage('Для возврата можно указывать только количество меньше 0!');
end;

{------------------------------------------------------------------------------}

procedure TMainCashForm2.UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
var
  GoodsId: Integer;
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

  AlternativeCDS.DisableControls;
  RemainsCDS.AfterScroll := Nil;
  RemainsCDS.DisableControls;
  GoodsId := RemainsCDS.FieldByName('Id').asInteger;
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
    CheckCDS.EnableControls;
    CheckCDS.Filter := oldFilter;
    CheckCDS.Filtered:= oldFiltered;
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
     ceAmount.Enabled := true;
     if SoldRegim then
        ceAmount.Value := 1
     else
        ceAmount.Value := - 1;
     ActiveControl := ceAmount;
  end;
  if Key = VK_TAB then
    ActiveControl:=MainGrid;
end;

procedure TMainCashForm2.MainColReservedGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

procedure TMainCashForm2.MainGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
 Cnt: integer;
begin

  actSetFilterExecute(nil); // Установка фильтров для товара

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

  FiscalNumber := '';
  pnlVIP.Visible := False;
  edPrice.Value := 0.0;
  edPrice.Visible := False;
  edAmount.Value := 0.0;
  edAmount.Visible := False;
  lblPrice.Visible := False;
  lblAmount.Visible := False;
  pnlDiscount.Visible := False;
  pnlSP.Visible := False;
  lblCashMember.Caption := '';
  lblBayer.Caption := '';
  CheckCDS.DisableControls;
  chbNotMCS.Checked := False;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;
  MCDesigner.CasualCache.Clear;

  MainCashForm.SoldRegim := true;
  MainCashForm.actSpec.Checked := false;
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
  ceAmount.Value := 0;
  isScaner:=false;
  ActiveControl := lcName;
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
    try
      if not gc_User.Local then
      Begin
        actRefreshAllExecute(nil);
        spDelete_CashSession.Execute;
      End
      else
      begin
        WaitForSingleObject(MutexRemains, INFINITE);
        SaveLocalData(RemainsCDS,remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        SaveLocalData(AlternativeCDS,Alternative_lcl);
        ReleaseMutex(MutexAlternative);
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

function TMainCashForm2.PutCheckToCash(SalerCash: Currency;
  PaidType: TPaidType; out AFiscalNumber, ACheckNumber: String): boolean;
var str_log_xml : String;
    i : Integer;
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //Продажа одного наименования
  begin
     // посылаем строку в кассу и если все OK, то ставим метку о продаже
     if not Assigned(Cash) or Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do begin
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text),
                                      FieldByName('Amount').asCurrency,
                                      FieldByName('Price').asCurrency,
                                      FieldByName('NDS').asCurrency)
         end
       else result:=true;
  end;
{------------------------------------------------------------------------------}
begin
  ACheckNumber := '';
  try
    if Assigned(Cash) AND NOT Cash.AlwaysSold then
      AFiscalNumber := Cash.FiscalNumber
    else
      AFiscalNumber := '';
    str_log_xml:=''; i:=0;
    result := not Assigned(Cash) or Cash.AlwaysSold or Cash.OpenReceipt;
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
                              + '</Items>';
                  except
                  str_log_xml:= str_log_xml
                              + '<Items="' +IntToStr(i)+ '">'
                              + '<GoodsCode>"' + FieldByName('GoodsCode').asString + '"</GoodsCode>'
                              + '<GoodsName>"???"</GoodsName>'
                              + '<List_UID>"' + FieldByName('List_UID').AsString + '"</List_UID>'
                              + '</Items>';
                  end;
              end;
           end;
        Next;
      end;
      if Assigned(Cash) AND not Cash.AlwaysSold then
      begin
        Cash.SubTotal(true, true, 0, 0);
        Cash.TotalSumm(SalerCash, PaidType);
        result := Cash.CloseReceiptEx(ACheckNumber); //Закрыли чек
      end;
    end;
  except
    result := false;
    raise;
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
        end
        else begin
            // на всяк случай условие - восстановим если Цена БЕЗ скидки была запонена
            if checkCDS.FieldByName('PriceSale').asCurrency > 0
            then checkCDS.FieldByName('Price').asCurrency        := checkCDS.FieldByName('PriceSale').asCurrency;
            // и обнулим скидку
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := 0;
        end;

        CheckCDS.FieldByName('Summ').asCurrency := GetSumm(CheckCDS.FieldByName('Amount').asCurrency,CheckCDS.FieldByName('Price').asCurrency);

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
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency;
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
    LoadLocalData(MyVipCDS, Vip_lcl);

    LoadLocalData(MyVipListCDS, VipList_lcl);
    ReleaseMutex(MutexVip);
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
    SaveLocalData(MyVipCDS, vip_lcl);
    MyVipListCDS.Filtered := False;
    SaveLocalData(MyVipListCDS, vipList_lcl);
    MyVipCDS.Free;
    MyVIPListCDS.Free;
    ReleaseMutex(MutexVip);
  End;  //Если чек виповский и ещё не проведен - то сохраняем в таблицу випов

  //сохраняем в дбф
  WaitForSingleObject(MutexDBF, INFINITE);
  FLocalDataBaseHead.Active:=True;
  FLocalDataBaseBody.Active:=True;
  try
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
                                         ASPKindId                 //Id Вид СП
                                        ]);
      End
      else
      Begin
        AUID := FLocalDataBaseHead.FieldByName('UID').Value;//uid чека
        FLocalDataBaseHead.Edit;
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

        FLocalDataBaseHead.Post;
      End;
    except ON E:Exception do
      Begin
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
    ReleaseMutex(MutexVip);
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
      SaveLocalData(ds,Vip_lcl);
      ReleaseMutex(MutexVip);

      sp.StoredProcName := 'gpSelect_MovementItem_CheckDeferred';
      sp.Params.Clear;
      sp.Execute(False,False);
      WaitForSingleObject(MutexVip, INFINITE);
      SaveLocalData(ds,VipList_lcl);
      ReleaseMutex(MutexVip);
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
     ceAmount.Value := 1;
  end
  else begin
     actSold.Caption := 'Возврат';
     ceAmount.Value := -1;
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
            if FLocalDataBaseHead.FieldByName('PMEDICALID').AsInteger <> 0 then
            begin
              APartnerMedicalId   := FLocalDataBaseHead.FieldByName('PMEDICALID').AsInteger;
              APartnerMedicalName := trim(FLocalDataBaseHead.FieldByName('PMEDICALN').AsString);
              AMedicSP            := trim(FLocalDataBaseHead.FieldByName('MEDICSP').AsString);
              AOperDateSP         := FLocalDataBaseHead.FieldByName('OPERDATESP').AsDateTime;
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

procedure TMainCashForm2.LoadFromLocalStorage;
var
  lMsg: String;
begin
  startSplash('Начало обновления данных с сервера');

  try
    MainGridDBTableView.BeginUpdate;
    RemainsCDS.DisableControls;
    AlternativeCDS.DisableControls;

    try
      if not FileExists(Remains_lcl) or not FileExists(Alternative_lcl) then
        ShowMessage('Нет локального хранилища.');

      WaitForSingleObject(MutexRemains, INFINITE);
      LoadLocalData(RemainsCDS, Remains_lcl);
      ReleaseMutex(MutexRemains);
      WaitForSingleObject(MutexAlternative, INFINITE);
      LoadLocalData(AlternativeCDS, Alternative_lcl);
      ReleaseMutex(MutexAlternative);
    finally
      RemainsCDS.EnableControls;
      AlternativeCDS.EnableControls;
      MainGridDBTableView.EndUpdate;
    end;
  finally
    EndSplash;
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
