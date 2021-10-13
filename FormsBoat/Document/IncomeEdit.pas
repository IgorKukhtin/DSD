unit IncomeEdit;

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
  dxSkinXmas2008Blue, cxCheckBox;

type
  TIncomeEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actRefresh: TdsdDataSetRefresh;
    actInsertUpdate: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel18: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    spGet_OperPriceList: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshOperPriceList: TdsdDataSetRefresh;
    spUpdate_Price: TdsdStoredProc;
    actUpdate_PriceWithoutPersent: TdsdExecStoredProc;
    cxLabel14: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxCurrencyEdit1: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceSummTaxMVAT: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceSummTaxPVAT: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel13: TcxLabel;
    cxLabel15: TcxLabel;
    cxCurrencyEdit2: TcxCurrencyEdit;
    cxCurrencyEdit3: TcxCurrencyEdit;
    cxCurrencyEdit4: TcxCurrencyEdit;
    cxCurrencyEdit5: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    cxCurrencyEdit6: TcxCurrencyEdit;
    cxCurrencyEdit7: TcxCurrencyEdit;
    cxCurrencyEdit8: TcxCurrencyEdit;
    cxCurrencyEdit9: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cxCurrencyEdit10: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeEditForm);

end.
