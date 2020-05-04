unit Partner_updatePersonal;

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
  cxTextEdit, dsdGuides, cxLabel, cxCurrencyEdit, Vcl.ExtCtrls;

type
  TPartner_updatePersonalForm = class(TParentForm)
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
    cxLabel6: TcxLabel;
    JuridicalGuides: TdsdGuides;
    edJuridical: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    GLNCode: TcxGridDBColumn;
    GLNCodeJuridical: TcxGridDBColumn;
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
    spUpdate_Personal: TdsdStoredProc;
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
    PriceListName_Prior: TcxGridDBColumn;
    PriceListName_30103: TcxGridDBColumn;
    PriceListName_30201: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteName_30201: TcxGridDBColumn;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartner_updatePersonalForm);

end.
