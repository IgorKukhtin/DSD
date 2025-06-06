unit MainCash;

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
  ActiveX,  Math,
  VKDBFDataSet, FormStorage, CommonData, ParentForm, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, LocalStorage,
  cxDataControllerConditionalFormattingRulesManagerDialog, System.Actions,
  dxDateRanges;

type
  THeadRecord = record
    ID: Integer;//id ����
    PAIDTYPE:Integer; //��� ������
    MANAGER:Integer; //Id ��������� (VIP)
    NOTMCS:Boolean; //�� ��� ���
    COMPL:Boolean; //���������
    SAVE:Boolean; //��������
    NEEDCOMPL: Boolean; //���������� ����������
    DATE: TDateTime; //����/����� ����
    UID: String[50];//uid ����
    CASH: String[20]; //�������� ��������
    BAYER:String[254]; //���������� (VIP)
    FISCID:String[50]; //����� ����������� ����
    //***20.07.16
    DISCOUNTID : Integer;     //Id ������� ���������� ����
    DISCOUNTN  : String[254]; //�������� ������� ���������� ����
    DISCOUNT   : String[50];  //� ���������� �����
    //***16.08.16
    BAYERPHONE  : String[50];  //���������� ������� (����������) - BayerPhone
    CONFIRMED   : String[50];  //������ ������ (��������� VIP-����) - ConfirmedKind
    NUMORDER    : String[50];  //����� ������ (� �����) - InvNumberOrder
    CONFIRMEDC  : String[50];  //������ ������ (��������� VIP-����) - ConfirmedKindClient
    //***24.01.17
    USERSESION: string[50]; //��� ������� - �������� ����� ��� �������
    //***08.04.17
    PMEDICALID  : Integer;       //Id ����������� ����������(���. ������)
    PMEDICALN   : String[254];   //�������� ����������� ����������(���. ������)
    AMBULANCE   : String[50];    //� ����������� (���. ������)
    MEDICSP     : String[254];   //��� ����� (���. ������)
    INVNUMSP    : String[50];    //����� ������� (���. ������)
    OPERDATESP  : TDateTime;     //���� ������� (���. ������)
    //***15.06.17
    SPKINDID    : Integer;       //Id ��� ��
    //***02.02.18
    PROMOCODE : Integer;       //Id ���������
  end;
  TBodyRecord = record
    ID: Integer;            //�� ������
    GOODSID: Integer;       //�� ������
    GOODSCODE: Integer;     //��� ������
    NDS: Currency;          //��� ������
    AMOUNT: Currency;       //���-��
    PRICE: Currency;        //����, � 20.07.16 ���� ���� ������ �� ������� ��������, ����� ����� ���� � ������ ������
    CH_UID: String[50];     //uid ����
    GOODSNAME: String[254]; //������������ ������
    //***20.07.16
    PRICESALE: Currency;    // ���� ��� ������
    CHPERCENT: Currency;    // % ������
    SUMMCH: Currency;       // ����� ������
    //***19.08.16
    AMOUNTORD: Currency;    // ���-�� ������
    //***10.08.16
    LIST_UID: String[50]    // UID ������ �������
  end;
  TBodyArr = Array of TBodyRecord;

  TSaveRealThread = class(TThread) // ������ 1 �����
    DiffCDS : TClientDataSet;
    FCheckUID: String;
    FShapeColor: TColor;
    FNeedSaveVIP: Boolean;
    FLastError: String;
    procedure SetShapeState(AColor: TColor);
    procedure SyncShapeState;
    procedure UpdateRemains;
    procedure SendError(const AErrorMessage: String);
  private
    procedure SendErrorMineForm;
  protected
    procedure Execute; override;
  end;
  TSaveRealAllThread = class(TThread) // ������ 1 �����
  protected
    procedure Execute; override;
  end;

   TRefreshDiffThread = class(TThread) // ������ 1 �����
    FUserSession: string; // ����������� �����
    FShapeColor: TColor;
    procedure SetShapeState(AColor: TColor);
    procedure SyncShapeState;
    procedure UpdateRemains;
  protected
    procedure Execute; override;
  end;

  TMainCashForm = class(TAncestorBaseForm)
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
    actUpdateRemainsCDS: TdsdUpdateDataSet;
    spUpdate_Object_Price: TdsdStoredProc;
    PanelMCSAuto: TPanel;
    Label6: TLabel;
    edDays: TcxCurrencyEdit;
    miMCSAuto: TMenuItem;
    actSetFilter: TAction;
    miSetPromo: TMenuItem;
    actSetPromoCode: TAction;
    pnlPromoCode: TPanel;
    Label8: TLabel;
    lblPromoName: TLabel;
    Label10: TLabel;
    lblPromoCode: TLabel;
    Label12: TLabel;
    edPromoCodeChangePrice: TcxCurrencyEdit;
    miPrintNotFiscalCheck: TMenuItem;
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
    procedure actGetJuridicalListExecute(Sender: TObject);
    procedure actGetJuridicalListUpdate(Sender: TObject);
    procedure miMCSAutoClick(Sender: TObject);
    procedure actSetFilterExecute(Sender: TObject); //***10.08.16
    procedure actSetPromoCodeExecute(Sender: TObject); //***05.02.18
    procedure miPrintNotFiscalCheckClick(Sender: TObject); //***13.02.18
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

    VipCDS, VIPListCDS: TClientDataSet;
    VIPForm: TParentForm;
    // ��� ������� ������
    fBlinkVIP, fBlinkCheck : Boolean;
    time_onBlink, time_onBlinkCheck :TDateTime;
    MovementId_BlinkVIP:String;
    procedure SetBlinkVIP (isRefresh : boolean);
    procedure SetBlinkCheck (isRefresh : boolean);

    procedure SetSoldRegim(const Value: boolean);
    // ��������� ��������� ��������� ��� �������� ������ ����
    procedure NewCheck(ANeedRemainsRefresh: Boolean = True);
    // ��������� ���� ����
    procedure InsertUpdateBillCheckItems;
    //�������� ������� �������� ��������� �������
    procedure UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
    //���������� ����� � ������� ����
    procedure UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0; APriceSale: Currency = 0);

    //��������� "�����" ���-�� - ������� ��� ������� � ������� � � ���� ��������� ��� ���������� "�����" ���-��
    function fGetCheckAmountTotal(AGoodsId: Integer = 0; AAmount: Currency = 0) : Currency;

    // ��������� ����� �� ����
    procedure CalcTotalSumm;
    // ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
    procedure Add_Log_XML(AMessage: String);
    // ��������� ��� ����� ����
    function PutCheckToCash(SalerCash, SalerCashAdd: Currency; PaidType: TPaidType;
      out AFiscalNumber, ACheckNumber: String; isFiscal: boolean = true): boolean;
    //����������� � ��������� ���� ������
    function InitLocalStorage: Boolean;
    //���������� ���� � ��������� ����. ���������� ���
    function SaveLocal(ADS :TClientDataSet; AManagerId: Integer; AManagerName: String;
      ABayerName, ABayerPhone, AConfirmedKindName, AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP : String;
      AOperDateSP : TDateTime;
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency; APromoCodeID : Integer;
      NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;
    //��������� ��� � �������� ����
    procedure SaveReal(AUID: String; ANeedComplete: boolean = False); // ������ 1 �����

    //������������ �������
    procedure StartRefreshDiffThread; // ������ 1 �����

    //��������� ��� ���� �������
    function fCheck_RemainsError : Boolean;

    //������� � ��������� ���� � �������� �������
    procedure SaveRealAll; // ������ 1 �����
    property SoldRegim: boolean read FSoldRegim write SetSoldRegim;
    procedure Thread_Exception(var Msg: TMessage); message UM_THREAD_EXCEPTION;
    procedure ConnectionModeChange(var Msg: TMessage); message UM_LOCAL_CONNECTION;
    procedure SetWorkMode(ALocal: Boolean);
  public
    procedure pGet_OldSP(var APartnerMedicalId: Integer; var APartnerMedicalName, AMedicSP: String; var AOperDateSP : TDateTime);
    function pCheck_InvNumberSP(ASPKind : integer; ANumber : string) : boolean;
  end;

var
  MainCashForm: TMainCashForm;
  CountRRT: Integer = 0; // ������ 1 �����
  CountSaveThread: Integer = 0; // ������ 1 �����
  ActualRemainSession: Integer = 0; // ������ 1 �����
  FLocalDataBaseHead : TVKSmartDBF;
  FLocalDataBaseBody : TVKSmartDBF;
  LocalDataBaseisBusy: Integer = 0;
  csCriticalSection,
  csCriticalSection_Save,
  csCriticalSection_All: TRTLCriticalSection;

  MutexDBF, MutexDBFDiff, MutexVip, MutexRemains, MutexAlternative: THandle;
  LastErr: Integer;

  function GetSumm(Amount,Price:currency): currency;
  function GetSummFull(Amount,Price:currency): currency;
  function GenerateGUID: String;

implementation

{$R *.dfm}

uses CashFactory, IniUtils, CashCloseDialog, VIPDialog, DiscountDialog, SPDialog, CashWork, MessagesUnit,
     LocalWorkUnit, Splash, DiscountService, MainCash2, UnilWin,
     PromoCodeDialog;

const
  StatusUnCompleteCode = 1;
  StatusCompleteCode = 2;
  StatusUnCompleteId = 14;
  StatusCompleteId = 15;

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
    RI := StrToInt(Copy(S1,1,length(S1)-4));
  if (Length(S1)>=4) AND
     (StrToint(S1[length(S1)-3])>=5) then
    RI := RI + 1;
  Result := (RI / 10);
end;

function GetSummFull(Amount,Price:currency): currency;
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



procedure TMainCashForm.actCalcTotalSummExecute(Sender: TObject);
begin
  CalcTotalSumm;
end;

procedure TMainCashForm.actCashWorkExecute(Sender: TObject);
begin
  inherited;
  with TCashWorkForm.Create(Cash, RemainsCDS, '') do begin
    ShowModal;
    Free;
  end;
end;

procedure TMainCashForm.actChoiceGoodsInRemainsGridExecute(Sender: TObject);
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

procedure TMainCashForm.actClearAllExecute(Sender: TObject);
begin
  //if CheckCDS.IsEmpty then exit;
  if MessageDlg('�������� ���?',mtConfirmation,mbYesNo,0)<>mrYes then exit;
  //������� ����� � ������� ����
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
  //***02.02.18
  FormParams.ParamByName('PromoCodeID').Value               := 0;
  FormParams.ParamByName('PromoCodeGUID').Value             := '';
  FormParams.ParamByName('PromoName').Value                 := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value    := 0.0;

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
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  StartRefreshDiffThread; // ������ 1 �����
end;

procedure TMainCashForm.actClearMoneyExecute(Sender: TObject);
begin
  lblMoneyInCash.Caption := '0.00';
end;

procedure TMainCashForm.actExecuteLoadVIPExecute(Sender: TObject);
var lMsg: String;
begin
  inherited;
  //
  SetBlinkVIP(true);
  //
  if not CheckCDS.IsEmpty then
  Begin
    ShowMessage('������� ��� �� ������. ������� �������� ���!');
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
    //������� "������" ���������-Main ***20.07.16
    DiscountServiceForm.pGetDiscountExternal (FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);
    // ***20.07.16
    if FormParams.ParamByName('DiscountExternalId').Value > 0 then
    begin
         //�������� ����� + �������� "�������" ���������-Main
         if not DiscountServiceForm.fCheckCard (lMsg
                                               ,DiscountServiceForm.gURL
                                               ,DiscountServiceForm.gService
                                               ,DiscountServiceForm.gPort
                                               ,DiscountServiceForm.gUserName
                                               ,DiscountServiceForm.gPassword
                                               ,FormParams.ParamByName('DiscountCardNumber').Value
                                               ,DiscountServiceForm.gisOneSupplier
                                               ,DiscountServiceForm.gisTwoPackages
                                               ,FormParams.ParamByName('DiscountExternalId').Value
                                               )
         then begin
            // �������, ����� ��������� ������ ������
            FormParams.ParamByName('DiscountExternalId').Value:= 0;
            // ������� "������" ���������-Item
            //DiscountServiceForm.pSetParamItemNull;
         end;

    end;
    //
    if FormParams.ParamByName('InvNumberSP').Value = ''
    then begin
        // Update ������� � CDS - �� ���� "�������" �������
        DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);
        //
        CalcTotalSumm;
    end;

    //***20.07.16
    lblDiscountExternalName.Caption:= '  ' + FormParams.ParamByName('DiscountExternalName').Value + '  ';
    lblDiscountCardNumber.Caption  := '  ' + FormParams.ParamByName('DiscountCardNumber').Value + '  ';
    pnlDiscount.Visible            := FormParams.ParamByName('DiscountExternalId').Value > 0;

    lblPartnerMedicalName.Caption:= '  ' + FormParams.ParamByName('PartnerMedicalName').Value; //+ '  /  � ���. ' + FormParams.ParamByName('Ambulance').Value;
    lblMedicSP.Caption:= '  ' + FormParams.ParamByName('MedicSP').Value + '  /  � '+FormParams.ParamByName('InvNumberSP').Value+'  �� ' + DateToStr(FormParams.ParamByName('OperDateSP').Value);
    if FormParams.ParamByName('SPTax').Value <> 0 then lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FloatToStr(FormParams.ParamByName('SPTax').Value) + '% : ' + FormParams.ParamByName('SPKindName').Value
    else lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FormParams.ParamByName('SPKindName').Value;
    pnlSP.Visible:= FormParams.ParamByName('InvNumberSP').Value <> '';

    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString;
    if (FormParams.ParamByName('ConfirmedKindName').AsString <> '')
    then lblCashMember.Caption := lblCashMember.Caption + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString;
    if (FormParams.ParamByName('InvNumberOrder').AsString <> '')
    then lblCashMember.Caption := lblCashMember.Caption + ' * ' + '� ' + FormParams.ParamByName('InvNumberOrder').AsString;

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

