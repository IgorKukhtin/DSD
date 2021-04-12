unit Report_Movement_Send_RemainsSun_Supplement;

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
  dxSkinXmas2008Blue, cxGridBandedTableView, cxGridDBBandedTableView;

type
  TReport_Movement_Send_RemainsSun_SupplementForm = class(TAncestorReportForm)
    rdUnit: TRefreshDispatcher;
    dxBarButton1: TdxBarButton;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    actRefreshOnDay: TdsdDataSetRefresh;
    spSendSUN: TdsdStoredProc;
    actSendSUN: TdsdExecStoredProc;
    macSendSUN: TMultiAction;
    bbSendSUN: TdxBarButton;
    actOpenReportPartionHistoryForm: TdsdOpenForm;
    actOpenReportPartionDateForm: TdsdOpenForm;
    bbReportPartionDate: TdxBarButton;
    bbReportPartionHistory: TdxBarButton;
    actOpenReportPartionDateChild: TdsdOpenForm;
    actOpenReportPartionHistoryChild: TdsdOpenForm;
    bbOpenReportPartionHistoryChild: TdxBarButton;
    bbOpenReportPartionDateChild: TdxBarButton;
    actReportSendSUN: TdsdOpenForm;
    bbReportSendSUN: TdxBarButton;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    GoodsCode: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    UnitName_From: TcxGridDBBandedColumn;
    UnitName_To: TcxGridDBBandedColumn;
    Amount: TcxGridDBBandedColumn;
    MCS: TcxGridDBBandedColumn;
    AmountRemains: TcxGridDBBandedColumn;
    AmountSalesDay: TcxGridDBBandedColumn;
    AverageSales: TcxGridDBBandedColumn;
    StockRatio: TcxGridDBBandedColumn;
    MCS_From: TcxGridDBBandedColumn;
    AmountRemains_From: TcxGridDBBandedColumn;
    AmountSalesDey_From: TcxGridDBBandedColumn;
    AmountSalesMonth_From: TcxGridDBBandedColumn;
    AverageSalesMonth_From: TcxGridDBBandedColumn;
    Need_From: TcxGridDBBandedColumn;
    Delt_From: TcxGridDBBandedColumn;
    MCS_To: TcxGridDBBandedColumn;
    AmountRemains_To: TcxGridDBBandedColumn;
    AmountSalesDey_To: TcxGridDBBandedColumn;
    AmountSalesMonth_To: TcxGridDBBandedColumn;
    AverageSalesMonth_To: TcxGridDBBandedColumn;
    Need_To: TcxGridDBBandedColumn;
    Delta_To: TcxGridDBBandedColumn;
    Summa_From: TcxGridDBBandedColumn;
    Summa_To: TcxGridDBBandedColumn;
    Layout_From: TcxGridDBBandedColumn;
    PromoUnit_From: TcxGridDBBandedColumn;
    MinExpirationDate: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Movement_Send_RemainsSun_SupplementForm: TReport_Movement_Send_RemainsSun_SupplementForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Movement_Send_RemainsSun_SupplementForm)
end.
