unit OrderType_Edit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit;

type
  TOrderType_EditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edKoeff1: TcxCurrencyEdit;
    edKoeff2: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edKoeff3: TcxCurrencyEdit;
    cbChange1: TcxCheckBox;
    cb—hange2: TcxCheckBox;
    cb—hange3: TcxCheckBox;
    cxLabel3: TcxLabel;
    edKoeff4: TcxCurrencyEdit;
    cb—hange4: TcxCheckBox;
    cxLabel4: TcxLabel;
    edKoeff5: TcxCurrencyEdit;
    cb—hange5: TcxCheckBox;
    cxLabel5: TcxLabel;
    edKoeff6: TcxCurrencyEdit;
    cb—hange6: TcxCheckBox;
    edKoeff7: TcxCurrencyEdit;
    edKoeff8: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edKoeff9: TcxCurrencyEdit;
    cb—hange7: TcxCheckBox;
    cb—hange8: TcxCheckBox;
    cb—hange9: TcxCheckBox;
    cxLabel10: TcxLabel;
    edKoeff10: TcxCurrencyEdit;
    cb—hange10: TcxCheckBox;
    cxLabel11: TcxLabel;
    edKoeff11: TcxCurrencyEdit;
    cb—hange11: TcxCheckBox;
    cxLabel12: TcxLabel;
    edKoeff12: TcxCurrencyEdit;
    cb—hange12: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderType_EditForm);

end.
