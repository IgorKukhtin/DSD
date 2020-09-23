unit ReturnInItemEdit;

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
  TReturnInItemEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel18: TcxLabel;
    ceCurrencyValue_USD: TcxCurrencyEdit;
    ceAmountGRN: TcxCurrencyEdit;
    cbisPayTotal: TcxCheckBox;
    cxLabel1: TcxLabel;
    ceAmountToPay: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceAmountRemains: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceAmountDiff: TcxCurrencyEdit;
    ceAmountUSD: TcxCurrencyEdit;
    ceAmountEUR: TcxCurrencyEdit;
    ceAmountCARD: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    ceCurrencyValue_EUR: TcxCurrencyEdit;
    RefreshDispatcher: TRefreshDispatcher;
    dsdDataSetRefreshStart: TdsdDataSetRefresh;
    spGet_Total: TdsdStoredProc;
    actRefreshTotal: TdsdDataSetRefresh;
    cbisGRN: TcxCheckBox;
    cbisUSD: TcxCheckBox;
    cbisEUR: TcxCheckBox;
    cbisCARD: TcxCheckBox;
    spGet_isGRN: TdsdStoredProc;
    spGet_isUSD: TdsdStoredProc;
    spGet_isEUR: TdsdStoredProc;
    spGet_isCard: TdsdStoredProc;
    actRefreshCard: TdsdDataSetRefresh;
    actRefreshEUR: TdsdDataSetRefresh;
    actRefreshUSD: TdsdDataSetRefresh;
    actRefreshGRN: TdsdDataSetRefresh;
    HeaderChanger: THeaderChanger;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnInItemEditForm);

end.