procedure TMainCashForm.actGetJuridicalListExecute(Sender: TObject);
begin
  if edAmount.Visible and (edAmount.Value > 0.0) then
  begin
    spGet_JuridicalList.ParamByName('inGoodsId').Value := RemainsCDS.FieldByName('Id').AsInteger;
    spGet_JuridicalList.ParamByName('inAmount').Value := edAmount.Value;
    ShowMessage(spGet_JuridicalList.Execute());
  end;
end;

procedure TMainCashForm.actGetJuridicalListUpdate(Sender: TObject);
begin
  actGetJuridicalList.Enabled := edAmount.Visible and (edAmount.Value > 0);
end;

procedure TMainCashForm.actGetMoneyInCashExecute(Sender: TObject);
begin
  if gc_User.local then exit;

  spGet_Password_MoneyInCash.Execute;
  //�������� ����� ��� ������
  //if InputBox('������','������� ������:','') <> spGet_Password_MoneyInCash.ParamByName('outPassword').AsString then exit;
  //
  spGetMoneyInCash.ParamByName('inDate').Value := Date;
  spGetMoneyInCash.Execute;
  lblMoneyInCash.Caption := FormatFloat(',0.00',spGetMoneyInCash.ParamByName('outTotalSumm').AsFloat);
  //
  TimerMoneyInCash.Enabled:=True;
end;

procedure TMainCashForm.TimerMoneyInCashTimer(Sender: TObject);
begin
 TimerMoneyInCash.Enabled:=False;
 try
  lblMoneyInCash.Caption := '0.00';
  TimerMoneyInCash.Enabled:=False;
 finally
   TimerMoneyInCash.Enabled:=True;
 end;
end;

procedure TMainCashForm.actInsertUpdateCheckItemsExecute(Sender: TObject);
begin
  if ceAmount.Value <> 0 then begin //���� ��������� ���-�� 0 �� ������ ��������� � ���������� ����
    if not Assigned(SourceClientDataSet) then
      SourceClientDataSet := RemainsCDS;

    if SoldRegim AND (SourceClientDataSet.FieldByName('Price').asCurrency = 0) then begin
       ShowMessage('������ ������� ����� � 0 �����! ��������� � ����������');
       exit;
    end;
    InsertUpdateBillCheckItems;
  end;
  SoldRegim := true;
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

//��������� ��� ���� �������
function TMainCashForm.fCheck_RemainsError : Boolean;
var GoodsId_list, Amount_list : String;
    B:TBookmark;
begin
  Result:=false;
  //
  GoodsId_list:= '';
  Amount_list:= '';
  //
  //����������� ������ �������
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
  //������ �����
  with spCheck_RemainsError do
  try
      ParamByName('inGoodsId_list').Value := GoodsId_list;
      ParamByName('inAmount_list').Value := Amount_list;
      Execute;
      Result:=ParamByName('outMessageText').Value = '';
      //if not Result then ShowMessage(ParamByName('outMessageText').Value);
  except
       //�.�. ��� ����� � ��� �� �������� �������
       Result:=true;
  end;
  if not Result then
  begin actShowMessage.MessageText:= spCheck_RemainsError.ParamByName('outMessageText').Value;
        actShowMessage.Execute;
  end;
end;

procedure TMainCashForm.actPutCheckToCashExecute(Sender: TObject);
var
  UID,CheckNumber: String;
  lMsg: String;
  fErr: Boolean;
  dsdSave: TdsdStoredProc;
  nBankPOSTerminal : integer;
  nPOSTerminalCode : integer;
  isDiscountCommit : Boolean;
begin
  if CheckCDS.RecordCount = 0 then exit;
  PaidType:=ptMoney;
  ASalerCashAdd:=0;
  //�������� ����� � ��� ������
  if not fShift then
  begin// ���� � Shift, �� �������, ��� ���� ��� �����
    if not CashCloseDialogExecute(FTotalSumm,ASalerCash,ASalerCashAdd,PaidType,nBankPOSTerminal,nPOSTerminalCode) then
    Begin
      if Self.ActiveControl <> ceAmount then
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
  //�������� ��� �������� ������
  ShapeState.Brush.Color := clYellow;
  ShapeState.Repaint;
  application.ProcessMessages;

  //��������� ��� ���� �������
  if fCheck_RemainsError = false then exit;

  //��������� ��� ���� ��� �� ��� �������� ������ ������ - 04.02.2017
  dsdSave := TdsdStoredProc.Create(nil);
  try
     //��������� � ����� ��������� ��������.
     dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
     dsdSave.OutputType := otResult;
     dsdSave.Params.Clear;
     dsdSave.Params.AddParam('inId',ftInteger,ptInput,FormParams.ParamByName('CheckId').Value);
     dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
     dsdSave.Execute(False,False);
     if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //��������
     Begin
          ShowMessage ('������.������ ��� ��� �������� ������ ������.��� ����������� - ���������� �������� ��� � ������� ������� ������.');
          exit;
     End;
  finally
     freeAndNil(dsdSave);
  end;

  //������� �� ������
  try
    if PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd, MainCashForm.PaidType, FiscalNumber, CheckNumber) then
    Begin

      if (FormParams.ParamByName('DiscountExternalId').Value > 0)
      then
      begin
        fErr:= not DiscountServiceForm.fCommitCDS_Discount (CheckNumber, CheckCDS, lMsg , FormParams.ParamByName('DiscountExternalId').Value,
                                                            FormParams.ParamByName('DiscountCardNumber').Value, isDiscountCommit);
        FormParams.ParamByName('isDiscountCommit').Value := isDiscountCommit;
      end
      else fErr:= false;

      if fErr = true
      then ShowMessage ('������.��� ����������.������� �� ���������')
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
                   //***02.02.18
                   FormParams.ParamByName('PromoCodeID').Value,

                   True,         // NeedComplete
                   CheckNumber,  // FiscalCheckNumber
                   UID           // out AUID
                  )
      then Begin
        SaveReal(UID, True); // ������ 1 �����
        NewCheck(false);
      End;
           end; // else if fErr = true
    End;
  finally
    ShapeState.Brush.Color := clGreen;
    ShapeState.Repaint;
  end;
end;

procedure TMainCashForm.actRefreshAllExecute(Sender: TObject);
var
  lMsg: String;
begin
  startSplash('������ ���������� ������ � �������');
  try
    if gc_User.Local AND RemainsCDS.IsEmpty then
    begin
      MainGridDBTableView.BeginUpdate;
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        if not FileExists(Remains_lcl) or
           not FileExists(Alternative_lcl) then
        Begin
          ShowMessage('��� ���������� ���������. ���������� ������ ����������!');
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
    if not gc_User.Local then
    Begin
      if Sender <> nil then
        InterlockedIncrement(ActualRemainSession); //��������� ������ ��������
      MainGridDBTableView.BeginUpdate;
      RemainsCDS.DisableControls;
      AlternativeCDS.DisableControls;
      try
        ChangeStatus('�������� ��������� ��������� �� ������������� � ��������� Pfizer ���');
        lMsg:= '';
        // ������ �����
        if not DiscountServiceForm.fPfizer_Send(2807930, lMsg) then
        begin
          ChangeStatus('������ � ���������� Pfizer ��� :' + lMsg);
          sleep(2000);
        end
        else
        begin
          ChangeStatus
            ('��������� ���������������� � ���������� Pfizer ��� ������� :' +
            lMsg);
          sleep(1000);
        end;
        // ������� "������ ����� ����-������"
        if not DiscountServiceForm.fPfizer_Send(15615415, lMsg) then
        begin
          ChangeStatus('������ � ���������� Pfizer ��� :' + lMsg);
          sleep(2000);
        end
        else
        begin
          ChangeStatus
            ('��������� ���������������� � ���������� Pfizer ��� ������� :' +
            lMsg);
          sleep(1000);
        end;

        ChangeStatus('��������� ��������');
        actRefresh.Execute;

        ChangeStatus('���������� �������� � ��������� ����');
        WaitForSingleObject(MutexRemains, INFINITE);
        SaveLocalData(RemainsCDS,Remains_lcl);
        ReleaseMutex(MutexRemains);
        WaitForSingleObject(MutexAlternative, INFINITE);
        SaveLocalData(AlternativeCDS,Alternative_lcl);
        ReleaseMutex(MutexAlternative);

        ChangeStatus('��������� ��� �����');

        SaveLocalVIP;
        ChangeStatus('���������� ��� ����� � ��������� ����');
      finally
        ChangeStatus('������������ ������ � ���� ���������');
        RemainsCDS.EnableControls;
        AlternativeCDS.EnableControls;
        MainGridDBTableView.EndUpdate;
      end;
    End;
  finally
    EndSplash;
  end;
end;

procedure TMainCashForm.actRefreshRemainsExecute(Sender: TObject);
begin
  StartRefreshDiffThread;
end;
{ synh1 } //��� ��������� ������������� ���� ����
procedure TMainCashForm.actSelectLocalVIPCheckExecute(Sender: TObject);
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
        CheckCDS.FieldByName('Amount').AsFloat := 0;//VipList.FieldByName('Amount').AsFloat; //��������� ��������, �������� 0, ***20.07.16
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
          //��������� ��������, ��������� � VipList, ***20.07.16
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

procedure TMainCashForm.actSetFilterExecute(Sender: TObject);
begin
  inherited;
 // if RemainsCDS.Active and AlternativeCDS.Active then

