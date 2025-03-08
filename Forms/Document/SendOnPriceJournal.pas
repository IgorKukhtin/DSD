unit SendOnPriceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, EDI, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TSendOnPriceJournalForm = class(TAncestorJournalForm)
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
    RouteName: TcxGridDBColumn;
    edIsPartnerDate: TcxCheckBox;
    TotalCountTare: TcxGridDBColumn;
    lTotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrintOut: TdsdPrintAction;
    bbPrintOut: TdxBarButton;
    InvNumber_Order: TcxGridDBColumn;
    spUpdateEdiOrdspr: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    EDI: TEDI;
    spGetDefaultEDI: TdsdStoredProc;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    actSetDefaults: TdsdExecStoredProc;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    actExecPrint_EDI: TdsdExecStoredProc;
    mactInvoice_Simple: TMultiAction;
    mactInvoice_All: TMultiAction;
    mactOrdSpr_Simple: TMultiAction;
    mactOrdSpr_All: TMultiAction;
    mactDesadv_Simple: TMultiAction;
    mactDesadv_All: TMultiAction;
    bbInvoice: TdxBarButton;
    bbOrdSpr: TdxBarButton;
    bbtDesadv: TdxBarButton;
    Invoice1: TMenuItem;
    Ordspr1: TMenuItem;
    Desadv1: TMenuItem;
    N13: TMenuItem;
    spSelectSale_EDI: TdsdStoredProc;
    RetailName_order: TcxGridDBColumn;
    PartnerName_order: TcxGridDBColumn;
    Comment_order: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actPrinDiff: TdsdPrintAction;
    bbPrinDiff: TdxBarButton;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    bbPrintSaleOrder: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    TotalCountShFrom: TcxGridDBColumn;
    TotalCountKgFrom: TcxGridDBColumn;
    TotalSummFrom: TcxGridDBColumn;
    spSelectPrint_TTN: TdsdStoredProc;
    spGet_TTN: TdsdStoredProc;
    actPrint_TTN: TdsdPrintAction;
    actGet_TTN: TdsdExecStoredProc;
    actDialog_TTN: TdsdOpenForm;
    mactPrint_TTN: TMultiAction;
    bbPrint_TTN: TdxBarButton;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
    bbPrint_QualityDoc: TdxBarButton;
    actPrintPackGross: TdsdPrintAction;
    bbPrintPackGross: TdxBarButton;
    spSelectPrint_Pack: TdsdStoredProc;
    spSelectPrint_SaleOrderTax: TdsdStoredProc;
    actPrintSaleOrderTax: TdsdPrintAction;
    bbPrintSaleOrderTax: TdxBarButton;
    spChecked: TdsdStoredProc;
    actChecked: TdsdExecStoredProc;
    bbChecked: TdxBarButton;
    isHistoryCost: TcxGridDBColumn;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    actChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSendOnPriceJournalForm);
end.
