unit ReturnIn;

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
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxImageComboBox,
  cxSplitter, dsdCommon;

type
  TReturnInForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    edFrom: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesTo: TdsdGuides;
    GuidesFrom: TdsdGuides;
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
    AmountPartner: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    actTaxJournalChoice: TOpenChoiceForm;
    N2: TMenuItem;
    N3: TMenuItem;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    spGetReportName: TdsdStoredProc;
    actSPPrintProcName: TdsdExecStoredProc;
    mactPrint: TMultiAction;
    PrintItemsCDS: TClientDataSet;
    edDocumentTaxKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesDocumentTaxKind: TdsdGuides;
    edPriceList: TcxButtonEdit;
    cxLabel11: TcxLabel;
    PriceListGuides: TdsdGuides;
    spTaxCorrective: TdsdStoredProc;
    actTaxCorrective: TdsdExecStoredProc;
    bbTaxCorrective: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    cxLabel12: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    MeasureName: TcxGridDBColumn;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    bbPrintTaxCorrective_Us: TdxBarButton;
    bbPrintTaxCorrective_Client: TdxBarButton;
    actCorrective: TdsdExecStoredProc;
    spCorrective: TdsdStoredProc;
    bbCorrective: TdxBarButton;
    edInvNumberMark: TcxTextEdit;
    cxLabel13: TcxLabel;
    actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction;
    bbPrint_Return_By_TaxCorrective: TdxBarButton;
    cxLabel14: TcxLabel;
    edCurrencyDocument: TcxButtonEdit;
    GuidesCurrencyDocument: TdsdGuides;
    cxLabel16: TcxLabel;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    GuidesCurrencyPartner: TdsdGuides;
    TaxCorrectiveCDS: TClientDataSet;
    TaxCorrectiveDS: TDataSource;
    gpUpdateTaxCorrective: TdsdStoredProc;
    spSelectTaxCorrective: TdsdStoredProc;
    spMovementCompleteTaxCorrective: TdsdStoredProc;
    spMovementSetErasedTaxCorrective: TdsdStoredProc;
    spMovementUnCompleteTaxCorrective: TdsdStoredProc;
    actUpdateTaxCorrectiveDS: TdsdUpdateDataSet;
    actUnCompleteTaxCorrective: TdsdChangeMovementStatus;
    actCompleteTaxCorrective: TdsdChangeMovementStatus;
    actSetErasedTaxCorrective: TdsdChangeMovementStatus;
    colIsError: TcxGridDBColumn;
    colInvNumberPartner_Child: TcxGridDBColumn;
    colOperDate_Child: TcxGridDBColumn;
    colTaxKindName: TcxGridDBColumn;
    bbCompleteTaxCorrective: TdxBarButton;
    bbSetErasedTaxCorrective: TdxBarButton;
    bbUnCompleteTaxCorrective: TdxBarButton;
    TaxCorrectiveViewAddOn: TdsdDBViewAddOn;
    colContractTagName: TcxGridDBColumn;
    colContractCode: TcxGridDBColumn;
    cxLabel20: TcxLabel;
    edContractTag: TcxButtonEdit;
    GuidesContractTag: TdsdGuides;
    cbCalcAmountPartner: TcxCheckBox;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    actGoodsKindChoice: TOpenChoiceForm;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    mactPrint_TaxCorrective_Us: TMultiAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    LineNum: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel19: TcxLabel;
    edInvNumberSale: TcxButtonEdit;
    GuidesSaleChoice: TdsdGuides;
    PartionMovementName: TcxGridDBColumn;
    actSaleJournalChoice: TOpenChoiceForm;
    cxLabel18: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel21: TcxLabel;
    edInvNumberParent: TcxButtonEdit;
    GuidesParentChoice: TdsdGuides;
    actGoodsChoice: TOpenChoiceForm;
    actOpenTaxCorrective: TdsdOpenForm;
    bbOpenTaxCorrective: TdxBarButton;
    cbPartner: TcxCheckBox;
    spUpdate_MI_ReturnIn_Price: TdsdStoredProc;
    actUpdatePrice: TdsdExecStoredProc;
    bbUpdatePrice: TdxBarButton;
    Price_Pricelist: TcxGridDBColumn;
    isCheck_Pricelist: TcxGridDBColumn;
    mactPrintPriceCorr: TMultiAction;
    bbPrintPriceCorr: TdxBarButton;
    spGetReportNamePriceCorr: TdsdStoredProc;
    actSPPrintProcNamePriceCorr: TdsdExecStoredProc;
    spUpdate_MI_ReturnIn_AmountPartner: TdsdStoredProc;
    actUpdateAmountPartner: TdsdExecStoredProc;
    bbUpdateAmountPartner: TdxBarButton;
    cbPromo: TcxCheckBox;
    MovementPromo: TcxGridDBColumn;
    Price_Pricelist_vat: TcxGridDBColumn;
    actOpenTax: TdsdOpenForm;
    bbOpenTax: TdxBarButton;
    actShowMessage: TShowMessageAction;
    edStartDateTax: TcxDateEdit;
    cxLabel22: TcxLabel;
    cbList: TcxCheckBox;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MI_Child: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    childAmount: TcxGridDBColumn;
    childPrice: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    childGoodsKindName: TcxGridDBColumn;
    childGoodsName: TcxGridDBColumn;
    childGoodsCode: TcxGridDBColumn;
    childAmountPartner: TcxGridDBColumn;
    InvNumber_Master: TcxGridDBColumn;
    spUpdateAuto: TdsdStoredProc;
    actUpdateAuto: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    FromName: TcxGridDBColumn;
    ToCode: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    GuidesJuridicalFrom: TdsdGuides;
    actOpenReportCheckForm: TdsdOpenForm;
    bbReportCheck: TdxBarButton;
    actChoiceSale: TOpenChoiceForm;
    spUpdateMIChild: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    actOpenReportCheckAmountForm: TdsdOpenForm;
    bbOpenReportCheckAmount: TdxBarButton;
    MIChildProtocolOpenForm: TdsdOpenForm;
    bbMIChildProtocol: TdxBarButton;
    IsErased: TcxGridDBColumn;
    edJuridicalFrom: TcxButtonEdit;
    DescName_Sale: TcxGridDBColumn;
    MovementItemId_sale: TcxGridDBColumn;
    MovementId_sale: TcxGridDBColumn;
    isError: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    ChangePercent_Sale: TcxGridDBColumn;
    MovementPromo_Sale: TcxGridDBColumn;
    spUpdateMovementContract: TdsdStoredProc;
    actUpdateMovementContract: TdsdExecStoredProc;
    actContractOpenForm: TOpenChoiceForm;
    macContractOpenForm: TMultiAction;
    bbContractOpenForm: TdxBarButton;
    edReestrKind: TcxButtonEdit;
    cxLabel26: TcxLabel;
    cxLabel23: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    spUpdateMovementMember: TdsdStoredProc;
    actUpdateMovementMember: TdsdExecStoredProc;
    actMemberOpenForm: TOpenChoiceForm;
    macMemberOpenForm: TMultiAction;
    bbMemberOpenForm: TdxBarButton;
    cxLabel24: TcxLabel;
    edMemberInsertName: TcxButtonEdit;
    spSavePrintState: TdsdStoredProc;
    cbPrinted: TcxCheckBox;
    actSPSavePrintState: TdsdExecStoredProc;
    cxLabel25: TcxLabel;
    edMemberExp: TcxButtonEdit;
    GuidesMemberExp: TdsdGuides;
    spSelectPrintAkt: TdsdStoredProc;
    mactPrintAkt: TMultiAction;
    actPrintAkt: TdsdPrintAction;
    bbPrintAkt: TdxBarButton;
    Amount_find: TcxGridDBColumn;
    cxTabSheet1: TcxTabSheet;
    cxGridDetail: TcxGrid;
    cxGridDBTableViewDetail: TcxGridDBTableView;
    ord: TcxGridDBColumn;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    GoodsKindName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    ReturnKindName_ch2: TcxGridDBColumn;
    ReasonName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevelDetail: TcxGridLevel;
    spSelectDetail: TdsdStoredProc;
    DBViewAddOnDetail: TdsdDBViewAddOn;
    spInsertUpdateMIDetail: TdsdStoredProc;
    spInsertMaskMIDetail: TdsdStoredProc;
    cxLabel28: TcxLabel;
    edReturnKind: TcxButtonEdit;
    GuidesReturnKind: TdsdGuides;
    actReasonOpenForm: TOpenChoiceForm;
    actReturnKindOpenForm: TOpenChoiceForm;
    DetailCDS_Reason: TClientDataSet;
    DetailDS_Reason: TDataSource;
    actUpdateDetailDS_Reason: TdsdUpdateDataSet;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    isError_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    spSelect_MI_Child_reason: TdsdStoredProc;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    ChildCDS_Reason: TClientDataSet;
    ChildDS_Reason: TDataSource;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    spUpdateMIChild_reason: TdsdStoredProc;
    actChoiceSale_reason: TOpenChoiceForm;
    StartDate_ch2: TcxGridDBColumn;
    EndDate_ch2: TcxGridDBColumn;
    spGet_checkopen_Sale: TdsdStoredProc;
    spGet_checkopen_Tax: TdsdStoredProc;
    actGet_checkopen_Sale: TdsdExecStoredProc;
    actOpenTax_child: TdsdOpenForm;
    actOpenSale_child: TdsdOpenForm;
    actGet_checkopen_Tax: TdsdExecStoredProc;
    bbGet_checkopen_Sale: TdxBarButton;
    bbGet_checkopen_Tax: TdxBarButton;
    spInsert_MI_byOrderReturnTare: TdsdStoredProc;
    actInsert_MI_byOrderReturnTare: TdsdExecStoredProc;
    HeaderExit: THeaderExit;
    cxLabel29: TcxLabel;
    edPriceListIn: TcxButtonEdit;
    GuidesPriceListIn: TdsdGuides;
    cxLabel30: TcxLabel;
    edSubjectDoc: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    spUpdateMovementSubjectDoc: TdsdStoredProc;
    macUpdateMovementSubjectDoc: TMultiAction;
    actOpenSubjectDocForm: TOpenChoiceForm;
    actUpdateMovementSubjectDoc: TdsdExecStoredProc;
    bbUpdateMovementSubjectDoc: TdxBarButton;
    cbisWeighing_inf: TcxCheckBox;
    cxLabel31: TcxLabel;
    edInvNumberOrderReturnTare: TcxButtonEdit;
    GuidesOrderReturnTare: TdsdGuides;
    edParPartnerValue: TcxCurrencyEdit;
    cxLabel32: TcxLabel;
    actSaleJournalChoiceMasc: TOpenChoiceForm;
    actUpdateMask: TdsdExecStoredProc;
    spUpdateMask: TdsdStoredProc;
    mactUpdateMaskSale: TMultiAction;
    bbUpdateMaskSale: TdxBarButton;
    actSendJournalChoiceMasc: TOpenChoiceForm;
    mactUpdateMaskSend: TMultiAction;
    bbUpdateMaskSend: TdxBarButton;
    actSubjectDocChoiceForm: TOpenChoiceForm;
    SubjectDocName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnInForm: TReturnInForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnInForm);

end.
