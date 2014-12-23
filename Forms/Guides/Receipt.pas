unit Receipt;

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
  TReceiptForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colValue: TcxGridDBColumn;
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
    clStartDate: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    clMain: TcxGridDBColumn;
    clPartionCount: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clPartionValue: TcxGridDBColumn;
    clName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clGoodsKindCompleteName: TcxGridDBColumn;
    clReceiptCostName: TcxGridDBColumn;
    clReceiptKindName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    cContractConditionKindName: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clsfcisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ContractConditionDS: TDataSource;
    ContractConditionCDS: TClientDataSet;
    spInsertUpdateReceiptChild: TdsdStoredProc;
    spSelectReceiptChild: TdsdStoredProc;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    InsertRecordCCK: TInsertRecord;
    bbInsertRecCCK: TdxBarButton;
    actContractCondition: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    PaidKindChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    clCode: TcxGridDBColumn;
    ChildViewAddOn: TdsdDBViewAddOn;
    clBonusKindName: TcxGridDBColumn;
    BonusKindChoiceForm: TOpenChoiceForm;
    colComment: TcxGridDBColumn;
    clccInfoMoneyName: TcxGridDBColumn;
    InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm;
    clValueCost: TcxGridDBColumn;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    PersonalCollationChoiceForm: TOpenChoiceForm;
    BankAccountChoiceForm: TOpenChoiceForm;
    ContractTagChoiceForm: TOpenChoiceForm;
    PersonalChoiceForm: TOpenChoiceForm;
    clTaxExit: TcxGridDBColumn;
    bbStartDate: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    bbEndDate: TdxBarControlContainerItem;
    bbIsEndDate: TdxBarControlContainerItem;
    bbIsPeriod: TdxBarControlContainerItem;
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
  RegisterClass(TReceiptForm);

end.
