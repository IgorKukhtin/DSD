unit GoodsListSale;

interface

uses
  Winapi.Windows, AncestorGuides, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.Menus, cxButtonEdit, cxContainer, dsdGuides, cxLabel,
  cxTextEdit, cxMaskEdit, Vcl.ExtCtrls;

type
  TGoodsListSaleForm = class(TAncestorGuidesForm)
    clContractCode: TcxGridDBColumn;
    Panel: TPanel;
    edRetail: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel27: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    RetailGuides: TdsdGuides;
    clPartnerName: TcxGridDBColumn;
    clRetailName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    mactOpenReportForm: TMultiAction;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    clAmount: TcxGridDBColumn;
    clGoodsKindName_List: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsListSaleForm);

end.
