unit Report_Send_RemainsSunOut_express_v2;

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
  TReport_Send_RemainsSunOut_express_v2Form = class(TAncestorReportForm)
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
    cxGridLevel2: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGridDBTableViewPartion: TcxGridDBTableView;
    chFromName: TcxGridDBColumn;
    chToName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DBViewAddOn_Partion: TdsdDBViewAddOn;
    PartionCDS: TClientDataSet;
    PartionDS: TDataSource;
    DBViewAddOn_Result_child: TdsdDBViewAddOn;
    Result_childCDS: TClientDataSet;
    Result_childDS: TDataSource;
    cxSplitter2: TcxSplitter;
    cxSplitter1: TcxSplitter;
    spSendSUN: TdsdStoredProc;
    actSendSUN: TdsdExecStoredProc;
    macSendSUN: TMultiAction;
    bbSendSUN: TdxBarButton;
    Amount_res: TcxGridDBColumn;
    Summ_res: TcxGridDBColumn;
    chAmountRemains: TcxGridDBColumn;
    chMCS: TcxGridDBColumn;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Send_RemainsSunOut_express_v2Form: TReport_Send_RemainsSunOut_express_v2Form;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Send_RemainsSunOut_express_v2Form)
end.
