unit PartnerPersonal;

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
  cxTextEdit, dsdGuides, cxLabel, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxDropDownEdit, cxCalendar, ChoicePeriod, Vcl.ExtCtrls;

type
  TPartnerPersonalForm = class(TParentForm)
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
    dsdStoredProc: TdsdStoredProc;
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
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Name: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Address: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    StreetName: TcxGridDBColumn;
    CaseNumber: TcxGridDBColumn;
    RoomNumber: TcxGridDBColumn;
    HouseNumber: TcxGridDBColumn;
    CityKindChoiceForm: TOpenChoiceForm;
    PriceListPromoChoiceForm: TOpenChoiceForm;
    cxLabel6: TcxLabel;
    JuridicalGuides: TdsdGuides;
    edJuridical: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    ShortName: TcxGridDBColumn;
    PostalCode: TcxGridDBColumn;
    CityName: TcxGridDBColumn;
    CityKindName: TcxGridDBColumn;
    RegionName: TcxGridDBColumn;
    ProvinceName: TcxGridDBColumn;
    StreetKindName: TcxGridDBColumn;
    StreetKindChoiceForm: TOpenChoiceForm;
    ProvinceCityName: TcxGridDBColumn;
    Order_Name: TcxGridDBColumn;
    Order_Mail: TcxGridDBColumn;
    Order_Phone: TcxGridDBColumn;
    Doc_Name: TcxGridDBColumn;
    Doc_Phone: TcxGridDBColumn;
    Doc_Mail: TcxGridDBColumn;
    Act_Name: TcxGridDBColumn;
    Act_Mail: TcxGridDBColumn;
    Act_Phone: TcxGridDBColumn;
    ContactPersonChoiceOrderForm: TOpenChoiceForm;
    ContactPersonChoiceActForm: TOpenChoiceForm;
    ContactPersonChoiceDocForm: TOpenChoiceForm;
    MemberTakeName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    PartnerTagName: TcxGridDBColumn;
    MemberTakeChoiceForm: TOpenChoiceForm;
    PersonalTradeChoiceForm: TOpenChoiceForm;
    PersonalChoiceForm: TOpenChoiceForm;
    AreaChoiceForm: TOpenChoiceForm;
    PartnerTagChoiceForm: TOpenChoiceForm;
    JuridicalGroupName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    UnitName_Personal: TcxGridDBColumn;
    PositionName_Personal: TcxGridDBColumn;
    UnitName_PersonalTrade: TcxGridDBColumn;
    PositionName_PersonalTrade: TcxGridDBColumn;
    BranchName_Personal: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    PaidKindName: TcxGridDBColumn;
    DocBranchName: TcxGridDBColumn;
    LastDocName: TcxGridDBColumn;
    deStart: TcxDateEdit;
    cxlEnd: TcxLabel;
    deEnd: TcxDateEdit;
    dxBarStatic2: TdxBarStatic;
    chkByDoc: TdxBarControlContainerItem;
    deStartDate: TdxBarControlContainerItem;
    textTo: TdxBarControlContainerItem;
    deEndDate: TdxBarControlContainerItem;
    actPrint_byPartner: TdsdPrintAction;
    bbPrint_byPartner: TdxBarButton;
    cxLabel5: TcxLabel;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    actRefreshPeriod: TdsdDataSetRefresh;
    cbPeriod: TcxCheckBox;
    NameInteger: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    Panel: TPanel;
    edRetail: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    GuidesPersonalTrade: TdsdGuides;
    GuidesRoute: TdsdGuides;
    spCheck: TdsdStoredProc;
    actShowCurPartnerOnMap: TdsdPartnerMapAction;
    actCheckShowAllPartnerOnMap: TdsdExecStoredProc;
    actShowAllPartnerOnMap: TdsdPartnerMapAction;
    mactShowAllPartnerOnMap: TMultiAction;
    bbShowCurPartnerOnMap: TdxBarButton;
    bbShowAllPartnerOnMap: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartnerPersonalForm);

end.
