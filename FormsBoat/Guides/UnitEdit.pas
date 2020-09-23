unit UnitEdit;

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
  TUnitEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    edDiscountTax: TcxCurrencyEdit;
    edAddress: TcxTextEdit;
    cxLabel4: TcxLabel;
    edPhone: TcxTextEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    ceParent: TcxButtonEdit;
    GuidesParent: TdsdGuides;
    cxLabel8: TcxLabel;
    ceChild: TcxButtonEdit;
    GuidesChild: TdsdGuides;
    cxLabel9: TcxLabel;
    ceBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    cxLabel10: TcxLabel;
    ceAccountDirection: TcxButtonEdit;
    GuidesAccountDirection: TdsdGuides;
    cxLabel11: TcxLabel;
    edPrinter: TcxTextEdit;
    cxLabel12: TcxLabel;
    edPrintName: TcxTextEdit;
    cbisPartnerBarCode: TcxCheckBox;
    cxLabel13: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    cxLabel14: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
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
