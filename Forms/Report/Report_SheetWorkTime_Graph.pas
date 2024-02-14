unit Report_SheetWorkTime_Graph;

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
  TReport_SheetWorkTime_GraphForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    bbPrint: TdxBarButton;
    bb: TdxBarButton;
    actPrint: TdsdPrintAction;
    CDSGraph1: TClientDataSet;
    DSGraph1: TDataSource;
    DBViewAddOn_Graph1: TdsdDBViewAddOn;
    actDetailToExcel: TdsdGridToExcel;
    actPivotToExcel: TdsdGridToExcel;
    bbPivotToExcel: TdxBarButton;
    bbDetailToExcel: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBChartView1: TcxGridDBChartView;
    cxGridDBChartDataGroup1: TcxGridDBChartDataGroup;
    cxGridDBChartSeries1: TcxGridDBChartSeries;
    cxGridLevel1: TcxGridLevel;
    DSGraph2: TDataSource;
    CDSGraph2: TClientDataSet;
    dsdDBViewAddOn_Graph2: TdsdDBViewAddOn;
    cxGrid2: TcxGrid;
    cxGridDBChartView2: TcxGridDBChartView;
    cxGridDBChartDataGroup2: TcxGridDBChartDataGroup;
    cxAmount: TcxGridDBChartSeries;
    cxGridLevel2: TcxGridLevel;
    cxTabSheet1: TcxTabSheet;
    DBViewAddOn_Graph3: TdsdDBViewAddOn;
    DSGraph3: TDataSource;
    CDSGraph3: TClientDataSet;
    cxGrid3: TcxGrid;
    cxGridDBChartView3: TcxGridDBChartView;
    cxGridDBChartDataGroup3: TcxGridDBChartDataGroup;
    cxGridLevel3: TcxGridLevel;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    cxGrid4: TcxGrid;
    cxGridDBChartView4: TcxGridDBChartView;
    cxGridDBChartDataGroup4: TcxGridDBChartDataGroup;
    cxGridDBChartSeries3: TcxGridDBChartSeries;
    cxGridLevel4: TcxGridLevel;
    cxGrid5: TcxGrid;
    cxGridDBChartView5: TcxGridDBChartView;
    cxGridDBChartSeries4: TcxGridDBChartSeries;
    dsdDBViewAddOn_Graph4: TdsdDBViewAddOn;
    DSGraph4: TDataSource;
    CDSGraph4: TClientDataSet;
    ceUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    UnitGuides: TdsdGuides;
    Weight_Send_out: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SheetWorkTime_GraphForm);

end.
