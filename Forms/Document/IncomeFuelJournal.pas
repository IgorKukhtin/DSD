unit IncomeFuelJournal;

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
  dxBarExtItems, cxCurrencyEdit, ChoicePeriod, System.Contnrs, cxLabel,
  cxButtonEdit, dsdGuides, dsdCommon;

type
  TIncomeFuelJournalForm = class(TParentForm)
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
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
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
    PriceWithVAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    RouteName: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    InvNumberMaster: TcxGridDBColumn;
    OperDateMaster: TcxGridDBColumn;
    ChangePrice: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    OperDatePartner: TcxGridDBColumn;
    actReCompleteAll: TdsdExecStoredProc;
    bbReCompleteAll: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    FuelName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    FuelCode: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    TotalCountPartner: TcxGridDBColumn;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    StartOdometre: TcxGridDBColumn;
    EndOdometre: TcxGridDBColumn;
    AmountFuel: TcxGridDBColumn;
    Reparation: TcxGridDBColumn;
    LimitMoney: TcxGridDBColumn;
    LimitDistance: TcxGridDBColumn;
    LimitMoneyChange: TcxGridDBColumn;
    LimitDistanceChange: TcxGridDBColumn;
    Distance: TcxGridDBColumn;
    DistanceReal: TcxGridDBColumn;
    FuelCalc: TcxGridDBColumn;
    PriceCalc: TcxGridDBColumn;
    SummReal: TcxGridDBColumn;
    FuelReal: TcxGridDBColumn;
    FuelRealCalc: TcxGridDBColumn;
    FuelDiff: TcxGridDBColumn;
    FuelSummDiff: TcxGridDBColumn;
    SummDiff: TcxGridDBColumn;
    SummDiffTotal: TcxGridDBColumn;
    SummReparation: TcxGridDBColumn;
    SummPersonal: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    spCompete: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    N3: TMenuItem;
    N4: TMenuItem;
    spUncomplete: TdsdExecStoredProc;
    actSimpleUncompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    N5: TMenuItem;
    spErased: TdsdExecStoredProc;
    actSimpleErased: TMultiAction;
    actSetErasedList: TMultiAction;
    N6: TMenuItem;
    spMovementReComplete: TdsdStoredProc;
    spReCompete: TdsdExecStoredProc;
    actSimpleReCompleteList: TMultiAction;
    actReCompleteList: TMultiAction;
    N7: TMenuItem;
    ExecuteDialog: TExecuteDialog;
    spUpdate_ChangePrice: TdsdStoredProc;
    actUpdate_ChangePrice: TdsdExecStoredProc;
    mactUpdate_ChangePrice: TMultiAction;
    bbUpdate_ChangePrice: TdxBarButton;
    macUpdate_ChangePriceList: TMultiAction;
    strSign: TcxGridDBColumn;
    strSignNo: TcxGridDBColumn;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    mactInsertUpdateMISignYes: TMultiAction;
    mactInsertUpdateMISignYesList: TMultiAction;
    bbInsertUpdateMISignYesList: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    spInsertUpdateMISign_No: TdsdStoredProc;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    mactInsertUpdateMISignNo: TMultiAction;
    mactInsertUpdateMISignNoList: TMultiAction;
    bbInsertUpdateMISignNoList: TdxBarButton;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    JuridicalName_from: TcxGridDBColumn;
    isChangePriceUser: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeFuelJournalForm);

end.
