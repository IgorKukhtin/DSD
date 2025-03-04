unit Sale_OrderJournal;

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
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, EDI, dsdInternetAction,
  dsdExportToXLSAction, dsdCommon;

type
  TSale_OrderJournalForm = class(TAncestorJournalForm)
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
    spChecked: TdsdStoredProc;
    bbactChecked: TdxBarButton;
    actChecked: TdsdExecStoredProc;
    IsEDI: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    CurrencyDocumentName: TcxGridDBColumn;
    CurrencyPartnerName: TcxGridDBColumn;
    actPrint_ExpInvoice: TdsdPrintAction;
    actPrint_ExpPack: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    bbPrint_Pack: TdxBarButton;
    TotalSummCurrency: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
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
    IsMedoc: TcxGridDBColumn;
    spSelectPrint_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    bbPrint_TTN: TdxBarButton;
    EdiOrdspr: TcxGridDBColumn;
    EdiInvoice: TcxGridDBColumn;
    EdiDesadv: TcxGridDBColumn;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    bbPrint_Quality: TdxBarButton;
    PersonalName: TcxGridDBColumn;
    mactPrint_TTN: TMultiAction;
    actDialog_TTN: TdsdOpenForm;
    actGet_TTN: TdsdExecStoredProc;
    spGet_TTN: TdsdStoredProc;
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
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
    MovementPromo: TcxGridDBColumn;
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
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    spSelect_Export: TdsdStoredProc;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    spGet_Export_FileName: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    mactExport: TMultiAction;
    bbExport: TdxBarButton;
    spGet_Export_Email: TdsdStoredProc;
    actGet_Export_Email: TdsdExecStoredProc;
    actSMTPFile: TdsdSMTPFileAction;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
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
    actPrintPack: TdsdPrintAction;
    macPrintPack: TMultiAction;
    macPrintPacklist: TMultiAction;
    actPrintPack_Transport: TdsdPrintAction;
    macPrintPack_Transport: TMultiAction;
    macPrintPackList_Transport: TMultiAction;
    N14: TMenuItem;
    N15: TMenuItem;
    spSelectPrint_Total_To: TdsdStoredProc;
    bbPrint_Sale_Total_To: TdxBarButton;
    actPrint_Total_To: TdsdPrintAction;
    mactPrint_Sale_Total_To: TMultiAction;
    spDelete_LockUnique: TdsdStoredProc;
    spInsert_LockUnique: TdsdStoredProc;
    spSelectPrint_Total_List: TdsdStoredProc;
    actDelete_LockUnique: TdsdExecStoredProc;
    actInsert_LockUnique: TdsdExecStoredProc;
    actPrint_Total_List: TdsdPrintAction;
    macInsert_LockUnique: TMultiAction;
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
    spUpdate_isMail: TdsdStoredProc;
    actUpdate_isMail: TdsdExecStoredProc;
    macExportAll: TMultiAction;
    bbmacExportAll: TdxBarButton;
    PersonalDriverName_TTN: TcxGridDBColumn;
    PersonalName_4_TTN: TcxGridDBColumn;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    PrintSignCDS: TClientDataSet;
    spGet_Export_FileName_xls: TdsdStoredProc;
    spSelectPrintItem: TdsdStoredProc;
    spSelectPrintHeader: TdsdStoredProc;
    spSelectPrintSign: TdsdStoredProc;
    actGet_Export_FileName_xls: TdsdExecStoredProc;
    actSelect_Export_xls: TdsdExecStoredProc;
    mactExport_xls: TMultiAction;
    dxBarButton1: TdxBarButton;
    spSelectPrintItem2244900110: TdsdStoredProc;
    mactExport_xls_2244900110: TMultiAction;
    bbExport_xls_2244900110: TdxBarButton;
    dsdPrintAction1: TdsdPrintAction;
    dsdPrintAction2: TdsdPrintAction;
    actExport_fr3: TdsdPrintAction;
    spUpdateMI_Sale_PriceIn: TdsdStoredProc;
    actUpdateMI_Sale_PriceIn: TdsdExecStoredProc;
    macUpdateMI_Sale_PriceIn_list: TMultiAction;
    macUpdateMI_Sale_PriceIn: TMultiAction;
    bbUpdateMI_Sale_PriceIn: TdxBarButton;
    spUpdate_MI_AmountPartner_round: TdsdStoredProc;
    ExecuteDialogUpdateAmountPartner: TExecuteDialog;
    actRoundAmountPartner: TdsdExecStoredProc;
    macRoundAmountPartner_list: TMultiAction;
    macRoundAmountPartner: TMultiAction;
    bbRoundAmountPartner: TdxBarButton;
    spGet_Export_FileNameXML: TdsdStoredProc;
    spSelectSale_xml: TdsdStoredProc;
    actExport_fileXml: TdsdStoredProcExportToFile;
    actGet_Export_FileNameXml: TdsdExecStoredProc;
    macExport_XML: TMultiAction;
    bbExport_XML: TdxBarButton;
    actFileDirectoryDialog: TFileDialogAction;
    spGet_Export_FileName_2: TdsdStoredProc;
    actGet_Export_FileName_fromMail: TdsdExecStoredProc;
    actExport_file_fromEmail: TdsdStoredProcExportToFile;
    macExportFile_fromMail: TMultiAction;
    macExportFile_fromMail_All: TMultiAction;
    bbExportFile_fromMail_All: TdxBarButton;
    spGetReportNameQuality_list: TdsdStoredProc;
    spInsertUpdate_TTN_byTransport: TdsdStoredProc;
    spInsertUpdate_Quality_byTransport: TdsdStoredProc;
    spSelectPrint_Quality_list: TdsdStoredProc;
    actPrint_Quality_ReportName_list: TdsdExecStoredProc;
    actPrint_QualityDoc_list: TdsdPrintAction;
    actSPPrintTTNProcName_list: TdsdExecStoredProc;
    actInsertUpdate_TTN_byTransport: TdsdExecStoredProc;
    actInsertUpdate_Quality_byTransport: TdsdExecStoredProc;
    actPrint_TTN_list: TdsdPrintAction;
    macPrint_QualityDoc_list: TMultiAction;
    macPrint_TTN_2copy_list: TMultiAction;
    macPrint_Group_list: TMultiAction;
    macPrint_Group: TMultiAction;
    bbPrint_Group: TdxBarButton;
    cxLabel30: TcxLabel;
    edInvNumberTransport: TcxButtonEdit;
    GuidesTransport: TdsdGuides;
    spUpdate_PriceList: TdsdStoredProc;
    actOpenChoicePriceList: TOpenChoiceForm;
    actUpdate_PriceList: TdsdExecStoredProc;
    macUpdate_PriceList_list: TMultiAction;
    macUpdate_PriceList: TMultiAction;
    bbUpdate_PriceList: TdxBarButton;
    actPrintPack_2copy: TdsdPrintAction;
    macPrintPack_2copy: TMultiAction;
    macPrint_Group_list_cash: TMultiAction;
    macPrint_Group_cash: TMultiAction;
    bbPrint_Group_cash: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbsPrintGroup: TdxBarSubItem;
    bbBarSeparator: TdxBarSeparator;
    bbsEdit: TdxBarSubItem;
    bbsUnLoad: TdxBarSubItem;
    bbsSend: TdxBarSubItem;
    bbPrintPacklist: TdxBarButton;
    spUpdatePrintAuto_False: TdsdStoredProc;
    spUpdatePrintAuto_True: TdsdStoredProc;
    actUpdatePrintAuto_False: TdsdExecStoredProc;
    actUpdatePrintAuto_True: TdsdExecStoredProc;
    macPrint_Group_cash_Ret: TMultiAction;
    actPrintReturnInDay_2copy: TdsdPrintAction;
    macPrint_Group_list_cash_Ret: TMultiAction;
    bbPrint_Group_cash_Ret: TdxBarButton;
    actPrint_TTN_copy1_list: TdsdPrintAction;
    macPrint_TTN_Copy1_list: TMultiAction;
    macPrint_Sale2_TTN_Quality_list: TMultiAction;
    macPrint_Sale2_TTN_Quality: TMultiAction;
    actPrintPack_3copy: TdsdPrintAction;
    macPrintPack_3copy: TMultiAction;
    macPrint_Sale3_TTN_Quality_list: TMultiAction;
    macPrint_Sale3_TTN_Quality: TMultiAction;
    bbPrint_Sale2_TTN_Quality: TdxBarButton;
    bbPrint_Sale3_TTN_Quality: TdxBarButton;
    actPrint_TTN_copy3_list: TdsdPrintAction;
    macPrint_TTN_Copy3_list: TMultiAction;
    spSelectPrintBox: TdsdStoredProc;
    spSelectPrintBoxTotal: TdsdStoredProc;
    actPrintBox: TdsdPrintAction;
    actPrintBoxTotal: TdsdPrintAction;
    bbPrintBoxTotal: TdxBarButton;
    bbPrintBox: TdxBarButton;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    actPrintBoxTotalPartner: TdsdPrintAction;
    bbPrintBoxTotalPartner: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sale_OrderJournalForm: TSale_OrderJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSale_OrderJournalForm);
end.
