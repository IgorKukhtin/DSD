unit PartnerEdit;

interface

uses
  AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, dsdGuides, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, cxLabel, Vcl.Controls, cxTextEdit, dsdDB,
  dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore, dsdAddOn,
  Vcl.StdCtrls, cxButtons, dxSkinsCore, dxSkinsDefaultPainters, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxPC, Vcl.ExtCtrls, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, Data.DB, cxDBData, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Datasnap.DBClient;

type
  TPartnerEditForm = class(TAncestorEditDialogForm)
    edAddress: TcxTextEdit;
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edGLNCode: TcxTextEdit;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    ceRoute: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceRouteSorting: TcxButtonEdit;
    cxLabel8: TcxLabel;
    ceMemberTake: TcxButtonEdit;
    GuidesMemberTake: TdsdGuides;
    dsdRouteSortingGuides: TdsdGuides;
    dsdRouteGuides: TdsdGuides;
    cePrepareDayCount: TcxCurrencyEdit;
    ceDocumentDayCount: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cePriceList: TcxButtonEdit;
    dsdPriceListGuides: TdsdGuides;
    cePriceListPromo: TcxButtonEdit;
    dsdPriceListPromoGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    edStartPromo: TcxDateEdit;
    edEndPromo: TcxDateEdit;
    cxLabel13: TcxLabel;
    edShortName: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    ceStreet: TcxButtonEdit;
    StreetGuides: TdsdGuides;
    edHouseNumber: TcxTextEdit;
    edCaseNumber: TcxTextEdit;
    edRoomNumber: TcxTextEdit;
    cxLabel18: TcxLabel;
    cePersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    cxLabel19: TcxLabel;
    cePersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel20: TcxLabel;
    ceArea: TcxButtonEdit;
    AreaGuides: TdsdGuides;
    cxLabel21: TcxLabel;
    cePartnerTag: TcxButtonEdit;
    PartnerTagGuides: TdsdGuides;
    cxLabel22: TcxLabel;
    ceRegion: TcxButtonEdit;
    GuidesRegion: TdsdGuides;
    cxLabel23: TcxLabel;
    ceProvince: TcxButtonEdit;
    GuidesProvince: TdsdGuides;
    cxLabel24: TcxLabel;
    ceCityKind: TcxButtonEdit;
    CityKindGuides: TdsdGuides;
    cxLabel25: TcxLabel;
    ceCity: TcxButtonEdit;
    CityGuides: TdsdGuides;
    cxLabel26: TcxLabel;
    ceProvinceCity: TcxButtonEdit;
    ProvinceCityGuides: TdsdGuides;
    cxLabel27: TcxLabel;
    ceStreetKind: TcxButtonEdit;
    StreetKindGuides: TdsdGuides;
    cxLabel28: TcxLabel;
    edPostalCode: TcxTextEdit;
    cbEdiOrdspr: TcxCheckBox;
    cbEdiDesadv: TcxCheckBox;
    cbEdiInvoice: TcxCheckBox;
    cxLabel29: TcxLabel;
    edGLNCodeJuridical: TcxTextEdit;
    cxLabel30: TcxLabel;
    edGLNCodeRetail: TcxTextEdit;
    edGLNCodeCorporate: TcxTextEdit;
    cxLabel31: TcxLabel;
    cxLabel32: TcxLabel;
    ceGoodsProperty: TcxButtonEdit;
    GoodsPropertyGuides: TdsdGuides;
    cbValue1: TcxCheckBox;
    cbValue2: TcxCheckBox;
    cbValue3: TcxCheckBox;
    cbValue4: TcxCheckBox;
    cbValue5: TcxCheckBox;
    cbValue6: TcxCheckBox;
    cbValue7: TcxCheckBox;
    cxLabel33: TcxLabel;
    cxLabel34: TcxLabel;
    edGPSN: TcxTextEdit;
    cxLabel35: TcxLabel;
    edGPSE: TcxTextEdit;
    cxLabel36: TcxLabel;
    cbDelivery1: TcxCheckBox;
    cbDelivery2: TcxCheckBox;
    cbDelivery3: TcxCheckBox;
    cbDelivery4: TcxCheckBox;
    cbDelivery5: TcxCheckBox;
    cbDelivery6: TcxCheckBox;
    cbDelivery7: TcxCheckBox;
    cxLabel37: TcxLabel;
    cePersonalMerch: TcxButtonEdit;
    GuidesPersonalMerch: TdsdGuides;
    cxLabel38: TcxLabel;
    edCategory: TcxCurrencyEdit;
    cxLabel39: TcxLabel;
    GuidesRoute30201: TdsdGuides;
    edRoute30201: TcxButtonEdit;
    cxLabel40: TcxLabel;
    cePriceList30201: TcxButtonEdit;
    GuidesPriceList30201: TdsdGuides;
    cxLabel47: TcxLabel;
    edUnitMobile: TcxButtonEdit;
    GuidesUnitMobile: TdsdGuides;
    cxLabel41: TcxLabel;
    edMovementComment: TcxTextEdit;
    edTaxSale_Personal: TcxCurrencyEdit;
    cxLabel42: TcxLabel;
    edTaxSale_PersonalTrade: TcxCurrencyEdit;
    cxLabel43: TcxLabel;
    edTaxSale_MemberSaler1: TcxCurrencyEdit;
    cxLabel44: TcxLabel;
    edTaxSale_MemberSaler2: TcxCurrencyEdit;
    cxLabel45: TcxLabel;
    cxLabel46: TcxLabel;
    edMemberSaler1: TcxButtonEdit;
    GuidesMemberSaler1: TdsdGuides;
    cxLabel48: TcxLabel;
    edMemberSaler2: TcxButtonEdit;
    GuidesMemberSaler2: TdsdGuides;
    edBranchCode: TcxTextEdit;
    cxLabel49: TcxLabel;
    edBranchJur: TcxTextEdit;
    cxLabel50: TcxLabel;
    cxLabel51: TcxLabel;
    edTerminal: TcxTextEdit;
    cxLabel52: TcxLabel;
    edPersonalSigning: TcxButtonEdit;
    GuidesPersonalSigning: TdsdGuides;
    cbEdiOrdspr_vch: TcxCheckBox;
    cbEdiInvoice_vch: TcxCheckBox;
    cbEdiDesadv_vch: TcxCheckBox;
    cxLabel53: TcxLabel;
    edGLNCodeCorporate_vch: TcxTextEdit;
    cxLabel54: TcxLabel;
    cxLabel55: TcxLabel;
    edPrepareDayCount_30201: TcxCurrencyEdit;
    edDocumentDayCount_30201: TcxCurrencyEdit;
    GuidesRouteTT: TdsdGuides;
    cxLabel57: TcxLabel;
    edTypeCommerc: TcxButtonEdit;
    GuidesTypeCommerc: TdsdGuides;
    GuidesUnitCommerc: TdsdGuides;
    GuidesPersonalGroupCommerc: TdsdGuides;
    cxPageControl3: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cePosition_1: TcxButtonEdit;
    GuidesPosition_1: TdsdGuides;
    cxLabel61: TcxLabel;
    cePosition_2: TcxButtonEdit;
    cxLabel62: TcxLabel;
    cePosition_3: TcxButtonEdit;
    cxLabel63: TcxLabel;
    cePosition_4: TcxButtonEdit;
    cxLabel64: TcxLabel;
    cePosition_5: TcxButtonEdit;
    cxLabel65: TcxLabel;
    cePosition_6: TcxButtonEdit;
    GuidesPosition_2: TdsdGuides;
    GuidesPosition_3: TdsdGuides;
    GuidesPosition_4: TdsdGuides;
    GuidesPosition_5: TdsdGuides;
    GuidesPosition_6: TdsdGuides;
    edPersonal_1: TcxButtonEdit;
    Guides_Personal_1: TdsdGuides;
    edPersonal_2: TcxButtonEdit;
    cxLabel68: TcxLabel;
    edPersonal_3: TcxButtonEdit;
    edPersonal_4: TcxButtonEdit;
    cxLabel69: TcxLabel;
    cxLabel70: TcxLabel;
    edPersonal_5: TcxButtonEdit;
    edPersonal_6: TcxButtonEdit;
    cxLabel71: TcxLabel;
    Guides_Personal_2: TdsdGuides;
    Guides_Personal_3: TdsdGuides;
    Guides_Personal_4: TdsdGuides;
    Guides_Personal_5: TdsdGuides;
    Guides_Personal_6: TdsdGuides;
    spGet_Commerc: TdsdStoredProc;
    Panel1: TPanel;
    cxLabel66: TcxLabel;
    cxLabel60: TcxLabel;
    cxLabel67: TcxLabel;
    Panel2: TPanel;
    cxLabel58: TcxLabel;
    cePosition_1ret: TcxButtonEdit;
    cxLabel73: TcxLabel;
    cePosition_2ret: TcxButtonEdit;
    cxLabel74: TcxLabel;
    cePosition_3ret: TcxButtonEdit;
    edPersonal_1ret: TcxButtonEdit;
    edPersonal_2ret: TcxButtonEdit;
    cxLabel78: TcxLabel;
    edPersonal_3ret: TcxButtonEdit;
    cxLabel82: TcxLabel;
    ceUnit_1ret: TcxButtonEdit;
    cxLabel83: TcxLabel;
    ceUnit_2ret: TcxButtonEdit;
    cxLabel84: TcxLabel;
    ceUnit_3ret: TcxButtonEdit;
    cxLabel88: TcxLabel;
    cxLabel89: TcxLabel;
    GuidesUnit_1ret: TdsdGuides;
    GuidesUnit_2ret: TdsdGuides;
    GuidesUnit_3ret: TdsdGuides;
    GuidesPosition_1ret: TdsdGuides;
    GuidesPosition_21ret: TdsdGuides;
    GuidesPosition_3ret: TdsdGuides;
    Guides_Personal_1ret: TdsdGuides;
    Guides_Personal_2ret: TdsdGuides;
    Guides_Personal_3ret: TdsdGuides;
    spUpdate_Commerc: TdsdStoredProc;
    HeaderExit: THeaderExit;
    actUpdate_Commerc: TdsdDataSetRefresh;
    cxLabel75: TcxLabel;
    cxLabel76: TcxLabel;
    cxTabSheet3: TcxTabSheet;
    Panel3: TPanel;
    cxLabel56: TcxLabel;
    ceRouteTT: TcxButtonEdit;
    cxLabel59: TcxLabel;
    edPersonalGroupCommerc: TcxButtonEdit;
    cxLabel72: TcxLabel;
    edUnitCommerc: TcxButtonEdit;
    ComLocalCDS: TClientDataSet;
    ComLocalDS: TDataSource;
    spSelectComLocal: TdsdStoredProc;
    ComRetailDS: TDataSource;
    ComRetailCDS: TClientDataSet;
    spSelectComRetail: TdsdStoredProc;
    dsdDBViewAddOnComLocal: TdsdDBViewAddOn;
    dsdDBViewAddOnComRetail: TdsdDBViewAddOn;
    cxPageControl1: TcxPageControl;
    cxTabSheet4: TcxTabSheet;
    cxGridComLocal: TcxGrid;
    cxGridDBTableViewComLocal: TcxGridDBTableView;
    Ord_ch4: TcxGridDBColumn;
    PersonalName_ch4: TcxGridDBColumn;
    PositionName_ch4: TcxGridDBColumn;
    UnitName_ch4: TcxGridDBColumn;
    cxGridLevelComLocal: TcxGridLevel;
    cxPageControl2: TcxPageControl;
    cxTabSheet5: TcxTabSheet;
    cxGridComRetail: TcxGrid;
    cxGridDBTableViewComRetail: TcxGridDBTableView;
    Ord_ch5: TcxGridDBColumn;
    PersonalName_ch5: TcxGridDBColumn;
    PositionName_ch5: TcxGridDBColumn;
    UnitName_ch5: TcxGridDBColumn;
    cxGridLevelComRetail: TcxGridLevel;
    Panel4: TPanel;
    edRetailName: TcxTextEdit;
    cxLabel77: TcxLabel;
    cxLabel79: TcxLabel;
    edCode_page2: TcxCurrencyEdit;
    edName_page2: TcxTextEdit;
    cxLabel80: TcxLabel;
    cxButton1: TcxButton;
    actRefresh_Commerc: TdsdDataSetRefresh;

  private
    { Private declara
    cxCheckBox1: TcxCheckBox;tions }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}


initialization
  RegisterClass(TPartnerEditForm);

end.
