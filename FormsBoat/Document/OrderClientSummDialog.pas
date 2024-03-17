unit OrderClientSummDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, cxCurrencyEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.ActnList, dsdAction;

type
  TOrderClientSummDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    edSummReal: TcxCurrencyEdit;
    cxLabel36: TcxLabel;
    edSummTax: TcxCurrencyEdit;
    cxLabel33: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    cxLabel34: TcxLabel;
    edDiscountNextTax: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    cxLabel27: TcxLabel;
    edTransportSumm_load: TcxCurrencyEdit;
    edInvNumber: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    cxLabel6: TcxLabel;
    edProduct: TcxButtonEdit;
    GuidesProduct: TdsdGuides;
    cxLabel31: TcxLabel;
    cxLabel32: TcxLabel;
    cxLabel8: TcxLabel;
    edBasis_summ_orig: TcxCurrencyEdit;
    edBasis_summ2_orig: TcxCurrencyEdit;
    edBasis_summ1_orig: TcxCurrencyEdit;
    edSummDiscount1: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    edSummDiscount2: TcxCurrencyEdit;
    cxLabel22: TcxLabel;
    edSummDiscount3: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    cxLabel38: TcxLabel;
    edSummDiscount_total: TcxCurrencyEdit;
    cxLabel39: TcxLabel;
    edBasis_summ: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    cxLabel28: TcxLabel;
    edBasis_summ_transport: TcxCurrencyEdit;
    cxLabel30: TcxLabel;
    edBasisWVAT_summ_transport: TcxCurrencyEdit;
    spGet: TdsdStoredProc;
    HeaderExit: THeaderExit;
    EnterMoveNext: TEnterMoveNext;
    actUpdate_summ_before: TdsdDataSetRefresh;
    actUpdate_summ_after: TdsdInsertUpdateGuides;
    spUpdate_before: TdsdStoredProc;
    spUpdate_after: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderClientSummDialogForm);

end.
