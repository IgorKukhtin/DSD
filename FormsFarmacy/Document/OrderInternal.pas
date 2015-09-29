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
  cxCalc;

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
    colSumm: TcxGridDBColumn;
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
    coJuridicalName: TcxGridDBColumn;
    coPrice: TcxGridDBColumn;
    coContractName: TcxGridDBColumn;
    coSuperFinalPrice: TcxGridDBColumn;
    spUpdatePrioritetPartner: TdsdStoredProc;
    actUpdatePrioritetPartner: TdsdExecStoredProc;
    bbPrioritetPartner: TdxBarButton;
    colMakerName: TcxGridDBColumn;
    colisCalculated: TcxGridDBColumn;
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
    clCalcAmount: TcxGridDBColumn;
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
    colTop: TcxGridDBColumn;
    colRemainsInUnit: TcxGridDBColumn;
    colMCS: TcxGridDBColumn;
    colGoodsGroupName: TcxGridDBColumn;
    colNDSKindName: TcxGridDBColumn;
    colAmountSecond: TcxGridDBColumn;
    colAmountAll: TcxGridDBColumn;
    colCalcAmountAll: TcxGridDBColumn;
    colSummAll: TcxGridDBColumn;
    colIncome_Amount: TcxGridDBColumn;
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
