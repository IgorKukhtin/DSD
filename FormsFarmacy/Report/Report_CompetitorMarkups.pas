unit Report_CompetitorMarkups;

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
  cxGridBandedTableView, cxGridDBBandedTableView, cxSplitter,
  cxPCdxBarPopupMenu, cxPC, cxImageComboBox;

type
  TReport_CompetitorMarkupsForm = class(TParentForm)
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
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsName: TcxGridDBBandedColumn;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    GoodsCode: TcxGridDBBandedColumn;
    bbUpdate: TdxBarButton;
    CompetitorCDS: TClientDataSet;
    CrossDBViewReportAddOn: TCrossDBViewReportAddOn;
    GroupsName: TcxGridDBBandedColumn;
    SubGroupsName: TcxGridDBBandedColumn;
    PriceUnitMin: TcxGridDBBandedColumn;
    Price: TcxGridDBBandedColumn;
    MarginPercentMin: TcxGridDBBandedColumn;
    JuridicalPriceMin0000: TcxGridDBBandedColumn;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    MarginPercentDeltaMin: TcxGridDBBandedColumn;
    PriceUnitMax: TcxGridDBBandedColumn;
    JuridicalPriceMax0000: TcxGridDBBandedColumn;
    MarginPercentMax: TcxGridDBBandedColumn;
    DPrice: TcxGridDBBandedColumn;
    MarginPercentDeltaMax: TcxGridDBBandedColumn;
    ColorMin: TcxGridDBBandedColumn;
    ColorMax: TcxGridDBBandedColumn;
    JuridicalPrice: TcxGridDBBandedColumn;
    MarginPercent: TcxGridDBBandedColumn;
    MarginPercentSGR: TcxGridDBBandedColumn;
    ColorDPriceUnit: TcxGridDBBandedColumn;
    cxGridDBBandedTableViewColumn1: TcxGridDBBandedColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSetGroupDS: TDataSource;
    ClientDataSetGroupCDS: TClientDataSet;
    CompetitorGroupCDS: TClientDataSet;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    chSubGroupsName: TcxGridDBBandedColumn;
    chMarginPercent: TcxGridDBBandedColumn;
    chMarginPercentSGR: TcxGridDBBandedColumn;
    chDMarginPercentCode: TcxGridDBBandedColumn;
    chDMarginPercent: TcxGridDBBandedColumn;
    CrossDBViewReportAddOnItog: TCrossDBViewReportAddOn;
    actShowPrev: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    actShowPUSHInfo: TdsdShowPUSHMessage;
    spPUSH: TdsdStoredProc;
    actMCRequestAllDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    tsMarginCategory_All: TcxTabSheet;
    spSelect: TdsdStoredProc;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    MarginCategoryName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ProvinceCityName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    Value_1: TcxGridDBColumn;
    Value_2: TcxGridDBColumn;
    Value_3: TcxGridDBColumn;
    Value_4: TcxGridDBColumn;
    Value_5: TcxGridDBColumn;
    Value_6: TcxGridDBColumn;
    Value_7: TcxGridDBColumn;
    avgPercent: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    DBViewAddOnAll: TdsdDBViewAddOn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_CompetitorMarkupsForm);

end.
