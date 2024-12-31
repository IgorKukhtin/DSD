unit Report_Promo_Result_Month;

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
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, dsdCommon;

type
  TReport_Promo_Result_MonthForm = class(TAncestorReportForm)
    cxLabel17: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    DateStartSale: TcxGridDBColumn;
    DeteFinalSale: TcxGridDBColumn;
    DateStartPromo: TcxGridDBColumn;
    DateFinalPromo: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    AmountPlanMin: TcxGridDBColumn;
    AmountPlanMinWeight: TcxGridDBColumn;
    AmountPlanMax: TcxGridDBColumn;
    AmountPlanMaxWeight: TcxGridDBColumn;
    GoodsWeight: TcxGridDBColumn;
    Discount: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CostPromo: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    actReport_PromoDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    AmountReal: TcxGridDBColumn;
    AmountRealWeight: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountOutWeight: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountInWeight: TcxGridDBColumn;
    actOpenPromo: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    FormParams: TdsdFormParams;
    MainDiscount: TcxGridDBColumn;
    PersentResult: TcxGridDBColumn;
    PriceIn1: TcxGridDBColumn;
    Profit_Virt: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    cbPromo: TcxCheckBox;
    cbTender: TcxCheckBox;
    cxLabel4: TcxLabel;
    edMovementPromo: TcxButtonEdit;
    GuidesMovementPromo: TdsdGuides;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    actPrint_Mov: TdsdPrintAction;
    bbPrint_Mov: TdxBarButton;
    cbGoodsKind: TcxCheckBox;
    OpenReport_SaleReturn_byPromo: TdsdOpenForm;
    bbReport_SaleReturn_byPromo: TdxBarButton;
    CommentMain: TcxGridDBColumn;
    spUpdate_MainDiscount: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxLabel6: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    Month_Partner: TcxGridDBColumn;
    cbReal: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Promo_Result_MonthForm);

end.