//a1  ��� �� ������� RemainsCDSAfterScroll ��� ��������� ������ ����������
 if RemainsCDS.FieldByName('AlternativeGroupId').AsInteger = 0 then
    AlternativeCDS.Filter := 'Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString
  else
    AlternativeCDS.Filter := '(Remains > 0 AND MainGoodsId='+RemainsCDS.FieldByName('Id').AsString +
      ') or (Remains > 0 AND AlternativeGroupId='+RemainsCDS.FieldByName('AlternativeGroupId').AsString+
           ' AND Id <> '+RemainsCDS.FieldByName('Id').AsString+')';
//a1
end;

procedure TMainCashForm.actSetFocusExecute(Sender: TObject);
begin
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;


procedure TMainCashForm.actSetPromoCodeExecute(Sender: TObject);
var
  PromoCodeId: Integer;
  PromoName, PromoCodeGUID, BayerName: String;
  PromoCodeChangePercent: currency;
begin
  if (not CheckCDS.IsEmpty) then
  Begin
    ShowMessage('������� ��� �� ������. ������� �������� ���!');
    exit;
  End;

  with TPromoCodeDialogForm.Create(nil) do
  try
     PromoCodeId            := Self.FormParams.ParamByName('PromoCodeID').Value;
     PromoCodeGUID          := Self.FormParams.ParamByName('PromoCodeGUID').Value;
     PromoName              := Self.FormParams.ParamByName('PromoName').Value;
     BayerName              := Self.FormParams.ParamByName('BayerName').Value;
     PromoCodeChangePercent := Self.FormParams.ParamByName('PromoCodeChangePercent').Value;
     if not PromoCodeDialogExecute(PromoCodeId, PromoCodeGUID, PromoName, BayerName, PromoCodeChangePercent)
     then exit;
  finally
     Free;
  end;
  //
  FormParams.ParamByName('PromoCodeID').Value             := PromoCodeId;
  FormParams.ParamByName('PromoCodeGUID').Value           := PromoCodeGUID;
  FormParams.ParamByName('PromoName').Value               := PromoName;
  FormParams.ParamByName('BayerName').Value               := BayerName;
  FormParams.ParamByName('PromoCodeChangePercent').Value  := PromoCodeChangePercent;

  pnlPromoCode.Visible          := PromoCodeId > 0;
  lblPromoName.Caption          := '  ' + PromoName + '  ';
  lblPromoCode.Caption          := '  ' + PromoCodeGUID + '  ';
  edPromoCodeChangePrice.Value  := PromoCodeChangePercent;
end;

procedure TMainCashForm.actSetConfirmedKind_CompleteExecute(Sender: TObject);
var UID: String;
    lConfirmedKindName:String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
       ShowMessage('������.VIP-��� �� ��������.');
       exit
  end;

  // �������� <������ ������> � �������� ��� ��������
  with spUpdate_ConfirmedKind do
  try
      ParamByName('inMovementId').Value := FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_Complete';
      Execute;
      lConfirmedKindName:=ParamByName('ouConfirmedKindName').Value;
  except
        ShowMessage('������.��� ����� � ��������');
  end;

  if spUpdate_ConfirmedKind.ParamByName('outMessageText').Value <> '' then
  begin actShowMessage.MessageText:= spUpdate_ConfirmedKind.ParamByName('outMessageText').Value;
        actShowMessage.Execute;
  end;

  if lConfirmedKindName = '' then
  begin
        ShowMessage('������.������ �������� ������ ����');
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
              //***02.02.18
              ,FormParams.ParamByName('PromoCodeID').Value

              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin
    SaveReal(UID); // ������ 1 �����
    //
    NewCheck(False);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString
                   + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString
                   + ' * ' + '� ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP (true);
end;

procedure TMainCashForm.actSetConfirmedKind_UnCompleteExecute(Sender: TObject);
var UID: String;
    lConfirmedKindName:String;
begin
  if FormParams.ParamByName('CheckId').Value = 0 then
  begin
       ShowMessage('������.VIP-��� �� ��������.');
       exit
  end;

  // �������� <������ ������> � �������� ��� ��������
  with spUpdate_ConfirmedKind do
  try
      ParamByName('inMovementId').Value := FormParams.ParamByName('CheckId').Value;
      ParamByName('inDescName').Value := 'zc_Enum_ConfirmedKind_UnComplete';
      Execute;
      lConfirmedKindName:=ParamByName('ouConfirmedKindName').Value;
  except
        ShowMessage('������.��� ����� � ��������');
  end;

  if lConfirmedKindName = '' then
  begin
        ShowMessage('������.������ �������� ������ ����');
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
              //***02.02.18
              ,FormParams.ParamByName('PromoCodeID').Value

              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin
    SaveReal(UID); // ������ 1 �����
    //
    NewCheck(False);
    //
    lblCashMember.Caption := FormParams.ParamByName('ManagerName').AsString
                   + ' * ' + FormParams.ParamByName('ConfirmedKindName').AsString
                   + ' * ' + '� ' + FormParams.ParamByName('InvNumberOrder').AsString;
  End;

  //
  SetBlinkVIP (true);
end;

//***20.07.16
procedure TMainCashForm.actSetDiscountExternalExecute(Sender: TObject);
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
  // update DataSet - ��� ��� �� ���� "�������" �������
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
procedure TMainCashForm.actSetSPExecute(Sender: TObject);
var
  PartnerMedicalId, SPKindId, MemberSPID : Integer;
  PartnerMedicalName, MedicSP, Ambulance, InvNumberSP, SPKindName, MemberSP : String;
  OperDateSP : TDateTime; SPTax : Currency;
  HelsiPartialPrescription, HelsiSkipDispenseSign : Boolean;
  HelsiID, HelsiIDList, HelsiName, HelsiProgramId, HelsiProgramName : string; HelsiQty : currency;
  PaperRecipeSP : Boolean;
begin
  if (not CheckCDS.IsEmpty) and (Self.FormParams.ParamByName('InvNumberSP').Value = '') then
  Begin
    ShowMessage('������� ��� �� ������. ������� �������� ���!');
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
     MemberSP     := Self.FormParams.ParamByName('MemberSP').Value;
     //
     if Self.FormParams.ParamByName('PartnerMedicalId').Value > 0
     then OperDateSP   := Self.FormParams.ParamByName('OperDateSP').Value
     else OperDateSP   := NOW;
     if not DiscountDialogExecute(PartnerMedicalId, SPKindId, PartnerMedicalName, Ambulance, MedicSP, InvNumberSP, SPKindName, OperDateSP, SPTax,
       MemberSPID, MemberSP, HelsiID, HelsiIDList, HelsiName, HelsiQty, HelsiProgramId, HelsiProgramName, HelsiPartialPrescription, HelsiSkipDispenseSign, PaperRecipeSP)
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
  Self.FormParams.ParamByName('MemberSP').Value := MemberSP;
  //
  pnlSP.Visible := InvNumberSP <> '';
  lblPartnerMedicalName.Caption:= '  ' + PartnerMedicalName; // + '  /  � ���. ' + Ambulance;
  lblMedicSP.Caption  := '  ' + MedicSP + '  /  � '+InvNumberSP+'  �� ' + DateToStr(OperDateSP);
  if SPTax <> 0 then lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + FloatToStr(SPTax) + '% : ' + SPKindName
  else lblMedicSP.Caption:= lblMedicSP.Caption + ' * ' + SPKindName;

end;

procedure TMainCashForm.actSetVIPExecute(Sender: TObject);
var
  ManagerID:Integer;
  ManagerName,BayerName: String;
  ConfirmedKindName_calc: String;
  UID: String;
begin
  if not VIPDialogExecute(ManagerID,ManagerName,BayerName) then exit;
  //
  FormParams.ParamByName('ManagerId').Value   := ManagerId;
  FormParams.ParamByName('ManagerName').Value := ManagerName;
  FormParams.ParamByName('BayerName').Value   := BayerName;
  if FormParams.ParamByName('ConfirmedKindName').Value = ''
  then FormParams.ParamByName('ConfirmedKindName').Value:= '�����������';
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
              //***02.02.18
              ,FormParams.ParamByName('PromoCodeID').Value

              ,False         // NeedComplete
              ,''            // FiscalCheckNumber
              ,UID           // out AUID
              )
  then begin
    NewCheck(False);
    SaveReal(UID); // ������ 1 �����
  End;
end;

procedure TMainCashForm.actSoldExecute(Sender: TObject);
begin
  SoldRegim:= not SoldRegim;
  ceAmount.Enabled := false;
  lcName.Text := '';
  if isScaner = true
  then ActiveControl := ceScaner
  else ActiveControl := lcName;
end;

procedure TMainCashForm.actSpecExecute(Sender: TObject);
begin
  if Assigned(Cash) then
    Cash.AlwaysSold := actSpec.Checked;
end;

procedure TMainCashForm.actUpdateRemainsExecute(Sender: TObject);
begin
  UpdateRemainsFromDiff(nil);
end;

procedure TMainCashForm.btnCheckClick(Sender: TObject);
begin
  SetBlinkCheck(true);
  //
  if fBlinkCheck = true
  then actOpenCheckVIP_Error.Execute
  else actCheck.Execute;
end;

procedure TMainCashForm.ceAmountExit(Sender: TObject);
begin
  ceAmount.Enabled := false;
  lcName.Text := '';
end;

procedure TMainCashForm.ceAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then
     actInsertUpdateCheckItems.Execute
end;

procedure TMainCashForm.ceScanerKeyPress(Sender: TObject; var Key: Char);
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
           // ��� �/� - �������������
           if zc_BarCodePref_Object <> Copy(ceScaner.Text,1, LengTh(zc_BarCodePref_Object))
           then begin
                 //����� �������
                 str_add:= '(������)';
                 //�����
                 isFind:= RemainsCDS.Locate('BarCode', trim(ceScaner.Text), []);
                 //��� ��������� ��� �����...
                 isFind:= (isFind) and (RemainsCDS.FieldByName('BarCode').AsString = trim(ceScaner.Text));
           end

           // ��� �/� - ��� ID
           else begin
                 //����� �������
                 str_add:= '(���)';

                 // ������� ��������� ��� ID
                 StrToInt(Copy(ceScaner.Text,4, 9));
                 //�����
                 isFind:= RemainsCDS.Locate('GoodsId_main', StrToInt(Copy(ceScaner.Text,4, 9)), []);
                 //��� ��������� ��� �����...
                 isFind:= (isFind) and (RemainsCDS.FieldByName('GoodsId_main').AsInteger = StrToInt(Copy(ceScaner.Text,4, 9)));

                 //���� �� ����� - ��������� �� ���� ������ - ����� ?
                 if not isFind then
                 begin
                   isFind:= RemainsCDS.Locate('BarCode', Trim(ceScaner.Text), []);
                   //��� ��������� ��� �����...
                   isFind:= (isFind) and (Trim(RemainsCDS.FieldByName('BarCode').AsString) = Trim(ceScaner.Text));
                 end;
            end;

            //
            if isFind
            then
               lbScaner.Caption:='������� ' + str_add + ' ' + ceScaner.Text
            else
               lbScaner.Caption:='�� ������� ' + str_add + ' ' + ceScaner.Text;

            // ������ �������
            ceScaner.Text:='';

       except
            lbScaner.Caption:='������ � �/�';
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

procedure TMainCashForm.actCheckConnectionExecute(Sender: TObject);
begin
  try
    spGet_User_IsAdmin.Execute;
    gc_User.Local := False;
    ShowMessage('����� ������: � ����');
  except
    Begin
      gc_User.Local := True;
      ShowMessage('����� ������: ���������');
    End;
  end;
end;

procedure TMainCashForm.CheckCDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if DataSet.FieldByName('List_UID').AsString = '' then
    DataSet.FieldByName('List_UID').AsString := GenerateGUID;
end;

procedure TMainCashForm.ConnectionModeChange(var Msg: TMessage);
begin
  SetWorkMode(gc_User.Local);
end;

