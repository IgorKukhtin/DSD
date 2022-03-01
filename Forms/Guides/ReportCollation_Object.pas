unit ReportCollation_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  DataModul, cxButtonEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  ChoicePeriod, cxCurrencyEdit, dsdGuides, cxImageComboBox;

type
  TReportCollation_ObjectForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    DBViewAddOn: TdsdDBViewAddOn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    cxlEnd: TcxLabel;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    JuridicalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    BuhName: TcxGridDBColumn;
    BuhDate: TcxGridDBColumn;
    isBuh: TcxGridDBColumn;
    idBarCode: TcxGridDBColumn;
    ObjectCode: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    isDiff: TcxGridDBColumn;
    StartRemainsRep: TcxGridDBColumn;
    spUpdateRemains: TdsdStoredProc;
    actUpdateRemains: TdsdUpdateDataSet;
    spUpdateRemainsCalc: TdsdStoredProc;
    bbUpdateRemainsCalc: TdxBarButton;
    macUpdateRemainsCalc: TMultiAction;
    actUpdateRemainsCalc: TdsdExecStoredProc;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    bbUpdateRemainsByRep: TdxBarButton;
    spUpdateRemainsByRep: TdsdStoredProc;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    macUpdateRemainsByRep: TMultiAction;
    actUpdateRemainsByRep: TdsdExecStoredProc;
    isStartRemainsRep: TcxGridDBColumn;
    isEndRemainsRep: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    UnitName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    cxLabel20: TcxLabel;
    edContractTag: TcxButtonEdit;
    ContractTagGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    spUpdate_Buh_Yes: TdsdStoredProc;
    spUpdate_Buh_No: TdsdStoredProc;
    actUpdate_Buh_Yes: TdsdExecStoredProc;
    actUpdate_Buh_No: TdsdExecStoredProc;
    bbUpdate_Buh_Yes: TdxBarButton;
    bbUpdate_Buh_No: TdxBarButton;
    macUpdate_Buh_Yes: TMultiAction;
    macUpdate_Buh_No: TMultiAction;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actPrintPack_two: TdsdPrintAction;
    spSelectPrintPack: TdsdStoredProc;
    mactPrintPack_two: TMultiAction;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrintPack_two: TdxBarButton;
    AreaContractName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    actPrintPack_one: TdsdPrintAction;
    mactPrintPack_one: TMultiAction;
    bbPrintPack_one: TdxBarButton;
    actPrintPack_one_ff: TdsdPrintAction;
    spSelectReport: TdsdStoredProc;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    ItemName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    MovementComment: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    PartionMovementName: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
    cxGridDBColumn1: TcxGridDBColumn;
    InvNumber_Transport: TcxGridDBColumn;
    OperDate_Transport: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    StartRemains_Currency: TcxGridDBColumn;
    Debet_Currency: TcxGridDBColumn;
    Kredit_Currency: TcxGridDBColumn;
    EndRemains_Currency: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    ContractStateKindCode: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    ContractComment: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    cxGridDBColumn5: TcxGridDBColumn;
    AccountName: TcxGridDBColumn;
    MovementSumm: TcxGridDBColumn;
    MovementSumm_Currency: TcxGridDBColumn;
    OperationSort: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actPrintPack_ff_one: TdsdPrintAction;
    spJuridicalBalance: TdsdStoredProc;
    FormParams: TdsdFormParams;
    mactPrintPackList_ff_one: TMultiAction;
    actspSelectReport: TdsdExecStoredProc;
    bbPrintPackList_ff: TdxBarButton;
    actPrintPack_ff_two: TdsdPrintAction;
    mactPrintPackList_ff_two: TMultiAction;
    bb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

initialization
  RegisterClass(TReportCollation_ObjectForm);

end.
