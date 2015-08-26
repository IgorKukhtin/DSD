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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxImageComboBox;

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
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
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
    colMeasureName: TcxGridDBColumn;
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
    CurrencyDocumentGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    CurrencyPartnerGuides: TdsdGuides;
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
    colLineNum: TcxGridDBColumn;
    clGoodsGroupNameFull: TcxGridDBColumn;
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
    cbisPartner: TcxCheckBox;
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
