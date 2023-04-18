unit ChangePercentMovement;

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
  TChangePercentMovementForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    spGetReportName: TdsdStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbTaxCorrective: TdxBarButton;
    bbPrint_by_Tax: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel10: TcxLabel;
    edPaidKindTo: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel11: TcxLabel;
    edContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    GuidesPriceList: TdsdGuides;
    actSPPrintProcName: TdsdExecStoredProc;
    cxLabel13: TcxLabel;
    edDocumentTaxKind: TcxButtonEdit;
    GuidesDocumentTaxKind: TdsdGuides;
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
    bbCompleteTaxCorrective: TdxBarButton;
    bbSetErasedTaxCorrective: TdxBarButton;
    bbUnCompleteTaxCorrective: TdxBarButton;
    actTaxJournalChoice: TOpenChoiceForm;
    actPrint_by_Tax: TdsdPrintAction;
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
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    spUpdateAuto: TdsdStoredProc;
    actUpdateAuto: TdsdExecStoredProc;
    actOpenReportCheckAmountForm: TdsdOpenForm;
    actOpenReportCheckForm: TdsdOpenForm;
    bbOpenReportCheckAmountForm: TdxBarButton;
    bbOpenReportCheckForm: TdxBarButton;
    bbUpdateAuto: TdxBarButton;
    spUpdateMIMaster: TdsdStoredProc;
    actUpdate_MI_ChangePercent: TdsdExecStoredProc;
    bbUpdate_MI_ChangePercent: TdxBarButton;
    PrintMovement_ReturnIn_By_TaxCorrective: TdsdPrintAction;
    bbPrintMovement_ReturnIn_By_TaxCorrective: TdxBarButton;
    PageDetail: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    LineNum: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    Price_ChangePercent: TcxGridDBColumn;
    Sum_ChangePercent: TcxGridDBColumn;
    LineNum_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    GoodsKindName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    AmountSumm_ch2: TcxGridDBColumn;
    Price_ch2: TcxGridDBColumn;
    CountForPrice_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    Price_ChangePercent_ch2: TcxGridDBColumn;
    Sum_ChangePercent_ch2: TcxGridDBColumn;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    actGridToExcelDetail: TdsdGridToExcel;
    bbGridToExcelDetail: TdxBarButton;
    Sum_Diff1: TcxGridDBColumn;
    Sum_Diff1_tax: TcxGridDBColumn;
    Sum_Diff1_tax_plus: TcxGridDBColumn;
    cxTabSheet1: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    LineNum_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    GoodsKindName_ch3: TcxGridDBColumn;
    MeasureName_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spSelect_child: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TChangePercentMovementForm);

end.
