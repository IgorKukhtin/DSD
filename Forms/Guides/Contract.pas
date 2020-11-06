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
  dxSkinXmas2008Blue;

type
  TContractForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    InvNumber: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
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
    SigningDate: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    ContractKindName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    JuridicalCode: TcxGridDBColumn;
    InvNumberArchive: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    InfoMoneyGroupCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationCode: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AreaContractName: TcxGridDBColumn;
    ContractArticleName: TcxGridDBColumn;
    ContractStateKindName: TcxGridDBColumn;
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
    OKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    PaidKindChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    JuridicalBasisName: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    ChildViewAddOn: TdsdDBViewAddOn;
    BonusKindName: TcxGridDBColumn;
    BonusKindChoiceForm: TOpenChoiceForm;
    colComment: TcxGridDBColumn;
    BankAccountExternal: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    IsDefault: TcxGridDBColumn;
    clccInfoMoneyName: TcxGridDBColumn;
    InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm;
    IsStandart: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalCollationName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    PersonalCollationChoiceForm: TOpenChoiceForm;
    BankAccountChoiceForm: TOpenChoiceForm;
    ContractTagChoiceForm: TOpenChoiceForm;
    ContractKeyId: TcxGridDBColumn;
    IsPersonal: TcxGridDBColumn;
    IsUnique: TcxGridDBColumn;
    DocumentCount: TcxGridDBColumn;
    DateDocument: TcxGridDBColumn;
    PersonalChoiceForm: TOpenChoiceForm;
    JuridicalGroupName: TcxGridDBColumn;
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
    GLNCode: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
    JuridicalDocumentChoiceForm: TOpenChoiceForm;
    JuridicalDocumentName: TcxGridDBColumn;
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
    cxLeftSplitter: TcxSplitter;
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
    PriceListName: TcxGridDBColumn;
    isConnected: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    GoodsPropertyChoiceForm: TOpenChoiceForm;
    ContractTermKindName: TcxGridDBColumn;
    Term: TcxGridDBColumn;
    EndDate_Term: TcxGridDBColumn;
    Panel1: TPanel;
    ContractSendName: TcxGridDBColumn;
    ContractSendChoiceForm: TOpenChoiceForm;
    spUpdateDefaultOut: TdsdStoredProc;
    actUpdateVat: TdsdExecStoredProc;
    bbCustom: TdxBarButton;
    isVat: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    JuridicalInvoiceName: TcxGridDBColumn;
    JuridicalInvoiceChoiceForm: TOpenChoiceForm;
    clPartnerCode: TcxGridDBColumn;
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
