unit IncomeItemPodiumEdit;

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
  TIncomeItemEditForm = class(TParentForm)
    cxLabel1: TcxLabel;
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
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    ceGoodsSize: TcxButtonEdit;
    GuidesGoodsSize: TdsdGuides;
    edGoodsName: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    edGoodsGroupName: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    edCompositionName: TcxButtonEdit;
    GuidesComposition: TdsdGuides;
    edGoodsInfoName: TcxButtonEdit;
    GuidesGoodsInfo: TdsdGuides;
    edLineFabricaName: TcxButtonEdit;
    GuidesLineFabrica: TdsdGuides;
    edMeasure: TcxButtonEdit;
    GuidesMeasure: TdsdGuides;
    cxLabel18: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cePriceJur: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    ceOperPriceList: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceCountForPrice: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    edLabelName: TcxButtonEdit;
    GuidesLabel: TdsdGuides;
    cxLabel12: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    GuidesJuridicalBasis: TdsdGuides;
    spGet_OperPriceList: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshOperPriceList: TdsdDataSetRefresh;
    cxLabel13: TcxLabel;
    edGoodsCode: TcxCurrencyEdit;
    spUpdate_PriceWithoutPersent: TdsdStoredProc;
    actUpdate_PriceWithoutPersent: TdsdExecStoredProc;
    cbisCode: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeItemEditForm);

end.
