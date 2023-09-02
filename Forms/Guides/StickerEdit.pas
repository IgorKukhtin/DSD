unit StickerEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdAddOn, cxPropertiesStore,
  dsdDB, dsdAction, Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons,
  cxLabel, cxTextEdit, dsdGuides, cxMaskEdit, cxButtonEdit, cxCheckBox, cxMemo;

type
  TStickerEditForm = class(TParentForm)
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel6: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel7: TcxLabel;
    edStickerFile: TcxButtonEdit;
    GuidesStickerFile: TdsdGuides;
    edComment: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceValue1: TcxCurrencyEdit;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceValue2: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    ceValue3: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceValue4: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceValue5: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    GuidesStickerGroup: TdsdGuides;
    edStickerGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesStickerTag: TdsdGuides;
    edStickerTag: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesStickerSort: TdsdGuides;
    edStickerSort: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edStickerType: TcxButtonEdit;
    GuidesStickerType: TdsdGuides;
    cxLabel14: TcxLabel;
    edStickerNorm: TcxButtonEdit;
    GuidesStickerNorm: TdsdGuides;
    ceInfo: TcxMemo;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    ceValue6: TcxCurrencyEdit;
    ceValue7: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    ceValue8: TcxCurrencyEdit;
    GuidesStickerFile_70_70: TdsdGuides;
    cxLabel19: TcxLabel;
    edStickerFile_70_70: TcxButtonEdit;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TStickerEditForm);

end.
