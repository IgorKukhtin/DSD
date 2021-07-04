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
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    ContractKindName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    JuridicalCode: TcxGridDBColumn;
    InvNumberArchive: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractStateKindName: TcxGridDBColumn;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    ContractConditionKindName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    clsfcisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ContractConditionDS: TDataSource;
    CDSContractCondition: TClientDataSet;
    OKPO: TcxGridDBColumn;
    JuridicalBasisName: TcxGridDBColumn;
    clCode: TcxGridDBColumn;
    ChildViewAddOn: TdsdDBViewAddOn;
    BonusKindName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    clccInfoMoneyName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    JuridicalGroupName: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    ContractTagGroupName: TcxGridDBColumn;
    cxGridContract_Child: TcxGrid;
    cxGridDBTableViewContract_Child: TcxGridDBTableView;
    cxGridLeveContract_Child: TcxGridLevel;
    dsdDBViewAddOnContract_Child: TdsdDBViewAddOn;
    Panel: TPanel;
    cxGridGoods: TcxGrid;
    cxGridDBTableViewGoods: TcxGridDBTableView;
    Code_ch4: TcxGridDBColumn;
    GoodsName_ch4: TcxGridDBColumn;
    cxGridLevelGoods: TcxGridLevel;
    CDSContractGoods: TClientDataSet;
    DataSourceGoods: TDataSource;
    dsdDBViewAddOnGoods: TdsdDBViewAddOn;
    GoodsKindName_ch4: TcxGridDBColumn;
    Price_ch4: TcxGridDBColumn;
    GoodsCode_ch4: TcxGridDBColumn;
    spErasedUnErasedGoods: TdsdStoredProc;
    clPisErased: TcxGridDBColumn;
    isErased_ch4: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    Panel1: TPanel;
    ContractSendName: TcxGridDBColumn;
    spUpdateVat: TdsdStoredProc;
    colStartDate: TcxGridDBColumn;
    colEndDate: TcxGridDBColumn;
    ccPaidKindName: TcxGridDBColumn;
    clPercentRetBonus: TcxGridDBColumn;
    actUpdateStateKind_Closed: TdsdExecStoredProc;
    macUpdateStateKind_Closed_list: TMultiAction;
    macUpdateStateKind_Closed: TMultiAction;
    actRefreshContract: TdsdDataSetRefresh;
    Contract_ChildDS: TDataSource;
    Contract_ChildCDS: TClientDataSet;
    cxSplitter1: TcxSplitter;
    cxSplitter3: TcxSplitter;
    InsertRecordCCPartner: TInsertRecord;
    dsdSetErasedCCPartner: TdsdUpdateErased;
    dsdSetUnErased——Partner: TdsdUpdateErased;
    ProtocolOpenFormCCPartner: TdsdOpenForm;
    cxLabel5: TcxLabel;
    edPromo: TcxButtonEdit;
    GuidesPromo: TdsdGuides;
    FormParams: TdsdFormParams;
    cxSplitter4: TcxSplitter;

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
