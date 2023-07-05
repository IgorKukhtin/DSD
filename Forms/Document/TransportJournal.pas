unit TransportJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxImageComboBox, Vcl.Menus, dsdAddOn, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarExtItems, ChoicePeriod, cxLabel, cxCurrencyEdit, cxButtonEdit, dsdGuides;

type
  TTransportJournalForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    CarTrailerName: TcxGridDBColumn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    actComplete: TdsdChangeMovementStatus;
    spMovementComplete: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    bbComplete: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    spMovementUnComplete: TdsdStoredProc;
    bbUnComplete: TdxBarButton;
    N2: TMenuItem;
    bbDelete: TdxBarButton;
    actSetErased: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    bbBarStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PersonalDriverName: TcxGridDBColumn;
    StartRunPlan: TcxGridDBColumn;
    EndRunPlan: TcxGridDBColumn;
    StartRun: TcxGridDBColumn;
    EndRun: TcxGridDBColumn;
    HoursWork: TcxGridDBColumn;
    HoursAdd: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    PersonalDriverMoreName: TcxGridDBColumn;
    UnitForwardingName: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    CarModelName: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    PersonalName: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    spMovementReComplete: TdsdStoredProc;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    spCompete: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    N6: TMenuItem;
    spUncomplete: TdsdExecStoredProc;
    actSimpleUncompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    N7: TMenuItem;
    spErased: TdsdExecStoredProc;
    actSimpleErased: TMultiAction;
    actSetErasedList: TMultiAction;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    actPrintFrom: TdsdPrintAction;
    actPrintTo: TdsdPrintAction;
    bbPrintFrom: TdxBarButton;
    bbPrintTo: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    AmountCost: TcxGridDBColumn;
    AmountMemberCost: TcxGridDBColumn;
    BranchCode_ProfitLoss: TcxGridDBColumn;
    BranchName_ProfitLoss: TcxGridDBColumn;
    spSelectPrintCost: TdsdStoredProc;
    actPrintCost: TdsdPrintAction;
    bbPrintCost: TdxBarButton;
    PartnerCount_no: TcxGridDBColumn;
    UnitName_Personal: TcxGridDBColumn;
    UnitName_PersonalMore: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransportJournalForm);

end.
