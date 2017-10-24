unit Sticker;

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
  TStickerForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
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
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    JuridicalName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    JuridicalCode: TcxGridDBColumn;
    Info: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    StickerGroupName: TcxGridDBColumn;
    ContractConditionKindChoiceForm: TOpenChoiceForm;
    bbInsertRecCCK: TdxBarButton;
    actContractCondition: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    StickerGroupChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    ContractKindChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    clCode: TcxGridDBColumn;
    StickerSortChoiceForm: TOpenChoiceForm;
    InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm;
    StickerNormName: TcxGridDBColumn;
    PersonalCollationChoiceForm: TOpenChoiceForm;
    StickerTypeChoiceForm: TOpenChoiceForm;
    StickerNormChoiceForm: TOpenChoiceForm;
    StickerTypeName: TcxGridDBColumn;
    bbStartDate: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    bbEndDate: TdxBarControlContainerItem;
    bbIsEndDate: TdxBarControlContainerItem;
    bbIsPeriod: TdxBarControlContainerItem;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    StickerSortName: TcxGridDBColumn;
    StickerFileChoiceForm: TOpenChoiceForm;
    StickerFileName: TcxGridDBColumn;
    CDSProperty: TClientDataSet;
    DSProperty: TDataSource;
    spSelectProperty: TdsdStoredProc;
    spInsertUpdateStickerProperty: TdsdStoredProc;
    dsdDBViewAddOnStickerProperty: TdsdDBViewAddOn;
    InsertRecordCP: TInsertRecord;
    bbRecordCP: TdxBarButton;
    dsdUpdateDataSet1: TdsdUpdateDataSet;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    GoodsChoiceForm: TOpenChoiceForm;
    bbRecordGoods: TdxBarButton;
    GoodsKindChoiceForm: TOpenChoiceForm;
    spErasedUnErasedPartner: TdsdStoredProc;
    dsdSetErasedPartner: TdsdUpdateErased;
    bbSetErasedPartner: TdxBarButton;
    bbSetErasedGoods: TdxBarButton;
    dsdSetUnErasedPartner: TdsdUpdateErased;
    bbSetUnErasedPartner: TdxBarButton;
    bbSetUnErasedGoods: TdxBarButton;
    ProtocolOpenFormPartner: TdsdOpenForm;
    bbProtocolOpenFormCondition: TdxBarButton;
    bbProtocolOpenFormPartner: TdxBarButton;
    bbProtocolOpenFormGoods: TdxBarButton;
    GoodsPropertyChoiceForm: TOpenChoiceForm;
    Value1: TcxGridDBColumn;
    ContractSendChoiceForm: TOpenChoiceForm;
    spUpdateVat: TdsdStoredProc;
    actUpdateVat: TdsdExecStoredProc;
    bbCustom: TdxBarButton;
    StickerTagName: TcxGridDBColumn;
    StickerTagChoiceForm: TOpenChoiceForm;
    Panel: TPanel;
    cxGridProperty: TcxGrid;
    cxGridDBTableViewProperty: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    isConnected: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    clPisErased: TcxGridDBColumn;
    cxGridLeveProperty: TcxGridLevel;
    cxLeftSplitter: TcxSplitter;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TStickerForm);

end.
