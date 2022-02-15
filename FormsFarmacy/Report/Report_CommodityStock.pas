unit Report_CommodityStock;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator, cxCalendar, cxCurrencyEdit;

type
  TReport_CommodityStockForm = class(TAncestorDBGridForm)
    GoodsCode: TcxGridDBColumn;
    SaleDay: TcxGridDBColumn;
    dsdUpdateMaster: TdsdUpdateDataSet;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    actOpenUnit: TOpenChoiceForm;
    actOpenUser: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    Sale: TcxGridDBColumn;
    Saldo: TcxGridDBColumn;
    AmountUnit: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    CommodityStock: TcxGridDBColumn;
    AmountUnitSaldo: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    isPromo: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    CommodityStockDelta: TcxGridDBColumn;
    SummaNot90: TcxGridDBColumn;
    SummaNotMCS90: TcxGridDBColumn;
    MCSValue: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_CommodityStockForm);

end.
