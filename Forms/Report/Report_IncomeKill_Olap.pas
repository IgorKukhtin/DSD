unit Report_IncomeKill_Olap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdGuides,
  cxButtonEdit;

type
  TReport_IncomeKill_OlapForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PivotAddOn: TPivotAddOn;
    spGetBalanceParam: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenReport_Account: TdsdOpenForm;
    macReport_Account: TMultiAction;
    actGetBalanceParam: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    cbTotal: TcxCheckBox;
    bbcbTotal: TdxBarControlContainerItem;
    actOpenReport_AccountMotion: TdsdOpenForm;
    bbOpenReport_AccountMotion: TdxBarButton;
    macReport_AccountMotion: TMultiAction;
    bbReport_Account: TdxBarButton;
    actPrint3: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    cbGroup: TcxCheckBox;
    bbGroup: TdxBarControlContainerItem;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxDBPivotGrid: TcxDBPivotGrid;
    pvMonthDate: TcxDBPivotGridField;
    pvInvNumber: TcxDBPivotGridField;
    pvOperDate: TcxDBPivotGridField;
    pvGoodsGroupName: TcxDBPivotGridField;
    pvGoodsCode: TcxDBPivotGridField;
    pvGoodsName: TcxDBPivotGridField;
    pvGoodsKindName: TcxDBPivotGridField;
    pvGoodsGroupNameFull: TcxDBPivotGridField;
    pvGoodsGroupAnalystName: TcxDBPivotGridField;
    pvTradeMarkName: TcxDBPivotGridField;
    pvGoodsTagName: TcxDBPivotGridField;
    pvGoodsPlatformName: TcxDBPivotGridField;
    pvPartionGoods: TcxDBPivotGridField;
    pvPartionGoods_Date: TcxDBPivotGridField;
    pvAmount: TcxDBPivotGridField;
    pvAmount_Weight: TcxDBPivotGridField;
    pvAmount_Sh: TcxDBPivotGridField;
    pvAmountPartner: TcxDBPivotGridField;
    pvAmountPartner_Weight: TcxDBPivotGridField;
    pvAmountPartner_Sh: TcxDBPivotGridField;
    pvPrice: TcxDBPivotGridField;
    pvPricePartner: TcxDBPivotGridField;
    pvSumm: TcxDBPivotGridField;
    pvSumm_ProfitLoss: TcxDBPivotGridField;
    pvTotalSumm: TcxDBPivotGridField;
    pvInfoMoneyCode: TcxDBPivotGridField;
    pvInfoMoneyGroupName: TcxDBPivotGridField;
    pvInfoMoneyDestinationName: TcxDBPivotGridField;
    pvInfoMoneyName: TcxDBPivotGridField;
    pvInfoMoneyName_all: TcxDBPivotGridField;
    pvInfoMoneyCode_Detail: TcxDBPivotGridField;
    pvInfoMoneyGroupName_Detail: TcxDBPivotGridField;
    pvInfoMoneyDestinationName_Detail: TcxDBPivotGridField;
    pvInfoMoneyName_Detail: TcxDBPivotGridField;
    pvInfoMoneyName_all_Detail: TcxDBPivotGridField;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_IncomeKill_OlapForm);

end.
