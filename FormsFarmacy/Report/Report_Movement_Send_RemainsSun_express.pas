unit Report_Movement_Send_RemainsSun_express;

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
  TReport_Movement_Send_RemainsSun_expressForm = class(TAncestorReportForm)
    rdUnit: TRefreshDispatcher;
    dxBarButton1: TdxBarButton;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    actRefreshOnDay: TdsdDataSetRefresh;
    cxGrid1: TcxGrid;
    cxGridDBTableViewPartion: TcxGridDBTableView;
    chFromName: TcxGridDBColumn;
    chToName: TcxGridDBColumn;
    chAmount_res: TcxGridDBColumn;
    chSumm_res: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DBViewAddOn_Partion: TdsdDBViewAddOn;
    PartionCDS: TClientDataSet;
    PartionDS: TDataSource;
    cxSplitter1: TcxSplitter;
    spSendSUN: TdsdStoredProc;
    actSendSUN: TdsdExecStoredProc;
    macSendSUN: TMultiAction;
    bbSendSUN: TdxBarButton;
    Amount_res: TcxGridDBColumn;
    Summ_res: TcxGridDBColumn;
    chAmountRemains_calc: TcxGridDBColumn;
    chAmountSun_summ: TcxGridDBColumn;
    chAmountRemains: TcxGridDBColumn;
    chPrice: TcxGridDBColumn;
    chMCS: TcxGridDBColumn;
    chAmount_sale: TcxGridDBColumn;
    chAmountIncome: TcxGridDBColumn;
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
    AmountSend_out: TcxGridDBColumn;
    chAmountReserve: TcxGridDBColumn;
    chAmountSend_in: TcxGridDBColumn;
    chAmountSend_out: TcxGridDBColumn;
    chSumm_sale: TcxGridDBColumn;
    AmountRemains_calc: TcxGridDBColumn;
    chAmountRemains_calc_all: TcxGridDBColumn;
    chAmountOrderExternal: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Movement_Send_RemainsSun_expressForm: TReport_Movement_Send_RemainsSun_expressForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Movement_Send_RemainsSun_expressForm)
end.
