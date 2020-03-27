unit Report_Transport_Cost;

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
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, ChoicePeriod, cxLabel, cxCheckBox, dxBarExtItems;

type
  TReport_Transport_CostForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
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
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    RouteName: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    OperDate: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    BranchName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    UnitName: TcxGridDBColumn;
    PriceFuel: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edCar: TcxButtonEdit;
    CarGuides: TdsdGuides;
    UnitGuides: TdsdGuides;
    cbMovement: TcxCheckBox;
    BusinessName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    dxBarStatic1: TdxBarStatic;
    Distance: TcxGridDBColumn;
    WeightTransport: TcxGridDBColumn;
    One_KM: TcxGridDBColumn;
    One_KG: TcxGridDBColumn;
    SumAmount_TransportAdd: TcxGridDBColumn;
    SumAmount_TransportAddLong: TcxGridDBColumn;
    SumAmount_TransportTaxi: TcxGridDBColumn;
    SumAmount_ServiceAdd: TcxGridDBColumn;
    SumAmount_ServiceTotal: TcxGridDBColumn;
    isAccount_50000: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    cbGoods: TcxCheckBox;
    GoodsKindName: TcxGridDBColumn;
    Count_doc: TcxGridDBColumn;
    TotalSumm_Sale: TcxGridDBColumn;
    HoursWork: TcxGridDBColumn;
    Sum_one: TcxGridDBColumn;
    Weight_one: TcxGridDBColumn;
    Wage_kg: TcxGridDBColumn;
    Wage_Hours: TcxGridDBColumn;
    Wage_doc: TcxGridDBColumn;
    TotalWageSumm: TcxGridDBColumn;
    TotalWageKg: TcxGridDBColumn;
    TotalSum_one: TcxGridDBColumn;
    TotalSum_kg: TcxGridDBColumn;
    TotalWeight_Doc: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    SummByPrint: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_Transport_CostForm);

end.
