unit CarExternalEdit;

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
  cxDBLookupComboBox, dsdAddOn, cxPropertiesStore, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit;

type
  TCarExternalEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn;
    cxLabel5: TcxLabel;
    cxLabel2: TcxLabel;
    ceRegistrationCertificate: TcxTextEdit;
    ceCarModel: TcxButtonEdit;
    CarModelGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceComment: TcxTextEdit;
    edLength: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edWidth: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edHeight: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edWeight: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edYear: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edVIN: TcxTextEdit;
    cxLabel19: TcxLabel;
    edCarType: TcxButtonEdit;
    GuidesCarType: TdsdGuides;
    edCarProperty: TcxButtonEdit;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    edObjectColor: TcxButtonEdit;
    GuidesObjectColor: TdsdGuides;
    GuidesCarProperty: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TCarExternalEditForm);
end.
