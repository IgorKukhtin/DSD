unit GoodsEdit;

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
  dxSkinXmas2008Blue, cxButtonEdit, dsdAddOn, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCalendar, dsdCommon;

type
  TGoodsEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
     Ó‰: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dsdMeasureGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    ceWeight: TcxCurrencyEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceParentGroup: TcxButtonEdit;
    ceMeasure: TcxButtonEdit;
    ÒÂTradeMark: TcxButtonEdit;
    cxLabel5: TcxLabel;
    TradeMarkGuides: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel6: TcxLabel;
    dsdInfoMoneyGuides: TdsdGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel7: TcxLabel;
    ceBusiness: TcxButtonEdit;
    BusinessGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edFuel: TcxButtonEdit;
    FuelGuides: TdsdGuides;
    GoodsGroupGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceGroupStat: TcxButtonEdit;
    GoodsGroupStatGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    ceGoodsTag: TcxButtonEdit;
    GoodsTagGuides: TdsdGuides;
    ceGoodsGroupAnalyst: TcxButtonEdit;
    cxLabel11: TcxLabel;
    GoodsGroupAnalystGuides: TdsdGuides;
    cxLabel12: TcxLabel;
    edStartDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    cePrice: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edWeightTare: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edCountForWeight: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edName_BUH: TcxTextEdit;
    cxLabel18: TcxLabel;
    edDate_BUH: TcxDateEdit;
    cxLabel19: TcxLabel;
    edShortName: TcxTextEdit;
    cxLabel20: TcxLabel;
    edGoodsGroupProperty: TcxButtonEdit;
    GuidesGoodsGroupProperty: TdsdGuides;
    cxLabel21: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    GuidesGoodsGroupPropertyParent: TdsdGuides;
    cxLabel22: TcxLabel;
    edGoodsGroupDirection: TcxButtonEdit;
    GuidesGoodsGroupDirection: TdsdGuides;
    cxLabel23: TcxLabel;
    ceComment: TcxTextEdit;
    cbHeadCount: TcxCheckBox;
    cbisPartionDate: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsEditForm);

end.
