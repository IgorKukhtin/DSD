unit Transport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxSplitter, cxCurrencyEdit, DataModul, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxBlobEdit, cxImageComboBox,
  Vcl.Grids, Vcl.DBGrids;

type
  TTransportForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edBranchForwarding: TcxButtonEdit;
    edCar: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesCar: TdsdGuides;
    spGet: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    RouteCode: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrintFrom: TdsdPrintAction;
    EndOdometre: TcxGridDBColumn;
    RouteKindName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    FreightName: TcxGridDBColumn;
    StartOdometre: TcxGridDBColumn;
    cxGridChild: TcxGrid;
    cxGridChildDBTableView: TcxGridDBTableView;
    FuelCode: TcxGridDBColumn;
    FuelName: TcxGridDBColumn;
    colñhAmount: TcxGridDBColumn;
    Amount_calc: TcxGridDBColumn;
    IsCalculated: TcxGridDBColumn;
    cxGridChildLevel: TcxGridLevel;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    cxSplitterChild: TcxSplitter;
    RateFuelKindName: TcxGridDBColumn;
    GridToExcel: TdsdGridToExcel;
    edPersonalDriver: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPersonalDriverMore: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edCarTrailer: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edStartRunPlan: TcxDateEdit;
    cxLabel8: TcxLabel;
    edEndRunPlan: TcxDateEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    edStartRun: TcxDateEdit;
    cxLabel11: TcxLabel;
    edEndRun: TcxDateEdit;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    edHoursWork: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edHoursAdd: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    spInsertUpdateMovement: TdsdStoredProc;
    GuidesCarTrailer: TdsdGuides;
    GuidesPersonalDriver: TdsdGuides;
    GuidesPersonalDriverMore: TdsdGuides;
    GuidesBranchForwarding: TdsdGuides;
    ColdHour: TcxGridDBColumn;
    ColdDistance: TcxGridDBColumn;
    AmountColdHour: TcxGridDBColumn;
    AmountColdDistance: TcxGridDBColumn;
    AmountFuel: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    GuidesFiller: TGuidesFiller;
    HeaderSaver: THeaderSaver;
    actInsertUpdateMovement: TdsdExecStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    bbPrintFrom: TdxBarButton;
    bbStatic: TdxBarStatic;
    bbGridToExel: TdxBarButton;
    bbInsertUpdateMovement: TdxBarButton;
    RefreshAddOn: TRefreshAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    RouteChoiceForm: TOpenChoiceForm;
    MasterViewAddOn: TdsdDBViewAddOn;
    FreightChoiceForm: TOpenChoiceForm;
    ChildViewAddOn: TdsdDBViewAddOn;
    actUpdateChildDS: TdsdUpdateDataSet;
    Number: TcxGridDBColumn;
    RateFuelKindTax: TcxGridDBColumn;
    InsertRecord: TInsertRecord;
    bbAddRoute: TdxBarButton;
    SetErased: TdsdUpdateErased;
    bbErased: TdxBarButton;
    SetUnErased: TdsdUpdateErased;
    bbUnErased: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    cxTabSheetIncome: TcxTabSheet;
    cxGridIncome: TcxGrid;
    cxGridIncomeDBTableView: TcxGridDBTableView;
    clincInvNumber: TcxGridDBColumn;
    clincStatusCode: TcxGridDBColumn;
    clincOperDate: TcxGridDBColumn;
    clincFromName: TcxGridDBColumn;
    clincPaidKindName: TcxGridDBColumn;
    clincPriceWithVAT: TcxGridDBColumn;
    clincVATPercent: TcxGridDBColumn;
    clincGoodsCode: TcxGridDBColumn;
    cxGridIncomeLevel: TcxGridLevel;
    IncomeCDS: TClientDataSet;
    IncomeDS: TDataSource;
    spSelectMIIncome: TdsdStoredProc;
    spInsertUpdateMIIncome: TdsdStoredProc;
    clincGoodsName: TcxGridDBColumn;
    clincFuelName: TcxGridDBColumn;
    clincAmount: TcxGridDBColumn;
    clincPrice: TcxGridDBColumn;
    clincCountForPrice: TcxGridDBColumn;
    clincAmountSumm: TcxGridDBColumn;
    clincAmountSummTotal: TcxGridDBColumn;
    InsertRecordIncome: TInsertRecord;
    SourceFuel_ObjectChoiceForm: TOpenChoiceForm;
    bbAddIncome: TdxBarButton;
    actUpdateIncomeDS: TdsdUpdateDataSet;
    ceStatus: TcxButtonEdit;
    cxLabel15: TcxLabel;
    clincInvNumberPartner: TcxGridDBColumn;
    clincRouteName: TcxGridDBColumn;
    PaidKindChoiceForm: TOpenChoiceForm;
    GoodsChoiceForm: TOpenChoiceForm;
    RouteIncomeChoiceForm: TOpenChoiceForm;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    SetErasedIncome: TdsdUpdateErased;
    SetUnErasedIncome: TdsdUpdateErased;
    spErasedMIIncome: TdsdStoredProc;
    spUnErasedMIIncome: TdsdStoredProc;
    bbErasedIncome: TdxBarButton;
    bbUnErasedIncome: TdxBarButton;
    IsErased: TcxGridDBColumn;
    clincIsErased: TcxGridDBColumn;
    IncomeViewAddOn: TdsdDBViewAddOn;
    isMasterFuel: TcxGridDBColumn;
    DistanceFuelChild: TcxGridDBColumn;
    actUnCompleteIncome: TdsdChangeMovementStatus;
    actCompleteIncome: TdsdChangeMovementStatus;
    actSetErasedIncome: TdsdChangeMovementStatus;
    bbCompleteIncome: TdxBarButton;
    bbUnCompleteIncome: TdxBarButton;
    bbSetErasedIncome: TdxBarButton;
    spMovementCompleteIncome: TdsdStoredProc;
    spMovementUnCompleteIncome: TdsdStoredProc;
    spMovementSetErasedIncome: TdsdStoredProc;
    RatioFuel: TcxGridDBColumn;
    DeleteMovement: TChangeGuidesStatus;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    clincChangePrice: TcxGridDBColumn;
    clincContractName: TcxGridDBColumn;
    Amount_Distance_calc: TcxGridDBColumn;
    Amount_ColdHour_calc: TcxGridDBColumn;
    Amount_ColdDistance_calc: TcxGridDBColumn;
    cxTabSheetReport: TcxTabSheet;
    cxGridReport: TcxGrid;
    cxGridReportDBTableView: TcxGridDBTableView;
    clrpStatusCode: TcxGridDBColumn;
    clrpKindName: TcxGridDBColumn;
    clrpAmount_20401: TcxGridDBColumn;
    clrpAmount_Start: TcxGridDBColumn;
    clrpAmount_In: TcxGridDBColumn;
    clrpAmount_Out: TcxGridDBColumn;
    clrpAmount_End: TcxGridDBColumn;
    cxGridReportLevel: TcxGridLevel;
    ReportCDS: TClientDataSet;
    ReportDS: TDataSource;
    spSelectMiReport: TdsdStoredProc;
    RouteKindName_Freight: TcxGridDBColumn;
    RouteKindFreightChoiceForm: TOpenChoiceForm;
    TotalRefresh: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrintHeader: TdsdStoredProc;
    actPrintTo: TdsdPrintAction;
    actPrintAdmin: TdsdPrintAction;
    bbPrintTo: TdxBarButton;
    bbPrintAdmin: TdxBarButton;
    cxLabel16: TcxLabel;
    edPersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    Comment: TcxGridDBColumn;
    WeightTranspor: TcxGridDBColumn;
    DistanceWeightTransport: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    UnitName: TcxGridDBColumn;
    UnitChoiceForm: TOpenChoiceForm;
    colchUnitName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    MIProtocolOpenForm: TdsdOpenForm;
    MIChildProtocolOpenForm: TdsdOpenForm;
    bbMIProtocol: TdxBarButton;
    bbMIChildProtocol: TdxBarButton;
    spErasedMIChild: TdsdStoredProc;
    SetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    spUnErasedMIChild: TdsdStoredProc;
    SetUnErasedChild: TdsdUpdateErased;
    bbSetUnErasedChild: TdxBarButton;
    colchisErased: TcxGridDBColumn;
    actPrintRoadList: TdsdPrintAction;
    bbPrintRoadList: TdxBarButton;
    cxLabel17: TcxLabel;
    edPartnerCount: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edStartStop: TcxDateEdit;
    cxLabel19: TcxLabel;
    edEndStop: TcxDateEdit;
    cxLabel20: TcxLabel;
    edHoursStop: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    edHoursMove: TcxCurrencyEdit;
    edCommentStop: TcxTextEdit;
    cxLabel22: TcxLabel;
    spUpdate_Confirmed_Yes: TdsdStoredProc;
    spUpdate_Confirmed_No: TdsdStoredProc;
    actUpdate_Confirmed_Yes: TdsdExecStoredProc;
    actUpdate_Confirmed_No: TdsdExecStoredProc;
    bbInsertUpdate_Confirmed_Yes: TdxBarButton;
    bbInsertUpdate_Confirmed_No: TdxBarButton;
    cxLabel23: TcxLabel;
    edDate_UserConfirmedKind: TcxDateEdit;
    cxLabel24: TcxLabel;
    edUserName_ConfirmedKind: TcxButtonEdit;
    actUpdate_PartnerCount: TdsdExecStoredProc;
    spUpdate_PartnerCount: TdsdStoredProc;
    bbUpdate_PartnerCount: TdxBarButton;
    spSelectPrintCost: TdsdStoredProc;
    actPrintCost: TdsdPrintAction;
    bbPrintCost: TdxBarButton;
    spUpdateChangePriceUser: TdsdStoredProc;
    actUpdateChangePriceUser: TdsdDataSetRefresh;
    actUpdateChangePriceUserDialog: TExecuteDialog;
    macUpdateChangePriceUserDialog: TMultiAction;
    bbUpdateChangePriceUserDialog: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransportForm);

end.
