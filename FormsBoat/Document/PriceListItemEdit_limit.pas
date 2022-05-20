unit PriceListItemEdit_limit;

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
  TPriceListItemEdit_limitForm = class(TParentForm)
    cxButtonOK: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefresh: TdsdDataSetRefresh;
    actInsertUpdate: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    edDiscountPartner: TcxButtonEdit;
    GuidesDiscountPartner: TdsdGuides;
    cxLabel8: TcxLabel;
    ceEmpfPriceParent: TcxCurrencyEdit;
    actRefreshOperPriceList: TdsdDataSetRefresh;
    cxLabel13: TcxLabel;
    edGoodsCode: TcxCurrencyEdit;
    ceAmount: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    ceWeightParent: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    cxLabel18: TcxLabel;
    edArticle: TcxTextEdit;
    EnterMoveNext: TEnterMoveNext;
    actGet_TotalCount: TdsdExecStoredProc;
    GuidesFiller: TGuidesFiller;
    cxLabel7: TcxLabel;
    cePriceParent: TcxCurrencyEdit;
    ceMeasureMult: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cxLabel9: TcxLabel;
    ceMinCount: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceMeasure: TcxButtonEdit;
    GuidesMeasure: TdsdGuides;
    cxLabel12: TcxLabel;
    edMeasureParent: TcxButtonEdit;
    GuidesMeasureParent: TdsdGuides;
    ceMinCountMult: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edCatalogPage: TcxTextEdit;
    cxLabel15: TcxLabel;
    cbOutlet: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListItemEdit_limitForm);

end.