procedure TMainCashForm.miMCSAutoClick(Sender: TObject);
begin
  if RemainsCDS.State in dsEditModes then RemainsCDS.Post;
  //
  edDays.Value:=7;
  PanelMCSAuto.Visible:= not PanelMCSAuto.Visible;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName('MCSValue').Index].Options.Editing:= PanelMCSAuto.Visible;
end;

procedure TMainCashForm.miPrintNotFiscalCheckClick(Sender: TObject);
var CheckNumber: string;
begin
  PutCheckToCash(MainCashForm.ASalerCash, MainCashForm.ASalerCashAdd, MainCashForm.PaidType, FiscalNumber, CheckNumber, false);
end;

procedure TMainCashForm.FormCreate(Sender: TObject);
var
  F: String;
begin
  inherited;

  isScaner:= false;
  //
  edDays.Value:=7;
  PanelMCSAuto.Visible:=false;
  MainGridDBTableView.Columns[MainGridDBTableView.GetColumnByFieldName('MCSValue').Index].Options.Editing:= False;
  //���
  // ������� ������� ���� �� �������
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

  //��������� ���� ��� ����������� ������
  ChangeStatus('��������� �������������� ����������');
  FormParams.ParamByName('CashSessionId').Value := GenerateGUID;
  FormParams.ParamByName('ClosedCheckId').Value := 0;
  FormParams.ParamByName('CheckId').Value := 0;
  ShapeState.Brush.Color := clGreen;
  if NOT GetIniFile(F) then
  Begin
    Application.Terminate;
    exit;
  End;
  ChangeStatus('�������� ������� ������������');
  //
  //�������� �����
  //UserSettingsStorageAddOn.LoadUserSettings;
  //
  try
    ChangeStatus('������������� ������������');
    Cash:=TCashFactory.GetCash(iniCashType);

    if (Cash <> nil) AND (Cash.FiscalNumber = '') then
    Begin
      MessageDlg('������ ������������� ��������� ��������. ���������� ������ ��������� ����������.' + #13#10 +
                 '��� ��������� ������� ���� "DATECS FP-320" ' + #13#10 +
                 '���������� ������ ��� �������� ����� � ���� ��������' + #13#10 +
                 '(������ [TSoldWithCompMainForm] �������� "FP320SERIAL")', mtError, [mbOK], 0);

      Application.Terminate;
      exit;
    End;

  except
    Begin
      ShowMessage('��������! ��������� �� ����� ������������ � ����������� ��������.'+#13+
                  '���������� ������ ��������� �������� ������ � ������������ ������!');
    End;
  end;

  ChangeStatus('������������� ���������� ���������');
  if not InitLocalStorage then
  Begin
    Application.Terminate;
    exit;
  End;

  SetWorkMode(gc_User.Local);

  SoldParallel:=iniSoldParallel;
  CheckCDS.CreateDataSet;
  ChangeStatus('���������� ������ ����');
  NewCheck;
  OnCLoseQuery := ParentFormCloseQuery;
  OnShow := ParentFormShow;
  TimerSaveAll.Enabled := true; // ������ 1 �����

  SetBlinkVIP (true);
  SetBlinkCheck (true);
  TimerBlinkBtn.Enabled := true;
end;

function TMainCashForm.InitLocalStorage: Boolean;
begin
  Result := False;

  WaitForSingleObject(MutexDBF, INFINITE);

  try
    Result := InitLocalDataBaseHead(Self, FLocalDataBaseHead) and
      InitLocalDataBaseBody(Self, FLocalDataBaseBody);

    if Result then
    begin
      FLocalDataBaseHead.Active := False;
      FLocalDataBaseBody.Active := False;
    end;
  finally
    ReleaseMutex(MutexDBF);
    if Result then
      SaveRealAll;  // ������ 1 �����
  end;
end;

procedure TMainCashForm.InsertUpdateBillCheckItems;
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
    ShowMessage('�� ������� ���������� ��� �������!');
    exit;
  end;
  if not SoldRegim AND
     (ceAmount.Value < 0) and
     (abs(ceAmount.Value) > abs(CheckCDS.FieldByName('Amount').asFloat)) then
  begin
    ShowMessage('�� ������� ���������� ��� ��������!');
    exit;
  end;
  //
  if SoldRegim = TRUE then
  begin
      if  (Self.FormParams.ParamByName('InvNumberSP').Value <> '')
       and(Self.FormParams.ParamByName('SPTax').Value = 0)
       and(SourceClientDataSet.FieldByName('isSP').asBoolean = FALSE)
      then begin
        ShowMessage('������.��������� ��� ������ �� ��������� � ���.�������!');
        exit;
      end;
      //
      //23.01.2018 - ����� ����� �������  ��������, ����� � ���� ��� ���������� ������ ���� ��-�
      if  (Self.FormParams.ParamByName('InvNumberSP').Value <> '')
       and(CheckCDS.RecordCount >= 1)
      then begin
        ShowMessage('������.� ���� ��� ���.������� ��� ���� <'+IntToStr(CheckCDS.RecordCount)+'> �����.��������� ������ ��� <1>.');
        exit;
      end;
  end;
  //
  // ������ ��� �����, ���� ��������� ���������� ����� + ���� ��� ������
  if SoldRegim = TRUE
  then //��� �������
       begin lGoodsId_bySoldRegim   := SourceClientDataSet.FieldByName('Id').asInteger;
             if (Self.FormParams.ParamByName('SPTax').Value <> 0)
                 and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
             then begin
                       // ���� ��� ������
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
                       // ���� �� ������� - � ��������� SPTax
                       lPrice_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency * (1 - Self.FormParams.ParamByName('SPTax').Value/100);
             end else
             if (SourceClientDataSet.FieldByName('isSP').asBoolean = TRUE)
                 and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
             then begin
                       // ���� ��� ������
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('PriceSaleSP').asCurrency;
                       // ���� �� �������
                       lPrice_bySoldRegim := SourceClientDataSet.FieldByName('PriceSP').asCurrency;
             end else
             if (DiscountServiceForm.gCode = 2) and (Abs(edPrice.Value) > 0.0001) then
             begin
               // ���� ��� ������
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // ���� �� �������
               lPrice_bySoldRegim := edPrice.Value;
             end else
             if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
                 CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, SourceClientDataSet.FieldByName('Id').asInteger)
             then
             begin
               // ���� ��� ������
               lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
               // ���� �� �������
               lPrice_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency * (1 - Self.FormParams.ParamByName('PromoCodeChangePercent').Value/100);
             end
             else begin
                       // ���� ��� ������
                       lPriceSale_bySoldRegim := SourceClientDataSet.FieldByName('Price').asCurrency;
                       // ���� �� ������� � ���� ������ ����� ��
                       lPrice_bySoldRegim := lPriceSale_bySoldRegim;
                  end
       end
  else //��� �������
       begin lGoodsId_bySoldRegim   := CheckCDS.FieldByName('GoodsId').AsInteger;
             if CheckCDS.FieldByName('PriceSale').asCurrency > 0 // !!!�� ���� ������, ��������
             then lPriceSale_bySoldRegim := CheckCDS.FieldByName('PriceSale').asCurrency
             else lPriceSale_bySoldRegim := CheckCDS.FieldByName('Price').asCurrency;
             // ?���� �� ������� � ���� ������ ����� ��?
             lPrice_bySoldRegim:= lPriceSale_bySoldRegim;
       end;
  {
  //��������� "�����" ���-�� - ������� ��� ������� � ������� � � ���� ��������� ��� ���������� "�����" ���-��
  lQuantity := fGetCheckAmountTotal (lGoodsId_bySoldRegim, ceAmount.Value);
  //���� ���������� ������ (���������� �����) ***20.07.16
  if (FormParams.ParamByName('DiscountExternalId').Value > 0)
    and (lQuantity > 0)
  then begin
         // ���� ��� ������
         lPriceSale := lPriceSale_bySoldRegim;
         // ��������� �������� �������
         if not DiscountServiceForm.fGetSale (lMsg, lPrice, lChangePercent, lSummChangePercent
                                            , FormParams.ParamByName('DiscountCardNumber').Value
                                            , FormParams.ParamByName('DiscountExternalId').Value
                                            , lGoodsId_bySoldRegim
                                            , lQuantity // ��� "�����" ���-��
                                            , lPriceSale
                                            , SourceClientDataSet.FieldByName('GoodsCode').asInteger
                                            , SourceClientDataSet.FieldByName('GoodsName').AsString
                                             )
         then if lMsg = ''
              then // �� ������ ����� ��� � �������� ��� ������
              else exit // !!!����� ???� ��� ��� ���������
         else // ��� ������ � �������� ������
  end
  else} begin
         lPrice             := lPrice_bySoldRegim; //lPriceSale_bySoldRegim;
         lPriceSale         := lPriceSale_bySoldRegim;
         if (Self.FormParams.ParamByName('SPTax').Value <> 0)
         and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
         //and(1=0) // �������� - �� ����� ���������
         then begin
                 lChangePercent     := Self.FormParams.ParamByName('SPTax').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim) * 0;
              end
         else if (Self.FormParams.ParamByName('PromoCodeID').Value > 0)
         then begin
                 lChangePercent     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value;
                 lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim);
              end
         else begin
                lChangePercent     := 0;
                lSummChangePercent := (lPriceSale_bySoldRegim - lPrice_bySoldRegim) * 0;
              end;
         // ������� "������" ���������-Item
         //DiscountServiceForm.pSetParamItemNull;
  end; // else ���� ���������� ������ (���������� �����) ***20.07.16
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

      End;
    finally
      CheckCDS.Filtered := True;
      CheckCDS.EnableControls;
    end;
    UpdateRemainsFromCheck(SourceClientDataSet.FieldByName('Id').asInteger,ceAmount.Value, lPriceSale);
    //Update ������� � CDS - �� ���� "�������" �������
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if not SoldRegim AND (ceAmount.Value < 0) then
  Begin
    UpdateRemainsFromCheck(CheckCDS.FieldByName('GoodsId').AsInteger,ceAmount.Value,CheckCDS.FieldByName('PriceSale').asCurrency);
    //Update ������� � CDS - �� ���� "�������" �������
    if FormParams.ParamByName('DiscountExternalId').Value > 0
    then DiscountServiceForm.fUpdateCDS_Discount (CheckCDS, lMsg, FormParams.ParamByName('DiscountExternalId').Value, FormParams.ParamByName('DiscountCardNumber').Value);

    CalcTotalSumm;
  End
  else
  if SoldRegim AND (ceAmount.Value < 0) then
    ShowMessage('��� ������� ����� ��������� ������ ���������� ������ 0!')
  else
  if not SoldRegim AND (ceAmount.Value > 0) then
    ShowMessage('��� �������� ����� ��������� ������ ���������� ������ 0!');
end;

{------------------------------------------------------------------------------}

procedure TMainCashForm.UpdateRemainsFromDiff(ADiffCDS : TClientDataSet);
var
  GoodsId: Integer;
  Amount_find: Currency;
  oldFilter:String;
  oldFiltered:Boolean;
