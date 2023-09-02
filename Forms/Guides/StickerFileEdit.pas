unit StickerFileEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxPropertiesStore, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar, cxCheckBox;

type
  TStickerFileEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    cxLabel2: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel3: TcxLabel;
    edTradeMark: TcxButtonEdit;
    GuidesTradeMark: TdsdGuides;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel5: TcxLabel;
    edLanguage: TcxButtonEdit;
    GuidesLanguage: TdsdGuides;
    cxLabel6: TcxLabel;
    cbisDefault: TcxCheckBox;
    cxLabel16: TcxLabel;
    cxLabel7: TcxLabel;
    ceWidth1: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceWidth6: TcxCurrencyEdit;
    ceWidth7: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel8: TcxLabel;
    ceWidth3: TcxCurrencyEdit;
    ceWidth4: TcxCurrencyEdit;
    ceWidth2: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cxLabel9: TcxLabel;
    ceWidth5: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceWidth10: TcxCurrencyEdit;
    ceWidth9: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceWidth8: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cxLabel17: TcxLabel;
    ceLevel1: TcxCurrencyEdit;
    ceLevel2: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    ceLeft1: TcxCurrencyEdit;
    ceLeft2: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    cxLabel24: TcxLabel;
    cxLabel25: TcxLabel;
    cxLabel26: TcxLabel;
    cxLabel27: TcxLabel;
    cxLabel28: TcxLabel;
    cxLabel29: TcxLabel;
    cbisSize70: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TStickerFileEditForm);

end.
