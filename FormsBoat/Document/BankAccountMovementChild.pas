unit BankAccountMovementChild;

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
  TBankAccountMovementChildForm = class(TAncestorEditDialog_boatForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceAmount: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel6: TcxLabel;
    ceObject: TcxButtonEdit;
    GuidesObject: TdsdGuides;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    edInvNumber: TcxTextEdit;
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel18: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    actGuidesInvoiceChoiceForm: TOpenChoiceForm;
    bbGuidesInvoiceChoiceForm: TcxButton;
    cxLabel9: TcxLabel;
    edInvoiceKind: TcxButtonEdit;
    GuidesInvoiceKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edParent: TcxButtonEdit;
    GuidesParent: TdsdGuides;
    cxLabel2: TcxLabel;
    edAmount_invoice: TcxCurrencyEdit;
    actGuidesParentChoiceForm: TOpenChoiceForm;
    bbGuidesParentChoiceForm: TcxButton;
    spGet_PrePay: TdsdStoredProc;
    spGet_Pay: TdsdStoredProc;
    spGet_Proforma: TdsdStoredProc;
    spGet_Service: TdsdStoredProc;
    actGet_PrePay: TdsdExecStoredProc;
    actGet_Pay: TdsdExecStoredProc;
    actGet_Proforma: TdsdExecStoredProc;
    actGet_Service: TdsdExecStoredProc;
    btnGet_PrePay: TcxButton;
    btnGet_Pay: TcxButton;
    btnGet_Proforma: TcxButton;
    btnGet_Service: TcxButton;
    cxLabel5: TcxLabel;
    cmText: TcxMemo;
    cxLabel3: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    ceAmount_pay: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountMovementChildForm);

end.
