unit Report_PromoPlan;

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
  cxCheckBox;

type
  TReport_PromoPlanForm = class(TAncestorReportForm)
    cxLabel17: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    DateStartSale: TcxGridDBColumn;
    DeteFinalSale: TcxGridDBColumn;
    DateStartPromo: TcxGridDBColumn;
    DateFinalPromo: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    GoodsWeight: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    actReport_PromoDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    actOpenPromo: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    cbPromo: TcxCheckBox;
    cbTender: TcxCheckBox;
    actUpdatePlanDS: TdsdUpdateDataSet;
    spUpdate_Plan: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    plGoodsKindName_List: TcxGridDBColumn;
    plPersonalTradeName: TcxGridDBColumn;
    plPersonalName: TcxGridDBColumn;
    plChecked: TcxGridDBColumn;
    plGoodsKindCompleteName: TcxGridDBColumn;
    Color_EndDate: TcxGridDBColumn;
    isEndDate: TcxGridDBColumn;
    isSale: TcxGridDBColumn;
    CountDaysPromo: TcxGridDBColumn;
    cbUnitSale: TcxCheckBox;
    CountDaysEndPromo: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PromoPlanForm);

end.
