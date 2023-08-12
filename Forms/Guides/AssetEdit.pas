unit AssetEdit;

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
  TAssetEditForm = class(TParentForm)
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
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    ceInvNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    AssetGroupGuides: TdsdGuides;
    ceAssetGroup: TcxButtonEdit;
    cxLabel3: TcxLabel;
    ceSerialNumber: TcxTextEdit;
    cxLabel5: TcxLabel;
    edRelease: TcxDateEdit;
    cxLabel6: TcxLabel;
    cePassportNumber: TcxTextEdit;
    cxLabel7: TcxLabel;
    ceFullName: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    ceMaker: TcxButtonEdit;
    cxLabel10: TcxLabel;
    MakerGuides: TdsdGuides;
    edPeriodUse: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    edCar: TcxButtonEdit;
    GuidesCar: TdsdGuides;
    cxLabel13: TcxLabel;
    edProduction: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edAssetType: TcxButtonEdit;
    GuidesAssetType: TdsdGuides;
    cxLabel15: TcxLabel;
    edKW: TcxCurrencyEdit;
    cbisDocGoods: TcxCheckBox;
    edPartionModel: TcxButtonEdit;
    cxLabel16: TcxLabel;
    GuidesPartionModel: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TAssetEditForm);

end.
