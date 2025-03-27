unit Report_Transport;

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
  cxButtonEdit, ChoicePeriod, cxLabel, dxBarExtItems, cxCheckBox, dsdCommon;

type
  TReport_TransportForm = class(TParentForm)
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
    StartOdometre: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    RouteName: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    EndOdometre: TcxGridDBColumn;
    AmountFuel_Start: TcxGridDBColumn;
    AmountFuel: TcxGridDBColumn;
    AmountColdHour: TcxGridDBColumn;
    AmountFuel_In: TcxGridDBColumn;
    AmountFuel_Out: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    OperDate: TcxGridDBColumn;
    AmountColdDistance: TcxGridDBColumn;
    AmountFuel_End: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    ColdHour: TcxGridDBColumn;
    ColdDistance: TcxGridDBColumn;
    Amount_Distance_calc: TcxGridDBColumn;
    InvNumberTransport: TcxGridDBColumn;
    RateFuelKindTax: TcxGridDBColumn;
    DistanceFuel: TcxGridDBColumn;
    RouteKindName: TcxGridDBColumn;
    RateFuelKindName: TcxGridDBColumn;
    Amount_ColdHour_calc: TcxGridDBColumn;
    Amount_ColdDistance_calc: TcxGridDBColumn;
    FuelName: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    BranchName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    WeightTransport: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    dxBarStatic: TdxBarStatic;
    SumTransportAdd: TcxGridDBColumn;
    SumTransportAddLong: TcxGridDBColumn;
    SumTransportTaxi: TcxGridDBColumn;
    InvNumber_Reestr: TcxGridDBColumn;
    UnitName_car: TcxGridDBColumn;
    UnitName_route: TcxGridDBColumn;
    TotalCountKg_Reestr_zp: TcxGridDBColumn;
    cbIsMonth: TcxCheckBox;
    actRefreshMonth: TdsdDataSetRefresh;
    PersonalServiceListName_find: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_TransportForm);

end.
