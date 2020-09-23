unit ClientEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox, dsdGuides, cxMaskEdit,
  cxButtonEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit,
  cxCalendar;

type
  TClientEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actDataSetRefresh: TdsdDataSetRefresh;
    actInsertUpdateGuides: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edAddress: TcxTextEdit;
    edDiscountCard: TcxTextEdit;
    edPhoneMobile: TcxTextEdit;
    cxLabel5: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceCity: TcxButtonEdit;
    GuidesCity: TdsdGuides;
    cxLabel7: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edDiscountTaxTwo: TcxCurrencyEdit;
    edHappyDate: TcxDateEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edMail: TcxTextEdit;
    cxLabel12: TcxLabel;
    edComment: TcxTextEdit;
    ceDiscountKind: TcxButtonEdit;
    cxLabel13: TcxLabel;
    GuidesDiscountKind: TdsdGuides;
    cxLabel14: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TClientEditForm);

end.
