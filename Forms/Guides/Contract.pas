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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, Vcl.ExtCtrls,
  cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, ExternalLoad, dsdCommon, dsdGuides;

type
  TContractForm = class(TParentForm)
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
    bsContract: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    ContractConditionKindName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    clsfcisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ContractConditionDS: TDataSource;
    CDSContractCondition: TClientDataSet;
    spInsertUpdateContractCondition: TdsdStoredProc;
    spSelectContractCondition: TdsdStoredProc;
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
    ChildViewAddOn: TdsdDBViewAddOn;
    BonusKindName: TcxGridDBColumn;
    BonusKindChoiceForm: TOpenChoiceForm;
    colComment: TcxGridDBColumn;
    clccInfoMoneyName: TcxGridDBColumn;
    InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    PersonalCollationChoiceForm: TOpenChoiceForm;
    BankAccountChoiceForm: TOpenChoiceForm;
    ContractTagChoiceForm: TOpenChoiceForm;
    PersonalChoiceForm: TOpenChoiceForm;
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
    JuridicalDocumentChoiceForm: TOpenChoiceForm;
    cxGridPartner: TcxGrid;
    cxGridDBTableViewPartner: TcxGridDBTableView;
    PartnerName: TcxGridDBColumn;
    cxGridLevePartner: TcxGridLevel;
    CDSContractPartner: TClientDataSet;
    DataSourcePartner: TDataSource;
    spSelectContractPartner: TdsdStoredProc;
    spInsertUpdateContractPartner: TdsdStoredProc;
    PartnerChoiceForm: TOpenChoiceForm;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    InsertRecordCP: TInsertRecord;
    bbRecordCP: TdxBarButton;
    colCode: TcxGridDBColumn;
    dsdUpdateDataSet1: TdsdUpdateDataSet;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    Panel: TPanel;
    cxGridGoods: TcxGrid;
    cxGridDBTableViewGoods: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    cxGridLevelGoods: TcxGridLevel;
    CDSContractGoods: TClientDataSet;
    DataSourceGoods: TDataSource;
    dsdDBViewAddOnGoods: TdsdDBViewAddOn;
    spSelectContractGoods: TdsdStoredProc;
    spInsertUpdateContractGoods: TdsdStoredProc;
    GoodsKindName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    InsertRecordGoods: TInsertRecord;
    GoodsChoiceForm: TOpenChoiceForm;
    bbRecordGoods: TdxBarButton;
    GoodsKindChoiceForm: TOpenChoiceForm;
    actUpdateDSGoods: TdsdUpdateDataSet;
    PartnerCode: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    spErasedUnErasedPartner: TdsdStoredProc;
    spErasedUnErasedGoods: TdsdStoredProc;
    dsdSetErasedPartner: TdsdUpdateErased;
    dsdSetErasedGoods: TdsdUpdateErased;
    bbSetErasedPartner: TdxBarButton;
    bbSetErasedGoods: TdxBarButton;
    clPisErased: TcxGridDBColumn;
    clGisErased: TcxGridDBColumn;
    dsdSetUnErasedPartner: TdsdUpdateErased;
    dsdSetUnErasedGoods: TdsdUpdateErased;
    bbSetUnErasedPartner: TdxBarButton;
    bbSetUnErasedGoods: TdxBarButton;
    ProtocolOpenFormCondition: TdsdOpenForm;
    ProtocolOpenFormPartner: TdsdOpenForm;
    ProtocolOpenFormGoods: TdsdOpenForm;
    bbProtocolOpenFormCondition: TdxBarButton;
    bbProtocolOpenFormPartner: TdxBarButton;
    bbProtocolOpenFormGoods: TdxBarButton;
    isConnected: TcxGridDBColumn;
    GoodsPropertyChoiceForm: TOpenChoiceForm;
    Panel1: TPanel;
    ContractSendName: TcxGridDBColumn;
    ContractSendChoiceForm: TOpenChoiceForm;
    spUpdateDefaultOut: TdsdStoredProc;
    actUpdateVat: TdsdExecStoredProc;
    bbCustom: TdxBarButton;
    JuridicalInvoiceChoiceForm: TOpenChoiceForm;
    spUpdateVat: TdsdStoredProc;
    actUpdateDefaultOut: TdsdExecStoredProc;
    bbUpdateDefaultOut: TdxBarButton;
    colStartDate: TcxGridDBColumn;
    colEndDate: TcxGridDBColumn;
    ccPaidKindName: TcxGridDBColumn;
    PaidKindChoiceForm——: TOpenChoiceForm;
    spUpdate_isWMS: TdsdStoredProc;
    actUpdate_isWMS: TdsdExecStoredProc;
    bbUpdate_isWMS: TdxBarButton;
    clPercentRetBonus: TcxGridDBColumn;
    spUpdateStateKind_Closed: TdsdStoredProc;
    actUpdateStateKind_Closed: TdsdExecStoredProc;
    macUpdateStateKind_Closed_list: TMultiAction;
    macUpdateStateKind_Closed: TMultiAction;
    bbUpdateStateKind_Closed: TdxBarButton;
    actRefreshContract: TdsdDataSetRefresh;
    actContractGoodsChoiceOpenForm: TdsdOpenForm;
    bbContractGoodsChoiceOpenForm: TdxBarButton;
    CCPartner: TcxGrid;
    cxGridDBTableViewCCPartner: TcxGridDBTableView;
    ccpCode: TcxGridDBColumn;
    ccpPartnerCode: TcxGridDBColumn;
    ccpPartnerName: TcxGridDBColumn;
    ccpisErased: TcxGridDBColumn;
    cxGridLevelCCPartner: TcxGridLevel;
    CCPartnerDS: TDataSource;
    CCPartnerCDS: TClientDataSet;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    dsdDBViewAddOnCCPartner: TdsdDBViewAddOn;
    spInsertUpdateCCPartner: TdsdStoredProc;
    spSelectCCPartner: TdsdStoredProc;
    spErasedUnErasedCCPartner: TdsdStoredProc;
    PartnerContractConditionChoiceForm: TOpenChoiceForm;
    actUpdateDataSetCCPartner: TdsdUpdateDataSet;
    InsertRecordCCPartner: TInsertRecord;
    dsdSetErasedCCPartner: TdsdUpdateErased;
    dsdSetUnErased——Partner: TdsdUpdateErased;
    bbInsertRecordCCPartner: TdxBarButton;
    bbdsdSetErasedCCPartner: TdxBarButton;
    bbdsdSetUnErased——Partner: TdxBarButton;
    ProtocolOpenFormCCPartner: TdsdOpenForm;
    bbProtocolOpenFormCCPartner: TdxBarButton;
    spDelete_ContractSend: TdsdStoredProc;
    actDelete_ContractSend: TdsdExecStoredProc;
    bbDelete_ContractSend: TdxBarButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    cxSplitter3: TcxSplitter;
    cxGridContractPriceList: TcxGrid;
    cxGridDBTableViewContractPriceList: TcxGridDBTableView;
    isErased_ch6: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ContractPriceListDS: TDataSource;
    ContractPriceListCDS: TClientDataSet;
    spSelect_ContractPriceList: TdsdStoredProc;
    dsdDBViewAddOnContractPriceList: TdsdDBViewAddOn;
    spInsertUpdate_ContractPriceList: TdsdStoredProc;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ContractStateKindName: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    InvNumberArchive: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    JuridicalGroupName: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    JuridicalDocumentName: TcxGridDBColumn;
    JuridicalInvoiceName: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    SigningDate: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    EndDate_real: TcxGridDBColumn;
    EndDate_Term: TcxGridDBColumn;
    ContractTermKindName: TcxGridDBColumn;
    Term: TcxGridDBColumn;
    ContractKindName: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalCollationName: TcxGridDBColumn;
    PersonalSigningName: TcxGridDBColumn;
    AreaContractName: TcxGridDBColumn;
    ContractArticleName: TcxGridDBColumn;
    JuridicalBasisName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    BankAccountExternal: TcxGridDBColumn;
    BankAccountPartner: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    isWMS: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    GLNCode: TcxGridDBColumn;
    clPartnerCode: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    DayTaxSummary: TcxGridDBColumn;
    IsStandart: TcxGridDBColumn;
    IsPersonal: TcxGridDBColumn;
    IsDefault: TcxGridDBColumn;
    IsDefaultOut: TcxGridDBColumn;
    IsUnique: TcxGridDBColumn;
    DocumentCount: TcxGridDBColumn;
    DateDocument: TcxGridDBColumn;
    ContractKeyId: TcxGridDBColumn;
    ContractStateKindName_Key: TcxGridDBColumn;
    Code_Key: TcxGridDBColumn;
    InvNumber_Key: TcxGridDBColumn;
    PriceListGoodsName: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    isVat: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Comment_ch6: TcxGridDBColumn;
    PriceListName_ch6: TcxGridDBColumn;
    InsertRecord_ContractPriceList: TInsertRecord;
    OpenForm_ContractPriceList: TdsdOpenForm;
    actSetErased_ContractPriceList: TdsdUpdateErased;
    actSetUnErased_ContractPriceList: TdsdUpdateErased;
    spErasedUnErased_ContractPriceList: TdsdStoredProc;
    ContractPriceListChoiceForm: TOpenChoiceForm;
    bbInsertRecord_ContractPriceList: TdxBarButton;
    bbSetErased_ContractPriceList: TdxBarButton;
    bbSetUnErased_ContractPriceList: TdxBarButton;
    bbOpenForm_ContractPriceList: TdxBarButton;
    bsContractPriceList: TdxBarSubItem;
    UpdateDataSet_ContractPriceList: TdsdUpdateDataSet;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    bsContract2: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    bsContractCondition: TdxBarSubItem;
    bsContractPartner: TdxBarSubItem;
    bsContractConditionPartner: TdxBarSubItem;
    bsContractGoods: TdxBarSubItem;
    dsdSetErasedCC: TdsdUpdateErased;
    dsdSetUnErased——: TdsdUpdateErased;
    spErasedUnErasedCC: TdsdStoredProc;
    bbSetErasedCC: TdxBarButton;
    bbSetUnErased——: TdxBarButton;
    BranchName: TcxGridDBColumn;
    isRealEx: TcxGridDBColumn;
    spUpdate_isIrna: TdsdStoredProc;
    actUpdate_isIrna: TdsdExecStoredProc;
    macUpdate_isIrna_list: TMultiAction;
    macUpdate_isIrna: TMultiAction;
    bbUpdate_isIrna: TdxBarButton;
    actShowAll_CCPartner: TBooleanStoredProcAction;
    bbShowAll_CCPartner: TdxBarButton;
    actUpdate_CCP_Connected_Yes: TdsdExecStoredProc;
    macUpdate_CCP_Connected_Yes: TMultiAction;
    macUpdate_CCP_Connected_list_Yes: TMultiAction;
    spUpdate_CCP_Connected_Yes: TdsdStoredProc;
    macUpdate_CCP_Connected_list_No: TMultiAction;
    macUpdate_CCP_Connected_No: TMultiAction;
    bbUpdate_CCP_Connected_Yes: TdxBarButton;
    bbUpdate_CCP_Connected_No: TdxBarButton;
    actRefreshCCPartner: TdsdDataSetRefresh;
    actGridToExcelCCP: TdsdGridToExcel;
    bbGridToExcelCCP: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    isNotTareReturning: TcxGridDBColumn;
    StartDate_PriceList: TcxGridDBColumn;
    spGetImportSettingId_PriceList: TdsdStoredProc;
    actDoLoad_PriceList: TExecuteImportSettingsAction;
    actGetImportSetting_PriceList: TdsdExecStoredProc;
    macStartLoadPriceList: TMultiAction;
    bbStartLoadPriceList: TdxBarButton;
    ChangePercent: TcxGridDBColumn;
    ChangePercentPartner: TcxGridDBColumn;
    actInsertUpdateCP_grid: TdsdExecStoredProc;
    bbInsertUpdateCP_grid: TdxBarButton;
    spInsertUpdateContractPartner_connect: TdsdStoredProc;
    spGetImportSettingId_PriceListNew: TdsdStoredProc;
    actGetImportSetting_PriceListNew: TdsdExecStoredProc;
    macStartLoadPriceListNew: TMultiAction;
    bbStartLoadPriceListNew: TdxBarButton;
    GuidesPersonal_update: TdsdGuides;
    spUpdatePersonal: TdsdStoredProc;
    actUpdate_Personal: TdsdExecStoredProc;
    macUpdate_Personal_list: TMultiAction;
    macUpdate_Personal: TMultiAction;
    bbUpdate_Personal: TdxBarButton;
    cePersonal_update: TcxButtonEdit;
    isMarketNot: TcxGridDBColumn;

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
