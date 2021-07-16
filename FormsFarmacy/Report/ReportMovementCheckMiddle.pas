unit ReportMovementCheckMiddle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, cxSplitter, cxGridChartView,
  cxGridDBChartView, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TReportMovementCheckMiddleForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    rdUnit: TRefreshDispatcher;
    UnitGuides: TdsdGuides;
    dxBarButton1: TdxBarButton;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel12: TcxLabel;
    cbisDay: TcxCheckBox;
    actRefreshOnDay: TdsdDataSetRefresh;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgUnit: TcxGridDBChartDataGroup;
    dgOperDate: TcxGridDBChartDataGroup;
    serSummaSale: TcxGridDBChartSeries;
    serAmount: TcxGridDBChartSeries;
    serAmountPeriod: TcxGridDBChartSeries;
    serSummaSalePeriod: TcxGridDBChartSeries;
    serSummaMiddle: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    serSummaMiddlePeriod: TcxGridDBChartSeries;
    cxLabel4: TcxLabel;
    edUnitHistory: TcxButtonEdit;
    GuidesUnitHistory: TdsdGuides;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chOperDate: TcxGridDBColumn;
    chAmount: TcxGridDBColumn;
    chAmountPeriod: TcxGridDBColumn;
    chSummaSale: TcxGridDBColumn;
    chSummaSalePeriod: TcxGridDBColumn;
    chSummaMiddle: TcxGridDBColumn;
    chSummaMiddlePeriod: TcxGridDBColumn;
    chSummSale_SP: TcxGridDBColumn;
    chSummaSaleWithSP: TcxGridDBColumn;
    chSummaMiddleWithSP: TcxGridDBColumn;
    chCount_1303: TcxGridDBColumn;
    chSummSale_1303: TcxGridDBColumn;
    chAmountWith_1303: TcxGridDBColumn;
    chSummaSaleAll: TcxGridDBColumn;
    chSummaMiddleAll: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    Color_Best: TcxGridDBColumn;
    actGridToExcel1: TdsdGridToExcel;
    bb: TdxBarButton;
    grChart2: TcxGrid;
    cxGridDBChartView1: TcxGridDBChartView;
    cxGridDBChartDataGroup2: TcxGridDBChartDataGroup;
    cxGridLevel2: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    cxLabel5: TcxLabel;
    ceMonth: TcxCurrencyEdit;
    chPersentMiddle: TcxGridDBColumn;
    SummDiscount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportMovementCheckMiddleForm: TReportMovementCheckMiddleForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReportMovementCheckMiddleForm)
end.
