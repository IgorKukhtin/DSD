unit PartnerAddress;

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
  cxDropDownEdit, cxCalendar, ChoicePeriod;

type
  TPartnerAddressForm = class(TParentForm)
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
    ceCode: TcxGridDBColumn;
    ceJuridicalName: TcxGridDBColumn;
    ceisErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    ceName: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    ceAddress: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    clStreetName: TcxGridDBColumn;
    clCaseNumber: TcxGridDBColumn;
    clRoomNumber: TcxGridDBColumn;
    clHouseNumber: TcxGridDBColumn;
    CityKindChoiceForm: TOpenChoiceForm;
    PriceListPromoChoiceForm: TOpenChoiceForm;
    cxLabel6: TcxLabel;
    JuridicalGuides: TdsdGuides;
    edJuridical: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbJuridicalLabel: TdxBarControlContainerItem;
    bbJuridicalGuides: TdxBarControlContainerItem;
    colShortName: TcxGridDBColumn;
    colPostalCode: TcxGridDBColumn;
    colCityName: TcxGridDBColumn;
    colCityKindName: TcxGridDBColumn;
    colRegionName: TcxGridDBColumn;
    colProvinceName: TcxGridDBColumn;
    colStreetKindName: TcxGridDBColumn;
    StreetKindChoiceForm: TOpenChoiceForm;
    colProvinceCityName: TcxGridDBColumn;
    colOrder_Name: TcxGridDBColumn;
    colOrder_Mail: TcxGridDBColumn;
    colOrder_Phone: TcxGridDBColumn;
    colDoc_Name: TcxGridDBColumn;
    colDoc_Phone: TcxGridDBColumn;
    colDoc_Mail: TcxGridDBColumn;
    colAct_Name: TcxGridDBColumn;
    colAct_Mail: TcxGridDBColumn;
    colAct_Phone: TcxGridDBColumn;
    ContactPersonChoiceOrderForm: TOpenChoiceForm;
    ContactPersonChoiceActForm: TOpenChoiceForm;
    ContactPersonChoiceDocForm: TOpenChoiceForm;
    colMemberTakeName: TcxGridDBColumn;
    colPersonalTradeName: TcxGridDBColumn;
    colPersonalName: TcxGridDBColumn;
    colAreaName: TcxGridDBColumn;
    colPartnerTagName: TcxGridDBColumn;
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
    clNameInteger: TcxGridDBColumn;
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
  RegisterClass(TPartnerAddressForm);

end.
