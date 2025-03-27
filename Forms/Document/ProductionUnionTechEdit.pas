unit ProductionUnionTechEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TProductionUnionTechEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceRealWeight: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceRecipe: TcxButtonEdit;
    ReceiptGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    ceGooods: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ReceiptGoodsGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceCount: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ce—uterCount: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ce—uterCountOrder: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceAmountOrder: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    GooodsKindGuides: TdsdGuides;
    ceGooodsKindGuides: TcxButtonEdit;
    ceReceiptCode: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceGooodsKindCompleteGuides: TcxButtonEdit;
    GooodsKindCompleteGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceCuterWeight: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    cxLabel15: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    ceRealWeightMsg: TcxCurrencyEdit;
    ceRealWeightShp: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    ceCountReal: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    ceAmountForm: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    ceAmountForm_two: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProductionUnionTechEditForm);

end.
