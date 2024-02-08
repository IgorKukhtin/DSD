unit SalePodiumItemEdit;

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
  dxSkinXmas2008Blue, cxCheckBox, DataModul, cxEditRepositoryItems;

type
  TSalePodiumItemEditForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel18: TcxLabel;
    ceCurrencyValue_USD: TcxCurrencyEdit_check;
    ceAmountGRN: TcxCurrencyEdit_check;
    cbisPayTotal: TcxCheckBox;
    cxLabel1: TcxLabel;
    ceAmountToPay: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceAmountRemains: TcxCurrencyEdit;
    ceAmountDiff: TcxCurrencyEdit_check;
    ceAmountUSD: TcxCurrencyEdit_check;
    ceAmountEUR: TcxCurrencyEdit_check;
    ceAmountCARD: TcxCurrencyEdit_check;
    ceAmountDiscRound: TcxCurrencyEdit_check;
    cxLabel2: TcxLabel;
    ceCurrencyValue_EUR: TcxCurrencyEdit_check;
    actDataSetRefreshStart: TdsdDataSetRefresh;
    spGet_Total: TdsdStoredProc;
    actRefreshTotal: TdsdDataSetRefresh;
    cbIsGRN: TcxCheckBox;
    cbIsUSD: TcxCheckBox;
    cbIsEUR: TcxCheckBox;
    cbIsCARD: TcxCheckBox;
    cbIsDiscount: TcxCheckBox;
    HeaderChanger: THeaderChanger;
    cxLabel5: TcxLabel;
    ceAmountToPay_EUR: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceAmountRemains_EUR: TcxCurrencyEdit_check;
    ceAmountDiscRound_EUR: TcxCurrencyEdit_check;
    cxLabel19: TcxLabel;
    edCurrencyClient: TcxButtonEdit;
    GuidesCurrencyClient: TdsdGuides;
    ceAmountToPayFull: TcxCurrencyEdit;
    ceAmountToPayFull_EUR: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceCurrencyValue_Cross: TcxCurrencyEdit_check;
    actEnableHeaderChanger: TdsdSetPropValueAction;
    actDisableHeaderChanger: TdsdSetPropValueAction;
    actRefreshDiscount: TdsdDataSetRefresh;
    actRefreshCard: TdsdDataSetRefresh;
    actRefreshEUR: TdsdDataSetRefresh;
    actRefreshUSD: TdsdDataSetRefresh;
    actRefreshGRN: TdsdDataSetRefresh;
    actEnableRefreshDiscount: TdsdSetPropValueAction;
    actDisableRefreshDiscount: TdsdSetPropValueAction;
    actEnableRefreshCard: TdsdSetPropValueAction;
    actDisableRefreshCard: TdsdSetPropValueAction;
    actEnableRefreshEUR: TdsdSetPropValueAction;
    actDisableRefreshEUR: TdsdSetPropValueAction;
    actEnableRefreshUSD: TdsdSetPropValueAction;
    actDisableRefreshUSD: TdsdSetPropValueAction;
    actEnableRefreshGRN: TdsdSetPropValueAction;
    actDisableRefreshGRN: TdsdSetPropValueAction;
    mactRefreshDiscount: TMultiAction;
    mactRefreshCard: TMultiAction;
    mactRefreshEUR: TMultiAction;
    mactRefreshUSD: TMultiAction;
    mactRefreshGRN: TMultiAction;
    ceAmountDiscDiff_EUR: TcxCurrencyEdit;
    ceAmountDiscDiff: TcxCurrencyEdit;
    actSetVisibleAction: TdsdSetVisibleAction;
    mactDataSetRefreshStart: TMultiAction;
    ceCurrencyValueIn_EUR: TcxCurrencyEdit_check;
    cxLabel8: TcxLabel;
    ceCurrencyValueIn_USD: TcxCurrencyEdit_check;
    cxLabel9: TcxLabel;
    cbChangeEUR: TcxCheckBox;
    cxLabel4: TcxLabel;
    mactAmountRemains_EUR: TMultiAction;
    mactAmountDiff: TMultiAction;
    actAmountRemains_EURDialog: TExecuteDialog;
    actAmountDiffDialog: TExecuteDialog;
    mactChangeEUR: TMultiAction;
    actChangeEUR: TdsdDataSetRefresh;
    actEnableChangeEUR: TdsdSetPropValueAction;
    actDisableChangeEUR: TdsdSetPropValueAction;
    ceAmountToPay_Calc: TcxCurrencyEdit;
    ceAmountRounding_EUR: TcxCurrencyEdit;
    ceAmountRounding: TcxCurrencyEdit;
    actClearGet_Total: TdsdSetDefaultParams;
    actSetGet_Total: TdsdSetDefaultParams;
    ceAmountGRN_EUR: TcxCurrencyEdit;
    ceAmountUSD_Over_GRN: TcxCurrencyEdit;
    ceAmountEUR_Pay_GRN: TcxCurrencyEdit;
    ceAmountUSD_EUR: TcxCurrencyEdit;
    ceAmountCARD_EUR: TcxCurrencyEdit;
    ceAmountDiff_EUR: TcxCurrencyEdit;
    ceAmountDiff_GRN: TcxCurrencyEdit;
    ceAmountUSD_Pay_GRN: TcxCurrencyEdit;
    ceAmountUSD_Pay: TcxCurrencyEdit;
    ceAmountUSD_Over: TcxCurrencyEdit;
    ceAmountEUR_Pay: TcxCurrencyEdit;
    ceAmountEUR_Over_GRN: TcxCurrencyEdit;
    ceAmountEUR_Over: TcxCurrencyEdit;
    ceAmountGRN_Over: TcxCurrencyEdit;
    ceAmountCARD_Over: TcxCurrencyEdit;
    ceAmountRest: TcxCurrencyEdit;
    ceAmountRest_EUR: TcxCurrencyEdit;
    actRefreshTotalRemains: TdsdDataSetRefresh;
    actRefreshTotalDiff: TdsdDataSetRefresh;
    spGet_TotalRemains: TdsdStoredProc;
    spGet_TotalDiff: TdsdStoredProc;
    spUpdate_CurrencyValueCross: TdsdStoredProc;
    actUpdate_CurrencyValueCross: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSalePodiumItemEditForm);

end.
