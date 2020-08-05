unit Report_LeftSend;

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
  cxSplitter, cxGridBandedTableView, cxGridDBBandedTableView;

type
  TReport_LeftSendForm = class(TParentForm)
    InventDS: TDataSource;
    InventCDS: TClientDataSet;
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
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    GridIncome: TcxGrid;
    GridIncomeDBBandedTableView: TcxGridDBBandedTableView;
    GridIncomeLevel: TcxGridLevel;
    GridGoods: TcxGrid;
    GridGoodsDBBandedTableView: TcxGridDBBandedTableView;
    GridGoodsLevel: TcxGridLevel;
    GridIncome_InvNumber: TcxGridDBBandedColumn;
    GridIncome_OperDate: TcxGridDBBandedColumn;
    GridIncome_UnitName: TcxGridDBBandedColumn;
    GoodsDS: TDataSource;
    GoodsCDS: TClientDataSet;
    GridGoods_GoodsCode: TcxGridDBBandedColumn;
    GridGoods_GoodsName: TcxGridDBBandedColumn;
    GridGoods_AmountReturn: TcxGridDBBandedColumn;
    GridWasGot: TcxGrid;
    GridWasGotDBBandedTableView: TcxGridDBBandedTableView;
    GridWasGot_InvNumber: TcxGridDBBandedColumn;
    GridWasGot_GoodsName: TcxGridDBBandedColumn;
    GridWasGotLevel: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    GridWasSent: TcxGrid;
    GridWasSentDBBandedTableView: TcxGridDBBandedTableView;
    GridWasSent_InvNumber: TcxGridDBBandedColumn;
    GridWasSent_OperDate: TcxGridDBBandedColumn;
    GridWasSent_UnitName: TcxGridDBBandedColumn;
    GridWasSentLevel: TcxGridLevel;
    GridWasGot_UnitName: TcxGridDBBandedColumn;
    WasSentDS: TDataSource;
    WasSentCDS: TClientDataSet;
    WasGotDS: TDataSource;
    WasGotCDS: TClientDataSet;
    GridWasGot_ReturnRate: TcxGridDBBandedColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_LeftSendForm);

end.
