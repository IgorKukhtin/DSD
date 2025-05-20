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
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spUpdate_isMany_byReport: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actGet: TdsdDataSetRefresh;
    actGet_check: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cbisMany: TcxCheckBox;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel3: TcxLabel;
    cxCurrencyEdit1: TcxCurrencyEdit;
    cxTextEdit1: TcxTextEdit;
    cxCheckBox1: TcxCheckBox;
    cxLabel6: TcxLabel;
    cxCurrencyEdit2: TcxCurrencyEdit;
    cxTextEdit2: TcxTextEdit;
    cxCheckBox2: TcxCheckBox;
    cxLabel7: TcxLabel;
    cxCurrencyEdit3: TcxCurrencyEdit;
    cxTextEdit3: TcxTextEdit;
    cxCheckBox3: TcxCheckBox;
    cxLabel8: TcxLabel;
    cxCurrencyEdit4: TcxCurrencyEdit;
    cxTextEdit4: TcxTextEdit;
    cxCheckBox4: TcxCheckBox;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    cxCurrencyEdit5: TcxCurrencyEdit;
    cxCurrencyEdit6: TcxCurrencyEdit;
    cxCurrencyEdit7: TcxCurrencyEdit;
    cxCurrencyEdit8: TcxCurrencyEdit;
    cxCurrencyEdit9: TcxCurrencyEdit;
    cxTextEdit5: TcxTextEdit;
    cxTextEdit6: TcxTextEdit;
    cxTextEdit7: TcxTextEdit;
    cxTextEdit8: TcxTextEdit;
    cxCheckBox5: TcxCheckBox;
    cxCheckBox6: TcxCheckBox;
    cxCheckBox7: TcxCheckBox;
    cxCheckBox8: TcxCheckBox;
    cxCheckBox9: TcxCheckBox;
    cxTextEdit9: TcxTextEdit;
    cxTextEdit10: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    cxCurrencyEdit10: TcxCurrencyEdit;
    cxCheckBox10: TcxCheckBox;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    cxCurrencyEdit11: TcxCurrencyEdit;
    cxTextEdit11: TcxTextEdit;
    cxCheckBox11: TcxCheckBox;
    cxLabel19: TcxLabel;
    cxCurrencyEdit12: TcxCurrencyEdit;
    cxTextEdit12: TcxTextEdit;
    cxCheckBox12: TcxCheckBox;
    cxLabel20: TcxLabel;
    cxCurrencyEdit13: TcxCurrencyEdit;
    cxTextEdit13: TcxTextEdit;
    cxCheckBox13: TcxCheckBox;
    cxLabel21: TcxLabel;
    cxCurrencyEdit14: TcxCurrencyEdit;
    cxTextEdit14: TcxTextEdit;
    cxCheckBox14: TcxCheckBox;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    cxLabel26: TcxLabel;
    cxCurrencyEdit15: TcxCurrencyEdit;
    cxCurrencyEdit16: TcxCurrencyEdit;
    cxCurrencyEdit17: TcxCurrencyEdit;
    cxCurrencyEdit18: TcxCurrencyEdit;
    cxCurrencyEdit19: TcxCurrencyEdit;
    cxTextEdit15: TcxTextEdit;
    cxTextEdit16: TcxTextEdit;
    cxTextEdit17: TcxTextEdit;
    cxTextEdit18: TcxTextEdit;
    cxCheckBox15: TcxCheckBox;
    cxCheckBox16: TcxCheckBox;
    cxCheckBox17: TcxCheckBox;
    cxCheckBox18: TcxCheckBox;
    cxCheckBox19: TcxCheckBox;
    cxTextEdit19: TcxTextEdit;
    cxLabel27: TcxLabel;
    cxCurrencyEdit20: TcxCurrencyEdit;
    cxTextEdit20: TcxTextEdit;
    cxCheckBox20: TcxCheckBox;
    cxLabel28: TcxLabel;
    cxCurrencyEdit21: TcxCurrencyEdit;
    cxTextEdit21: TcxTextEdit;
    cxCheckBox21: TcxCheckBox;
    cxLabel29: TcxLabel;
    ceGooods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesGooodsKind: TdsdGuides;
    ceGooodsKind: TcxButtonEdit;
    cxLabel30: TcxLabel;
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
