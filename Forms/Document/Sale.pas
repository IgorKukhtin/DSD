unit Sale;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, EDI, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TSaleForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    GuidesRouteSorting: TdsdGuides;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    GuidesContract: TdsdGuides;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    edIsChecked: TcxCheckBox;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountChangePercent: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    cxLabel12: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    mactPrint_Sale: TMultiAction;
    actUpdatePrice: TdsdExecStoredProc;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    mactPrint_Tax_Us: TMultiAction;
    actPrintTax_Us: TdsdPrintAction;
    spGetReporNameTax: TdsdStoredProc;
    bbPrintTax: TdxBarButton;
    actPrint_Tax_ReportName: TdsdExecStoredProc;
    PrintItemsCDS: TClientDataSet;
    edDocumentTaxKind: TcxButtonEdit;
    cxLabel14: TcxLabel;
    DocumentTaxKindGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    edTax: TcxTextEdit;
    actTax: TdsdExecStoredProc;
    spTax: TdsdStoredProc;
    bbTax: TdxBarButton;
    mactPrint_Tax_Client: TMultiAction;
    actPrintTax_Client: TdsdPrintAction;
    spSelectTax_Client: TdsdStoredProc;
    bbPrintTax_Client: TdxBarButton;
    spSelectTax_Us: TdsdStoredProc;
    spGetReporNameBill: TdsdStoredProc;
    mactPrint_Account: TMultiAction;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    actPrint_Account: TdsdPrintAction;
    bbPrint_Bill: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    mactDECLAR: TMultiAction;
    bbDECLAR: TdxBarButton;
    actExecPrintStoredProc: TdsdExecStoredProc;
    spEDIConnect: TdsdExecStoredProc;
    spConnectWithEDI: TdsdStoredProc;
    bbConnectWithComdoc: TdxBarButton;
    cbCOMDOC: TcxCheckBox;
    mactCOMDOC: TMultiAction;
    EDIDeclar: TEDIAction;
    EDIComdoc: TEDIAction;
    bbEDIComDoc: TdxBarButton;
    EDI: TEDI;
    spGetDefaultEDI: TdsdStoredProc;
    actSetDefaults: TdsdExecStoredProc;
    cxLabel17: TcxLabel;
    edCurrencyDocument: TcxButtonEdit;
    GuidesCurrencyDocument: TdsdGuides;
    cxLabel18: TcxLabel;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel19: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    GuidesCurrencyPartner: TdsdGuides;
    actPrint_ExpInvoice: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    actPrint_ExpPack: TdsdPrintAction;
    bbPrint_Pack: TdxBarButton;
    BoxName: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    actGoodsBoxChoice: TOpenChoiceForm;
    edContractTag: TcxButtonEdit;
    cxLabel20: TcxLabel;
    GuidesContractTag: TdsdGuides;
    edInvNumberOrder: TcxButtonEdit;
    GuidesInvNumberOrder: TdsdGuides;
    spSelectPrint_ExpPack: TdsdStoredProc;
    cbCalcAmountPartner: TcxCheckBox;
    edChangePercentAmount: TcxCurrencyEdit;
    bbIsCalcAmountPartner: TdxBarControlContainerItem;
    bbChangePercentAmount: TdxBarControlContainerItem;
    spSelectPrint_Spec: TdsdStoredProc;
    spSelectPrint_Pack: TdsdStoredProc;
    actPrint_Spec: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    bbPrint_Pack21: TdxBarButton;
    bbPrint_Pack22: TdxBarButton;
    spSelectPrint_ExpInvoice: TdsdStoredProc;
    edParPartnerValue: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    actPrint_ExpSpec: TdsdPrintAction;
    bbPrint_Spec: TdxBarButton;
    spUpdatePriceCurrency: TdsdStoredProc;
    actUpdatePriceCurrency: TdsdExecStoredProc;
    bbUpdatePriceCurrency: TdxBarButton;
    spSelectPrint_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    bbPrint_TTN: TdxBarButton;
    LineNum: TcxGridDBColumn;
    bbPrint_Quality: TdxBarButton;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    mactPrint_TTN: TMultiAction;
    actDialog_TTN: TdsdOpenForm;
    GoodsGroupNameFull: TcxGridDBColumn;
    actAssetGoodsChoiceForm: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    PriceCost: TcxGridDBColumn;
    SumCost: TcxGridDBColumn;
    spUpdate_MI_Sale_Price: TdsdStoredProc;
    bbUpdatePrice: TdxBarButton;
    cxLabel23: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    edParValue: TcxCurrencyEdit;
    Price_Pricelist: TcxGridDBColumn;
    actSPPrintSaleProcName: TdsdExecStoredProc;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    edInvNumberTransport: TcxButtonEdit;
    GuidesTransportChoice: TdsdGuides;
    HeaderSaver2: THeaderSaver;
    spSelectPrintReturnInDay: TdsdStoredProc;
    actPrintReturnInDay: TdsdPrintAction;
    bbPrintReturnInDay: TdxBarButton;
    isBarCode: TcxGridDBColumn;
    CountPack: TcxGridDBColumn;
    WeightTotal: TcxGridDBColumn;
    WeightPack: TcxGridDBColumn;
    TotalPercentAmount: TcxGridDBColumn;
    cbPromo: TcxCheckBox;
    MovementPromo: TcxGridDBColumn;
    PricePromo: TcxGridDBColumn;
    cbPrinted: TcxCheckBox;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    ChangePercent: TcxGridDBColumn;
    Price_Pricelist_vat: TcxGridDBColumn;
    spGetReportNameTransport: TdsdStoredProc;
    bbPrint_Transport: TdxBarButton;
    mactPrint_Transport: TMultiAction;
    actPrint_Transport: TdsdPrintAction;
    actPrint_Transport_ReportName: TdsdExecStoredProc;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    cxLabel26: TcxLabel;
    edReestrKind: TcxButtonEdit;
    isPeresort: TcxGridDBColumn;
    cxLabel27: TcxLabel;
    edInvNumberProduction: TcxButtonEdit;
    GuidesProductionDoc: TdsdGuides;
    actOpenProductionForm: TdsdOpenForm;
    bbOpenProduction: TdxBarButton;
    bbPrintPackGross: TdxBarButton;
    actPrintPackGross: TdsdPrintAction;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrderTax: TdxBarButton;
    bbPrint_PackWeight: TdxBarButton;
    actPrint_PackWeight: TdsdPrintAction;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    mactPrint_QualityDoc: TMultiAction;
    actDialog_QualityDoc: TdsdOpenForm;
    actOpenFormOrderExternal: TdsdOpenForm;
    bbOrderExternal: TdxBarButton;
    actOpenFormPromo: TdsdOpenForm;
    bbPromo: TdxBarButton;
    spCheckRight: TdsdStoredProc;
    macOpenFormPromo: TMultiAction;
    actCheckRight: TdsdExecStoredProc;
    cxLabel28: TcxLabel;
    edPartionGoodsDate: TcxDateEdit;
    spUpdate_MI_PartionGoodsDate: TdsdStoredProc;
    actUpdate_PartionGoodsDate: TdsdExecStoredProc;
    macUpdate_PartionGoodsDate: TMultiAction;
    macUpdate_PartionGoodsDateList: TMultiAction;
    actRefreshMI: TdsdDataSetRefresh;
    bbUpdate_PartionGoodsDateList: TdxBarButton;
    spUpdate_Invnumber: TdsdStoredProc;
    actUpdate_Invnumber: TdsdUpdateDataSet;
    actUpdate_InvnumberDialog: TExecuteDialog;
    macUpdate_Invnumber: TMultiAction;
    bbUpdate_Invnumber: TdxBarButton;
    cbReCalcPrice: TcxCheckBox;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    cxLabel29: TcxLabel;
    edPriceListIn: TcxButtonEdit;
    GuidesPriceListIn: TdsdGuides;
    spUpdateMI_Sale_PriceIn: TdsdStoredProc;
    actUpdateMI_Sale_PriceIn: TdsdExecStoredProc;
    macUpdateMI_Sale_PriceIn: TMultiAction;
    bbUpdateMI_Sale_PriceIn: TdxBarButton;
    cxLabel30: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    GuidesReturnIn: TdsdGuides;
    cxLabel31: TcxLabel;
    edReturnIn: TcxButtonEdit;
    spInsert_MI_Sale_byReturnIn: TdsdStoredProc;
    HeaderExit: THeaderExit;
    actInsert_MI_Sale_byReturnIn: TdsdExecStoredProc;
    spUpdateMask: TdsdStoredProc;
    actSendJournalChoiceMasc: TOpenChoiceForm;
    mactUpdateMaskSend: TMultiAction;
    actUpdateMask: TdsdExecStoredProc;
    actReturnJournalChoiceMasc: TOpenChoiceForm;
    mactUpdateMaskReturn: TMultiAction;
    bbUpdateMaskReturn: TdxBarButton;
    bbUpdateMaskSend: TdxBarButton;
    spGet_Export_FileNameXML: TdsdStoredProc;
    spSelectSale_xml: TdsdStoredProc;
    actExport_fileXml: TdsdStoredProcExportToFile;
    actGet_Export_FileNameXml: TdsdExecStoredProc;
    macExport_XML: TMultiAction;
    bbExport_XML: TdxBarButton;
    ExportDS: TDataSource;
    ExportCDS: TClientDataSet;
    actOpenWeighingPartner_bySale: TdsdOpenForm;
    bbOpenWeighingPartner_bySale: TdxBarButton;
    bbOpenProductionUnionForm: TdxBarButton;
    actOpenProductionUnionForm: TdsdOpenForm;
    mactSendETTN: TMultiAction;
    actSendETTN: TdsdEDINAction;
    actExecSelectPrint_TTN: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    bbsEdit: TdxBarSubItem;
    bbsPrint: TdxBarSubItem;
    bbSeparator: TdxBarSeparator;
    bbsShow: TdxBarSubItem;
    bbsUnLoad: TdxBarSubItem;
    spUpdate_CurrencyUser: TdsdStoredProc;
    actUpdate_CurrencyDialog: TExecuteDialog;
    actUpdate_Currency: TdsdUpdateDataSet;
    mactUpdate_Currency: TMultiAction;
    cbCurrencyUser: TcxCheckBox;
    bbUpdate_Currency: TdxBarButton;
    cbTotalSumm_GoodsReal: TcxCheckBox;
    spUpdateTotalSumm_GoodsReal: TdsdStoredProc;
    actUpdateTotalSumm_GoodsReal: TdsdExecStoredProc;
    bbUpdateTotalSumm_GoodsReal: TdxBarButton;
    actPrintBox: TdsdPrintAction;
    spSelectPrintBox: TdsdStoredProc;
    bbPrintBox: TdxBarButton;
    spSelectPrintBoxTotal: TdsdStoredProc;
    actPrintBoxTotal: TdsdPrintAction;
    bbPrintBoxTotal: TdxBarButton;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    bbPrintBoxTotalPartner: TdxBarButton;
    actPrintBoxTotalPartner: TdsdPrintAction;
    actPrintBoxTotal1: TdsdPrintAction;
    bbb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
