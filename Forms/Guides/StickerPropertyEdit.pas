unit StickerPropertyEdit;

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
  TStickerPropertyEditForm = class(TParentForm)
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
    edSticker: TcxButtonEdit;
    GuidesSticker: TdsdGuides;
    cxLabel6: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GuidesGoodsKind: TdsdGuides;
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
    GuidesStickerSkin: TdsdGuides;
    edStickerSkin: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesStickerPack: TdsdGuides;
    edStickerPack: TcxButtonEdit;
    cbisFix: TcxCheckBox;
    cxLabel12: TcxLabel;
    ceValue6: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceValue7: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edBarCode: TcxTextEdit;
    cxLabel15: TcxLabel;
    ceValue8: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    ceValue9: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    ceValue10: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    ceValue11: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edStickerFile70_70: TcxButtonEdit;
    GuidesStickerFile70_70: TdsdGuides;

  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TStickerPropertyEditForm);

end.
