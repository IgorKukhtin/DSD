unit Report_Account;

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
  cxButtonEdit, ChoicePeriod, cxLabel;

type
  TReport_AccountForm = class(TParentForm)
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
    CarCode: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    SummOut: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    edAccount: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel2: TcxLabel;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    AccountGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    CarModelName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    PersonalCode_inf: TcxGridDBColumn;
    PersonalName_inf: TcxGridDBColumn;
    CarModelName_inf: TcxGridDBColumn;
    CarCode_inf: TcxGridDBColumn;
    CarName_inf: TcxGridDBColumn;
    RouteCode_inf: TcxGridDBColumn;
    RouteName_inf: TcxGridDBColumn;
    UnitCode_inf: TcxGridDBColumn;
    UnitName_inf: TcxGridDBColumn;
    BranchName_inf: TcxGridDBColumn;
    BranchCode_inf: TcxGridDBColumn;
    BusinesCode_inf: TcxGridDBColumn;
    BusinesName_inf: TcxGridDBColumn;
    AccountGroupCode: TcxGridDBColumn;
    AccountGroupName: TcxGridDBColumn;
    AccountDirectionCode: TcxGridDBColumn;
    AccountDirectionName: TcxGridDBColumn;
    AccountCode: TcxGridDBColumn;
    AccountName: TcxGridDBColumn;
    AccountGroupCode_inf: TcxGridDBColumn;
    AccountGroupName_inf: TcxGridDBColumn;
    AccountDirectionCode_inf: TcxGridDBColumn;
    AccountDirectionName_inf: TcxGridDBColumn;
    AccountCode_inf: TcxGridDBColumn;
    AccountName_inf: TcxGridDBColumn;
    AccountName_All: TcxGridDBColumn;
    AccountName_All_inf: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_AccountForm);

end.
