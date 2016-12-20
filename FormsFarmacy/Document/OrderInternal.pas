unit OrderInternal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, cxSplitter, dxBarBuiltInMenu, cxNavigator,
  cxCalc, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TOrderInternalForm = class(TAncestorDocumentForm)
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colPrice: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    coCode: TcxGridDBColumn;
    DBViewChildAddOn: TdsdDBViewAddOn;
    colContractName: TcxGridDBColumn;
    colDeferment: TcxGridDBColumn;
    colPercent: TcxGridDBColumn;
    colSuperFinalPrice: TcxGridDBColumn;
    colBonus: TcxGridDBColumn;
    colPartnerGoodsName: TcxGridDBColumn;
    coPrice: TcxGridDBColumn;
    coContractName: TcxGridDBColumn;
    spUpdatePrioritetPartner: TdsdStoredProc;
    actUpdatePrioritetPartner: TdsdExecStoredProc;
    bbPrioritetPartner: TdxBarButton;
    colMakerName: TcxGridDBColumn;
    actSetLinkGoodsForm: TdsdOpenForm;
    bbSetGoodsLink: TdxBarButton;
    colPartnerGoodsCode: TcxGridDBColumn;
    clMakerName: TcxGridDBColumn;
    spDelete_Object_LinkGoodsByGoods: TdsdStoredProc;
    mactDeleteLink: TMultiAction;
    actDeleteLink: TdsdExecStoredProc;
    bbDeleteLink: TdxBarButton;
    colPartionGoodsDate: TcxGridDBColumn;
    colPartionGoodsDateColor: TcxGridDBColumn;
    clPartionGoodsDate: TcxGridDBColumn;
    clPartionGoodsDateColor: TcxGridDBColumn;
    clMinimumLot: TcxGridDBColumn;
    colMinimumLot: TcxGridDBColumn;
    colMultiplicity: TcxGridDBColumn;
    mactDeleteLinkGroup: TMultiAction;
    mactDeleteLinkDS: TMultiAction;
    N2: TMenuItem;
    cxLabel3: TcxLabel;
    edOrderKind: TcxButtonEdit;
    GuidesOrderKind: TdsdGuides;
    colRemains: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colisTopColor: TcxGridDBColumn;
    colRemainsInUnit: TcxGridDBColumn;
    colMCS: TcxGridDBColumn;
    colNDSKindName: TcxGridDBColumn;
    colAmountAll: TcxGridDBColumn;
    colCalcAmountAll: TcxGridDBColumn;
    colSummAll: TcxGridDBColumn;
    colIncome_Amount: TcxGridDBColumn;
    colisCalculated: TcxGridDBColumn;
    clCheckAmount: TcxGridDBColumn;
    colisOneJuridical: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    clisPromo: TcxGridDBColumn;
    OperDatePromo: TcxGridDBColumn;
    InvNumberPromo: TcxGridDBColumn;
    actMovementItemProtocolChild: TdsdOpenForm;
    bbMovementItemProtocolChild: TdxBarButton;
    edIsDocument: TcxCheckBox;
    colSendAmount: TcxGridDBColumn;
    InsertRecord: TInsertRecord;
    actGoodsChoiceForm: TOpenChoiceForm;
    bb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalForm);

end.
