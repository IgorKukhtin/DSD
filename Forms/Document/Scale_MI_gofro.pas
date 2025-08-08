unit Scale_MI_gofro;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dsdGuides, cxMaskEdit, cxButtonEdit, dsdCommon;

type
  TScale_MI_gofroForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCodeGofro_pd: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edGofro_pd: TcxButtonEdit;
    GuidesGofro_pd: TdsdGuides;
    edAmount_gofro_pd: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel1: TcxLabel;
    edAmount_gofro_box: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    edgofro_box: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edCodegofro_box: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edCodegofro_ugol: TcxCurrencyEdit;
    edgofro_ugol: TcxButtonEdit;
    cxLabel7: TcxLabel;
    Guidesgofro_ugol: TdsdGuides;
    edAmount_gofro_ugol: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edCodegofro_1: TcxCurrencyEdit;
    edgofro_1: TcxButtonEdit;
    cxLabel10: TcxLabel;
    Guidesgofro_1: TdsdGuides;
    edAmount_gofro_1: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    cxLabel13: TcxLabel;
    edCodegofro_2: TcxCurrencyEdit;
    edgofro_2: TcxButtonEdit;
    cxLabel14: TcxLabel;
    edAmount_gofro_2: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edCodegofro_3: TcxCurrencyEdit;
    edgofro_3: TcxButtonEdit;
    cxLabel17: TcxLabel;
    edAmount_gofro_3: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    edCodegofro_4: TcxCurrencyEdit;
    edgofro_4: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edAmount_gofro_4: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    edCodegofro_5: TcxCurrencyEdit;
    edgofro_5: TcxButtonEdit;
    cxLabel23: TcxLabel;
    edAmount_gofro_5: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    edCodegofro_6: TcxCurrencyEdit;
    edgofro_6: TcxButtonEdit;
    cxLabel26: TcxLabel;
    edAmount_gofro_6: TcxCurrencyEdit;
    cxLabel27: TcxLabel;
    cxLabel28: TcxLabel;
    edCodegofro_7: TcxCurrencyEdit;
    edgofro_7: TcxButtonEdit;
    cxLabel29: TcxLabel;
    edAmount_gofro_7: TcxCurrencyEdit;
    cxLabel30: TcxLabel;
    cxLabel31: TcxLabel;
    edCodegofro_8: TcxCurrencyEdit;
    edgofro_8: TcxButtonEdit;
    cxLabel32: TcxLabel;
    edAmount_gofro_8: TcxCurrencyEdit;
    cxLabel33: TcxLabel;
    Guidesgofro_box: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TScale_MI_gofroForm);

end.
