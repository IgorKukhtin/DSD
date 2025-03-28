unit EDIJournalLoad;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, EDI,
  cxSplitter, ChoicePeriod, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TEDIJournalLoadForm = class(TAncestorDBGridForm)
    clOperDate: TcxGridDBColumn;
    clInvNumber: TcxGridDBColumn;
    clInvNumberPartner: TcxGridDBColumn;
    clOperDatePartner: TcxGridDBColumn;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    EDIActionComdocLoad: TEDIAction;
    spHeaderOrder: TdsdStoredProc;
    spListOrder: TdsdStoredProc;
    bbLoadComDoc: TdxBarButton;
    Splitter: TcxSplitter;
    cxChildGrid: TcxGrid;
    cxChildGridDBTableView: TcxGridDBTableView;
    clGoodsName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clAmountOrder: TcxGridDBColumn;
    clAmountPartner: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    clPrice: TcxGridDBColumn;
    clGoodsKind: TcxGridDBColumn;
    spClient: TdsdStoredProc;
    ClientDS: TDataSource;
    ClientCDS: TClientDataSet;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    clGLNCode: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    clPartnerNameFind: TcxGridDBColumn;
    clJuridicalNameFind: TcxGridDBColumn;
    maEDIComDocLoad: TMultiAction;
    clGoodsGLNCode: TcxGridDBColumn;
    clGoodsNameEDI: TcxGridDBColumn;
    clSummPartner: TcxGridDBColumn;
    EDI: TEDI;
    maEDIOrdersLoad: TMultiAction;
    EDIActionOrdersLoad: TEDIAction;
    bbNOLoadOrder: TdxBarButton;
    clJuridicalName: TcxGridDBColumn;
    clGLNPlaceCode: TcxGridDBColumn;
    clInvNumber_Order: TcxGridDBColumn;
    clInvNumber_Sale: TcxGridDBColumn;
    clInvNumberPartner_Tax: TcxGridDBColumn;
    spHeaderComDoc: TdsdStoredProc;
    spListComDoc: TdsdStoredProc;
    BottomPanel: TPanel;
    DBChildViewAddOn: TdsdDBViewAddOn;
    cxProtocolGrid: TcxGrid;
    cxProtocolGridView: TcxGridDBTableView;
    colProtocolOperDate: TcxGridDBColumn;
    colProtocolText: TcxGridDBColumn;
    colProtocolUserName: TcxGridDBColumn;
    cxGridProtocolLevel: TcxGridLevel;
    ProtocolCDS: TClientDataSet;
    ProtocolDS: TDataSource;
    spProtocol: TdsdStoredProc;
    DBProtocolViewAddOn: TdsdDBViewAddOn;
    cxVerticalSplitter: TcxSplitter;
    spGetDefaultEDI: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actSetDefaults: TdsdExecStoredProc;
    actOpenSaleForm: TdsdOpenForm;
    bbGotoSale: TdxBarButton;
    clOperDate_Order: TcxGridDBColumn;
    clOperDate_Tax: TcxGridDBColumn;
    clOperDatePartner_Sale: TcxGridDBColumn;
    clAmountPartnerEDI: TcxGridDBColumn;
    clSummPartnerEDI: TcxGridDBColumn;
    clIsCheck: TcxGridDBColumn;
    clmovIsCheck: TcxGridDBColumn;
    spInsertUpdate_SaleLinkEDI: TdsdStoredProc;
    spUpdate_EDIComdoc_Params: TdsdStoredProc;
    actUpdate_EDIComdoc_Params: TdsdExecStoredProc;
    actUpdateMI_EDIComdoc: TdsdExecStoredProc;
    bbUpdate_EDIComdoc_Params: TdxBarButton;
    bbInsertUpdate_SaleLinkEDI: TdxBarButton;
    spSelectPrint: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    mactCOMDOC: TMultiAction;
    bb_mactComDoc: TdxBarButton;
    actExecPrintStoredProc: TdsdExecStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    mactDECLAR: TMultiAction;
    EDIDeclar: TEDIAction;
    bbDeclar: TdxBarButton;
    actStoredProcTaxPrint: TdsdExecStoredProc;
    clOperDateTax: TcxGridDBColumn;
    clInvNumberTax: TcxGridDBColumn;
    clDescName: TcxGridDBColumn;
    clOperDate_TaxCorrective: TcxGridDBColumn;
    clInvNumberPartner_TaxCorrective: TcxGridDBColumn;
    EDIReceipt: TEDIAction;
    bbReceipt: TdxBarButton;
    maEDIReceiptLoad: TMultiAction;
    spInsert_Protocol_EDIReceipt: TdsdStoredProc;
    clisElectron: TcxGridDBColumn;
    EDIReturnComDoc: TEDIAction;
    mactReturnComdoc: TMultiAction;
    bbReturnCOMDOC: TdxBarButton;
    spGetFileBlob: TdsdStoredProc;
    spGetFileName: TdsdStoredProc;
    spSelectTaxCorrective_Client: TdsdStoredProc;
    EDIDeclarReturn: TEDIAction;
    actStoredProcTaxCorrectivePrint: TdsdExecStoredProc;
    EDI1: TMenuItem;
    EDI2: TMenuItem;
    N2: TMenuItem;
    EDI3: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ComDoc1: TMenuItem;
    mactSendComdoc: TMultiAction;
    mactSendComdocAndRefresh: TMultiAction;
    EDI4: TMenuItem;
    mactSendDeclar: TMultiAction;
    mactSendDeclarAndRefresh: TMultiAction;
    mactSendReturnAndRefresh: TMultiAction;
    EDI5: TMenuItem;
    mactSendReturn: TMultiAction;
    mactSendReturnAndRefresh1: TMenuItem;
    clUnitName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceContract: TOpenChoiceForm;
    actChoiceUnit: TOpenChoiceForm;
    clAmountOrderEDI: TcxGridDBColumn;
    clAmountNoticeEDI: TcxGridDBColumn;
    clAmountNotice: TcxGridDBColumn;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    bbInvoice: TdxBarButton;
    bbOrderSp: TdxBarButton;
    bbDecadv: TdxBarButton;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    spUpdateEdiOrdspr: TdsdStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    clError: TcxGridDBColumn;
    EDIError: TEDIAction;
    mactErrorEDI: TMultiAction;
    bbEDIError: TdxBarButton;
    mactDeclarSilent: TMultiAction;
    clGoodsPropertyName: TcxGridDBColumn;
    ClientRefresh: TdsdDataSetRefresh;
    maEDIRecadvLoad: TMultiAction;
    EDIActionRecadvLoad: TEDIAction;
    bbEDIRecadvLoad: TdxBarButton;
    spInsertRecadv: TdsdStoredProc;
    InvNumberRecadv: TcxGridDBColumn;
    FileName: TcxGridDBColumn;
    DateRegistered: TcxGridDBColumn;
    InvNumberRegistered: TcxGridDBColumn;
    clPersonalSigningName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    spUpdate_DateRegistered: TdsdStoredProc;
    actUpdate_DateRegistered: TdsdExecStoredProc;
    actShowMessage: TShowMessageAction;
    clPrice_EDI: TcxGridDBColumn;
    actOpenOrderForm: TdsdOpenForm;
    bbOpenOrderForm: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
    actGridItemToExcel: TdsdGridToExcel;
    actGridProtocolToExcel: TdsdGridToExcel;
    bbGridItemToExcel: TdxBarButton;
    bbGridProtocolToExcel: TdxBarButton;
    maEDIOrdersNOLoad: TMultiAction;
    OperDate_Insert: TcxGridDBColumn;
    mactVchasnoEDIOrdersLoad: TMultiAction;
    bbVchasnoEDIOrdersLoad: TdxBarButton;
    actVchasnoEDIOrdeLoad: TdsdVchasnoEDIAction;
    actVchasnoEDIDesadv: TdsdVchasnoEDIAction;
    mactVchasnoEDIDesadv: TMultiAction;
    dsVchasnoEDI: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    bbVchasnoEDIDesadv: TdxBarButton;
    mactVchasnoEDIOrdrsp: TMultiAction;
    actVchasnoEDIOrdrsp: TdsdVchasnoEDIAction;
    mactVchasnoEDIDeclar: TMultiAction;
    actVchasnoEDIDeclar: TdsdVchasnoEDIAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    spInsertUpdate_EDIINVOICE_NP: TdsdStoredProc;
    spGet_DefaultEDIN: TdsdStoredProc;
    actGet_DefaultEDIN: TdsdExecStoredProc;
    actLoadInvoiceNR: TdsdEDINAction;
    mactLoadInvoiceNR: TMultiAction;
    dxBarButton3: TdxBarButton;
    mactVchasnoEDISignDeclar: TMultiAction;
    actVchasnoEDISignDeclar: TdsdVchasnoEDIAction;
    dxBarButton4: TdxBarButton;
    isVchasno: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEDIJournalLoadForm);

end.
