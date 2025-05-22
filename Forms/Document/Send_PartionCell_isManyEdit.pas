unit Send_PartionCell_isManyEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxCheckBox, dsdGuides, cxMaskEdit, cxButtonEdit;

type
  TSend_PartionCell_isManyEditForm = class(TParentForm)
    edName1: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spUpdate_isMany_byReport_all: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actGet: TdsdDataSetRefresh;
    actGet_check: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode1: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cbisMany1: TcxCheckBox;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel3: TcxLabel;
    edCode2: TcxCurrencyEdit;
    edName2: TcxTextEdit;
    cbisMany2: TcxCheckBox;
    cxLabel6: TcxLabel;
    edCode3: TcxCurrencyEdit;
    edName3: TcxTextEdit;
    cbisMany3: TcxCheckBox;
    cxLabel7: TcxLabel;
    edCode4: TcxCurrencyEdit;
    edName9: TcxTextEdit;
    cbisMany4: TcxCheckBox;
    cxLabel8: TcxLabel;
    edCode5: TcxCurrencyEdit;
    edName5: TcxTextEdit;
    cbisMany5: TcxCheckBox;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edCode10: TcxCurrencyEdit;
    edCode9: TcxCurrencyEdit;
    edCode8: TcxCurrencyEdit;
    edCode7: TcxCurrencyEdit;
    edCode6: TcxCurrencyEdit;
    edName6: TcxTextEdit;
    edName7: TcxTextEdit;
    edName8: TcxTextEdit;
    edName10: TcxTextEdit;
    cbisMany6: TcxCheckBox;
    cbisMany7: TcxCheckBox;
    cbisMany8: TcxCheckBox;
    cbisMany9: TcxCheckBox;
    cbisMany10: TcxCheckBox;
    edName4: TcxTextEdit;
    edName12: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edCode12: TcxCurrencyEdit;
    cbisMany12: TcxCheckBox;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    edCode13: TcxCurrencyEdit;
    edName13: TcxTextEdit;
    cbisMany13: TcxCheckBox;
    cxLabel19: TcxLabel;
    edCode14: TcxCurrencyEdit;
    edName14: TcxTextEdit;
    cbisMany14: TcxCheckBox;
    cxLabel20: TcxLabel;
    edCode15: TcxCurrencyEdit;
    edName20: TcxTextEdit;
    cbisMany15: TcxCheckBox;
    cxLabel21: TcxLabel;
    edCode16: TcxCurrencyEdit;
    edName16: TcxTextEdit;
    cbisMany16: TcxCheckBox;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    cxLabel26: TcxLabel;
    edCode21: TcxCurrencyEdit;
    edCode20: TcxCurrencyEdit;
    edCode19: TcxCurrencyEdit;
    edCode18: TcxCurrencyEdit;
    edCode17: TcxCurrencyEdit;
    edName17: TcxTextEdit;
    edName18: TcxTextEdit;
    edName19: TcxTextEdit;
    edName21: TcxTextEdit;
    cbisMany17: TcxCheckBox;
    cbisMany18: TcxCheckBox;
    cbisMany19: TcxCheckBox;
    cbisMany20: TcxCheckBox;
    cbisMany21: TcxCheckBox;
    edName15: TcxTextEdit;
    cxLabel27: TcxLabel;
    edCode11: TcxCurrencyEdit;
    edName11: TcxTextEdit;
    cbisMany11: TcxCheckBox;
    cxLabel28: TcxLabel;
    edCode22: TcxCurrencyEdit;
    edName22: TcxTextEdit;
    cbisMany22: TcxCheckBox;
    cxLabel29: TcxLabel;
    ceGooods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesGooodsKind: TdsdGuides;
    ceGooodsKind: TcxButtonEdit;
    cxLabel30: TcxLabel;
    cxLabel31: TcxLabel;
    cePartionGoods: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSend_PartionCell_isManyEditForm);

end.
