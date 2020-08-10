unit CashOperationBonus;

interface

uses
  AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TCashOperationBonusForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    ceCash: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesCash: TdsdGuides;
    GuidesUnit: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    ceObject: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    cxLabel3: TcxLabel;
    ceAmountOut: TcxCurrencyEdit;
    edInvNumber: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceMember: TcxButtonEdit;
    cxLabel11: TcxLabel;
    cePosition: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesPersonal: TdsdGuides;
    GuidesMember: TdsdGuides;
    ceServiceDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    ceCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceParPartnerValue: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceCurrency: TcxButtonEdit;
    cxLabel16: TcxLabel;
    ceAmountSumm: TcxCurrencyEdit;
    GuidesCurrency: TdsdGuides;
    cxLabel19: TcxLabel;
    edInvNumberSale: TcxButtonEdit;
    GuidesSaleChoice: TdsdGuides;
    cxLabel17: TcxLabel;
    ceInvoice: TcxButtonEdit;
    cxLabel18: TcxLabel;
    ceComment_Invoice: TcxTextEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel20: TcxLabel;
    ceCurrencyPartner: TcxButtonEdit;
    GuidesCurrencyPartner: TdsdGuides;
    cxLabel21: TcxLabel;
    edCar: TcxButtonEdit;
    GuidesCar: TdsdGuides;
    PopupMenu: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    actOpenPositionForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCashOperationBonusForm);

end.
