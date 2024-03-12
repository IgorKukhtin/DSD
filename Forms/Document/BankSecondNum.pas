unit BankSecondNum;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, dsdGuides, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxCurrencyEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TBankSecondNumForm = class(TAncestorEditDialogForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceBankSecondDiff_num: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceBankSecondTwo_num: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    edInvNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceBankSecond_num: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    GuidesBankSecond_num: TdsdGuides;
    edBankSecond_num: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edBankSecondTwo_num: TcxButtonEdit;
    GuidesBankSecondTwo_num: TdsdGuides;
    cxLabel2: TcxLabel;
    edBankSecondDiff_num: TcxButtonEdit;
    GuidesBankSecondDiff_num: TdsdGuides;
    cxLabel30: TcxLabel;
    edInvNumberPersonalService: TcxButtonEdit;
    GuidesPersonalService: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankSecondNumForm);

end.
