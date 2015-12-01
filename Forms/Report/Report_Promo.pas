unit Report_Promo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdGuides, cxButtonEdit, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit;

type
  TReport_PromoForm = class(TAncestorReportForm)
    cxLabel17: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    colDateStartSale: TcxGridDBColumn;
    colDeteFinalSale: TcxGridDBColumn;
    colDateStartPromo: TcxGridDBColumn;
    colDateFinalPromo: TcxGridDBColumn;
    colRetailName: TcxGridDBColumn;
    colAreaName: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colTradeMarkName: TcxGridDBColumn;
    colAmountPlanMin: TcxGridDBColumn;
    colAmountPlanMinWeight: TcxGridDBColumn;
    colAmountPlanMax: TcxGridDBColumn;
    colAmountPlanMaxWeight: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colGoodsWeight: TcxGridDBColumn;
    colDiscount: TcxGridDBColumn;
    colPriceWithOutVAT: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCostPromo: TcxGridDBColumn;
    colAdvertisingName: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    colShowAll: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    actReport_PromoDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PromoForm);

end.
