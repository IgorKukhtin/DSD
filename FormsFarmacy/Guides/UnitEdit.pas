unit UnitEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox, ParentForm, dsdGuides, dsdDB,
  dsdAction, cxMaskEdit, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxSpinEdit,
  cxTimeEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxPC;

type
  TUnitEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    DataSetRefresh: TdsdDataSetRefresh;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    FormClose: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ParentGuides: TdsdGuides;
    ceParent: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    edMarginCategory: TcxButtonEdit;
    MarginCategoryGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceTaxService: TcxCurrencyEdit;
    cbRepriceAuto: TcxCheckBox;
    cxLabel6: TcxLabel;
    ceTaxServiceNigth: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edEndServiceNigth: TcxDateEdit;
    edStartServiceNigth: TcxDateEdit;
    cxLabel9: TcxLabel;
    edAddress: TcxTextEdit;
    cxLabel10: TcxLabel;
    ceProvinceCity: TcxButtonEdit;
    GuidesProvinceCity: TdsdGuides;
    cxLabel11: TcxLabel;
    edCreateDate: TcxDateEdit;
    edCloseDate: TcxDateEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edUserManager: TcxButtonEdit;
    GuidesUserManager: TdsdGuides;
    cxLabel14: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    ceUnitCategory: TcxButtonEdit;
    cxLabel15: TcxLabel;
    GuidesUnitCategory: TdsdGuides;
    ceNormOfManDays: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel18: TcxLabel;
    edUnitRePrice: TcxButtonEdit;
    GuidesUnitRePrice: TdsdGuides;
    cxLabel19: TcxLabel;
    edPartnerMedical: TcxButtonEdit;
    GuidesPartnerMedical: TdsdGuides;
    cbPharmacyItem: TcxCheckBox;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    edTaxUnitEnd: TcxDateEdit;
    edTaxUnitStart: TcxDateEdit;
    cbGoodsCategory: TcxCheckBox;
    cbSp: TcxCheckBox;
    cxLabel22: TcxLabel;
    edDateSp: TcxDateEdit;
    cxLabel23: TcxLabel;
    edStartSP: TcxDateEdit;
    edEndSP: TcxDateEdit;
    cxLabel24: TcxLabel;
    cbDividePartionDate: TcxCheckBox;
    cbRedeemByHandSP: TcxCheckBox;
    edUnitOverdue: TcxButtonEdit;
    cxLabel25: TcxLabel;
    GuidesUnitOverdue: TdsdGuides;
    cxLabel26: TcxLabel;
    edUserManager2: TcxButtonEdit;
    GuidesUserManager2: TdsdGuides;
    cxLabel27: TcxLabel;
    edUserManager3: TcxButtonEdit;
    GuidesUserManager3: TdsdGuides;
    cbSUN: TcxCheckBox;
    cbAutoMCS: TcxCheckBox;
    cxLabel28: TcxLabel;
    edKoeffInSUN: TcxCurrencyEdit;
    edKoeffOutSUN: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    cbTopNo: TcxCheckBox;
    cxPageControl: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxLabel30: TcxLabel;
    cxLabel31: TcxLabel;
    cxLabel32: TcxLabel;
    cxLabel33: TcxLabel;
    cxLabel34: TcxLabel;
    cxLabel35: TcxLabel;
    cxLabel36: TcxLabel;
    cxLabel37: TcxLabel;
    ceMondayEnd: TcxDateEdit;
    ceMondayStart: TcxDateEdit;
    ceSaturdayEnd: TcxDateEdit;
    ceSaturdayStart: TcxDateEdit;
    ceSundayEnd: TcxDateEdit;
    ceSundayStart: TcxDateEdit;
    edLatitude: TcxTextEdit;
    edLongitude: TcxTextEdit;
    cxLabel38: TcxLabel;
    edListDaySUN: TcxTextEdit;
    cxTabSheet3: TcxTabSheet;
    cbNotCashMCS: TcxCheckBox;
    cbNotCashListDiff: TcxCheckBox;
    edUnitOld: TcxButtonEdit;
    cxLabel39: TcxLabel;
    GuidesUnitOld: TdsdGuides;
    ceMorionCode: TcxCurrencyEdit;
    cxLabel40: TcxLabel;
    edAccessKeyYF: TcxTextEdit;
    cxLabel41: TcxLabel;
    cxLabel42: TcxLabel;
    cbTechnicalRediscount: TcxCheckBox;
    cbAlertRecounting: TcxCheckBox;
    cxLabel43: TcxLabel;
    edListDaySUN_pi: TcxTextEdit;
    cxLabel44: TcxLabel;
    edSun_v4Income: TcxCurrencyEdit;
    edSun_v2Income: TcxCurrencyEdit;
    cxLabel45: TcxLabel;
    ceSerialNumberTabletki: TcxCurrencyEdit;
    cxLabel46: TcxLabel;
    cxLabel47: TcxLabel;
    edLayout: TcxButtonEdit;
    GuidesLayout: TdsdGuides;
    cxLabel48: TcxLabel;
    edPromoForSale: TcxTextEdit;
    cdMinPercentMarkup: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TUnitEditForm);

end.
