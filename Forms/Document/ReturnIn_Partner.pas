unit ReturnIn_Partner;

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
  TReturnIn_PartnerForm = class(TAncestorDocumentForm)
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
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    edIsChecked: TcxCheckBox;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
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
    DocumentTaxKindGuides: TdsdGuides;
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
    ContractTagGuides: TdsdGuides;
    actGoodsKindChoice: TOpenChoiceForm;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    LineNum: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel21: TcxLabel;
    edInvNumberParent: TcxButtonEdit;
    ParentChoiceGuides: TdsdGuides;
    cxLabel18: TcxLabel;
    ceComment: TcxTextEdit;
    actGoodsChoice: TOpenChoiceForm;
    edInvNumberSale: TcxButtonEdit;
    cxLabel19: TcxLabel;
    actOpenTaxCorrective: TdsdOpenForm;
    bbOpenTaxCorrective: TdxBarButton;
    cbPartner: TcxCheckBox;
    spUpdate_MI_ReturnIn_Price: TdsdStoredProc;
    actUpdatePrice: TdsdExecStoredProc;
    bbUpdatePrice: TdxBarButton;
    spGetReportNamePriceCorr: TdsdStoredProc;
    mactPrintPriceCorr: TMultiAction;
    actSPPrintProcNamePriceCorr: TdsdExecStoredProc;
    bbPrintPriceCorr: TdxBarButton;
    spUpdate_MI_ReturnIn_AmountPartner: TdsdStoredProc;
    actUpdateAmountPartner: TdsdExecStoredProc;
    bbUpdateAmountPartner: TdxBarButton;
    cbPromo: TcxCheckBox;
    Price_Pricelist_vat: TcxGridDBColumn;
    actOpenTax: TdsdOpenForm;
    bbOpenTax: TdxBarButton;
    actShowMessage: TShowMessageAction;
    cxLabel22: TcxLabel;
    edStartDateTax: TcxDateEdit;
    cbList: TcxCheckBox;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MI_Child: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    childGoodsCode: TcxGridDBColumn;
    childGoodsName: TcxGridDBColumn;
    childGoodsKindName: TcxGridDBColumn;
    childAmount: TcxGridDBColumn;
    childAmountPartner: TcxGridDBColumn;
    childPrice: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    DocumentTaxKindName: TcxGridDBColumn;
    InvNumber_Master: TcxGridDBColumn;
    InvNumberPartner_Master: TcxGridDBColumn;
    OperDate_Master: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actUpdateAuto: TdsdExecStoredProc;
    spUpdateAuto: TdsdStoredProc;
    bbUpdateAuto: TdxBarButton;
    JuridicalFromGuides: TdsdGuides;
    actOpenReportCheckForm: TdsdOpenForm;
    actOpenReportCheckAmountForm: TdsdOpenForm;
    bbOpenReportCheckAmount: TdxBarButton;
    bbOpenReportCheck: TdxBarButton;
    MIChildProtocolOpenForm: TdsdOpenForm;
    bbMIChildProtocol: TdxBarButton;
    edJuridicalFrom: TcxButtonEdit;
    SaleChoiceGuides: TdsdGuides;
    actSaleJournalChoice: TOpenChoiceForm;
    ChangePercent: TcxGridDBColumn;
    ChangePercent_Sale: TcxGridDBColumn;
    MovementPromo_Sale: TcxGridDBColumn;
    bbContractChoice: TdxBarButton;
    spUpdateMovementContract: TdsdStoredProc;
    actContractOpenForm: TOpenChoiceForm;
    macContractOpenForm: TMultiAction;
    actUpdateMovementContract: TdsdExecStoredProc;
    cxLabel23: TcxLabel;
    edMember: TcxButtonEdit;
    cxLabel26: TcxLabel;
    edReestrKind: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    spUpdateMovementMember: TdsdStoredProc;
    actUpdateMovementMember: TdsdExecStoredProc;
    actMemberOpenForm: TOpenChoiceForm;
    macMemberOpenForm: TMultiAction;
    bbMemberOpenForm: TdxBarButton;
    cxLabel24: TcxLabel;
    edMemberInsertName: TcxButtonEdit;
    cxLabel25: TcxLabel;
    edMemberExp: TcxButtonEdit;
    GuidesMemberExp: TdsdGuides;
    cbPrinted: TcxCheckBox;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    spSelectPrintAkt: TdsdStoredProc;
    actPrintAkt: TdsdPrintAction;
    mactPrintAkt: TMultiAction;
    bbPrintAkt: TdxBarButton;
    Amount_find: TcxGridDBColumn;
    spGet_checkopen_Sale: TdsdStoredProc;
    actOpenTax_child: TdsdOpenForm;
    actOpenSale_child: TdsdOpenForm;
    bbOpenSale_child: TdxBarButton;
    bbOpenTax_child: TdxBarButton;
    macOpenSale_child: TMultiAction;
    actGet_checkopen_Sale: TdsdExecStoredProc;
    macOpenTax_child: TMultiAction;
    spGet_checkopen_Tax: TdsdStoredProc;
    actGet_checkopen_Tax: TdsdExecStoredProc;
    cxLabel29: TcxLabel;
    edPriceListIn: TcxButtonEdit;
    GuidesPriceListIn: TdsdGuides;
    spUpdateMovementSubjectDoc: TdsdStoredProc;
    actOpenSubjectDocForm: TOpenChoiceForm;
    actUpdateMovementSubjectDoc: TdsdExecStoredProc;
    macUpdateMovementSubjectDoc: TMultiAction;
    bbUpdateMovementSubjectDoc: TdxBarButton;
    cxLabel30: TcxLabel;
    edSubjectDoc: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
    cbisWeighing_inf: TcxCheckBox;
    edParPartnerValue: TcxCurrencyEdit;
    cxLabel32: TcxLabel;
    spUpdateMask: TdsdStoredProc;
    actSaleJournalChoiceMasc: TOpenChoiceForm;
    actSendJournalChoiceMasc: TOpenChoiceForm;
    actUpdateMask: TdsdExecStoredProc;
    mactUpdateMaskSale: TMultiAction;
    mactUpdateMaskSend: TMultiAction;
    bbUpdateMaskSale: TdxBarButton;
    bbUpdateMaskSend: TdxBarButton;
    SubjectDocName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnIn_PartnerForm: TReturnIn_PartnerForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnIn_PartnerForm);

end.
