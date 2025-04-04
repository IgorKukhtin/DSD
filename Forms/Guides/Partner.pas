unit Partner;

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
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinsdxBarPainter, dxBarExtItems,
  dsdAddOn, cxCheckBox, dxSkinscxPCPainter, cxButtonEdit, cxContainer,
  cxTextEdit, dsdGuides, cxLabel, cxCurrencyEdit, Vcl.ExtCtrls, ExternalLoad,
  dsdCommon;

type
  TPartnerForm = class(TParentForm)
    DataSource: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    spErasedUnErased: TdsdStoredProc;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Name: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Address: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    PriceListName: TcxGridDBColumn;
    PriceListPromoName: TcxGridDBColumn;
    StartPromo: TcxGridDBColumn;
    EndPromo: TcxGridDBColumn;
    actChoicePriceListForm: TOpenChoiceForm;
    actChoicePriceListPromoForm: TOpenChoiceForm;
    cxLabel6: TcxLabel;
    JuridicalGuides: TdsdGuides;
    edJuridical: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    GLNCode: TcxGridDBColumn;
    GLNCodeJuridical: TcxGridDBColumn;
    actChoiceRoute: TOpenChoiceForm;
    actChoiceRouteSorting: TOpenChoiceForm;
    actChoiceMemberTake: TOpenChoiceForm;
    AreaName: TcxGridDBColumn;
    PartnerTagName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    EdiOrdspr: TcxGridDBColumn;
    EdiInvoice: TcxGridDBColumn;
    EdiDesadv: TcxGridDBColumn;
    spUpdateEdiOrdspr: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    actUpdateEdiOrdspr: TdsdExecStoredProc;
    actUpdateEdiInvoice: TdsdExecStoredProc;
    actUpdateEdiDesadv: TdsdExecStoredProc;
    bbUpdateEdiOrdspr: TdxBarButton;
    bbUpdateEdiInvoice: TdxBarButton;
    bbUpdateEdiDesadv: TdxBarButton;
    GLNCodeRetail: TcxGridDBColumn;
    GLNCodeCorporate: TcxGridDBColumn;
    PrepareDayCount: TcxGridDBColumn;
    DocumentDayCount: TcxGridDBColumn;
    PersonalChoiceForm: TOpenChoiceForm;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    actChoiceUnit: TOpenChoiceForm;
    PriceListName_Prior: TcxGridDBColumn;
    PriceListName_30103: TcxGridDBColumn;
    PriceListName_30201: TcxGridDBColumn;
    actChoicePriceList_Prior: TOpenChoiceForm;
    actChoicePriceList_30103: TOpenChoiceForm;
    actChoicePriceList_30201: TOpenChoiceForm;
    RouteName: TcxGridDBColumn;
    RouteName_30201: TcxGridDBColumn;
    actChoiceRoute_30201: TOpenChoiceForm;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    GPSN: TcxGridDBColumn;
    GPSE: TcxGridDBColumn;
    bbShowAllPartnerOnMap: TdxBarButton;
    actShowAllPartnerOnMap: TdsdPartnerMapAction;
    actShowCurPartnerOnMap: TdsdPartnerMapAction;
    bbShowCurPartnerOnMap: TdxBarButton;
    mactShowAllPartnerOnMap: TMultiAction;
    actCheckShowAllPartnerOnMap: TdsdExecStoredProc;
    spCheck: TdsdStoredProc;
    Panel: TPanel;
    edRetail: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesRetail: TdsdGuides;
    cxLabel2: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel4: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRoute: TdsdGuides;
    PersonalMerchChoiceForm: TOpenChoiceForm;
    PersonalTradeCode: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    PersonalMerchCode: TcxGridDBColumn;
    BranchName_PersonalTrade: TcxGridDBColumn;
    UnitName_PersonalTrade: TcxGridDBColumn;
    Category: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    actUpdate_Category: TdsdInsertUpdateAction;
    bbUpdate_Category: TdxBarButton;
    edUnitMobile_text: TcxLabel;
    edUnitMobile: TcxButtonEdit;
    GuidesUnitMobile: TdsdGuides;
    bbedUnitMobile_text: TdxBarControlContainerItem;
    bbedUnitMobile: TdxBarControlContainerItem;
    spUpdate_UnitMobile: TdsdStoredProc;
    actUpdate_UnitMobile: TdsdExecStoredProc;
    macUpdate_UnitMobile_list: TMultiAction;
    macUpdate_UnitMobile: TMultiAction;
    bbUpdate_UnitMobile: TdxBarButton;
    ShortName: TcxGridDBColumn;
    spInsertUpdate_BasisCode: TdsdStoredProc;
    actInsertUpdate_BasisCode: TdsdExecStoredProc;
    macInsertUpdate_BasisCode_list: TMultiAction;
    macInsertUpdate_BasisCode: TMultiAction;
    bbInsertUpdate_BasisCode: TdxBarButton;
    spUpdate_isIrna: TdsdStoredProc;
    actUpdate_isIrna: TdsdExecStoredProc;
    macUpdate_isIrna_list: TMultiAction;
    macUpdate_isIrna: TMultiAction;
    bbUpdate_isIrna: TdxBarButton;
    spUpdateGoodsBox: TdsdStoredProc;
    actUpdateGoodsBox: TdsdExecStoredProc;
    macUpdateGoodsBox_list: TMultiAction;
    macUpdateGoodsBox: TMultiAction;
    bbUpdateGoodsBox: TdxBarButton;
    isGoodsBox: TcxGridDBColumn;
    MovementComment: TcxGridDBColumn;
    BranchCode: TcxGridDBColumn;
    BranchJur: TcxGridDBColumn;
    Terminal: TcxGridDBColumn;
    cxLabel18: TcxLabel;
    cePersonal_update: TcxButtonEdit;
    GuidesPersonal_update: TdsdGuides;
    bbsUpdate: TdxBarSubItem;
    bbSeparator: TdxBarSeparator;
    bbPersonal: TdxBarControlContainerItem;
    spUpdatePersonal: TdsdStoredProc;
    spUpdatePersonalTrade: TdsdStoredProc;
    spUpdatePersonalMerch: TdsdStoredProc;
    actUpdate_Personal: TdsdExecStoredProc;
    actUpdate_PersonalMerch: TdsdExecStoredProc;
    actUpdate_PersonalTrade: TdsdExecStoredProc;
    macUpdate_Personal_list: TMultiAction;
    macUpdate_PersonaTradel_list: TMultiAction;
    macUpdate_PersonalMerch_list: TMultiAction;
    macUpdate_Personal: TMultiAction;
    macUpdate_PersonalTrade: TMultiAction;
    macUpdate_PersonalMerch: TMultiAction;
    bbUpdate_Personal: TdxBarButton;
    bbUpdate_PersonalTrade: TdxBarButton;
    bbUpdate_PersonalMerch: TdxBarButton;
    BranchName_Personal: TcxGridDBColumn;
    UnitName_Personal: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartnerForm);

end.
