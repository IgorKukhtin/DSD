unit GoodsGroupEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore, dsdDB,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, dsdAction, ParentForm, Data.DB, Datasnap.DBClient,
  cxCurrencyEdit, cxMaskEdit, cxDropDownEdit, cxDBEdit, cxCustomData, cxStyles,
  cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, dsdGuides,
  Vcl.Grids, Vcl.DBGrids, dxSkinsCore, cxButtonEdit, dsdAddOn,
  dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar;

type
  TGoodsGroupEditForm = class(TParentForm)
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
    cxLabel2: TcxLabel;
    ceCode: TcxCurrencyEdit;
    Код: TcxLabel;
    GoodsGroupGuides: TdsdGuides;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    ceParentGroup: TcxButtonEdit;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel3: TcxLabel;
    ceGroupStat: TcxButtonEdit;
    GoodsGroupStatGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceTradeMark: TcxButtonEdit;
    TradeMarkGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceGoodsTag: TcxButtonEdit;
    GoodsTagGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceGoodsGroupAnalyst: TcxButtonEdit;
    GoodsGroupAnalystGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    ceGoodsPlatform: TcxButtonEdit;
    GoodsPlatformGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceCodeUKTZED: TcxTextEdit;
    cxLabel10: TcxLabel;
    ceTaxImport: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceDKPP: TcxTextEdit;
    cxLabel12: TcxLabel;
    ceTaxAction: TcxTextEdit;
    ceisAsset: TcxCheckBox;
    cxLabel13: TcxLabel;
    ceCodeUKTZED_new: TcxTextEdit;
    cxLabel14: TcxLabel;
    edDateUKTZED_new: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsGroupEditForm);

end.
