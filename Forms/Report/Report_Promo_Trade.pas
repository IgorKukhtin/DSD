unit Report_Promo_Trade;

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
  cxCheckBox, cxImageComboBox;

type
  TReport_Promo_TradeForm = class(TAncestorReportForm)
    cxLabel17: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
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
    GoodsKindName: TcxGridDBColumn;
    GoodsWeight: TcxGridDBColumn;
    Discount: TcxGridDBColumn;
    PriceWithOutVAT: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CostPromo: TcxGridDBColumn;
    AdvertisingName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    ShowAll: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actReport_PromoDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    AmountReal: TcxGridDBColumn;
    AmountRealWeight: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    AmountOrderWeight: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountOutWeight: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountInWeight: TcxGridDBColumn;
    cbPromo: TcxCheckBox;
    cbTender: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    actPrint1: TdsdPrintAction;
    actPrint2: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbPrint2: TdxBarButton;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    actPrintPromo: TdsdPrintAction;
    bbPrintPromo: TdxBarButton;
    cxLabel6: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Promo_TradeForm);

end.
