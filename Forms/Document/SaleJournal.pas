unit SaleJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, EDI, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TSaleJournalForm = class(TAncestorJournalForm)
    OperDatePartner: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalCountPartner: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
    Checked: TcxGridDBColumn;
    edIsPartnerDate: TcxCheckBox;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    spTax: TdsdStoredProc;
    actTax: TdsdExecStoredProc;
    bbTax: TdxBarButton;
    cxLabel14: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    InvNumberPartner_Master: TcxGridDBColumn;
    DocumentTaxKindName: TcxGridDBColumn;
    OKPO_To: TcxGridDBColumn;
    JuridicalName_To: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    TotalCountTare: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
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
    actPrint_Tax_ReportName: TdsdExecStoredProc;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    spGetReporNameBill: TdsdStoredProc;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    actPrint_Account: TdsdPrintAction;
    mactPrint_Account: TMultiAction;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    IsError: TcxGridDBColumn;
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    IsEDI: TcxGridDBColumn;
    spChecked: TdsdStoredProc;
    bbspChecked: TdxBarButton;
    actChecked: TdsdExecStoredProc;
    CurrencyDocumentName: TcxGridDBColumn;
    CurrencyPartnerName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    actPrint_ExpInvoice: TdsdPrintAction;
    actPrint_ExpPack: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    bbPrint_Pack: TdxBarButton;
    spSelectPrint_ExpPack: TdsdStoredProc;
    spSelectPrint_Pack: TdsdStoredProc;
    spSelectPrint_Spec: TdsdStoredProc;
    actPrint_Spec: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    bbPrint_Pack21: TdxBarButton;
    bbPrint_Pack22: TdxBarButton;
    spSelectPrint_ExpInvoice: TdsdStoredProc;
    TotalSummCurrency: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
    bbPrint_Spec: TdxBarButton;
    actPrint_ExpSpec: TdsdPrintAction;
    IsMedoc: TcxGridDBColumn;
    actPrint_TTN: TdsdPrintAction;
    spSelectPrint_TTN: TdsdStoredProc;
    bbTTN: TdxBarButton;
    EdiOrdspr: TcxGridDBColumn;
    EdiInvoice: TcxGridDBColumn;
    EdiDesadv: TcxGridDBColumn;
    actPrint_QualityDoc: TdsdPrintAction;
    spSelectPrint_Quality: TdsdStoredProc;
    bbPrint_Quality: TdxBarButton;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    actDialog_TTN: TdsdOpenForm;
    spGet_TTN: TdsdStoredProc;
    actGet_TTN: TdsdExecStoredProc;
    mactPrint_TTN: TMultiAction;
    PaymentDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    EDI: TEDI;
    spUpdateEdiOrdspr: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    spGetDefaultEDI: TdsdStoredProc;
    actSetDefaults: TdsdExecStoredProc;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    bbInvoice: TdxBarButton;
    bbOrdSpr: TdxBarButton;
    bbDesadv: TdxBarButton;
    N13: TMenuItem;
    miInvoice: TMenuItem;
    miOrdSpr: TMenuItem;
    miDesadv: TMenuItem;
    actExecPrint_EDI: TdsdExecStoredProc;
    isEdiOrdspr_partner: TcxGridDBColumn;
    isEdiInvoice_partner: TcxGridDBColumn;
    isEdiDesadv_partner: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    mactInvoice_Simple: TMultiAction;
    mactInvoice_All: TMultiAction;
    mactOrdSpr_Simple: TMultiAction;
    mactOrdSpr_All: TMultiAction;
    mactDesadv_Simple: TMultiAction;
    mactDesadv_All: TMultiAction;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    MovementId_Order: TcxGridDBColumn;
    bbPrintSaleOrder: TdxBarButton;
    spSelectSale_EDI: TdsdStoredProc;
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    mactUpdateMovementDesc: TMultiAction;
    actUpdateMovementDesc: TdsdExecStoredProc;
    spUpdateMovementDesc: TdsdStoredProc;
    GuidesTo: TdsdGuides;
    dxBarButton1: TdxBarButton;
    PersonalName: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    InvNumber_Transport: TcxGridDBColumn;
    OperDate_Transport: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    spSelectPrintReturnInDay: TdsdStoredProc;
    actPrintReturnInDay: TdsdPrintAction;
    bbPrintReturnInDay: TdxBarButton;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
    isPromo: TcxGridDBColumn;
    MovementPromo: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    spElectron: TdsdStoredProc;
    actElectron: TdsdExecStoredProc;
    bbElectron: TdxBarButton;
    spGetReportNameTransport: TdsdStoredProc;
    actPrint_Transport_ReportName: TdsdExecStoredProc;
    actPrint_Transport: TdsdPrintAction;
    mactPrint_Transport: TMultiAction;
    bbPrint_Transport: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    ReestrKindName: TcxGridDBColumn;
    actPrint_Total: TdsdPrintAction;
    mactPrint_Sale_Total: TMultiAction;
    bbPrint_Sale_Total: TdxBarButton;
    spSelectPrint_Total: TdsdStoredProc;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actPrintPack: TdsdPrintAction;
    macPrintPack: TMultiAction;
    macPrintPacklist: TMultiAction;
    bbPrintPacklist: TdxBarButton;
    actPrintPack_Transport: TdsdPrintAction;
    macPrintPack_Transport: TMultiAction;
    macPrintPackList_Transport: TMultiAction;
    bb: TdxBarButton;
    N14: TMenuItem;
    N15: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSaleJournalForm);
end.
