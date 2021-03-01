unit Report_BalanceNo;

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
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox;

type
  TReport_BalanceNoForm = class(TParentForm)
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
    cxDBPivotGrid: TcxDBPivotGrid;
    pvRootName: TcxDBPivotGridField;
    pvAccountGroupName: TcxDBPivotGridField;
    pvAccountDirectionName: TcxDBPivotGridField;
    pvAccountName: TcxDBPivotGridField;
    pvInfoMoneyName: TcxDBPivotGridField;
    pvAmountDebet: TcxDBPivotGridField;
    pvAmountKredit: TcxDBPivotGridField;
    pvAmountDebetStart: TcxDBPivotGridField;
    pvAmountKreditStart: TcxDBPivotGridField;
    pvAmountDebetEnd: TcxDBPivotGridField;
    pvAmountKreditEnd: TcxDBPivotGridField;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    pvObjectDirection: TcxDBPivotGridField;
    pvObjectDestination: TcxDBPivotGridField;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    pvJuridicalBasisName: TcxDBPivotGridField;
    pvBusinessName: TcxDBPivotGridField;
    PivotAddOn: TPivotAddOn;
    spGetBalanceParam: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenReport_Account: TdsdOpenForm;
    macReport_Account: TMultiAction;
    actGetBalanceParam: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    pvPaidKindName: TcxDBPivotGridField;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    pvAmountActiveStart: TcxDBPivotGridField;
    pvAmountPassiveStart: TcxDBPivotGridField;
    pvAmountActiveEnd: TcxDBPivotGridField;
    pvAmountPassiveEnd: TcxDBPivotGridField;
    pvByObjectItemName: TcxDBPivotGridField;
    pvGoodsItemName: TcxDBPivotGridField;
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
    actOpenReport_Account_noBalance: TdsdOpenForm;
    actOpenReport_AccountMotion_noBalance: TdsdOpenForm;
    macReport_AccountMotion_noBalance: TMultiAction;
    macReport_Account_noBalance: TMultiAction;
    bbReport_Account_noBalance: TdxBarButton;
    bbReport_AccountMotion_noBalance: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_BalanceNoForm);

end.
