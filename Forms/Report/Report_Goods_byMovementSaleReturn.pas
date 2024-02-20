unit Report_Goods_byMovementSaleReturn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxSplitter,
  cxGridChartView, cxGridDBChartView, cxCheckBox, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_Goods_byMovementSaleReturnForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel5: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edGoodsGroupGP: TcxButtonEdit;
    GoodsGroupGPGuides: TdsdGuides;
    UnitGroupGuides: TdsdGuides;
    cxGridPivot: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ReturnAmount: TcxGridDBColumn;
    ReturnAmountPartner: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    bbPrint: TdxBarButton;
    isTop: TcxGridDBColumn;
    chisTop: TcxGridDBColumn;
    bbPrint_test: TdxBarButton;
    ColorRecord: TcxGridDBColumn;
    chColorRecord: TcxGridDBColumn;
    NumLine: TcxGridDBColumn;
    chNumLine: TcxGridDBColumn;
    BoldRecord: TcxGridDBColumn;
    chBoldRecord: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    DetailCDS: TClientDataSet;
    DSDetail: TDataSource;
    StartDate: TcxGridDBColumn;
    DetaildsdDBViewAddOn: TdsdDBViewAddOn;
    GroupNum: TcxGridDBColumn;
    Num: TcxGridDBColumn;
    Num2: TcxGridDBColumn;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgOperDate: TcxGridDBChartDataGroup;
    serSaleAmount_11: TcxGridDBChartSeries;
    serReturnAmount_11: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    chWeek: TcxCheckBox;
    chMonth: TcxCheckBox;
    EndDate: TcxGridDBColumn;
    DOW_StartDate: TcxGridDBColumn;
    DOW_EndDate: TcxGridDBColumn;
    actDetailToExcel: TdsdGridToExcel;
    actPivotToExcel: TdsdGridToExcel;
    bbPivotToExcel: TdxBarButton;
    bbDetailToExcel: TdxBarButton;
    tsMainTest: TcxTabSheet;
    tsPivotTest: TcxTabSheet;
    cxGrid_PG4: TcxGrid;
    cxGridDBTableView_PG4: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridDBColumn7: TcxGridDBColumn;
    cxGridDBColumn8: TcxGridDBColumn;
    cxGridDBColumn9: TcxGridDBColumn;
    cxGridDBColumn10: TcxGridDBColumn;
    cxGridDBColumn11: TcxGridDBColumn;
    cxGridLevel_PG4: TcxGridLevel;
    DBViewAddOnPG4: TdsdDBViewAddOn;
    PG4CDS: TClientDataSet;
    PG4DS: TDataSource;
    cxGridPG5: TcxGrid;
    cxGridDBTableView_PG5: TcxGridDBTableView;
    cxGridDBColumn12: TcxGridDBColumn;
    cxGridDBColumn13: TcxGridDBColumn;
    cxGridDBColumn14: TcxGridDBColumn;
    cxGridDBColumn15: TcxGridDBColumn;
    cxGridDBColumn16: TcxGridDBColumn;
    cxGridDBColumn17: TcxGridDBColumn;
    cxGridDBColumn18: TcxGridDBColumn;
    cxGridDBColumn19: TcxGridDBColumn;
    cxGridDBColumn20: TcxGridDBColumn;
    cxGridDBColumn21: TcxGridDBColumn;
    cxGridDBColumn22: TcxGridDBColumn;
    cxGridDBColumn23: TcxGridDBColumn;
    cxGridDBColumn24: TcxGridDBColumn;
    cxGridDBColumn25: TcxGridDBColumn;
    cxGridDBColumn26: TcxGridDBColumn;
    cxGridDBColumn27: TcxGridDBColumn;
    cxGridDBColumn28: TcxGridDBColumn;
    cxGridLevelPG5: TcxGridLevel;
    PG5CDS: TClientDataSet;
    PG5DS: TDataSource;
    DBViewAddOnPG5: TdsdDBViewAddOn;
    actPrint_test: TdsdPrintAction;
    actGridTestToExcel: TdsdGridToExcel;
    actPivotTestToExcel: TdsdGridToExcel;
    bbGridTestToExcel: TdxBarButton;
    bbPivotTestToExcel: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Goods_byMovementSaleReturnForm);

end.
