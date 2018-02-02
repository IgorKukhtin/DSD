unit Report_Transport_ProfitLoss;

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
  cxButtonEdit, ChoicePeriod, cxLabel, dxBarExtItems, cxCheckBox;

type
  TReport_Transport_ProfitLossForm = class(TParentForm)
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
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    dxBarStatic: TdxBarStatic;
    cxLabel3: TcxLabel;
    edBusiness: TcxButtonEdit;
    GuidesBusiness: TdsdGuides;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edCar: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesCar: TdsdGuides;
    cbMovement: TcxCheckBox;
    MovementDescName: TcxGridDBColumn;
    FuelName: TcxGridDBColumn;
    SumCount_Transport: TcxGridDBColumn;
    SumAmount_Transport: TcxGridDBColumn;
    PriceFuel: TcxGridDBColumn;
    SumAmount_TransportAdd: TcxGridDBColumn;
    SumAmount_TransportAddLong: TcxGridDBColumn;
    SumAmount_TransportTaxi: TcxGridDBColumn;
    SumAmount_ServiceTotal: TcxGridDBColumn;
    SumAmount_TransportService: TcxGridDBColumn;
    SumAmount_ServiceAdd: TcxGridDBColumn;
    SumAmount_PersonalSendCash: TcxGridDBColumn;
    SumTotal: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    ProfitLossName: TcxGridDBColumn;
    ProfitLossName_all: TcxGridDBColumn;
    Distance: TcxGridDBColumn;
    WeightTransport: TcxGridDBColumn;
    WeightSale: TcxGridDBColumn;
    One_KM: TcxGridDBColumn;
    One_KG: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_Transport_ProfitLossForm);

end.
