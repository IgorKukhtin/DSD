unit MemberHolidayEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, ChoicePeriod, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TMemberHolidayEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edOperDate: TcxDateEdit;
    edInvNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    edMember: TcxButtonEdit;
    GuideMemberHoliday: TdsdGuides;
    edSummHoliday1_calc: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    cxLabel12: TcxLabel;
    edDay_holiday: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edSummHoliday2_calc: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edAmountCompensation: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    GuidesPS1: TdsdGuides;
    cxLabel4: TcxLabel;
    cxButtonEdit2: TcxButtonEdit;
    GuidesPS2: TdsdGuides;
    cxLabel5: TcxLabel;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TMemberHolidayEditForm);

end.
