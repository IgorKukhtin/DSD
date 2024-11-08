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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

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
    dsdJuridicalGuides: TdsdGuides;
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
    RegionGuides: TdsdGuides;
    cxLabel23: TcxLabel;
    ceProvince: TcxButtonEdit;
    ProvinceGuides: TdsdGuides;
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

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}


initialization
  RegisterClass(TPartnerEditForm);

end.
