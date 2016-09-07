unit GoodsAllRetail;

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
  TGoodsAllRetailForm = class(TAncestorGuidesForm)
    cxGridGChild1: TcxGrid;
    cxGridDBTableViewChild1: TcxGridDBTableView;
    cxGridLevelChild1: TcxGridLevel;
    spSelectMaster: TdsdStoredProc;
    cxSplitter: TcxSplitter;
    ChildCDS_1: TClientDataSet;
    ChildDS_1: TDataSource;
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
    cxGridLevel2: TcxGridLevel;
    ChildCDS_2: TClientDataSet;
    ChildDS_2: TDataSource;
    dsdDBViewAddOnChild2: TdsdDBViewAddOn;
    spSelectChild2: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    LinkId_1: TcxGridDBColumn;
    isUpload_1: TcxGridDBColumn;
    isSpecCondition_1: TcxGridDBColumn;
    Protocol2OpenForm: TdsdOpenForm;
    Protocol3OpenForm: TdsdOpenForm;
    bbProtocol2OpenForm: TdxBarButton;
    bbProtocol3OpenForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsAllRetailForm);

end.
