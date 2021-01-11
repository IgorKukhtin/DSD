unit PromoContractBonus_Detail;

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
  dxSkinXmas2008Blue, dsdGuides;

type
  TPromoContractBonus_DetailForm = class(TParentForm)
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
    spSelect: TdsdStoredProc;
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
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    InsertRecordCCK: TInsertRecord;
    actContractCondition: TdsdUpdateDataSet;
    OKPO: TcxGridDBColumn;
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
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    GLNCode: TcxGridDBColumn;
    ContractTagGroupName: TcxGridDBColumn;
    JuridicalDocumentChoiceForm: TOpenChoiceForm;
    JuridicalDocumentName: TcxGridDBColumn;
    cxGridContract_Child: TcxGrid;
    cxGridDBTableViewContract_Child: TcxGridDBTableView;
    cxGridLeveContract_Child: TcxGridLevel;
    PartnerChoiceForm: TOpenChoiceForm;
    dsdDBViewAddOnContract_Child: TdsdDBViewAddOn;
    InsertRecordCP: TInsertRecord;
    dsdUpdateDataSet1: TdsdUpdateDataSet;
    ProtocolOpenForm: TdsdOpenForm;
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
    GoodsKindName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    InsertRecordGoods: TInsertRecord;
    GoodsChoiceForm: TOpenChoiceForm;
    GoodsKindChoiceForm: TOpenChoiceForm;
    actUpdateDSGoods: TdsdUpdateDataSet;
    GoodsCode: TcxGridDBColumn;
    spErasedUnErasedGoods: TdsdStoredProc;
    dsdSetErasedPartner: TdsdUpdateErased;
    dsdSetErasedGoods: TdsdUpdateErased;
    clPisErased: TcxGridDBColumn;
    clGisErased: TcxGridDBColumn;
    dsdSetUnErasedPartner: TdsdUpdateErased;
    dsdSetUnErasedGoods: TdsdUpdateErased;
    ProtocolOpenFormCondition: TdsdOpenForm;
    ProtocolOpenFormPartner: TdsdOpenForm;
    ProtocolOpenFormGoods: TdsdOpenForm;
    PriceListName: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    GoodsPropertyChoiceForm: TOpenChoiceForm;
    ContractTermKindName: TcxGridDBColumn;
    Term: TcxGridDBColumn;
    EndDate_Term: TcxGridDBColumn;
    Panel1: TPanel;
    ContractSendName: TcxGridDBColumn;
    ContractSendChoiceForm: TOpenChoiceForm;
    actUpdateVat: TdsdExecStoredProc;
    isVat: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    JuridicalInvoiceName: TcxGridDBColumn;
    JuridicalInvoiceChoiceForm: TOpenChoiceForm;
    clPartnerCode: TcxGridDBColumn;
    spUpdateVat: TdsdStoredProc;
    actUpdateDefaultOut: TdsdExecStoredProc;
    colStartDate: TcxGridDBColumn;
    colEndDate: TcxGridDBColumn;
    ccPaidKindName: TcxGridDBColumn;
    PaidKindChoiceForm——: TOpenChoiceForm;
    actUpdate_isWMS: TdsdExecStoredProc;
    clPercentRetBonus: TcxGridDBColumn;
    actUpdateStateKind_Closed: TdsdExecStoredProc;
    macUpdateStateKind_Closed_list: TMultiAction;
    macUpdateStateKind_Closed: TMultiAction;
    actRefreshContract: TdsdDataSetRefresh;
    actContractGoodsChoiceOpenForm: TdsdOpenForm;
    Contract_ChildDS: TDataSource;
    Contract_ChildCDS: TClientDataSet;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    cxSplitter3: TcxSplitter;
    PartnerContractConditionChoiceForm: TOpenChoiceForm;
    actUpdateDataSetCCPartner: TdsdUpdateDataSet;
    InsertRecordCCPartner: TInsertRecord;
    dsdSetErasedCCPartner: TdsdUpdateErased;
    dsdSetUnErased——Partner: TdsdUpdateErased;
    ProtocolOpenFormCCPartner: TdsdOpenForm;
    cxLabel5: TcxLabel;
    edPromo: TcxButtonEdit;
    GuidesPromo: TdsdGuides;
    FormParams: TdsdFormParams;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoContractBonus_DetailForm);

end.
