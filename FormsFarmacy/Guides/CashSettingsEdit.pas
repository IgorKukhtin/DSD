unit CashSettingsEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxPropertiesStore, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TCashSettingsEditForm = class(TParentForm)
    edShareFromPriceName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    spGet: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    edShareFromPriceCode: TcxTextEdit;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    cbGetHardwareData: TcxCheckBox;
    edDateBanSUN: TcxDateEdit;
    cxLabel11: TcxLabel;
    edSummaFormSendVIP: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edSummaUrgentlySendVIP: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cbBlockVIP: TcxCheckBox;
    cbPairedOnlyPromo: TcxCheckBox;
    edDaySaleForSUN: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edAttemptsSub: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edDayNonCommoditySUN: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edLowerLimitPromoBonus: TcxCurrencyEdit;
    edUpperLimitPromoBonus: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edMinPercentPromoBonus: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceDayCompensDiscount: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edMethodsAssortment: TcxButtonEdit;
    MethodsAssortmentGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    ceAssortmentGeograph: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceAssortmentSales: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceCustomerThreshold: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cePriceCorrectionDay: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    cbRequireUkrName: TcxCheckBox;
    cbRemovingPrograms: TcxCheckBox;
    cePriceSamples: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    ceSamples21: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    ceSamples22: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    ceSamples3: TcxCurrencyEdit;
    edTelegramBotToken: TcxTextEdit;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    cePercentIC: TcxCurrencyEdit;
    cePercentUntilNextSUN: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    cbEliminateColdSUN: TcxCheckBox;
    ceTurnoverMoreSUN2: TcxCurrencyEdit;
    cxLabel25: TcxLabel;
    ceDeySupplInSUN2: TcxCurrencyEdit;
    ceDeySupplOutSUN2: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    cxLabel27: TcxLabel;
    ceExpressVIPConfirm: TcxCurrencyEdit;
    cxLabel28: TcxLabel;
    edPriceFormSendVIP: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    ceMinPriceSale: TcxCurrencyEdit;
    cxLabel30: TcxLabel;
    ceDeviationsPrice1303: TcxCurrencyEdit;
    cxLabel31: TcxLabel;
    cdWagesCheckTesting: TcxCheckBox;
    edUserUpdateMarketing: TcxButtonEdit;
    cxLabel32: TcxLabel;
    UserUpdateMarketingGuides: TdsdGuides;
    ceNormNewMobileOrders: TcxCurrencyEdit;
    cxLabel33: TcxLabel;
    ceLimitCash: TcxCurrencyEdit;
    cxLabel34: TcxLabel;
    ceAddMarkupTabletki: TcxCurrencyEdit;
    cxLabel35: TcxLabel;
    cbShoresSUN: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCashSettingsEditForm);

end.
