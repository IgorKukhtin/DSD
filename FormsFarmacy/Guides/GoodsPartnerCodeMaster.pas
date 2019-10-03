unit GoodsPartnerCodeMaster;

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
  dxSkinsdxBarPainter;

type
  TGoodsPartnerCodeMasterForm = class(TAncestorGuidesForm)
    clCodeInt: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    edPartnerCode: TcxButtonEdit;
    cxLabel: TcxLabel;
    bbLabel: TdxBarControlContainerItem;
    bbPartnerCode: TdxBarControlContainerItem;
    PartnerCodeGuides: TdsdGuides;
    clCode: TcxGridDBColumn;
    cxGridGoodsLink: TcxGrid;
    cxGridDBTableViewGoodsLink: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spSelect_PartnerGoods: TdsdStoredProc;
    cxSplitter: TcxSplitter;
    GoodsLinkCDS: TClientDataSet;
    GoodsLinkDS: TDataSource;
    clJuridicalName: TcxGridDBColumn;
    DBViewAddOnMaster: TdsdDBViewAddOn;
    actGoodsLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    DataSetDelete: TDataSetDelete;
    spDeleteLinkGoods: TdsdStoredProc;
    actDeleteLinkGoods: TdsdExecStoredProc;
    clMakerName: TcxGridDBColumn;
    mactListDelete: TMultiAction;
    N8: TMenuItem;
    N9: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPartnerCodeMasterForm);

end.
