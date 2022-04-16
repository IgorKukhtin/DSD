unit PriceCorrective;

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
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxSplitter;

type
  TPriceCorrectiveForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
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
    bbPrintTaxCorrective_Us: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel11: TcxLabel;
    edContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    edPartner: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesPartner: TdsdGuides;
    mactPrint: TMultiAction;
    actSPPrintProcName: TdsdExecStoredProc;
    cxLabel13: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    GuidesDocumentTaxKind: TdsdGuides;
    bbCorrective: TdxBarButton;
    spCorrective: TdsdStoredProc;
    spSelectPrintTaxCorrective_Us: TdsdStoredProc;
    spSelectPrintTaxCorrective_Client: TdsdStoredProc;
    cxLabel5: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel6: TcxLabel;
    edInvNumberMark: TcxTextEdit;
    spGetReportNameTaxCorrective: TdsdStoredProc;
    actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc;
    actPrint_TaxCorrective_Us: TdsdPrintAction;
    actPrint_TaxCorrective_Client: TdsdPrintAction;
    mactPrint_TaxCorrective_Client: TMultiAction;
    mactPrint_TaxCorrective_Us: TMultiAction;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    TaxCorrectiveDS: TDataSource;
    TaxCorrectiveCDS: TClientDataSet;
    spMovementUnCompleteTaxCorrective: TdsdStoredProc;
    spSelectTaxCorrective: TdsdStoredProc;
    gpUpdateTaxCorrective: TdsdStoredProc;
    spMovementCompleteTaxCorrective: TdsdStoredProc;
    spMovementSetErasedTaxCorrective: TdsdStoredProc;
    TaxCorrectiveViewAddOn: TdsdDBViewAddOn;
    actOpenTaxCorrective: TdsdOpenForm;
    bbOpenTaxCorrective: TdxBarButton;
    actUnCompleteTaxCorrective: TdsdChangeMovementStatus;
    actSetErasedTaxCorrective: TdsdChangeMovementStatus;
    actCompleteTaxCorrective: TdsdChangeMovementStatus;
    bbCompleteTaxCorrective: TdxBarButton;
    bbUnCompleteTaxCorrective: TdxBarButton;
    bbSetErasedTaxCorrective: TdxBarButton;
    actTaxJournalChoice: TOpenChoiceForm;
    actUpdateTaxCorrectiveDS: TdsdUpdateDataSet;
    spGetReportNameReturnIn: TdsdStoredProc;
    mactPrintReturnIn: TMultiAction;
    actSPPrintProcNameReturnIn: TdsdExecStoredProc;
    bbPrintReturnIn: TdxBarButton;
    actOpenTax: TdsdOpenForm;
    bbOpenTax: TdxBarButton;
    actShowMessage: TShowMessageAction;
    cxLabel8: TcxLabel;
    edDocumentTax: TcxButtonEdit;
    GuidesDocumentTax: TdsdGuides;
    edIsChecked: TcxCheckBox;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    spSelect_MI_Child: TdsdStoredProc;
    spUpdateMIChild: TdsdStoredProc;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    isError: TcxGridDBColumn;
    childGoodsCode: TcxGridDBColumn;
    childGoodsName: TcxGridDBColumn;
    childGoodsKindName: TcxGridDBColumn;
    childAmount: TcxGridDBColumn;
    childAmountPartner: TcxGridDBColumn;
    childPrice: TcxGridDBColumn;
    ChangePercent_Sale: TcxGridDBColumn;
    MovementPromo_Sale: TcxGridDBColumn;
    DescName_Sale: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    InvNumber_Master: TcxGridDBColumn;
    InvNumberPartner_Master: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    OperDate_Master: TcxGridDBColumn;
    ContractCode_Sale: TcxGridDBColumn;
    ContractName_Sale: TcxGridDBColumn;
    ContractCode_Tax: TcxGridDBColumn;
    ContractName_Tax: TcxGridDBColumn;
    DocumentTaxKindName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToCode: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    MovementId_sale: TcxGridDBColumn;
    MovementItemId_sale: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    actUpdateAuto: TdsdExecStoredProc;
    spUpdateAuto: TdsdStoredProc;
    cxLabel22: TcxLabel;
    edStartDateTax: TcxDateEdit;
    actOpenReportForm: TdsdOpenForm;
    actOpenReportCheckForm: TdsdOpenForm;
    actOpenReportCheckAmountForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    bbOpenReportCheckForm: TdxBarButton;
    bbOpenReportCheckAmountForm: TdxBarButton;
    bbUpdateAuto: TdxBarButton;
    actTaxCorrective: TdsdExecStoredProc;
    spTaxCorrective: TdsdStoredProc;
    bbTaxCorrective: TdxBarButton;
    actMIChildProtocolOpenForm: TdsdOpenForm;
    bbMIChildProtocolOpenForm: TdxBarButton;
    cxLabel14: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceCorrectiveForm);

end.
