unit EDIJournal;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit;

type
  TEDIJournalForm = class(TAncestorDBGridForm)
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
    colAmountOrder: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
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
    bbLoadOrder: TdxBarButton;
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
    EDIComdoc: TEDIAction;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEDIJournalForm);

end.
