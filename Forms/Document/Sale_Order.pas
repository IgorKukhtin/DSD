unit Sale_Order;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
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
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  Scales, dsdCommon;

type
  TSale_OrderForm = class(TAncestorDocumentForm)
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
    ContractGuides: TdsdGuides;
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
    actSPPrintSaleProcName: TdsdExecStoredProc;
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
    GuidesDocumentTaxKind: TdsdGuides;
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
    cbCOMDOC: TcxCheckBox;
    GuidesCurrencyPartner: TdsdGuides;
    GuidesCurrencyDocument: TdsdGuides;
    edCurrencyDocument: TcxButtonEdit;
    cxLabel17: TcxLabel;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    cxLabel19: TcxLabel;
    actPrint_ExpInvoice: TdsdPrintAction;
    actPrint_ExpPack: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    bbPrint_Pack: TdxBarButton;
    BoxName: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    actGoodsBoxChoice: TOpenChoiceForm;
    cxLabel20: TcxLabel;
    edContractTag: TcxButtonEdit;
    GuidesContractTag: TdsdGuides;
    edInvNumberOrder: TcxButtonEdit;
    GuidesInvNumberOrder: TdsdGuides;
    AmountOrder: TcxGridDBColumn;
    bbChangePercentAmount: TdxBarControlContainerItem;
    bbIsCalcAmountPartner: TdxBarControlContainerItem;
    edChangePercentAmount: TcxCurrencyEdit;
    cbCalcAmountPartner: TcxCheckBox;
    cxLabel21: TcxLabel;
    edParPartnerValue: TcxCurrencyEdit;
    spSelectPrint_ExpInvoice: TdsdStoredProc;
    spSelectPrint_ExpPack: TdsdStoredProc;
    spSelectPrint_Pack: TdsdStoredProc;
    spSelectPrint_Spec: TdsdStoredProc;
    actPrint_ExpSpec: TdsdPrintAction;
    bbPrint_Spec: TdxBarButton;
    actPrint_Pack: TdsdPrintAction;
    actPrint_Spec: TdsdPrintAction;
    bbPrint_Pack21: TdxBarButton;
    bbPrint_Pack22: TdxBarButton;
    spUpdatePriceCurrency: TdsdStoredProc;
    actUpdatePriceCurrency: TdsdExecStoredProc;
    bbUpdatePriceCurrency: TdxBarButton;
    spSelectPrint_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    bbPrint_TTN: TdxBarButton;
    ScaleAction: TScaleAction;
    bbScale: TdxBarButton;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    bbPrint_Quality: TdxBarButton;
    LineNum: TcxGridDBColumn;
    actDialog_TTN: TdsdOpenForm;
    mactPrint_TTN: TMultiAction;
    GoodsGroupNameFull: TcxGridDBColumn;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    spUpdate_MI_Sale_Price: TdsdStoredProc;
    actUpdatePrice: TdsdExecStoredProc;
    bbUpdatePrice: TdxBarButton;
    cxLabel23: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    edParValue: TcxCurrencyEdit;
    cxLabel25: TcxLabel;
    edInvNumberTransport: TcxButtonEdit;
    GuidesTransportChoice: TdsdGuides;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    HeaderSaver2: THeaderSaver;
    spSelectPrintReturnInDay: TdsdStoredProc;
    actPrintReturnInDay: TdsdPrintAction;
    bbPrintReturnInDay: TdxBarButton;
    cbPromo: TcxCheckBox;
    MovementPromo: TcxGridDBColumn;
    PricePromo: TcxGridDBColumn;
    cbPrinted: TcxCheckBox;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    Price_Pricelist_vat: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    spGetReportNameTransport: TdsdStoredProc;
    bbPrint_Transport: TdxBarButton;
    actPrint_Transport: TdsdPrintAction;
    actPrint_Transport_ReportName: TdsdExecStoredProc;
    mactPrint_Transport: TMultiAction;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReport: TdxBarButton;
    cxLabel26: TcxLabel;
    edReestrKind: TcxButtonEdit;
    isPeresort: TcxGridDBColumn;
    cxLabel27: TcxLabel;
    edInvNumberProduction: TcxButtonEdit;
    GuidesProductionDoc: TdsdGuides;
    actOpenProductionForm: TdsdOpenForm;
    bbOpenProduction: TdxBarButton;
    actPrintPackGross: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrderTax: TdxBarButton;
    bbPrint_PackWeight: TdxBarButton;
    actPrint_PackWeight: TdsdPrintAction;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    actOpenFormOrderExternal: TdsdOpenForm;
    bbOrderExternal: TdxBarButton;
    actOpenFormPromo: TdsdOpenForm;
    bbPromo: TdxBarButton;
    spCheckRight: TdsdStoredProc;
    actCheckRight: TdsdExecStoredProc;
    macOpenFormPromo: TMultiAction;
    cxLabel28: TcxLabel;
    edPartionGoodsDate: TcxDateEdit;
    spUpdate_MI_PartionGoodsDate: TdsdStoredProc;
    actUpdate_PartionGoodsDate: TdsdExecStoredProc;
    macUpdate_PartionGoodsDate: TMultiAction;
    macUpdate_PartionGoodsDateList: TMultiAction;
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
    cxLabel31: TcxLabel;
    edReturnIn: TcxButtonEdit;
    GuidesReturnIn: TdsdGuides;
    spUpdateMask: TdsdStoredProc;
    actUpdateMask: TdsdExecStoredProc;
    actSendJournalChoiceMasc: TOpenChoiceForm;
    mactUpdateMaskSend: TMultiAction;
    actReturnJournalChoiceMasc: TOpenChoiceForm;
    mactUpdateMaskReturn: TMultiAction;
    bbUpdateMaskReturn: TdxBarButton;
    bbUpdateMaskSend: TdxBarButton;
    spGet_Export_FileNameXML: TdsdStoredProc;
    spSelectSale_xml: TdsdStoredProc;
    actExport_fileXml: TdsdStoredProcExportToFile;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    actGet_Export_FileNameXml: TdsdExecStoredProc;
    macExport_XML: TMultiAction;
    bbExport_XML: TdxBarButton;
    actOpenProductionUnionForm: TdsdOpenForm;
    bbOpenProductionUnionForm: TdxBarButton;
    bbsEdit: TdxBarSubItem;
    bbsSeparator: TdxBarSeparator;
    bbsShow: TdxBarSubItem;
    bbsUnLoad: TdxBarSubItem;
    bbsPrint: TdxBarSubItem;
    cbCurrencyUser: TcxCheckBox;
    spUpdate_CurrencyUser: TdsdStoredProc;
    actUpdate_CurrencyDialog: TExecuteDialog;
    actUpdate_Currency: TdsdUpdateDataSet;
    mactUpdate_Currency: TMultiAction;
    bbUpdate_Currency: TdxBarButton;
    spSelectPrintBox: TdsdStoredProc;
    actPrintBox: TdsdPrintAction;
    bbPrintBox: TdxBarButton;
    spSelectPrintBoxTotal: TdsdStoredProc;
    actPrintBoxTotal: TdsdPrintAction;
    bbPrintBoxTotal: TdxBarButton;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    actPrintBoxTotalPartner: TdsdPrintAction;
    bbPrintBoxTotalPartner: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sale_OrderForm: TSale_OrderForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSale_OrderForm);

end.
