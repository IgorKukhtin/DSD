unit GoodsPropertyValueEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxButtonEdit;

type
  TGoodsPropertyValueEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    cxLabel3: TcxLabel;
    GuidesGoodsProperty: TdsdGuides;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceGoodsProperty: TcxButtonEdit;
    ceAmount: TcxCurrencyEdit;
    ceBarCode: TcxTextEdit;
    ceBarCodeGLN: TcxTextEdit;
    ceArticle: TcxTextEdit;
    ceArticleGLN: TcxTextEdit;
    cxLabel2: TcxLabel;
    ceGoodsKind: TcxButtonEdit;
    GuidesGoodsKind: TdsdGuides;
    cxLabel4: TcxLabel;
    ceGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceGroupName: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceBoxCount: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    ceAmountDoc: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edGoodsBox: TcxButtonEdit;
    GuidesGoodsBox: TdsdGuides;
    cxLabel14: TcxLabel;
    edGoodsKindSub: TcxButtonEdit;
    GuidesGoodsKindSub: TdsdGuides;
    cbisGoodsKind: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPropertyValueEditForm);

end.
