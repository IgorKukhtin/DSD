unit Sale_PartnerJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet;

type
  TSale_PartnerJournalForm = class(TAncestorJournalForm)
    colOperDatePartner: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalCountPartner: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colChangePercent: TcxGridDBColumn;
    colPriceWithVAT: TcxGridDBColumn;
    colVATPercent: TcxGridDBColumn;
    colTotalSummVAT: TcxGridDBColumn;
    colTotalSummMVAT: TcxGridDBColumn;
    colTotalSummPVAT: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colInvNumberOrder: TcxGridDBColumn;
    colChecked: TcxGridDBColumn;
    colRouteSortingName: TcxGridDBColumn;
    edIsPartnerDate: TcxCheckBox;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    spTax: TdsdStoredProc;
    actTax: TdsdExecStoredProc;
    bbTax: TdxBarButton;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    colInvNumberPartner_Master: TcxGridDBColumn;
    colDocumentTaxKindName: TcxGridDBColumn;
    colOKPO_To: TcxGridDBColumn;
    colJuridicalName_To: TcxGridDBColumn;
    colInvNumberPartner: TcxGridDBColumn;
    colTotalCountTare: TcxGridDBColumn;
    colTotalCountSh: TcxGridDBColumn;
    colTotalCountKg: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    spGetReporNameTax: TdsdStoredProc;
    spGetReportName: TdsdStoredProc;
    mactPrint_Sale: TMultiAction;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    actPrint: TdsdPrintAction;
    actSPPrintSaleProcName: TdsdExecStoredProc;
    actSPPrintSaleTaxProcName: TdsdExecStoredProc;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    spGetReporNameBill: TdsdStoredProc;
    actSPPrintSaleBillProcName: TdsdExecStoredProc;
    actPrint_Bill: TdsdPrintAction;
    mactPrint_Bill: TMultiAction;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    colIsError: TcxGridDBColumn;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    spChecked: TdsdStoredProc;
    bbactChecked: TdxBarButton;
    actChecked: TdsdExecStoredProc;
    colIsEDI: TcxGridDBColumn;
    clRouteName: TcxGridDBColumn;
    colCurrencyDocumentName: TcxGridDBColumn;
    colCurrencyPartnerName: TcxGridDBColumn;
    actPrint_Invoice: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    bbPrint_Pack: TdxBarButton;
    spSelectPrintPack: TdsdStoredProc;
    spSelectPrintPack21: TdsdStoredProc;
    spSelectPrintPack22: TdsdStoredProc;
    actPrint_Pack22: TdsdPrintAction;
    actPrint_Pack21: TdsdPrintAction;
    bbPrint_Pack21: TdxBarButton;
    bbPrint_Pack22: TdxBarButton;
    spSelectPrintInvoice: TdsdStoredProc;
    TotalSummCurrency: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
    actPrint_Spec: TdsdPrintAction;
    bbPrint_Spec: TdxBarButton;
    colTotalSummChange: TcxGridDBColumn;
    colIsMedoc: TcxGridDBColumn;
    spSelectPrintTTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    bbPrint_TTN: TdxBarButton;
    clEdiOrdspr: TcxGridDBColumn;
    clEdiInvoice: TcxGridDBColumn;
    clEdiDesadv: TcxGridDBColumn;
    spSelectPrintQuality: TdsdStoredProc;
    actPrint_Quality: TdsdPrintAction;
    bbPrint_Quality: TdxBarButton;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    actDialog_TTN: TdsdOpenForm;
    spGet_TTN: TdsdStoredProc;
    actGet_TTN: TdsdExecStoredProc;
    mactPrint_TTN: TMultiAction;
    colPaymentDate: TcxGridDBColumn;
    colInsertDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sale_PartnerJournalForm: TSale_PartnerJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSale_PartnerJournalForm);
end.
