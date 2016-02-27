unit GoodsAllJuridical;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, cxContainer, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.ExtCtrls;

type
  TGoodsAllJuridicalForm = class(TAncestorGuidesForm)
    clCodeInt: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    bbLabel: TdxBarControlContainerItem;
    bbJuridical: TdxBarControlContainerItem;
    clCode: TcxGridDBColumn;
    cxGridGChild1: TcxGrid;
    cxGridDBTableViewChild1: TcxGridDBTableView;
    clCode1: TcxGridDBColumn;
    clName1: TcxGridDBColumn;
    cxGridLevelChild1: TcxGridLevel;
    spGoodsRetail: TdsdStoredProc;
    cxSplitter: TcxSplitter;
    ChildCDS_1: TClientDataSet;
    ChildDS_1: TDataSource;
    clGoodsGroupName: TcxGridDBColumn;
    DBViewAddOnChild1: TdsdDBViewAddOn;
    actGoodsLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    DataSetDelete: TDataSetDelete;
    dsdStoredProc1: TdsdStoredProc;
    dsdExecStoredProc1: TdsdExecStoredProc;
    mactListDelete: TMultiAction;
    N8: TMenuItem;
    N9: TMenuItem;
    cxGrid2: TcxGrid;
    cxGridDBTableViewChild2: TcxGridDBTableView;
    cxGoodsId: TcxGridDBColumn;
    cxCode: TcxGridDBColumn;
    cxGoodsName: TcxGridDBColumn;
    cxObjectName: TcxGridDBColumn;
    cxMakerName: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ChildCDS_2: TClientDataSet;
    ChildDS_2: TDataSource;
    dsdDBViewAddOnChild2: TdsdDBViewAddOn;
    spGoodsJuridical: TdsdStoredProc;
    colId: TcxGridDBColumn;
    clId: TcxGridDBColumn;
    clGoodsMainId: TcxGridDBColumn;
    colNDSKindName: TcxGridDBColumn;
    clObjectName: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    cxGoodsMainId: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    colisErased: TcxGridDBColumn;
    clObjectDescName: TcxGridDBColumn;
    colGoodsGroupName: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    clNDSKindName: TcxGridDBColumn;
    clMinimumLot: TcxGridDBColumn;
    clisClose: TcxGridDBColumn;
    clisTOP: TcxGridDBColumn;
    clPercentMarkup: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    colMakerName: TcxGridDBColumn;
    cxObjectDescName: TcxGridDBColumn;
    MainId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsAllJuridicalForm);

end.
