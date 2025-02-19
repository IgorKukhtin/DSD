unit WeighingProductionBoxEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  cxCurrencyEdit, dsdAction, Vcl.ActnList;

type
  TWeighingProductionBoxEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel12: TcxLabel;
    edBox2: TcxButtonEdit;
    cxLabel1: TcxLabel;
    edBox1: TcxButtonEdit;
    GuidesBox1: TdsdGuides;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spGet: TdsdStoredProc;
    spInsertUpdate: TdsdStoredProc;
    cxLabel2: TcxLabel;
    edBox3: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edBox4: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edBox5: TcxButtonEdit;
    GuidesBox5: TdsdGuides;
    GuidesBox2: TdsdGuides;
    GuidesBox3: TdsdGuides;
    GuidesBox4: TdsdGuides;
    cxLabel5: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    cxLabel6: TcxLabel;
    cxButtonEdit2: TcxButtonEdit;
    GuidesBox6: TdsdGuides;
    cxLabel7: TcxLabel;
    cxButtonEdit3: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxButtonEdit4: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxButtonEdit5: TcxButtonEdit;
    GuidesBox10: TdsdGuides;
    GuidesBox7: TdsdGuides;
    GuidesBox8: TdsdGuides;
    GuidesBox9: TdsdGuides;
    cxLabel10: TcxLabel;
    edCountTare1: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    edCountTare2: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edCountTare3: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edCountTare4: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edCountTare5: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edCountTare6: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edCountTare7: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edCountTare8: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edCountTare9: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    edCountTare10: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingProductionBoxEditForm);

end.
