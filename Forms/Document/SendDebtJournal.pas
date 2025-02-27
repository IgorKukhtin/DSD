unit SendDebtJournal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, ParentForm, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, Data.DB, cxDBData, cxImageComboBox, cxCurrencyEdit, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dsdDB, dsdAction, System.Classes, Vcl.ActnList,
  dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.Controls, Vcl.ExtCtrls, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns, cxButtonEdit, dsdGuides,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TSendDebtJournalForm = class(TParentForm)
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
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
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    actComplete: TdsdChangeMovementStatus;
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
    Amount: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    spMovementReCompleteAll: TdsdStoredProc;
    bbReCompleteAll: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    JuridicalFromCode: TcxGridDBColumn;
    JuridicalFromName: TcxGridDBColumn;
    FromOKPO: TcxGridDBColumn;
    PaidKindFromName: TcxGridDBColumn;
    ContractFromName: TcxGridDBColumn;
    InfoMoneyFromCode: TcxGridDBColumn;
    InfoMoneyGroupFromName: TcxGridDBColumn;
    InfoMoneyDestinationFromName: TcxGridDBColumn;
    InfoMoneyFromName: TcxGridDBColumn;
    JuridicalToCode: TcxGridDBColumn;
    JuridicalToName: TcxGridDBColumn;
    ToOKPO: TcxGridDBColumn;
    PaidKindToName: TcxGridDBColumn;
    ContractToName: TcxGridDBColumn;
    InfoMoneyToCode: TcxGridDBColumn;
    InfoMoneyGroupToName: TcxGridDBColumn;
    InfoMoneyDestinationToName: TcxGridDBColumn;
    InfoMoneyToName: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    actMovementItemContainer: TdsdOpenForm;
    bbMovementItemContainer: TdxBarButton;
    bbAddBonus: TdxBarButton;
    BranchFromName: TcxGridDBColumn;
    BranchToName: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    spUpdate_isCopy: TdsdStoredProc;
    actIsCopy: TdsdExecStoredProc;
    isCopy: TcxGridDBColumn;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    FormParams: TdsdFormParams;
    mactIsCopy: TMultiAction;
    actIsCopyTrue: TdsdExecStoredProc;
    mactInsertProfitLossService: TMultiAction;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actShowErased: TBooleanStoredProcAction;
    bbiShowErased: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendDebtJournalForm);

end.