begin
  //���� ��� ����������� - ������ �� ������
  if ADiffCDS = nil then
    ADiffCDS := DiffCDS;
  if ADIffCDS.IsEmpty then
    exit;
  //��������� �������

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
          // ������� ������ ���-�� � �����
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
          {12.10.2016 - ������ �� �������, �.�. � CheckCDS ������ ����� ����������� GoodsId
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
          {12.10.2016 - ������ �� �������, �.�. � CheckCDS ������ ����� ����������� GoodsId
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

procedure TMainCashForm.CalcTotalSumm;
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

procedure TMainCashForm.WM_KEYDOWN(var Msg: TWMKEYDOWN);
begin
  if (Msg.charcode = VK_TAB) and (ActiveControl=lcName) then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm.lcNameEnter(Sender: TObject);
begin
  inherited;
  SourceClientDataSet := nil;
  isScaner:= false;
end;

procedure TMainCashForm.lcNameExit(Sender: TObject);
begin
  inherited;
  if (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then begin
     ActiveControl:=CheckGrid;
     exit
  end;
  if GetKeyState(VK_TAB)<0 then
     ActiveControl:=MainGrid;
end;

procedure TMainCashForm.lcNameKeyDown(Sender: TObject; var Key: Word;
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

procedure TMainCashForm.MainColReservedGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if AText = '0' then
    AText := '';
end;

procedure TMainCashForm.MainGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
 Cnt: integer;
begin

  actSetFilterExecute(nil); // ��������� �������� ��� ������

  if MainGrid.IsFocused then exit;

  Cnt := Sender.ViewInfo.RecordsViewInfo.VisibleCount;
  Sender.Controller.TopRecordIndex := Sender.Controller.FocusedRecordIndex - Round((Cnt+1)/2);


end;

// ��������� ��������� ��������� ��� �������� ������ ����
procedure TMainCashForm.NewCheck(ANeedRemainsRefresh: Boolean = True);
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
  //***02.02.18
  FormParams.ParamByName('PromoCodeID').Value               := 0;
  FormParams.ParamByName('PromoCodeGUID').Value             := '';
  FormParams.ParamByName('PromoName').Value                 := '';
  FormParams.ParamByName('PromoCodeChangePercent').Value    := 0.0;

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
  pnlPromoCode.Visible := false;
  lblPromoName.Caption := '';
  lblPromoCode.Caption := '';
  edPromoCodeChangePrice.Value := 0;
  try
    CheckCDS.EmptyDataSet;
  finally
    CheckCDS.EnableControls;
  end;

  MainCashForm.SoldRegim := true;
  MainCashForm.actSpec.Checked := false;
  if Assigned(MainCashForm.Cash) AND MainCashForm.Cash.AlwaysSold then
    MainCashForm.Cash.AlwaysSold := False;

  if Self.Visible then
  Begin
    if ANeedRemainsRefresh then // ������ 1 �����
      StartRefreshDiffThread;  // ������ 1 �����
  End
  else
  Begin
    actRefreshAllExecute(nil);
  End;
  CalcTotalSumm;
  ceAmount.Value := 0;
  isScaner:=false;
  ActiveControl := lcName;
end;

procedure TMainCashForm.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if not CheckCDS.IsEmpty then
  Begin
    CanClose := False;
    ShowMessage('������� �������� ���.');
  End
  else
    CanClose := MessageDlg('�� ������������� ������ �����?',mtConfirmation,[mbYes,mbCancel], 0) = mrYes;
  while CountRRT>0 do //���� ���� ��������� ��� ������  // ������ 1 �����
    Application.ProcessMessages;  // ������ 1 �����
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
  End;
  //
  //�������� �����
  //UserSettingsStorageAddOn.SaveUserSettings;
  //
end;



procedure TMainCashForm.ParentFormDestroy(Sender: TObject);
begin
  inherited;
 CloseHandle(MutexDBF);
 CloseHandle(MutexDBFDiff);
 CloseHandle(MutexVip);
 CloseHandle(MutexRemains);
 CloseHandle(MutexAlternative);
end;

procedure TMainCashForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
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

procedure TMainCashForm.ParentFormShow(Sender: TObject);
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

// ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
procedure TMainCashForm.Add_Log_XML(AMessage: String);
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

function TMainCashForm.PutCheckToCash(SalerCash, SalerCashAdd: Currency;
  PaidType: TPaidType; out AFiscalNumber, ACheckNumber: String; isFiscal: boolean = true): boolean;
var str_log_xml : String;   Disc: Currency;
    i : Integer;
{------------------------------------------------------------------------------}
  function PutOneRecordToCash: boolean; //������� ������ ������������
  begin
     // �������� ������ � ����� � ���� ��� OK, �� ������ ����� � �������
     if not Assigned(Cash) or Cash.AlwaysSold then
        result := true
     else
       if not SoldParallel then
         with CheckCDS do begin
            result := Cash.SoldFromPC(FieldByName('GoodsCode').asInteger,
                                      AnsiUpperCase(FieldByName('GoodsName').Text),
                                      '',
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
    if Assigned(Cash) AND NOT Cash.AlwaysSold and isFiscal then
      AFiscalNumber := Cash.FiscalNumber
    else
      AFiscalNumber := '';
    str_log_xml:=''; i:=0; Disc:= 0;
    result := not Assigned(Cash) or Cash.AlwaysSold or Cash.OpenReceipt(isFiscal);
    with CheckCDS do
    begin
      First;
      while not EOF do
      begin
        if result then
           begin
             if CheckCDS.FieldByName('Amount').asCurrency >= 0.001 then
              begin
                  //������� ������ � �����
                  result := PutOneRecordToCash;
                  //��������� ������ � ���
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
                  Disc := Disc + (FieldByName('Summ').asCurrency - GetSummFull(FieldByName('Amount').asCurrency, FieldByName('Price').asCurrency));
              end;
           end;
        Next;
      end;
      if Assigned(Cash) AND not Cash.AlwaysSold then
      begin
        if Disc <> 0 then Cash.DiscountGoods(Disc);
        Cash.SubTotal(true, true, 0, 0);
        Cash.TotalSumm(SalerCash - SalerCashAdd, SalerCashAdd, PaidType);
        result := Cash.CloseReceiptEx(ACheckNumber); //������� ���
      end;
    end;
  except
    result := false;
    raise;
  end;
  //
  // ��� � �������� ������ - ������� � ��� ��� - �� ����� �������� ���� ����� ����
  Add_Log_XML('<Head now="'+FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+'">'
     +#10+#13+'<CheckNumber>"'  + ACheckNumber  + '"</CheckNumber>'
             +'<FiscalNumber>"' + AFiscalNumber + '"</FiscalNumber>'
             +'<Summa>"' + FloatToStr(SalerCash) + '"</Summa>'
     +#10+#13+str_log_xml
     +#10+#13+'</Head>'
             );
end;


//��������� "�����" ���-�� - ������� ��� ������� � ������� � � ���� ��������� ��� ���������� "�����" ���-��
function TMainCashForm.fGetCheckAmountTotal(AGoodsId: Integer = 0; AAmount: Currency = 0) : Currency;
var
  GoodsId: Integer;
begin
  Result :=AAmount;
  //���� ����� - ������ �� ������
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;

  //��������� �������
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

procedure TMainCashForm.UpdateRemainsFromCheck(AGoodsId: Integer = 0; AAmount: Currency = 0; APriceSale: Currency = 0);
var
  GoodsId: Integer;
  //lPriceSale : Currency;
begin
  //���� ����� - ������ �� ������
  CheckCDS.DisableControls;
  CheckCDS.filtered := False;
  if CheckCDS.IsEmpty then
  Begin
    CheckCDS.filtered := true;
    CheckCDS.EnableControls;
    exit;
  End;
  //��������� �������
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
        //������� ������� ������, � ������� ����, ������� ��� ��������� ��������� ***20.07.16
        if (FormParams.ParamByName('DiscountExternalId').Value > 0) and (AGoodsId <> 0)
          // �� ���� ������ �������
          and (DiscountServiceForm.gGoodsId = AGoodsId)
          and (DiscountServiceForm.gDiscountExternalId = FormParams.ParamByName('DiscountExternalId').Value)
        then begin
            // �� ���� ������ ������� - ����������� ���� ���� �� ������� ���� ��������
            if DiscountServiceForm.gPrice > 0
            then checkCDS.FieldByName('Price').asCurrency        :=DiscountServiceForm.gPrice;
            checkCDS.FieldByName('ChangePercent').asCurrency     :=DiscountServiceForm.gChangePercent;
            checkCDS.FieldByName('SummChangePercent').asCurrency :=DiscountServiceForm.gSummChangePercent;
        end
        else}
        if (Self.FormParams.ParamByName('SPTax').Value <> 0)
          and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
        then begin
            // �� ���� ������ - ��������� ������ ��� �����
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := RemainsCDS.FieldByName('Price').asCurrency * (1 - Self.FormParams.ParamByName('SPTax').Value/100);
            // � ��������� ������ - � ��������� SPTax
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('SPTax').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * RemainsCDS.FieldByName('Price').asCurrency * (Self.FormParams.ParamByName('SPTax').Value/100);
        end else
        if (RemainsCDS.FieldByName('isSP').asBoolean = TRUE)
          and(Self.FormParams.ParamByName('InvNumberSP').Value <> '')
        then begin
            // �� ���� ������ - ��������� ������ ��� �����
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('PriceSaleSP').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := RemainsCDS.FieldByName('PriceSP').asCurrency;
            // � ��������� ������
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * (RemainsCDS.FieldByName('PriceSaleSP').asCurrency - RemainsCDS.FieldByName('PriceSP').asCurrency);
        end else
        if (DiscountServiceForm.gCode = 2) and (Abs(edPrice.Value) > 0.0001) then
        begin
            // �� ���� ������ - ��������� ������ ��� �����
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := edPrice.Value;
            // � ��������� ������
            checkCDS.FieldByName('ChangePercent').asCurrency     := 0;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency * (RemainsCDS.FieldByName('Price').asCurrency - edPrice.Value);
        end else
        if (Self.FormParams.ParamByName('PromoCodeID').Value > 0) and
           CheckIfGoodsIdInPromo(Self.FormParams.ParamByName('PromoCodeID').Value, SourceClientDataSet.FieldByName('Id').asInteger)
        then
        begin
           // �� ���� ������ - ��������� ������ ��� �����
            checkCDS.FieldByName('PriceSale').asCurrency:= RemainsCDS.FieldByName('Price').asCurrency;
            checkCDS.FieldByName('Price').asCurrency    := RemainsCDS.FieldByName('Price').asCurrency
                                                           * (1 - Self.FormParams.ParamByName('PromoCodeChangePercent').Value/100);
            // � ��������� ������
            checkCDS.FieldByName('ChangePercent').asCurrency     := Self.FormParams.ParamByName('PromoCodeChangePercent').Value;
            checkCDS.FieldByName('SummChangePercent').asCurrency := CheckCDS.FieldByName('Amount').asCurrency
                                                                    * RemainsCDS.FieldByName('Price').asCurrency
                                                                    * (Self.FormParams.ParamByName('PromoCodeChangePercent').Value/100);
        end
        else begin
            // �� ���� ������ ������� - ����������� ���� ���� ��� ������ ���� ��������
            if checkCDS.FieldByName('PriceSale').asCurrency > 0
            then checkCDS.FieldByName('Price').asCurrency        := checkCDS.FieldByName('PriceSale').asCurrency;
            // � ������� ������
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

function TMainCashForm.SaveLocal(ADS :TClientDataSet; AManagerId: Integer; AManagerName: String;
      ABayerName, ABayerPhone, AConfirmedKindName, AInvNumberOrder, AConfirmedKindClientName: String;
      ADiscountExternalId: Integer; ADiscountExternalName, ADiscountCardNumber: String;
      APartnerMedicalId: Integer; APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP : String;
      AOperDateSP : TDateTime;
      ASPKindId: Integer; ASPKindName : String; ASPTax : Currency; APromoCodeID : Integer;
      NeedComplete: Boolean; FiscalCheckNumber: String; out AUID: String): Boolean;
var
  NextVIPId: integer;
  myVIPCDS, myVIPListCDS: TClientDataSet;
  str_log_xml : String;
  i : Integer;
begin
  //���� ��� ��������� � ��� �� �������� - �� ��������� � ������� �����
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
  End;  //���� ��� ��������� � ��� �� �������� - �� ��������� � ������� �����

  //��������� � ���
  WaitForSingleObject(MutexDBF, INFINITE);
  FLocalDataBaseHead.Active:=True;
  FLocalDataBaseBody.Active:=True;
  try
    //��������� ���� ��� ����
    if AUID = '' then
      AUID := GenerateGUID;
    Result := True;
    //��������� �����
    try
      if (FormParams.ParamByName('CheckId').Value = 0) or
         not FLocalDataBaseHead.Locate('ID',FormParams.ParamByName('CheckId').Value,[]) then
      Begin
        FLocalDataBaseHead.AddRecord(VarArrayOf([FormParams.ParamByName('CheckId').Value, //id ����
                                         AUID,                                    //uid ����
                                         Now,                                     //����/����� ����
                                         Integer(PaidType),                       //��� ������
                                         FiscalNumber,                            //�������� ��������
                                         AManagerId,                              //Id ��������� (VIP)
                                         ABayerName,                              //���������� (VIP)
                                         False,                                   //���������� �� ���������� ������������
                                         False,                                   //�������� � �������� ���� ������
                                         NeedComplete,                            //���������� ����������
                                         chbNotMCS.Checked,                       //�� ��������� � ������� ���
                                         FiscalCheckNumber,                       //����� ����������� ����
                                         //***20.07.16
                                         ADiscountExternalId,      //Id ������� ���������� ����
                                         ADiscountExternalName,    //�������� ������� ���������� ����
                                         ADiscountCardNumber,      //� ���������� �����
                                         //***20.07.16
                                         ABayerPhone,              //���������� ������� (����������) - BayerPhone
                                         AConfirmedKindName,       //������ ������ (��������� VIP-����) - ConfirmedKind
                                         AInvNumberOrder,          //����� ������ (� �����) - InvNumberOrder
                                         AConfirmedKindClientName, //������ ������ (��������� VIP-����) - ConfirmedKindClient
                                         //***24.01.17
                                         gc_User.Session,          //��� ������� - �������� ����� ��� �������
                                         //***08.04.17
                                         APartnerMedicalId,        //Id ����������� ����������(���. ������)
                                         APartnerMedicalName,      //�������� ����������� ����������(���. ������)
                                         AAmbulance,               //� ����������� (���. ������)
                                         AMedicSP,                 //��� ����� (���. ������)
                                         AInvNumberSP,             //����� ������� (���. ������)
                                         AOperDateSP,              //���� ������� (���. ������)
                                         //***15.06.17
                                         ASPKindId,                 //Id ��� ��
                                         //***02.02.18
                                         APromoCodeID               //Id ���������
                                        ]));
      End
      else
      Begin
        AUID := FLocalDataBaseHead.FieldByName('UID').Value;//uid ����
        FLocalDataBaseHead.Edit;
        FLocalDataBaseHead.FieldByName('PAIDTYPE').Value := Integer(PaidType); //��� ������
        FLocalDataBaseHead.FieldByName('CASH').Value := FiscalNumber; //�������� ��������
        FLocalDataBaseHead.FieldByName('MANAGER').Value := AManagerId; //Id ��������� (VIP)
        FLocalDataBaseHead.FieldByName('BAYER').Value := ABayerName; //���������� (VIP)
        FLocalDataBaseHead.FieldByName('SAVE').Value := False; //���������� (VIP)
        FLocalDataBaseHead.FieldByName('COMPL').Value := False; //���������� (VIP)
        FLocalDataBaseHead.FieldByName('NEEDCOMPL').Value := NeedComplete; //����� �������� ��������
        FLocalDataBaseHead.FieldByName('NOTMCS').Value := chbNotMCS.Checked; //�� ��������� � ������� ���
        FLocalDataBaseHead.FieldByName('FISCID').Value := FiscalCheckNumber; //����� ����������� ����
        //***20.07.16
        FLocalDataBaseHead.FieldByName('DISCOUNTID').Value := ADiscountExternalId;   //Id ������� ���������� ����
        FLocalDataBaseHead.FieldByName('DISCOUNTN').Value  := ADiscountExternalName; //�������� ������� ���������� ����
        FLocalDataBaseHead.FieldByName('DISCOUNT').Value   := ADiscountCardNumber;   //� ���������� �����
        //***16.08.16
        FLocalDataBaseHead.FieldByName('BAYERPHONE').Value := ABayerPhone;              //���������� ������� (����������) - BayerPhone
        FLocalDataBaseHead.FieldByName('CONFIRMED').Value  := AConfirmedKindName;       //������ ������ (��������� VIP-����) - ConfirmedKind
        FLocalDataBaseHead.FieldByName('NUMORDER').Value   := AInvNumberOrder;          //����� ������ (� �����) - InvNumberOrder
        FLocalDataBaseHead.FieldByName('CONFIRMEDC').Value := AConfirmedKindClientName; //������ ������ (��������� VIP-����) - ConfirmedKindClient
        //***24.01.17
        FLocalDataBaseHead.FieldByName('USERSESION').Value := gc_User.Session;  //��� ������� - �������� ����� ��� �������
        //***08.04.17
        FLocalDataBaseHead.FieldByName('PMEDICALID').Value := APartnerMedicalId;   //Id ����������� ����������(���. ������)
        FLocalDataBaseHead.FieldByName('PMEDICALN').Value  := APartnerMedicalName; //�������� ����������� ����������(���. ������)
        FLocalDataBaseHead.FieldByName('AMBULANCE').Value  := AAmbulance;          //� ����������� (���. ������)
        FLocalDataBaseHead.FieldByName('MEDICSP').Value    := AMedicSP;            //��� ����� (���. ������)
        FLocalDataBaseHead.FieldByName('INVNUMSP').Value   := AInvNumberSP;        //����� ������� (���. ������)
        FLocalDataBaseHead.FieldByName('OPERDATESP').Value := AOperDateSP;         //���� ������� (���. ������)
        //***15.06.17
        FLocalDataBaseHead.FieldByName('SPKINDID').Value   := ASPKindId;  //Id ��� ��
        //***02.02.18
        FLocalDataBaseHead.FieldByName('PROMOCODE').Value  := APromoCodeID;  //Id ���������


        FLocalDataBaseHead.Post;
      End;
    except ON E:Exception do
      Begin
        // ��� � �������� ������ - ������� � ���
        Add_Log_XML('<Head err="'+E.Message+'">');

        Application.OnException(Application.MainForm,E);
//        ShowMessage('������ ���������� ���������� ����: '+E.Message);
        result := False;
        exit;
      End;
    end; //��������� �����

    //��������� ����
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
          FLocalDataBaseBody.AppendRecord([ADS.FieldByName('Id').AsInteger,         //id ������
                                           AUID,                                    //uid ����
                                           ADS.FieldByName('GoodsId').AsInteger,    //�� ������
                                           ADS.FieldByName('GoodsCode').AsInteger,  //��� ������
                                           ADS.FieldByName('GoodsName').AsString,   //������������ ������
                                           ADS.FieldByName('NDS').asCurrency,          //��� ������
                                           ADS.FieldByName('Amount').asCurrency,       //���-��
                                           ADS.FieldByName('Price').asCurrency,        //����, � 20.07.16 ���� ���� ������ �� ������� ��������, ����� ����� ���� � ������ ������
                                           //***20.07.16
                                           ADS.FieldByName('PriceSale').asCurrency,         // ���� ��� ������
                                           ADS.FieldByName('ChangePercent').asCurrency,     // % ������
                                           ADS.FieldByName('SummChangePercent').asCurrency, // ����� ������
                                           //***19.08.16
                                           ADS.FieldByName('AmountOrder').asCurrency, // ���-�� ������
                                           //***10.08.16
                                           ADS.FieldByName('List_UID').AsString // UID ������ �������
                                           ]);
                  //��������� ������ � ���
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
        // ��� � �������� ������ - ������� � ���
        Add_Log_XML('<Body err="'+E.Message+'">');

        Application.OnException(Application.MainForm,E);
//          ShowMessage('������ ���������� ���������� ����������� ����: '+E.Message);
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

  end;

  // ��� � �������� ������ - ������� � ��� ��� - �� ����� ���������� ����, �.�. ����� �������� ����� ����
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

procedure TMainCashForm.SaveLocalVIP;
var
  sp : TdsdStoredProc;
  ds : TClientDataSet;
begin
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
      SaveLocalData(ds,Member_lcl);

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

procedure TMainCashForm.SaveReal(AUID: String; ANeedComplete: boolean = False); // ������ 1 �����
Begin
  With TSaveRealThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    FCheckUID := AUID;
    Start;
  End;
End;

procedure TMainCashForm.SaveRealAll; // ������ 1 �����
begin
  With TSaveRealAllThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    Start;
  End;
end;

procedure TMainCashForm.StartRefreshDiffThread; // ������ 1 �����
Begin
  With TRefreshDiffThread.Create(true) do
  Begin
    FreeOnTerminate := true;
    Start;
  End;
End;

procedure TMainCashForm.SetSoldRegim(const Value: boolean);
begin
  FSoldRegim := Value;
  if SoldRegim then begin
     actSold.Caption := '�������';
     ceAmount.Value := 1;
  end
  else begin
     actSold.Caption := '�������';
     ceAmount.Value := -1;
  end;
end;

procedure TMainCashForm.SetWorkMode(ALocal: Boolean);
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

procedure TMainCashForm.Thread_Exception(var Msg: TMessage);
var
  spUserProtocol : TdsdStoredProc;
begin
  // ��������� ������ ��� MainCash, � ����� MainCash2 ���������� ������ - ��������
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
//  ShowMessage('�� ����� ���������� ���� �������� ������:'+#13+
//              ThreadErrorMessage+#13#13+
//              '��������� ��������� ���� �, ��� �������������, ��������� ��� �������.');
end;


procedure TMainCashForm.TimerBlinkBtnTimer(Sender: TObject);
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

procedure TMainCashForm.SetBlinkVIP (isRefresh : boolean);
var lMovementId_BlinkVIP : String;
begin
  // ���� ������ > 100 ��� - �����������
  if ((now - time_onBlink) > 0.002) or(isRefresh = true) then

  try
      //��������� ����� "���������" ��������� ���� ���������� - � ����� "�� �����������"
      time_onBlink:= now;

      //�������� ������ ���� ���������� - � ����� "�� �����������"
      spGet_BlinkVIP.Execute;
      lMovementId_BlinkVIP:=spGet_BlinkVIP.ParamByName('outMovementId_list').Value;

      // � ���� ������ ������ ����� ������
      fBlinkVIP:= lMovementId_BlinkVIP <> '';

      // ���� ���� �����, ������ ON-line ����� ����� ��� VIP-�����
      Self.Caption := '������� ('+GetFileVersionString(ParamStr(0))+')' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>';

      //���� ������ ��������� ��� ���� "�� ������ ��������" - �������� "�� ����� ������" ���������� �����
      if (lMovementId_BlinkVIP <> MovementId_BlinkVIP) or(isRefresh = true)
      then begin
                // ��������� ������ ���� ���������� - � ����� "�� �����������"
                MovementId_BlinkVIP:= lMovementId_BlinkVIP;
                // "�� ����� ������" ���������� �����
                StartRefreshDiffThread; // ������ 1 �����
      end;

  except
        Self.Caption := '������� ('+GetFileVersionString(ParamStr(0))+') - OFF-line ����� ��� VIP-�����' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
  end;
end;

procedure TMainCashForm.SetBlinkCheck (isRefresh : boolean);
var lMovementId_BlinkCheck : String;
begin
  // ���� ������ > 50 ��� - �����������
  if ((now - time_onBlinkCheck) > 0.003) or(isRefresh = true) then

  try
      //��������� ����� "���������" ��������� ���� ���������� - � "������ - ����/���� �������"
      time_onBlinkCheck:= now;

      //�������� ������ ���� ���������� - � ����� "�� �����������"
      spGet_BlinkCheck.Execute;
      lMovementId_BlinkCheck:=spGet_BlinkCheck.ParamByName('outMovementId_list').Value;

      // � ���� ������ ������ ����� ������
      fBlinkCheck:= lMovementId_BlinkCheck <> '';

      // ���� ���� �����, ������ ON-line ����� ����� ��� �������� "������ - ����/���� �������"
      if fBlinkCheck = True
      then Self.Caption := '������� ('+GetFileVersionString(ParamStr(0))+') : ���� ������ - ����/���� �������' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
      else Self.Caption := '������� ('+GetFileVersionString(ParamStr(0))+')' + ' <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>';

  except
        Self.Caption := '������� ('+GetFileVersionString(ParamStr(0))+') - OFF-line ����� ��� ����� � �������' + ' - <' + IniUtils.gUnitName + '>' + ' - <' + IniUtils.gUserName + '>'
  end;
end;


procedure TMainCashForm.pGet_OldSP(var APartnerMedicalId: Integer; var APartnerMedicalName, AMedicSP: String; var AOperDateSP : TDateTime);
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

function TMainCashForm.pCheck_InvNumberSP(ASPKind : integer; ANumber : string) : boolean;
begin

 Result := False;
//
 try
     WaitForSingleObject(MutexDBF, INFINITE);
     try
       FLocalDataBaseHead.Active:=True;
       FLocalDataBaseHead.First;
       while not FLocalDataBaseHead.EOF do
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
       FLocalDataBaseBody.Active:=False;
       ReleaseMutex(MutexDBF);
     end;
     //
  except
  end;

end;

procedure TMainCashForm.TimerSaveAllTimer(Sender: TObject);
var fEmpt  : Boolean;
    RCount : Integer;
begin
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
     //����� �������� ��� ����� � ����� ���� + ������� ����� ��� �� �����������
     try spUpdate_UnitForFarmacyCash.ParamByName('inAmount').Value:= RCount;
         spUpdate_UnitForFarmacyCash.Execute;
     except end;
     //
     //��� �������� ����, ���� ��� ����
     if not fEmpt then  // ������ 1 �����
       SaveRealAll;  // ������ 1 �����

 finally
    TimerSaveAll.Enabled:=True;
 end;

end;

{ TSaveRealThread }
// TSaveRealThread ���������������� � ������ 2 � ����������� �������
procedure TSaveRealThread.Execute;
var
  Head: THeadRecord;
  Body: TBodyArr;
  Find: Boolean;
  dsdSave: TdsdStoredProc;
  I: Integer;
  Trd:  TRefreshDiffThread;
  fError_isComplete: Boolean;
begin
  inherited;
  if gc_User.Local then exit;
  EnterCriticalSection(csCriticalSection_Save);
  try
    CoInitialize(nil);
    SetShapeState(clRed);
    try
      Find := False;
      InterlockedIncrement(CountRRT);
      InterlockedIncrement(CountSaveThread);
      try

         WaitForSingleObject(MutexDBF, INFINITE);

         FLocalDataBaseHead.Active:=True;
         FLocalDataBaseBody.Active:=True;
        try
          if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
             not FLocalDataBaseHead.Deleted then
          Begin
            Find := True;
            With Head, FLocalDataBaseHead do
            Begin
              ID       := FieldByName('ID').AsInteger;
              UID      := FieldByName('UID').AsString;
              DATE     := FieldByName('DATE').asCurrency;
              CASH     := trim(FieldByName('CASH').AsString);
              PAIDTYPE := FieldByName('PAIDTYPE').AsInteger;
              MANAGER  := FieldByName('MANAGER').AsInteger;
              BAYER    := trim(FieldByName('BAYER').AsString);
              COMPL    := FieldByName('COMPL').AsBoolean;
              NEEDCOMPL:= FieldByName('NEEDCOMPL').AsBoolean;
              SAVE     := FieldByName('SAVE').AsBoolean;
              FISCID   := trim(FieldByName('FISCID').AsString);
              NOTMCS   := FieldByName('NOTMCS').AsBoolean;
              //***20.07.16
              DISCOUNTID := FieldByName('DISCOUNTID').AsInteger;
              DISCOUNTN  := trim(FieldByName('DISCOUNTN').AsString);
              DISCOUNT   := trim(FieldByName('DISCOUNT').AsString);
              //***16.08.16
              BAYERPHONE := trim(FieldByName('BAYERPHONE').AsString);
              CONFIRMED  := trim(FieldByName('CONFIRMED').AsString);
              NUMORDER   := trim(FieldByName('NUMORDER').AsString);
              CONFIRMEDC := trim(FieldByName('CONFIRMEDC').AsString);
              //***24.01.17
              USERSESION := trim(FieldByName('USERSESION').AsString);
              //***08.04.17
              PMEDICALID := FieldByName('PMEDICALID').AsInteger;
              PMEDICALN  := trim(FieldByName('PMEDICALN').AsString);
              AMBULANCE  := trim(FieldByName('AMBULANCE').AsString);
              MEDICSP    := trim(FieldByName('MEDICSP').AsString);
              INVNUMSP   := trim(FieldByName('INVNUMSP').AsString);
              OPERDATESP := FieldByName('OPERDATESP').asCurrency;
              //***15.06.17
              SPKINDID := FieldByName('SPKINDID').AsInteger;
              //***02.02.18
              PROMOCODE:= FieldByName('PROMOCODE').AsInteger;

              FNeedSaveVIP := (MANAGER <> 0);
            end;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.Eof do
            Begin
              if (Trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                 not FLocalDataBaseBody.Deleted  then
              Begin
                SetLength(Body,Length(Body)+1);
                with Body[Length(Body)-1],FLocalDataBaseBody  do
                Begin
                  CH_UID    := trim(FieldByName('CH_UID').AsString);
                  GOODSID   := FieldByName('GOODSID').AsInteger;
                  GOODSCODE := FieldByName('GOODSCODE').AsInteger;
                  GOODSNAME := trim(FieldByName('GOODSNAME').AsString);
                  NDS       := FieldByName('NDS').asCurrency;
                  AMOUNT    := FieldByName('AMOUNT').asCurrency;
                  PRICE     := FieldByName('PRICE').asCurrency;
                  //***20.07.16
                  PRICESALE := FieldByName('PRICESALE').asCurrency;
                  CHPERCENT := FieldByName('CHPERCENT').asCurrency;
                  SUMMCH    := FieldByName('SUMMCH').asCurrency;
                  //***19.08.16
                  AMOUNTORD := FieldByName('AMOUNTORD').asCurrency;
                  //***10.08.16
                  LIST_UID  := trim(FieldByName('LIST_UID').asString);
                End;
              End;
              FLocalDataBaseBody.Next;
            End;
          End;
        finally
          FLocalDataBaseHead.Active:=False;
          FLocalDataBaseBody.Active:=False;
          ReleaseMutex(MutexDBF);

        end; // ��������� ��� � head and body

        //�.�. ��� ����� ����� ������� �� ���
        fError_isComplete:= FALSE; // 04.02.2017

        if Find AND NOT HEAD.SAVE then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            try
              //��������� � ����� ��������� ��������.
              dsdSave.StoredProcName := 'gpGet_Movement_CheckState';
              dsdSave.OutputType := otResult;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('outState',ftInteger,ptOutput,Null);
              dsdSave.Execute(False,False);
              if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '2' then //��������
              Begin
                Head.SAVE := True;
                Head.NEEDCOMPL := False;

                //�.�. ��� ������ ����� ������� �� ���
                fError_isComplete:= TRUE; // 04.02.2017
              End
              else
              //���� �� ��������
              Begin
                if VarToStr(dsdSave.Params.ParamByName('outState').Value) = '3' then //������
                Begin
                  dsdSave.StoredProcName := 'gpUnComplete_Movement_Check';
                  dsdSave.OutputType := otResult;
                  dsdSave.Params.Clear;
                  dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
                  dsdSave.Execute(False,False);
                end;
                //�������� �����
                dsdSave.StoredProcName := 'gpInsertUpdate_Movement_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId',ftInteger,ptInputOutput,Head.ID);
                dsdSave.Params.AddParam('inDate',ftDateTime,ptInput,Head.DATE);
                dsdSave.Params.AddParam('inCashRegister',ftString,ptInput,Head.CASH);
                dsdSave.Params.AddParam('inPaidType',ftInteger,ptInput,Head.PAIDTYPE);
                dsdSave.Params.AddParam('inManagerId',ftInteger,ptInput,Head.MANAGER);
                dsdSave.Params.AddParam('inBayer',ftString,ptInput,Head.BAYER);
                dsdSave.Params.AddParam('inFiscalCheckNumber',ftString,ptInput,Head.FISCID);
                dsdSave.Params.AddParam('inNotMCS',ftBoolean,ptInput,Head.NOTMCS);
                //***20.07.16
                dsdSave.Params.AddParam('inDiscountExternalId',ftInteger,ptInput,Head.DISCOUNTID);
                dsdSave.Params.AddParam('inDiscountCardNumber',ftString,ptInput,Head.DISCOUNT);
                //***16.08.16
                dsdSave.Params.AddParam('inBayerPhone',       ftString,ptInput,Head.BAYERPHONE);
                dsdSave.Params.AddParam('inConfirmedKindName',ftString,ptInput,Head.CONFIRMED);
                dsdSave.Params.AddParam('inInvNumberOrder',   ftString,ptInput,Head.NUMORDER);
                //***08.04.17
                dsdSave.Params.AddParam('inPartnerMedicalId',ftInteger,ptInput,Head.PMEDICALID);
                dsdSave.Params.AddParam('inAmbulance', ftString, ptInput, Head.AMBULANCE);
                dsdSave.Params.AddParam('inMedicSP', ftString, ptInput, Head.MEDICSP);
                dsdSave.Params.AddParam('inInvNumberSP', ftString, ptInput, Head.INVNUMSP);
                dsdSave.Params.AddParam('inOperDateSP', ftDateTime, ptInput, Head.OPERDATESP);
                //***15.06.17
                dsdSave.Params.AddParam('inSPKindId',ftInteger,ptInput,Head.SPKINDID);
                //***02.02.18
                dsdSave.Params.AddParam('inPromoCodeId',ftInteger,ptInput,Head.PROMOCODE);
                //***24.01.17
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                dsdSave.Execute(False,False);
                SetShapeState(clBlack);
                //��������� � ��������� ���� ���������� �����
                if Head.ID <> StrToInt(dsdSave.Params.ParamByName('ioID').AsString) then
                Begin
                  Head.ID := StrToInt(dsdSave.Params.ParamByName('ioID').AsString);
                  WaitForSingleObject(MutexDBF, INFINITE);
                  SetShapeState(clRed);
                  FLocalDataBaseHead.Active:=True;
                  try
                    if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                       not FLocalDataBaseHead.Deleted then
                    Begin
                      FLocalDataBaseHead.Edit;
                      FLocalDataBaseHead.FieldByname('ID').AsInteger := Head.ID;
                      FLocalDataBaseHead.Post;
                    End;
                  finally
                   FLocalDataBaseHead.Active:=False;
                   ReleaseMutex(MutexDBF);

                  end;
                end;

                //�������� ����
                dsdSave.StoredProcName := 'gpInsertUpdate_MovementItem_Check_ver2';
                dsdSave.OutputType := otResult;
                dsdSave.Params.Clear;
                dsdSave.Params.AddParam('ioId',ftInteger,ptInputOutput,Null);
                dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
                dsdSave.Params.AddParam('inGoodsId',ftInteger,ptInput,Null);
                dsdSave.Params.AddParam('inAmount',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inPrice',ftFloat,ptInput,Null);
                //***20.07.16
                dsdSave.Params.AddParam('inPriceSale',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inChangePercent',ftFloat,ptInput,Null);
                dsdSave.Params.AddParam('inSummChangePercent',ftFloat,ptInput,Null);
                //***19.08.16
                //dsdSave.Params.AddParam('inAmountOrder',ftFloat,ptInput,Null);
                //***10.08.16
                dsdSave.Params.AddParam('inList_UID',ftString,ptInput,Null);
                //
                dsdSave.Params.AddParam('inUserSession', ftString, ptInput, Head.USERSESION);

                for I := 0 to Length(Body)-1 do
                Begin
                  dsdSave.ParamByName('ioId').Value := Body[I].ID;
                  dsdSave.ParamByName('inGoodsId').Value := Body[I].GOODSID;
                  dsdSave.ParamByName('inAmount').Value := Body[I].AMOUNT;
                  dsdSave.ParamByName('inPrice').Value :=  Body[I].PRICE;
                  //***20.07.16
                  dsdSave.ParamByName('inPriceSale').Value :=  Body[I].PRICESALE;
                  dsdSave.ParamByName('inChangePercent').Value :=  Body[I].CHPERCENT;
                  dsdSave.ParamByName('inSummChangePercent').Value :=  Body[I].SUMMCH;
                  //***19.08.16
                  //dsdSave.ParamByName('inAmountOrder').Value :=  Body[I].AMOUNTORD;
                  //***10.08.16
                  dsdSave.ParamByName('inList_UID').Value :=  Body[I].LIST_UID;

                  dsdSave.Execute(False,False);
                  if Body[I].ID <> StrToInt(dsdSave.ParamByName('ioId').AsString) then
                  Begin
                    Body[I].ID := StrToInt(dsdSave.ParamByName('ioId').AsString);
                     WaitForSingleObject(MutexDBF, INFINITE);

                     FLocalDataBaseBody.Active:=True;
                    try
                      FLocalDataBaseBody.First;
                      while not FLocalDataBaseBody.eof do
                      Begin
                        if (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID)
                           AND
                           not FLocalDataBaseBody.Deleted
                           AND
                           (FLocalDataBaseBody.FieldByName('GOODSID').AsInteger = Body[I].GOODSID) then
                        Begin
                          FLocalDataBaseBody.Edit;
                          FLocalDataBaseBody.FieldByname('ID').AsInteger := Body[I].ID;
                          FLocalDataBaseBody.Post;
                          break;
                        End;
                        FLocalDataBaseBody.Next;
                      End;
                    finally
                     FLocalDataBaseBody.Active:=False;
                     ReleaseMutex(MutexDBF);

                    end;
                  End;
                End;
                SetShapeState(clBlue);
                Head.SAVE := True;
                WaitForSingleObject(MutexDBF, INFINITE);

                FLocalDataBaseHead.Active:=True;
                try
                  if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                     not FLocalDataBaseHead.Deleted then
                  Begin
                    FLocalDataBaseHead.Edit;
                    FLocalDataBaseHead.FieldByname('SAVE').AsBoolean := True;
                    FLocalDataBaseHead.Post;
                  End;
                finally
                  FLocalDataBaseHead.Active:=False;
                  ReleaseMutex(MutexDBF);

                end;
              End;
            except ON E: Exception do
              Begin
                SendError(E.Message);
              End;
            end;
          finally
            freeAndNil(dsdSave);
          end;
        end;
        //���� ���������� �������� ���
        if find AND Head.SAVE AND Head.NEEDCOMPL then
        Begin
          dsdSave := TdsdStoredProc.Create(nil);
          try
            DiffCDS := TClientDataSet.Create(nil);
            try
              dsdSave.StoredProcName := 'gpComplete_Movement_Check_ver2';
              dsdSave.OutputType := otDataSet;
              dsdSave.DataSet := DiffCDS;
              dsdSave.Params.Clear;
              dsdSave.Params.AddParam('inMovementId',ftInteger,ptInput,Head.ID);
              dsdSave.Params.AddParam('inPaidType',ftInteger,ptInput,Head.PAIDTYPE);
              dsdSave.Params.AddParam('inCashRegister',ftString,ptInput,Head.CASH);
              dsdSave.Params.AddParam('inCashSessionId',ftString,ptInput,MainCashForm.FormParams.ParamByName('CashSessionId').Value);
              dsdSave.Params.AddParam('inUserSession', ftString,ptInput, Head.USERSESION);
              try
                dsdSave.Execute(False,False);
                Head.COMPL := True;
              except on E: Exception do
                Begin
                  SendError(E.Message);
                End;
              end;
              SetShapeState(clYellow);
              Synchronize(UpdateRemains);
              SetShapeState(clWhite);
            finally
              DiffCDS.free;
            end;
          finally
            freeAndNil(dsdSave);
          end;
          //������� ����������� ��� - ���� ����� ... 04.02.2017
          if Head.COMPL AND (fError_isComplete = FALSE)
          then Begin
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active:=True;
            FLocalDataBaseBody.Active:=True;
            try
              if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
                 not FLocalDataBaseHead.Deleted then
                FLocalDataBaseHead.DeleteRecord;
              FLocalDataBaseBody.First;
              while not FLocalDataBaseBody.eof do
              Begin
                IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                    not FLocalDataBaseBody.Deleted then
                  FLocalDataBaseBody.DeleteRecord;
                FLocalDataBaseBody.Next;
              End;
              FLocalDataBaseHead.Pack;
              FLocalDataBaseBody.Pack;
            finally
             FLocalDataBaseHead.Active:=False;
             FLocalDataBaseBody.Active:=False;
             ReleaseMutex(MutexDBF);
            end;
          End;
        end
        //���� ��������� �� ����� � ���� ����� ... 04.02.2017
        ELSE
        if find and Head.SAVE and (fError_isComplete = FALSE)
        then BEGIN
          if (Head.MANAGER <> 0) or (Head.BAYER <> '') then
          Begin
           //����
//            With TRefreshDiffThread.Create(true) do
//            Begin
//              { TODO -oufomaster : �������� ���� ����� �������� head.usersesion ����� ���� ������ � �� ����� ��������� � ������ �� ������ }
//              FreeOnTerminate := true;
//              Start;
//            End;

            //�����
            trd:= TRefreshDiffThread.Create(true);
            try
            Trd.FUserSession := Head.USERSESION;
            Trd.Execute;
            finally
            Trd.Free;
            end;

          end;
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active:=True;
            FLocalDataBaseBody.Active:=True;
          try
            if FLocalDataBaseHead.Locate('UID',FCheckUID,[loPartialKey]) AND
               not FLocalDataBaseHead.Deleted then
              FLocalDataBaseHead.DeleteRecord;
            FLocalDataBaseBody.First;
            while not FLocalDataBaseBody.eof do
            Begin
              IF (trim(FLocalDataBaseBody.FieldByName('CH_UID').AsString) = FCheckUID) AND
                  not FLocalDataBaseBody.Deleted then
                FLocalDataBaseBody.DeleteRecord;
              FLocalDataBaseBody.Next;
            End;
            FLocalDataBaseHead.Pack;
            FLocalDataBaseBody.Pack;
          finally
           FLocalDataBaseHead.Active:=False;
           FLocalDataBaseBody.Active:=False;
           ReleaseMutex(MutexDBF);
          end;
        End;
      finally
        InterlockedDecrement(CountRRT);
        InterlockedDecrement(CountSaveThread);
      end;
    finally
      CoUninitialize;
    end;
  finally
    LeaveCriticalSection(csCriticalSection_Save);
  end;
end;



procedure TSaveRealThread.SendError(const AErrorMessage: String); // ������ 1 �����
begin
  FLastError := AErrorMessage;
  Synchronize(SendErrorMineForm);
end;

procedure  TSaveRealThread.SendErrorMineForm; // ������ 1 �����
begin
  MainCashForm.ThreadErrorMessage := FLastError;
  PostMessage(MainCashForm.Handle,UM_THREAD_EXCEPTION,0,0);
end;

procedure TSaveRealThread.SetShapeState(AColor: TColor); // ������ 1 �����
begin
  FShapeColor := AColor;
  Synchronize(SyncShapeState);
end;

procedure TSaveRealThread.SyncShapeState; // ������ 1 �����
begin
  MainCashForm.ShapeState.Pen.Color := FShapeColor;
end;

procedure TSaveRealThread.UpdateRemains; // ������ 1 �����

begin
  MainCashForm.UpdateRemainsFromDiff(DiffCDS);
  SaveLocalData(MainCashForm.RemainsCDS,Remains_lcl);
  SaveLocalData(MainCashForm.AlternativeCDS,Alternative_lcl);
  if FNeedSaveVIP then
    MainCashForm.SaveLocalVIP;
end;

{ TRefreshDiffThread }

procedure TRefreshDiffThread.Execute;
begin
  inherited;
  if gc_User.Local then exit;

  CoInitialize(nil);
  try
    InterlockedIncrement(CountRRT);
    try
      EnterCriticalSection(csCriticalSection);
      try
        SetShapeState(clRed);
        MainCashForm.spSelect_CashRemains_Diff.Execute(False,False,False);
        SetShapeState(clBlue);
        Synchronize(UpdateRemains);
        SetShapeState(clWhite);
      finally
        LeaveCriticalSection(csCriticalSection);
      end;
    finally
      InterlockedDecrement(CountRRT);
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TRefreshDiffThread.SetShapeState(AColor: TColor);
begin
  FShapeColor := AColor;
  Synchronize(SyncShapeState);
end;

procedure TRefreshDiffThread.SyncShapeState;
begin
  MainCashForm.ShapeState.Pen.Color := FShapeColor;
end;

procedure TRefreshDiffThread.UpdateRemains;
begin
  MainCashForm.UpdateRemainsFromDiff(nil);
end;

{ TSaveRealAllThread }

procedure TSaveRealAllThread.Execute;
var
  I: Integer;
  UID: String;
  T:TSaveRealThread;
begin
  inherited;
  if gc_User.Local then exit;

  if CountSaveThread > 0 then exit;
  
  InterlockedIncrement(CountRRT);
  try
    EnterCriticalSection(csCriticalSection_All);
    try
      for I := 0 to 6 do
      Begin
       WaitForSingleObject(MutexDBF, INFINITE);
       FLocalDataBaseHead.Active:=True;
       FLocalDataBaseBody.Active:=True;
        try
          FLocalDataBaseHead.Pack;
          FLocalDataBaseBody.Pack;
          FLocalDataBaseHead.First;
          UID := '';
          while not FLocalDataBaseHead.eof do
          Begin
            if not FLocalDataBaseHead.Deleted then
            Begin
              UID := trim(FLocalDataBaseHead.FieldByName('UID').AsString);
              break;
            End;
            FLocalDataBaseHead.Next;
          End;
        finally
         FLocalDataBaseBody.Active:=False;
         FLocalDataBaseHead.Active:=False;
         ReleaseMutex(MutexDBF);

        end;
        if UID <> '' then
        Begin
          T := TSaveRealThread.create(true);
          try
            T.FCheckUID := UID;
            T.Execute;
          finally
            T.Free;
            
            WaitForSingleObject(MutexDBF, INFINITE);
            FLocalDataBaseHead.Active:=True;
            FLocalDataBaseHead.First;
            FLocalDataBaseHead.Active:=False;
            ReleaseMutex(MutexDBF);
          end;
        End;
      End;
    finally
      LeaveCriticalSection(csCriticalSection_All);
    end;
  finally
    InterlockedDecrement(CountRRT);
  end;
end;

initialization
  RegisterClass(TMainCashForm);
  FLocalDataBaseHead := TVKSmartDBF.Create(nil);
  FLocalDataBaseBody := TVKSmartDBF.Create(nil);
  InitializeCriticalSection(csCriticalSection);
  InitializeCriticalSection(csCriticalSection_Save);
  InitializeCriticalSection(csCriticalSection_All);
finalization
  FLocalDataBaseHead.Free;
  FLocalDataBaseBody.Free;
  DeleteCriticalSection(csCriticalSection);
  DeleteCriticalSection(csCriticalSection_Save);
  DeleteCriticalSection(csCriticalSection_All);
end.
