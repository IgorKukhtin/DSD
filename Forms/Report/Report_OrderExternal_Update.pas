unit Report_OrderExternal_Update;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridChartView, cxGridDBChartView, cxSplitter, dsdCommon;

type
  TReport_OrderExternal_UpdateForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    AmountSh: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    CarInfoName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    edTo: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesTo: TdsdGuides;
    ItemsCDS: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    AmountWeight: TcxGridDBColumn;
    mactOpenDocument: TMultiAction;
    actMovementCheck: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    getMovementCheck: TdsdStoredProc;
    Count_Partner: TcxGridDBColumn;
    actOpenChoiceCarInfoForm: TOpenChoiceForm;
    spUpdate_CarInfo: TdsdStoredProc;
    macUpdate_CarInfo_list: TMultiAction;
    actUpdate_CarInfo: TdsdExecStoredProc;
    macUpdate_CarInfo: TMultiAction;
    bbUpdate_CarInfo: TdxBarButton;
    Days: TcxGridDBColumn;
    Times: TcxGridDBColumn;
    DayOfWeekName: TcxGridDBColumn;
    DayOfWeekName_Partner: TcxGridDBColumn;
    DayOfWeekName_CarInfo: TcxGridDBColumn;
    edIsSubPrint: TcxCheckBox;
    actRefresh_Car: TdsdDataSetRefresh;
    spUpdate_CarInfo_grid: TdsdStoredProc;
    actUpdate_CarInfo_grid: TdsdExecStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgOperDate_CarInfo_str: TcxGridDBChartDataGroup;
    serCount_Partner: TcxGridDBChartSeries;
    serAmountWeight: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    grDayOfWeekName_CarInfo: TcxGridDBChartDataGroup;
    StartWeighing: TcxGridDBColumn;
    EndWeighing: TcxGridDBColumn;
    DayOfWeekName_StartW: TcxGridDBColumn;
    DayOfWeekName_EndW: TcxGridDBColumn;
    Hours_EndW: TcxGridDBColumn;
    Hours_real: TcxGridDBColumn;
    actOrderExternal_byReport: TdsdOpenForm;
    bbOrderExternal_byReport: TdxBarButton;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cbisGoods: TcxCheckBox;
    actRefresh_Goods: TdsdDataSetRefresh;
    spSelectPrintGoods: TdsdStoredProc;
    actPrintGoods: TdsdPrintAction;
    bbPrintGoods: TdxBarButton;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount_list: TMultiAction;
    macUpdateMIChild_Amount: TMultiAction;
    actUpdateMIChild_AmountSecond: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecond_list: TMultiAction;
    macUpdateMIChild_AmountSecond: TMultiAction;
    spUpdateMIChild_Amount_report: TdsdStoredProc;
    spUpdateMIChild_AmountSecond_report: TdsdStoredProc;
    spUpdateMIChild_AmountNull_report: TdsdStoredProc;
    spUpdateMIChild_AmountSecondNull_report: TdsdStoredProc;
    actUpdateMIChild_AmountNull: TdsdExecStoredProc;
    macUpdateMIChild_AmountNull_list: TMultiAction;
    macUpdateMIChild_AmountNull: TMultiAction;
    actUpdateMIChild_AmountSecondNull: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecondNull_list: TMultiAction;
    macUpdateMIChild_AmountSecondNull: TMultiAction;
    bbUpdateMIChild_Amount: TdxBarButton;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    bbUpdateMIChild_AmountNull: TdxBarButton;
    bbUpdateMIChild_AmountSecondNull: TdxBarButton;
    OperDate_CarInfo_str: TcxGridDBColumn;
    OperDate_CarInfo_date: TcxGridDBColumn;
    DayOfWeekName_CarInfo_date: TcxGridDBColumn;
    Ord: TcxGridDBColumn;
    HeaderCDS: TClientDataSet;
    MeasureName: TcxGridDBColumn;
    MeasureName_sub: TcxGridDBColumn;
    GoodsCode_sub: TcxGridDBColumn;
    GoodsName_sub: TcxGridDBColumn;
    GoodsKindName_sub: TcxGridDBColumn;
    AmountWeight_child_one: TcxGridDBColumn;
    AmountWeight_child_sec: TcxGridDBColumn;
    actPrintGoodsDiff: TdsdPrintAction;
    spSelectPrintGoodsDiff: TdsdStoredProc;
    bbPrintGoodsDiff: TdxBarButton;
    OperDate_CarInfo_calc: TcxGridDBColumn;
    DayOfWeekName_CarInfo_calc: TcxGridDBColumn;
    Min_calc: TcxGridDBColumn;
    Id_calc: TcxGridDBColumn;
    spSelectPrintGoodsDiff_3: TdsdStoredProc;
    actPrintGoodsDiff_3: TdsdPrintAction;
    bbPrintGoodsDiff_3: TdxBarButton;
    spSelectPrintGoods_upack: TdsdStoredProc;
    actPrintGoods_Upack: TdsdPrintAction;
    bbPrintGoods_Upack: TdxBarButton;
    Count_Doc: TcxGridDBColumn;
    isRemains: TcxGridDBColumn;
    actPrintGoodsDiff_Upack: TdsdPrintAction;
    spSelectPrintGoodsDiff_Upack: TdsdStoredProc;
    actPrintGoodsDiff_3Upack: TdsdPrintAction;
    spSelectPrintGoodsDiff_3Upack: TdsdStoredProc;
    bbPrintGoodsDiff_Upack: TdxBarButton;
    bbPrintGoodsDiff_3Upack: TdxBarButton;
    AmountWeight_sub_child_one: TcxGridDBColumn;
    AmountWeight_sub_child_sec: TcxGridDBColumn;
    AmountWeight_sub_child: TcxGridDBColumn;
    AmountSh_sub_child_one: TcxGridDBColumn;
    AmountSh_sub_child_sec: TcxGridDBColumn;
    AmountSh_sub_child: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderExternal_UpdateForm);

end.
