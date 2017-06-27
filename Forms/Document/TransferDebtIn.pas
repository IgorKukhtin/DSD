unit TransferDebtIn;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxImageComboBox,
  MeDOC, cxSplitter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TTransferDebtInForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edContractFrom: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cxLabel6: TcxLabel;
    edPaidKindFrom: TcxButtonEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    PaidKindFromGuides: TdsdGuides;
    ContractFromGuides: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colChangePercentAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTaxCorrective_Client: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTaxCorrective: TdxBarButton;
    bbPrintTaxCorrective_Us: TdxBarButton;
    colMeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel10: TcxLabel;
    edPaidKindTo: TcxButtonEdit;
    PaidKindToGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edContractTo: TcxButtonEdit;
    ContractToGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    edPartnerFrom: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesPartnerFrom: TdsdGuides;
    mactPrint: TMultiAction;
    actSPPrintProcName: TdsdExecStoredProc;
    cxLabel13: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    bbCorrective: TdxBarButton;
    spCorrective: TdsdStoredProc;
    spTaxCorrective: TdsdStoredProc;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    cxLabel14: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    edIsChecked: TcxCheckBox;
    TaxCorrectiveCDS: TClientDataSet;
    TaxCorrectiveDS: TDataSource;
    spSelectTaxCorrective: TdsdStoredProc;
    spMovementSetErasedTaxCorrective: TdsdStoredProc;
    spMovementCompleteTaxCorrective: TdsdStoredProc;
    spMovementUnCompleteTaxCorrective: TdsdStoredProc;
    gpUpdateTaxCorrective: TdsdStoredProc;
    actUnCompleteTaxCorrective: TdsdChangeMovementStatus;
    actSetErasedTaxCorrective: TdsdChangeMovementStatus;
    actCompleteTaxCorrective: TdsdChangeMovementStatus;
    bbCompleteTaxCorrective: TdxBarButton;
    bbSetErasedTaxCorrective: TdxBarButton;
    bbUnCompleteTaxCorrective: TdxBarButton;
    actTaxJournalChoice: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    edInvNumberMark: TcxTextEdit;
    actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction;
    bbPrint_ReturnIn_by_TaxCorrective: TdxBarButton;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    spUpdateIsMedoc: TdsdStoredProc;
    MedocAction: TMedocAction;
    actMedocProcedure: TdsdExecStoredProc;
    actUpdateIsMedoc: TdsdExecStoredProc;
    mactMeDoc: TMultiAction;
    bbtMeDoc: TdxBarButton;
    colIsEDI: TcxGridDBColumn;
    colIsElectron: TcxGridDBColumn;
    colIsMedoc: TcxGridDBColumn;
    cxLabel17: TcxLabel;
    ceComment: TcxTextEdit;
    bbOpenTaxCorrective: TdxBarButton;
    actOpenTaxCorrective: TdsdOpenForm;
    actOpenTax: TdsdOpenForm;
    bbOpenTax: TdxBarButton;
    cxLabel18: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    actShowMessage: TShowMessageAction;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MI_Child: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cxSplitter1: TcxSplitter;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    DocumentTaxKindName: TcxGridDBColumn;
    InvNumber_Master: TcxGridDBColumn;
    InvNumberPartner_Master: TcxGridDBColumn;
    OperDate_Master: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    DescName_Sale: TcxGridDBColumn;
    spUpdateAuto: TdsdStoredProc;
    actUpdateAuto: TdsdExecStoredProc;
    actOpenReportCheckAmountForm: TdsdOpenForm;
    actOpenReportCheckForm: TdsdOpenForm;
    bbOpenReportCheckAmountForm: TdxBarButton;
    bbOpenReportCheckForm: TdxBarButton;
    bbUpdateAuto: TdxBarButton;
    colAmountChild: TcxGridDBColumn;
    colAmountChildDiff: TcxGridDBColumn;
    LineNum: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTransferDebtInForm);

end.
