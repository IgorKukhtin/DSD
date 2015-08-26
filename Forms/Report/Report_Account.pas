unit Report_Account;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, ChoicePeriod, cxLabel, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

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
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
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
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    RouteName_inf: TcxGridDBColumn;
    UnitName_inf: TcxGridDBColumn;
    BranchName_inf: TcxGridDBColumn;
    BusinessName_inf: TcxGridDBColumn;
    AccountCode: TcxGridDBColumn;
    AccountCode_inf: TcxGridDBColumn;
    AccountName_All: TcxGridDBColumn;
    AccountName_All_inf: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ProfitLossName_All_inf: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    ObjectCode_Destination: TcxGridDBColumn;
    ObjectName_Destination: TcxGridDBColumn;
    ObjectCode_Direction: TcxGridDBColumn;
    ObjectName_Direction: TcxGridDBColumn;
    JuridicalBasisName: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    DescName_Direction: TcxGridDBColumn;
    DescName_Destination: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    bbStatic: TdxBarButton;
    bbOpenDocument: TdxBarButton;
    FormParams: TdsdFormParams;
    cxLabel4: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    AccountGroupGuides: TdsdGuides;
    ceAccountDirection: TcxButtonEdit;
    cxLabel5: TcxLabel;
    AccountDirectionGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceProfitLossGroup: TcxButtonEdit;
    ProfitLossGroupGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceProfitLossDirection: TcxButtonEdit;
    ProfitLossDirectionGuides: TdsdGuides;
    BranchGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    ceProfitLoss: TcxButtonEdit;
    ProfitLossGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceBranch: TcxButtonEdit;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_AccountForm);

end.
