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
    spUpdate_summ_after: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefresh: TdsdDataSetRefresh;
    actUpdate_summ_after: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel18: TcxLabel;
    ceTotalSummMVAT: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    actUpdate_summ_before: TdsdDataSetRefresh;
    spUpdate_summ_before: TdsdStoredProc;
    cxLabel14: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    ceDiscountTax: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceSummTaxPVAT: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceSummTaxMVAT: TcxCurrencyEdit;
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
    ceTotalSummTaxMVAT: TcxCurrencyEdit;
    ceTotalSummTaxPVAT: TcxCurrencyEdit;
    ceTotalDiscountTax: TcxCurrencyEdit;
    ceSumm3: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    HeaderExit: THeaderExit;
    EnterMoveNext: TEnterMoveNext;
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
