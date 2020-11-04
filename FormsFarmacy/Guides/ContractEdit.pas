unit ContractEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, cxCheckBox,
  dsdGuides, cxMaskEdit, cxButtonEdit, cxTextEdit, cxCurrencyEdit, cxLabel,
  dsdDB, dsdAction, Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls,
  cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar,
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
  dxSkinXmas2008Blue;

type
  TContractEditForm = class(TAncestorEditDialogForm)
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edName: TcxTextEdit;
    cxLabel4: TcxLabel;
    ceJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel5: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceDeferment: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edStartDate: TcxDateEdit;
    cxLabel8: TcxLabel;
    edEndDate: TcxDateEdit;
    cxLabel9: TcxLabel;
    cePercent: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceGroupMemberSP: TcxButtonEdit;
    GroupMemberSPGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    cePercentSP: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edBankAccount: TcxButtonEdit;
    BankAccountGuides: TdsdGuides;
    edBank: TcxTextEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    ceOrderSumm: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceOrderSummComment: TcxTextEdit;
    cxLabel16: TcxLabel;
    ceOrderTime: TcxTextEdit;
    edSigningDate: TcxDateEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    cbPartialPay: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractEditForm);

end.

