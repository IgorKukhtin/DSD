unit RecalcMCSShedulerEdit;

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
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.Menus, dsdAddOn, cxPropertiesStore,
  dsdGuides, Data.DB, Datasnap.DBClient, dsdDB, dsdAction, Vcl.ActnList,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, cxButtonEdit,
  cxCheckBox;

type
  TRecalcMCSShedulerEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel4: TcxLabel;
    ceUser: TcxButtonEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    UserGuides: TdsdGuides;
    cbIsClose: TcxCheckBox;
    edUnitName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel5: TcxLabel;
    cePeriod: TcxCurrencyEdit;
    ceDay: TcxCurrencyEdit;
    ceDay1: TcxCurrencyEdit;
    cePeriod1: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceDay2: TcxCurrencyEdit;
    cePeriod2: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceDay3: TcxCurrencyEdit;
    cePeriod3: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    ceDay4: TcxCurrencyEdit;
    cePeriod4: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    ceDay5: TcxCurrencyEdit;
    cePeriod5: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceDay6: TcxCurrencyEdit;
    cePeriod6: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceDay7: TcxCurrencyEdit;
    cePeriod7: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cbPharmacyItem: TcxCheckBox;
    cbAllRetail: TcxCheckBox;
    ceDaySun3: TcxCurrencyEdit;
    ceDaySun7: TcxCurrencyEdit;
    cePeriodSun7: TcxCurrencyEdit;
    ceDaySun6: TcxCurrencyEdit;
    cePeriodSun6: TcxCurrencyEdit;
    ceDaySun5: TcxCurrencyEdit;
    cePeriodSun5: TcxCurrencyEdit;
    ceDaySun4: TcxCurrencyEdit;
    cePeriodSun4: TcxCurrencyEdit;
    cePeriodSun3: TcxCurrencyEdit;
    ceDaySun2: TcxCurrencyEdit;
    cePeriodSun2: TcxCurrencyEdit;
    ceDaySun1: TcxCurrencyEdit;
    cePeriodSun1: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel16: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
initialization

  RegisterClass(TRecalcMCSShedulerEditForm);

end.
