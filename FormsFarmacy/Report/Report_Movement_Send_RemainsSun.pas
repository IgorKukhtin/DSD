unit Report_Movement_Send_RemainsSun;

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
  TReport_Movement_Send_RemainsSunForm = class(TAncestorReportForm)
    rdUnit: TRefreshDispatcher;
    dxBarButton1: TdxBarButton;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    actRefreshOnDay: TdsdDataSetRefresh;
    cxGrid2: TcxGrid;
    cxGridDBTableViewResult_child: TcxGridDBTableView;
    ch2FromName: TcxGridDBColumn;
    ch2ToName: TcxGridDBColumn;
    ch2Amount: TcxGridDBColumn;
    ch2OperDate: TcxGridDBColumn;
    ch2Invnumber: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGridDBTableViewPartion: TcxGridDBTableView;
    chFromName: TcxGridDBColumn;
    chToName: TcxGridDBColumn;
    chAmount: TcxGridDBColumn;
    chSumm: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DBViewAddOn_Partion: TdsdDBViewAddOn;
    PartionCDS: TClientDataSet;
    PartionDS: TDataSource;
    DBViewAddOn_Result_child: TdsdDBViewAddOn;
    Result_childCDS: TClientDataSet;
    Result_childDS: TDataSource;
    chAmount_next: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    cxSplitter2: TcxSplitter;
    cxSplitter1: TcxSplitter;
    chExpirationDate_in: TcxGridDBColumn;
    spSendSUN: TdsdStoredProc;
    DefSUNCDS: TClientDataSet;
    DefSUNDS: TDataSource;
    actSendSUN: TdsdExecStoredProc;
    macSendSUN: TMultiAction;
    bbSendSUN: TdxBarButton;
    cxSplitter3: TcxSplitter;
    cxGrid3: TcxGrid;
    cxGridDBTableViewDefSUN: TcxGridDBTableView;
    dsFromName: TcxGridDBColumn;
    dsToName: TcxGridDBColumn;
    dsGoodsCode: TcxGridDBColumn;
    dfGoodsName: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    Amount_res: TcxGridDBColumn;
    Summ_res: TcxGridDBColumn;
    Amount_next_res: TcxGridDBColumn;
    Summ_next_res: TcxGridDBColumn;
    AmountSunOnly_summ: TcxGridDBColumn;
    Amount_notSold_summ: TcxGridDBColumn;
    chAmountSunOnly_summ: TcxGridDBColumn;
    chAmount_notSold_summ: TcxGridDBColumn;
    chAmountResult: TcxGridDBColumn;
    chAmountRemains: TcxGridDBColumn;
    chPrice: TcxGridDBColumn;
    chMCS: TcxGridDBColumn;
    chAmount_sale: TcxGridDBColumn;
    chAmountSun_summ_save: TcxGridDBColumn;
    chAmountSun_summ: TcxGridDBColumn;
    chPartionDateKindName: TcxGridDBColumn;
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
    BalanceCDS: TClientDataSet;
    BalanceDS: TDataSource;
    DBViewAddOnBalance: TdsdDBViewAddOn;
    cxGrid4: TcxGrid;
    cxGridDBTableViewBalance: TcxGridDBTableView;
    UnitName_g5: TcxGridDBColumn;
    Summ_out: TcxGridDBColumn;
    Summ_in: TcxGridDBColumn;
    KoeffInSUN: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    DBViewAddOnDefSUN: TdsdDBViewAddOn;
    KoeffOutSUN: TcxGridDBColumn;
    Summ_out_partion: TcxGridDBColumn;
    Summ_in_partion: TcxGridDBColumn;
    Summ_out_partion_calc: TcxGridDBColumn;
    Summ_in_partion_calc: TcxGridDBColumn;
    Amount_not_out_res: TcxGridDBColumn;
    Summ_not_out_res: TcxGridDBColumn;
    Amount_not_in_res: TcxGridDBColumn;
    Summ_not_in_res: TcxGridDBColumn;
    chAmount_not_out: TcxGridDBColumn;
    chSumm_not_out: TcxGridDBColumn;
    chAmount_not_in: TcxGridDBColumn;
    chSumm_not_in: TcxGridDBColumn;
    ñðLayout: TcxGridDBColumn;
    chPromoUnit: TcxGridDBColumn;
    isClose: TcxGridDBColumn;
    isCloseMCS: TcxGridDBColumn;
    chisCloseMCS: TcxGridDBColumn;
    InvNumberLayout: TcxGridDBColumn;
    LayoutName: TcxGridDBColumn;
    Layout: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Movement_Send_RemainsSunForm: TReport_Movement_Send_RemainsSunForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Movement_Send_RemainsSunForm)
end.
