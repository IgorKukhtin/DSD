unit RecalcMCSShedulerSunDialog;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, cxMemo, Vcl.ActnList, dsdAction;

type
  TRecalcMCSShedulerSunDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    PeriodChoice: TPeriodChoice;
    ceDaySun7: TcxCurrencyEdit;
    cePeriodSun7: TcxCurrencyEdit;
    ceDaySun6: TcxCurrencyEdit;
    cePeriodSun6: TcxCurrencyEdit;
    ceDaySun5: TcxCurrencyEdit;
    cePeriodSun5: TcxCurrencyEdit;
    ceDaySun4: TcxCurrencyEdit;
    cePeriodSun4: TcxCurrencyEdit;
    ceDaySun3: TcxCurrencyEdit;
    cePeriodSun3: TcxCurrencyEdit;
    ceDaySun2: TcxCurrencyEdit;
    cePeriodSun2: TcxCurrencyEdit;
    ceDaySun1: TcxCurrencyEdit;
    cePeriodSun1: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    spGet: TdsdStoredProc;
    ActionList: TActionList;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    cxLabel12: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel6: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRecalcMCSShedulerSunDialogForm);

end.
