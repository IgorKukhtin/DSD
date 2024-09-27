unit ProfitLossService;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox, dxSkinBlack, dxSkinBlue,
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
  TProfitLossServiceForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cePaidKind: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountDebet: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    PaidKindGuides: TdsdGuides;
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
    ContractGuides: TdsdGuides;
    ceAmountKredit: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    ceContractConditionKind: TcxButtonEdit;
    BonusKindGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    ceBonusKind: TcxButtonEdit;
    ContractConditionKindGuides: TdsdGuides;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    ceContractMaster: TcxButtonEdit;
    ContractMasterGuides: TdsdGuides;
    ceContractChild: TcxButtonEdit;
    ContractChildGuides: TdsdGuides;
    ceBonusValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    cxLabel16: TcxLabel;
    cePartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel17: TcxLabel;
    edAmountCurrency: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrencyPartner: TdsdGuides;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    cxLabel21: TcxLabel;
    edParPartnerValue: TcxCurrencyEdit;
    GuidesTradeMark: TdsdGuides;
    edTradeMark: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edDoc: TcxButtonEdit;
    cxLabel22: TcxLabel;
    GuidesDoc: TdsdGuides;
    ceInvNumberInvoice: TcxTextEdit;
    cxLabel29: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProfitLossServiceForm);

end.
