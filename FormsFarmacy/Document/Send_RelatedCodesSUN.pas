unit Send_RelatedCodesSUN;

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
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdPivotGrid,
  cxImageComboBox, cxButtonEdit, dsdGuides;

type
  TSend_RelatedCodesSUNForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
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
    spGetBalanceParam: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    DBViewAddOn: TdsdDBViewAddOn;
    actUpdate: TdsdInsertUpdateAction;
    bbUpdate: TdxBarButton;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colStatus: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ProvinceCityName_From: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    ProvinceCityName_To: TcxGridDBColumn;
    DriverSunName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    TotalSummFrom: TcxGridDBColumn;
    TotalSummTo: TcxGridDBColumn;
    isAuto: TcxGridDBColumn;
    Checked: TcxGridDBColumn;
    isComplete: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    isSUN_v2: TcxGridDBColumn;
    isSUN_v3: TcxGridDBColumn;
    isSUN_v4: TcxGridDBColumn;
    isSUN: TcxGridDBColumn;
    isDefSUN: TcxGridDBColumn;
    isSent: TcxGridDBColumn;
    isReceived: TcxGridDBColumn;
    isOverdueSUN: TcxGridDBColumn;
    isNotDisplaySUN: TcxGridDBColumn;
    isVIP: TcxGridDBColumn;
    isUrgently: TcxGridDBColumn;
    isConfirmed: TcxGridDBColumn;
    MCSPeriod: TcxGridDBColumn;
    MCSDay: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    lInsertName: TcxGridDBColumn;
    lInsertDate: TcxGridDBColumn;
    InsertDateDiff: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    UpdateDateDiff: TcxGridDBColumn;
    ReportInvNumber_full: TcxGridDBColumn;
    NumberSeats: TcxGridDBColumn;
    isBanFiscalSale: TcxGridDBColumn;
    isSendLoss: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    GoodsGuides: TdsdGuides;
    ceGoods: TcxButtonEdit;
    cxLabel3: TcxLabel;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSend_RelatedCodesSUNForm);

end.
