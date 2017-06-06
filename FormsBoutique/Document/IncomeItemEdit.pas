unit IncomeItemEdit;

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
  dxSkinXmas2008Blue;

type
  TIncomeItemEditForm = class(TParentForm)
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
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    ceGoodsSize: TcxButtonEdit;
    GoodsSizeGuides: TdsdGuides;
    ceGoodsName: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edGoodsGroupName: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    edCompositionName: TcxButtonEdit;
    CompositionGuides: TdsdGuides;
    edGoodsInfoName: TcxButtonEdit;
    GoodsInfoGuides: TdsdGuides;
    edLineFabricaName: TcxButtonEdit;
    LineFabricaGuides: TdsdGuides;
    edMeasure: TcxButtonEdit;
    MeasureGuides: TdsdGuides;
    cxLabel18: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    ceOperPrice: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    ceOperPriceList: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceCountForPrice: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    edLabelName: TcxButtonEdit;
    LabelGuides: TdsdGuides;
    cxLabel12: TcxLabel;
    ceJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_OperPriceList: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshOperPriceList: TdsdDataSetRefresh;
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
