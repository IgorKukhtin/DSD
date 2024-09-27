unit Service;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TServiceForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cePaidKind: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountDebet: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesPaidKind: TdsdGuides;
    GuidesUnit: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceContract: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    GuidesContract: TdsdGuides;
    ceAmountKredit: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    ceOperDatePartner: TcxDateEdit;
    edInvNumberPartner: TcxTextEdit;
    cxLabel11: TcxLabel;
    edInvNumber: TcxTextEdit;
    cePartner: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesPartner: TdsdGuides;
    cxLabel13: TcxLabel;
    ceIncomeCost: TcxButtonEdit;
    GuidesIncomeCost: TdsdGuides;
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel14: TcxLabel;
    ceAsset: TcxButtonEdit;
    GuidesAsset: TdsdGuides;
    cxLabel19: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    GuidesCurrencyPartner: TdsdGuides;
    cxLabel18: TcxLabel;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    edParPartnerValue: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    ceAmountCurrencyDebet: TcxCurrencyEdit;
    ceAmountCurrencyKredit: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    ceCountDebet: TcxCurrencyEdit;
    cxLabel22: TcxLabel;
    cePrice: TcxCurrencyEdit;
    cxLabel23: TcxLabel;
    ceCountKredit: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    ceSumma: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    GuidesJuridicalBasis: TdsdGuides;
    edDoc: TcxButtonEdit;
    cxLabel25: TcxLabel;
    GuidesDoc: TdsdGuides;
    cxLabel27: TcxLabel;
    edTradeMark: TcxButtonEdit;
    GuidesTradeMark: TdsdGuides;
    cxLabel28: TcxLabel;
    ceContractChild: TcxButtonEdit;
    GuidesContractChild: TdsdGuides;
    cxLabel29: TcxLabel;
    ceInvNumberInvoice: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TServiceForm);

end.
