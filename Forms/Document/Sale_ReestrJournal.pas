unit Sale_ReestrJournal;

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
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, EDI, dsdInternetAction;

type
  TSale_ReestrJournalForm = class(TAncestorJournalForm)
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
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    spTax: TdsdStoredProc;
    actTax: TdsdExecStoredProc;
    bbTax: TdxBarButton;
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
    actMovementCheck: TdsdOpenForm;
    bbMovementCheck: TdxBarButton;
    spChecked: TdsdStoredProc;
    bbactChecked: TdxBarButton;
    actChecked: TdsdExecStoredProc;
    RouteName: TcxGridDBColumn;
    actPrint_ExpInvoice: TdsdPrintAction;
    actPrint_ExpPack: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    bbPrint_Pack: TdxBarButton;
    spSelectPrint_ExpInvoice: TdsdStoredProc;
    actPrint_ExpSpec: TdsdPrintAction;
    bbPrint_Spec: TdxBarButton;
    spSelectPrint_ExpPack: TdsdStoredProc;
    spSelectPrint_Spec: TdsdStoredProc;
    spSelectPrint_Pack: TdsdStoredProc;
    actPrint_Pack: TdsdPrintAction;
    actPrint_Spec: TdsdPrintAction;
    bbPrint_Pack21: TdxBarButton;
    bbPrint_Pack22: TdxBarButton;
    spSelectPrint_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    bbPrint_TTN: TdxBarButton;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    bbPrint_Quality: TdxBarButton;
    PersonalName: TcxGridDBColumn;
    mactPrint_TTN: TMultiAction;
    actDialog_TTN: TdsdOpenForm;
    actGet_TTN: TdsdExecStoredProc;
    spGet_TTN: TdsdStoredProc;
    InsertDate: TcxGridDBColumn;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
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
    Comment: TcxGridDBColumn;
    mactInvoice_Simple: TMultiAction;
    mactInvoice_All: TMultiAction;
    mactOrdSpr_Simple: TMultiAction;
    mactOrdSpr_All: TMultiAction;
    mactDesadv_Simple: TMultiAction;
    mactDesadv_All: TMultiAction;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    MovementId_Order: TcxGridDBColumn;
    actPrintSaleOrder: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    spSelectSale_EDI: TdsdStoredProc;
    RouteGroupName: TcxGridDBColumn;
    spSelectPrintReturnInDay: TdsdStoredProc;
    actPrintReturnInDay: TdsdPrintAction;
    bbPrintReturnInDay: TdxBarButton;
    isPromo: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    spElectron: TdsdStoredProc;
    actElectron: TdsdExecStoredProc;
    bbElectron: TdxBarButton;
    spGetReportNameTransport: TdsdStoredProc;
    actPrint_Transport: TdsdPrintAction;
    actPrint_Transport_ReportName: TdsdExecStoredProc;
    mactPrint_Transport: TMultiAction;
    bbPrint_Transport: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbactOpenReport: TdxBarButton;
    spSelectPrint_Total: TdsdStoredProc;
    mactPrint_Sale_Total: TMultiAction;
    actPrint_Total: TdsdPrintAction;
    bbPrint_Sale_Total: TdxBarButton;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    InvNumber_Reestr: TcxGridDBColumn;
    OperDate_Reestr: TcxGridDBColumn;
    CarModelName_Reestr: TcxGridDBColumn;
    OperDate_Transport_reestr: TcxGridDBColumn;
    actPrintPack: TdsdPrintAction;
    macPrintPack: TMultiAction;
    macPrintPacklist: TMultiAction;
    N14: TMenuItem;
    actPrintPack_Transport: TdsdPrintAction;
    macPrintPack_Transport: TMultiAction;
    macPrintPackList_Transport: TMultiAction;
    N15: TMenuItem;
    actPrint_Total_To: TdsdPrintAction;
    spSelectPrint_Total_To: TdsdStoredProc;
    mactPrint_Sale_Total_To: TMultiAction;
    bbPrint_Sale_Total_To: TdxBarButton;
    spDelete_LockUnique: TdsdStoredProc;
    spInsert_LockUnique: TdsdStoredProc;
    spSelectPrint_Total_List: TdsdStoredProc;
    actDelete_LockUnique: TdsdExecStoredProc;
    actInsert_LockUnique: TdsdExecStoredProc;
    macInsert_LockUnique: TMultiAction;
    actPrint_Total_List: TdsdPrintAction;
    mactPrint_Sale_Total_List: TMultiAction;
    bbPrint_Sale_Total_List: TdxBarButton;
    actPrint_Account_List: TdsdPrintAction;
    mactPrint_Account_List: TMultiAction;
    bbPrint_Account_List: TdxBarButton;
    actPrintPackGross: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrderTax: TdxBarButton;
    bbPrint_PackWeight: TdxBarButton;
    actPrint_PackWeight: TdsdPrintAction;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    bbsPrint: TdxBarSubItem;
    bbBarSeparator: TdxBarSeparator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sale_ReestrJournalForm: TSale_ReestrJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSale_ReestrJournalForm);
end.
