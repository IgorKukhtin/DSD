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
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dsdInternetAction, MeDOC,
  dsdCommon;

type
  TSale_PartnerJournalForm = class(TAncestorJournalForm)
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
    actPrint_ExpSpec: TdsdPrintAction;
    bbPrint_Spec: TdxBarButton;
    TotalSummChange: TcxGridDBColumn;
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
    InvNumber_TransportGoods: TcxGridDBColumn;
    OperDate_TransportGoods: TcxGridDBColumn;
    actDialog_TTN: TdsdOpenForm;
    spGet_TTN: TdsdStoredProc;
    actGet_TTN: TdsdExecStoredProc;
    mactPrint_TTN: TMultiAction;
    PaymentDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
    spElectron: TdsdStoredProc;
    actElectron: TdsdExecStoredProc;
    bbElectron: TdxBarButton;
    spGetReportNameTransport: TdsdStoredProc;
    actPrint_Transport: TdsdPrintAction;
    actPrint_Transport_ReportName: TdsdExecStoredProc;
    mactPrint_Transport: TMultiAction;
    bbPrint_Transport: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
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
    actPrintPack_Transport: TdsdPrintAction;
    macPrintPack_Transport: TMultiAction;
    macPrintPackList_Transport: TMultiAction;
    actPrintPack: TdsdPrintAction;
    macPrintPack: TMultiAction;
    macPrintPacklist: TMultiAction;
    miPrintPacklist: TMenuItem;
    miPrintPackList_Transport: TMenuItem;
    spSelectPrint_Total_To: TdsdStoredProc;
    actPrint_Total_To: TdsdPrintAction;
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
    PersonalName: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    actPrintPackGross: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
    bbPrint_PackWeight: TdxBarButton;
    actPrint_PackWeight: TdsdPrintAction;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    spSelect_Export: TdsdStoredProc;
    spUpdate_isMail: TdsdStoredProc;
    spGet_Export_Email: TdsdStoredProc;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    ExportEmailDS: TDataSource;
    ExportEmailCDS: TClientDataSet;
    actGet_Export_Email: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actUpdate_isMail: TdsdExecStoredProc;
    spGet_Export_FileName: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    mactExport: TMultiAction;
    macExportAll: TMultiAction;
    bbExport: TdxBarButton;
    macPrintPackList_TTN: TMultiAction;
    macPrintPack_TTN: TMultiAction;
    miPrintPackList_TTN: TMenuItem;
    actPrint_TTN_two: TdsdPrintAction;
    PersonalDriverName_TTN: TcxGridDBColumn;
    PersonalName_4_TTN: TcxGridDBColumn;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
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
    macExportFile_fromMail: TMultiAction;
    bbbExportFile_fromMail: TdxBarButton;
    actExport_file_fromEmail: TdsdStoredProcExportToFile;
    macExportFile_fromMail_All: TMultiAction;
    actGet_Export_FileName_fromMail: TdsdExecStoredProc;
    spGet_Export_FileName_2: TdsdStoredProc;
    spGetDirectoryName: TdsdStoredProc;
    actFileDirectoryDialog: TFileDialogAction;
    spUpdate_PriceList: TdsdStoredProc;
    actOpenChoicePriceList: TOpenChoiceForm;
    actUpdate_PriceList: TdsdExecStoredProc;
    macUpdate_PriceList_list: TMultiAction;
    macUpdate_PriceList: TMultiAction;
    bbUpdate_PriceList: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbBarSeparator: TdxBarSeparator;
    bbsPrintGroup: TdxBarSubItem;
    bbPrintPacklist: TdxBarButton;
    bbsEdit: TdxBarSubItem;
    bbsUnLoad: TdxBarSubItem;
    spUpdateTotalSumm_GoodsReal: TdsdStoredProc;
    actUpdateTotalSumm_GoodsReal: TdsdExecStoredProc;
    bbUpdateTotalSumm_GoodsReal: TdxBarButton;
    spSelectPrintBox: TdsdStoredProc;
    spSelectPrintBoxTotal: TdsdStoredProc;
    actPrintBox: TdsdPrintAction;
    actPrintBoxTotal: TdsdPrintAction;
    bbPrintBoxTotal: TdxBarButton;
    bbactPrintBox: TdxBarButton;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    actPrintBoxTotalPartner: TdsdPrintAction;
    bbPrintBoxTotalPartner: TdxBarButton;
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
