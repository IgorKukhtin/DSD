unit Goods;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  Vcl.DBActns, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TGoodsForm = class(TAncestorGuidesForm)
    clCode: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clNDSKindName: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    spRefreshOneRecord: TdsdDataSetRefresh;
    spGet: TdsdStoredProc;
    mactAfterInsert: TMultiAction;
    DataSetInsert1: TDataSetInsert;
    DataSetPost1: TDataSetPost;
    FormParams: TdsdFormParams;
    spGetOnInsert: TdsdStoredProc;
    spRefreshOnInsert: TdsdExecStoredProc;
    InsertRecord1: TInsertRecord;
    clMinimumLot: TcxGridDBColumn;
    UpdateDataSet: TdsdUpdateDataSet;
    spUpdate_Goods_MinimumLot: TdsdStoredProc;
    clIsClose: TcxGridDBColumn;
    cbIsTop: TcxGridDBColumn;
    cbPercentMarkup: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    clisFirst: TcxGridDBColumn;
    spUpdate_Goods_isFirst: TdsdStoredProc;
    clColor_calc: TcxGridDBColumn;
    RetailCode: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    spUpdate_Goods_isSecond: TdsdStoredProc;
    spUpdate_Goods_Published: TdsdStoredProc;
    actPublished: TdsdExecStoredProc;
    actSimplePublishedList: TMultiAction;
    actPublishedList: TMultiAction;
    bbPublished: TdxBarButton;
    clisMarketToday: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsForm);

end.
