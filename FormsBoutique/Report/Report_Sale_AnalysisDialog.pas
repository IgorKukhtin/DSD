unit Report_Sale_AnalysisDialog;

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
  cxCurrencyEdit;

type
  TReport_Sale_AnalysisDialogForm = class(TParentForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    deEnd: TcxDateEdit;
    deStart: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FormParams: TdsdFormParams;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel1: TcxLabel;
    edBrand: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    GuidesPartner: TdsdGuides;
    cxLabel5: TcxLabel;
    edPeriod: TcxButtonEdit;
    GuidesPeriod: TdsdGuides;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    edStartYear: TcxButtonEdit;
    edEndYear: TcxButtonEdit;
    GuidesStartYear: TdsdGuides;
    GuidesEndYear: TdsdGuides;
    cbPeriodAll: TcxCheckBox;
    cbUnit: TcxCheckBox;
    cbIsAmount: TcxCheckBox;
    cbIsSumm: TcxCheckBox;
    cbIsProf: TcxCheckBox;
    cxLabel4: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel13: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    cxLabel14: TcxLabel;
    edPresent1: TcxCurrencyEdit;
    edPresent2: TcxCurrencyEdit;
    edPresent1_Summ: TcxCurrencyEdit;
    edPresent2_Summ: TcxCurrencyEdit;
    edPresent1_Prof: TcxCurrencyEdit;
    edPresent2_Prof: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edLineFabrica: TcxButtonEdit;
    cbLineFabrica: TcxCheckBox;
    GuidesLineFabrica: TdsdGuides;
    cbBrand: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Sale_AnalysisDialogForm);

end.
