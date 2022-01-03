unit Send;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxBarBuiltInMenu,
  cxNavigator, cxCalc, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxSplitter;

type
  TSendForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    actUnitChoiceForm: TOpenChoiceForm;
    actStorageChoiceForm: TOpenChoiceForm;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    actGoodsChoiceForm: TOpenChoiceForm;
    AmountRemains: TcxGridDBColumn;
    PriceIn: TcxGridDBColumn;
    PriceUnitFrom: TcxGridDBColumn;
    PriceUnitTo: TcxGridDBColumn;
    SumPriceIn: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cbNotDisplaySUN: TcxCheckBox;
    ActionList1: TActionList;
    dsdDataSetRefresh1: TdsdDataSetRefresh;
    dsdGridToExcel1: TdsdGridToExcel;
    actOpenPartionReport: TdsdOpenForm;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    actSend: TdsdExecStoredProc;
    macSend: TMultiAction;
    ActionList2: TActionList;
    dsdDataSetRefresh2: TdsdDataSetRefresh;
    dsdGridToExcel2: TdsdGridToExcel;
    dsdOpenForm1: TdsdOpenForm;
    dsdDataSetRefresh3: TdsdDataSetRefresh;
    dsdDataSetRefresh4: TdsdDataSetRefresh;
    ExecuteDialog1: TExecuteDialog;
    dsdExecStoredProc1: TdsdExecStoredProc;
    MultiAction1: TMultiAction;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edNumberSeats: TcxCurrencyEdit;
    edDay: TcxCurrencyEdit;
    ceChecked: TcxCheckBox;
    edisComplete: TcxCheckBox;
    MinExpirationDate: TcxGridDBColumn;
    spMovementComplete: TdsdStoredProc;
    bbComplete: TdxBarButton;
    actComplete: TdsdExecStoredProc;
    spInsert_Object_Price: TdsdStoredProc;
    actExecuteDialogInsertPrice: TExecuteDialog;
    actInsertPrice: TdsdDataSetRefresh;
    macInsertPrice: TMultiAction;
    bbInsertPrice: TdxBarButton;
    cbisDeferred: TcxCheckBox;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    bbDeferredNo: TdxBarButton;
    bbDeferredYes: TdxBarButton;
    bbWriteRestFromPoint: TdxBarButton;
    spInsert_Send_WriteRestFromPoint: TdsdStoredProc;
    spWriteRestFromPoint: TdsdExecStoredProc;
    actWriteRestFromPoint: TMultiAction;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelect_MI_Child: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    chExpirationDate: TcxGridDBColumn;
    chOperDate_Income: TcxGridDBColumn;
    chInvnumber_Income: TcxGridDBColumn;
    chContainerId: TcxGridDBColumn;
    chFromName_Income: TcxGridDBColumn;
    chContractName_Income: TcxGridDBColumn;
    chisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxLabel29: TcxLabel;
    edPartionDateKind: TcxButtonEdit;
    GuidesPartionDateKind: TdsdGuides;
    cbSun: TcxCheckBox;
    spUpdate_SendOverdue: TdsdStoredProc;
    actUpdate_SendOverdue: TMultiAction;
    actExecUpdate_SendOverdue: TdsdExecStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    cbDefSun: TcxCheckBox;
    cbReceived: TcxCheckBox;
    cbSent: TcxCheckBox;
    actUpdateDataSetDetailDS: TdsdUpdateDataSet;
    spInsertUpdateMIChild: TdsdStoredProc;
    chColor_calc: TcxGridDBColumn;
    DateInsertChild: TcxGridDBColumn;
    chDateInsert: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edDriverSun: TcxButtonEdit;
    GuidesDriverSun: TdsdGuides;
    spUpdate_Movement_Received: TdsdStoredProc;
    spUpdate_Movement_Sent: TdsdStoredProc;
    actSetReceived: TMultiAction;
    actExecSetReceived: TdsdExecStoredProc;
    actSetSent: TMultiAction;
    actExecSetSent: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    DateInsert: TcxGridDBColumn;
    edIsAuto: TcxCheckBox;
    actSetNotDisplaySUN: TdsdExecStoredProc;
    spUpdate_Movement_NotDisplaySUN: TdsdStoredProc;
    dxBarButton4: TdxBarButton;
    cbSun_v2: TcxCheckBox;
    PartyRelated: TcxGridDBColumn;
    actCreateLoss: TMultiAction;
    dxBarButton5: TdxBarButton;
    spCreateLoss: TdsdStoredProc;
    actExecCreateLoss: TdsdExecStoredProc;
    actOpenLossForm: TdsdOpenForm;
    cxCurrencyEdit1: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cbSUN_v4: TcxCheckBox;
    isPromo: TcxGridDBColumn;
    cbVIP: TcxCheckBox;
    cbConfirmed: TcxCheckBox;
    cbUrgently: TcxCheckBox;
    actExecSetConfirmed: TdsdExecStoredProc;
    spUpdate_Movement_Confirmed: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    edConfirmed: TcxTextEdit;
    actOpenConfirmedDialog: TOpenChoiceForm;
    CommentSendName: TcxGridDBColumn;
    actChoiceCommentSend: TOpenChoiceForm;
    actClearCommentSend: TdsdSetDefaultParams;
    TechnicalRediscountInvNumber: TcxGridDBColumn;
    TechnicalRediscountOperDate: TcxGridDBColumn;
    spUpdate_MovementItem_ContainerId: TdsdStoredProc;
    actUpdate_MovementItem_ContainerId: TdsdExecStoredProc;
    dxBarButton7: TdxBarButton;
    actMovementItem_ShowPUSH_Comment: TdsdShowPUSHMessage;
    spMovementItem_ShowPUSH_Comment: TdsdStoredProc;
    actChoiceIncome: TOpenChoiceForm;
    actExecLoadIncome: TdsdExecStoredProc;
    dxBarButton8: TdxBarButton;
    spAddIncome: TdsdStoredProc;
    actMISetErasedDetail: TdsdUpdateErased;
    actMISetUnErasedDetail: TdsdUpdateErased;
    bbMISetErasedDetail: TdxBarButton;
    bbMISetUnErasedDetail: TdxBarButton;
    spErasedMIMasterDetail: TdsdStoredProc;
    spUnErasedMIMasterDetail: TdsdStoredProc;
    cbisBanFiscalSale: TcxCheckBox;
    cbSendLoss: TcxCheckBox;
    actUpdteSendLoss: TdsdExecStoredProc;
    bbUpdteSendLoss: TdxBarButton;
    spUpdateSendLoss: TdsdStoredProc;
    actSetFocused: TdsdSetFocusedAction;
    actSendPartionDateChange: TdsdOpenForm;
    spGet_SendPartionDateChangeId: TdsdStoredProc;
    actGet_SendPartionDateChangeId: TdsdExecStoredProc;
    dxBarButton9: TdxBarButton;
    actPrintFP: TdsdOpenStaticForm;
    dxBarButton10: TdxBarButton;
    cbSendLossFrom: TcxCheckBox;
    spUpdateSendLossFrom: TdsdStoredProc;
    actUpdateSendLossFrom: TdsdExecStoredProc;
    dxBarButton11: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendForm);

end.
