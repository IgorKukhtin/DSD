unit Contract;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, DataModul, ParentForm,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxButtonEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, ChoicePeriod, dsdDB, dsdAction, System.Classes, Vcl.ActnList,
  dxBarExtItems, dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient,
  cxCheckBox, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, Vcl.Controls, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TContractForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clInvNumber: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    clSigningDate: TcxGridDBColumn;
    clStartDate: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    clContractKindName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clJuridicalCode: TcxGridDBColumn;
    clInvNumberArchive: TcxGridDBColumn;
    clPersonalName: TcxGridDBColumn;
    clInfoMoneyGroupCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationCode: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clAreaName: TcxGridDBColumn;
    clContractArticleName: TcxGridDBColumn;
    clContractStateKindName: TcxGridDBColumn;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    cContractConditionKindName: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clsfcisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ContractConditionDS: TDataSource;
    ContractConditionCDS: TClientDataSet;
    spInsertUpdateContractCondition: TdsdStoredProc;
    spSelectContractCondition: TdsdStoredProc;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    InsertRecordCCK: TInsertRecord;
    bbInsertRecCCK: TdxBarButton;
    actContractCondition: TdsdUpdateDataSet;
    clOKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    PaidKindChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    clJuridicalBasisName: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    ChildViewAddOn: TdsdDBViewAddOn;
    clBonusKindName: TcxGridDBColumn;
    BonusKindChoiceForm: TOpenChoiceForm;
    colComment: TcxGridDBColumn;
    clBankAccountExternal: TcxGridDBColumn;
    clBankName: TcxGridDBColumn;
    clInsertName: TcxGridDBColumn;
    clUpdateName: TcxGridDBColumn;
    clInsertDate: TcxGridDBColumn;
    clUpdateDate: TcxGridDBColumn;
    clIsDefault: TcxGridDBColumn;
    clccInfoMoneyName: TcxGridDBColumn;
    InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm;
    clIsStandart: TcxGridDBColumn;
    clPersonalTradeName: TcxGridDBColumn;
    clPersonalCollationName: TcxGridDBColumn;
    clBankAccountName: TcxGridDBColumn;
    clContractTagName: TcxGridDBColumn;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    PersonalCollationChoiceForm: TOpenChoiceForm;
    BankAccountChoiceForm: TOpenChoiceForm;
    ContractTagChoiceForm: TOpenChoiceForm;
    clContractKeyId: TcxGridDBColumn;
    clIsPersonal: TcxGridDBColumn;
    clIsUnique: TcxGridDBColumn;
    clDocumentCount: TcxGridDBColumn;
    clDateDocument: TcxGridDBColumn;
    PersonalChoiceForm: TOpenChoiceForm;
    clJuridicalGroupName: TcxGridDBColumn;
    deStart: TcxDateEdit;
    cxlEnd: TcxLabel;
    deEnd: TcxDateEdit;
    cbPeriod: TcxCheckBox;
    bbStartDate: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    bbEndDate: TdxBarControlContainerItem;
    bbIsEndDate: TdxBarControlContainerItem;
    bbIsPeriod: TdxBarControlContainerItem;
    cbEndDate: TcxCheckBox;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractForm);

end.
