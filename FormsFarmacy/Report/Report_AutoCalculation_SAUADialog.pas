unit Report_AutoCalculation_SAUADialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod,
  dsdGuides, cxDropDownEdit, cxCalendar, cxTextEdit, cxMaskEdit, cxButtonEdit,
  cxPropertiesStore, dsdAddOn, dsdDB, cxLabel, dxSkinsCore,
  dxSkinsDefaultPainters, cxCheckBox, dsdAction, Vcl.ActnList, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, cxMemo;

type
  TReport_AutoCalculation_SAUADialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    cxLabel6: TcxLabel;
    edRecipient: TcxTextEdit;
    cxLabel1: TcxLabel;
    edAssortment: TcxMemo;
    spGet: TdsdStoredProc;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    PeriodChoice: TPeriodChoice;
    ceCountPharmacies: TcxCurrencyEdit;
    ceDaysStock: TcxCurrencyEdit;
    ceThreshold: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cbNeedRound: TcxCheckBox;
    cbAssortmentRound: TcxCheckBox;
    cbNotCheckNoMCS: TcxCheckBox;
    cbMCSIsClose: TcxCheckBox;
    cbGoodsClose: TcxCheckBox;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_AutoCalculation_SAUADialogForm);

end.
