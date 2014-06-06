unit EDIJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, EDI,
  cxSplitter, ChoicePeriod, dsdActionOld;

type
  TEDIJournalForm = class(TAncestorDBGridForm)
    colOperDate: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colSaleInvNumber: TcxGridDBColumn;
    colSaleOperDate: TcxGridDBColumn;
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
    colGoodsName: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colAmountOrder: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    colPricePartner: TcxGridDBColumn;
    colGoodsKind: TcxGridDBColumn;
    spClient: TdsdStoredProc;
    ClientDS: TDataSource;
    ClientCDS: TClientDataSet;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    colGLNCode: TcxGridDBColumn;
    colOKPO: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    maEDIComDocLoad: TMultiAction;
    colGoodsGLNCode: TcxGridDBColumn;
    colEDIGoodsName: TcxGridDBColumn;
    colSummPartner: TcxGridDBColumn;
    EDI: TEDI;
    maEDIOrdersLoad: TMultiAction;
    EDIActionOrdersLoad: TEDIAction;
    bbLoadOrder: TdxBarButton;
    colLoadJuridicalName: TcxGridDBColumn;
    colGLNPlaceCode: TcxGridDBColumn;
    colIsOrder: TcxGridDBColumn;
    colIsSale: TcxGridDBColumn;
    colIsTax: TcxGridDBColumn;
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
    dsdOpenForm2: TdsdOpenForm;
    bbGotoSale: TdxBarButton;
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
