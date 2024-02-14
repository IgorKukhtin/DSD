unit BankAccountChild;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog_boat, cxGraphics,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxMemo;

type
  TBankAccountChildForm = class(TAncestorEditDialog_boatForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    ceBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    ceAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceAmountOut: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    ceObject: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    edInvNumber: TcxTextEdit;
    ceBank: TcxButtonEdit;
    cxLabel13: TcxLabel;
    GuidesBank: TdsdGuides;
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel18: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    GuidesFiller: TGuidesFiller;
    cxLabel4: TcxLabel;
    GuidesParent: TdsdGuides;
    edParent: TcxButtonEdit;
    actGuidesInvoiceChoiceForm: TOpenChoiceForm;
    bbGuidesInvoiceChoiceForm: TcxButton;
    actGuidesParentChoiceForm: TOpenChoiceForm;
    bbGuidesParentChoiceForm: TcxButton;
    cxLabel9: TcxLabel;
    edInvoiceKind: TcxButtonEdit;
    GuidesInvoiceKind: TdsdGuides;
    cmText: TcxMemo;
    cxLabel8: TcxLabel;
    cxLabel11: TcxLabel;
    ceAmount_pay: TcxCurrencyEdit;
    edAmount_invoice: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    cxLabel12: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    spGet_PrePay: TdsdStoredProc;
    spGet_Pay: TdsdStoredProc;
    spGet_Proforma: TdsdStoredProc;
    spGet_Service: TdsdStoredProc;
    btnGet_PrePay: TcxButton;
    btnGet_Pay: TcxButton;
    btnGet_Proforma: TcxButton;
    btnGet_Service: TcxButton;
    actGet_Pay: TdsdExecStoredProc;
    actGet_Proforma: TdsdExecStoredProc;
    actGet_Service: TdsdExecStoredProc;
    actGet_PrePay: TdsdExecStoredProc;
    cxLabel14: TcxLabel;
    edString_7: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountChildForm);

end.
