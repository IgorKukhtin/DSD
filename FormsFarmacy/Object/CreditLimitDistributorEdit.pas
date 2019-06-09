unit CreditLimitDistributorEdit;

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
  TCreditLimitDistributorEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose1: TdsdFormClose;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel4: TcxLabel;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxLabel5: TcxLabel;
    ceCreditLimit: TcxCurrencyEdit;
    ceCode: TcxCurrencyEdit;
    ���: TcxLabel;
    cxLabel1: TcxLabel;
    ceJuridical: TcxButtonEdit;
    ceProvider: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    ProviderGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
initialization

  RegisterClass(TCreditLimitDistributorEditForm);

end.
