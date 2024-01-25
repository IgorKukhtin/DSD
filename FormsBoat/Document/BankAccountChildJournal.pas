unit BankAccountChildJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal_boat, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.DBActns,
  cxButtonEdit, dsdGuides, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  Vcl.StdCtrls, cxButtons, ExternalLoad, cxSplitter;

type
  TBankAccountChildJournalForm = class(TAncestorJournal_boatForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    MoneyPlaceName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    ExecuteDialog: TExecuteDialog;
    Comment: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    actRefreshStart: TdsdDataSetRefresh;
    bbOpenInvoiceForm: TdxBarButton;
    bbUpdateMoneyPlace: TdxBarButton;
    actOpenInvoiceForm: TdsdOpenForm;
    Panel_btn: TPanel;
    btnComplete: TcxButton;
    btnUnComplete: TcxButton;
    btnSetErased: TcxButton;
    btnFormClose: TcxButton;
    lbSearchArticle: TcxLabel;
    edSearch_ReceiptNumber_Invoice: TcxTextEdit;
    cxLabel3: TcxLabel;
    edSearchMoneyPlaceName: TcxTextEdit;
    cxLabel4: TcxLabel;
    edSearchInvNumber_OrderClient: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting_csv: TdsdExecStoredProc;
    mactStartLoad_csv: TMultiAction;
    bbStartLoad: TdxBarButton;
    String_7: TcxGridDBColumn;
    actInsert_Child: TdsdInsertUpdateAction;
    actUpdate_Child: TdsdInsertUpdateAction;
    bbInsert_Child: TdxBarButton;
    bbUpdate_Child: TdxBarButton;
    bbsView: TdxBarSubItem;
    dxBarSeparator: TdxBarSeparator;
    bbsDoc: TdxBarSubItem;
    bbDetail: TdxBarSubItem;
    bbsLoadForm: TdxBarSubItem;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actSetUnErasedItem: TdsdUpdateErased;
    mactSetUnErasedItem: TMultiAction;
    actSetErasedItem: TdsdUpdateErased;
    mactSetErasedItem: TMultiAction;
    actRefreshChild: TdsdDataSetRefresh;
    bbSetErasedItem: TdxBarButton;
    bbSetUnErasedItem: TdxBarButton;
    actUpdateDataSetChild: TdsdUpdateDataSet;
    actInvoiceDetailChoiceForm_Child: TOpenChoiceForm;
    actOpenFormPdfEdit: TdsdOpenForm;
    bbOpenFormPdfEdit: TdxBarButton;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    actPrintInvoice: TdsdPrintAction;
    actInvoiceReportName: TdsdExecStoredProc;
    mactPrint_Invoice: TMultiAction;
    spSelectPrint_Invoice: TdsdStoredProc;
    spGetReportName_invoice: TdsdStoredProc;
    bbtPrint_Invoice: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintReturnCDS: TClientDataSet;
    PrintOptionCDS: TClientDataSet;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountChildJournalForm);

end.
