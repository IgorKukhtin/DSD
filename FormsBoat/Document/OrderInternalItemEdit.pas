unit OrderInternalItemEdit;

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
  TOrderInternalItemEditForm = class(TParentForm)
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
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    actRefreshOperPriceList: TdsdDataSetRefresh;
    cxLabel13: TcxLabel;
    edGoodsCode: TcxCurrencyEdit;
    edAmount: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    ceTotalCount: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    cxLabel18: TcxLabel;
    edArticle: TcxTextEdit;
    cxLabel1: TcxLabel;
    edPartNumber: TcxTextEdit;
    EnterMoveNext: TEnterMoveNext;
    spGet_TotalCount: TdsdStoredProc;
    actGet_TotalCount: TdsdExecStoredProc;
    edComment: TcxTextEdit;
    cxLabel9: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceAmountRemainsFrom: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalItemEditForm);

end.
