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
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns;

type
  TGoodsPartnerCodeMasterForm = class(TAncestorGuidesForm)
    clCodeInt: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    edJuridical: TcxButtonEdit;
    cxLabel1: TcxLabel;
    bbLabel: TdxBarControlContainerItem;
    bbJuridical: TdxBarControlContainerItem;
    JuridicalGuides: TdsdGuides;
    clCode: TcxGridDBColumn;
    cxGridGoodsLink: TcxGrid;
    cxGridDBTableViewGoodsLink: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spGoodsLink: TdsdStoredProc;
    cxSplitter: TcxSplitter;
    GoodsLinkCDS: TClientDataSet;
    GoodsLinkDS: TDataSource;
    clJuridicalName: TcxGridDBColumn;
    DBViewAddOnMaster: TdsdDBViewAddOn;
    actGoodsLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    DataSetDelete: TDataSetDelete;
    dsdStoredProc1: TdsdStoredProc;
    dsdExecStoredProc1: TdsdExecStoredProc;
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
