unit IncomeEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dsdGuides, cxMaskEdit, cxButtonEdit,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCheckBox;

type
  TIncomeEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefresh: TdsdDataSetRefresh;
    actInsertUpdate: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel18: TcxLabel;
    ceTotalSummMVAT: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    actRefreshOperPriceList: TdsdDataSetRefresh;
    spUpdate_Price: TdsdStoredProc;
    actUpdate_PriceWithoutPersent: TdsdExecStoredProc;
    cxLabel14: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    ceDiscountTax: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceSummTaxMVAT: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceSummTaxPVAT: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel13: TcxLabel;
    cxLabel15: TcxLabel;
    ceSummInsur: TcxCurrencyEdit;
    ceSummPack: TcxCurrencyEdit;
    ceSummPost: TcxCurrencyEdit;
    ceSumm2: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    ceTotalSummTaxPVAT: TcxCurrencyEdit;
    ceTotalSummTaxMVAT: TcxCurrencyEdit;
    ceTotalDiscountTax: TcxCurrencyEdit;
    ceSumm3: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    HeaderExit: THeaderExit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeEditForm);

end.