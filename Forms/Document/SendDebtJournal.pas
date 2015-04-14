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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns;

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
    colStatus: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
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
    clAmount: TcxGridDBColumn;
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
    clJuridicalFromCode: TcxGridDBColumn;
    clJuridicalFromName: TcxGridDBColumn;
    clFromOKPO: TcxGridDBColumn;
    clPaidKindFromName: TcxGridDBColumn;
    clContractFromName: TcxGridDBColumn;
    clInfoMoneyFromCode: TcxGridDBColumn;
    clInfoMoneyGroupFromName: TcxGridDBColumn;
    clInfoMoneyDestinationFromName: TcxGridDBColumn;
    clInfoMoneyFromName: TcxGridDBColumn;
    clJuridicalToCode: TcxGridDBColumn;
    clJuridicalToName: TcxGridDBColumn;
    clToOKPO: TcxGridDBColumn;
    clPaidKindToName: TcxGridDBColumn;
    clContractToName: TcxGridDBColumn;
    clInfoMoneyToCode: TcxGridDBColumn;
    clInfoMoneyGroupToName: TcxGridDBColumn;
    clInfoMoneyDestinationToName: TcxGridDBColumn;
    clInfoMoneyToName: TcxGridDBColumn;
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
    clisCopy: TcxGridDBColumn;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    FormParams: TdsdFormParams;
    mactIsCopy: TMultiAction;
    actIsCopyTrue: TdsdExecStoredProc;
    mactInsertProfitLossService: TMultiAction;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendDebtJournalForm);

end.
