unit BankAccountMovement;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxMemo,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxPC;

type
  TBankAccountMovementForm = class(TAncestorEditDialog_boatForm)
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
    actGuidesInvoiceChoiceForm: TOpenChoiceForm;
    bbGuidesInvoiceChoiceForm: TcxButton;
    actGuidesParentChoiceForm: TOpenChoiceForm;
    bbGuidesParentChoiceForm: TcxButton;
    cxLabel9: TcxLabel;
    edInvoiceKind: TcxButtonEdit;
    GuidesInvoiceKind: TdsdGuides;
    cxLabel5: TcxLabel;
    cmText: TcxMemo;
    edParent: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edAmount_invoice: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actGuidesObjectChoiceForm: TOpenChoiceForm;
    btnGuidesObjectChoiceForm: TcxButton;
    actGet_Pay: TdsdExecStoredProc;
    actGet_Proforma: TdsdExecStoredProc;
    actGet_Service: TdsdExecStoredProc;
    actGet_PrePay: TdsdExecStoredProc;
    spGet_PrePay: TdsdStoredProc;
    spGet_Pay: TdsdStoredProc;
    spGet_Proforma: TdsdStoredProc;
    spGet_Service: TdsdStoredProc;
    btnGet_PrePay: TcxButton;
    btnGet_Pay: TcxButton;
    btnGet_Proforma: TcxButton;
    btnGet_Service: TcxButton;
    edString_7: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxLabel11: TcxLabel;
    GuidesBankAccount_p2: TdsdGuides;
    cxLabel20: TcxLabel;
    cxLabel12: TcxLabel;
    edCode: TcxCurrencyEdit;
    edTaxNumber: TcxTextEdit;
    cxLabel19: TcxLabel;
    edTaxKind: TcxButtonEdit;
    edName: TcxTextEdit;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    edPLZ: TcxButtonEdit;
    cxLabel21: TcxLabel;
    edStreet: TcxTextEdit;
    edCountry: TcxButtonEdit;
    cxLabel23: TcxLabel;
    cxLabel22: TcxLabel;
    edCity: TcxButtonEdit;
    edStreet_add: TcxTextEdit;
    cxLabel25: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    spInsert_MoneyPlace: TdsdStoredProc;
    edIBAN: TcxTextEdit;
    GuidesTaxKind: TdsdGuides;
    GuidesCountry: TdsdGuides;
    GuidesPLZ: TdsdGuides;
    spUpdate_MoneyPlace: TdsdStoredProc;
    actInsert_MoneyPlace: TdsdExecStoredProc;
    actInsertUpdate_MoneyPlace: TdsdExecStoredProc;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    spGet_MoneyPlace_Clear: TdsdStoredProc;
    actClear_MoneyPlace: TdsdExecStoredProc;
    spGet_MoneyPlace: TdsdStoredProc;
    actGet_MoneyPlace: TdsdExecStoredProc;
    cxPageControl1: TcxPageControl;
    Main: TcxTabSheet;
    cxTabSheet1: TcxTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountMovementForm);

end.
