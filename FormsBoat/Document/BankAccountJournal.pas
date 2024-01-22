unit BankAccountJournal;

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
  TBankAccountJournalForm = class(TAncestorJournal_boatForm)
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
    bbPrint1: TdxBarButton;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    ExecuteDialog: TExecuteDialog;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    bbOpenInvoiceForm: TdxBarButton;
    bbUpdateMoneyPlace: TdxBarButton;
    actOpenInvoiceForm: TdsdOpenForm;
    InfoMoneyGroupName_Invoice: TcxGridDBColumn;
    InfoMoneyDestinationName_Invoice: TcxGridDBColumn;
    InfoMoneyName_all_Invoice: TcxGridDBColumn;
    Panel_btn: TPanel;
    btnInsert: TcxButton;
    btnUpdate: TcxButton;
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
    InvoiceKindName: TcxGridDBColumn;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting_csv: TdsdExecStoredProc;
    mactStartLoad_csv: TMultiAction;
    bbStartLoad: TdxBarButton;
    String_1: TcxGridDBColumn;
    String_2: TcxGridDBColumn;
    String_3: TcxGridDBColumn;
    String_4: TcxGridDBColumn;
    String_7: TcxGridDBColumn;
    String_8: TcxGridDBColumn;
    String_9: TcxGridDBColumn;
    String_10: TcxGridDBColumn;
    String_13: TcxGridDBColumn;
    String_15: TcxGridDBColumn;
    String_16: TcxGridDBColumn;
    String_17: TcxGridDBColumn;
    String_18: TcxGridDBColumn;
    String_19: TcxGridDBColumn;
    TDateTime_5: TcxGridDBColumn;
    TFloat_14: TcxGridDBColumn;
    cxSplitter_Bottom_Child: TcxSplitter;
    cxGrid_Child: TcxGrid;
    cxGridDBTableView_child: TcxGridDBTableView;
    ItemName_ch2: TcxGridDBColumn;
    ObjectName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    InvNumber_Invoice_Full_ch2: TcxGridDBColumn;
    ReceiptNumber_Invoice_ch2: TcxGridDBColumn;
    Comment_ch2: TcxGridDBColumn;
    InvoiceKindName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    DBViewAddOnChild: TdsdDBViewAddOn;
    spInsertUpdateMIChild: TdsdStoredProc;
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
    InvNumber_Invoice_child: TcxGridDBColumn;
    bbSetErasedItem: TdxBarButton;
    bbSetUnErasedItem: TdxBarButton;
    Ord_ch2: TcxGridDBColumn;
    actUpdateDataSetChild: TdsdUpdateDataSet;
    actInvoiceDetailChoiceForm_Child: TOpenChoiceForm;
    spSelectChild: TdsdStoredProc;
    actOpenFormPdfEdit: TdsdOpenForm;
    bbOpenFormPdfEdit: TdxBarButton;
    btnInsert_Child: TcxButton;
    btnUpdate_Child: TcxButton;
    btnSetErasedItem: TcxButton;
    actPrintInvoice: TdsdPrintAction;
    actInvoiceReportName: TdsdExecStoredProc;
    mactPrint_Invoice: TMultiAction;
    spSelectPrint_Invoice: TdsdStoredProc;
    spGetReportName_invoice: TdsdStoredProc;
    bbtPrint_Invoice: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintReturnCDS: TClientDataSet;
    PrintOptionCDS: TClientDataSet;
    btntPrint_Invoice: TcxButton;
    btnOpenFormPdfEdit: TcxButton;
    ObjectName_invoice_ch2: TcxGridDBColumn;
    Amount_invoice_ch2: TcxGridDBColumn;
    InvNumberFull_parent_ch2: TcxGridDBColumn;
    MovementDescName_parent_ch2: TcxGridDBColumn;
    ProductName_Invoice_ch2: TcxGridDBColumn;
    ProductCIN_Invoice_ch2: TcxGridDBColumn;
    InfoMoneyName_Invoice_ch2: TcxGridDBColumn;
    InfoMoneyName_all_Invoice_ch2: TcxGridDBColumn;
    AmountChild: TcxGridDBColumn;
    isError: TcxGridDBColumn;
    AmountChild_diff: TcxGridDBColumn;
    Amount_Invoice_all: TcxGridDBColumn;
    Amount_Pay_all: TcxGridDBColumn;
    ReceiptNumber_Invoice_child: TcxGridDBColumn;
    InvoiceKindName_child: TcxGridDBColumn;
    InfoMoneyName_child: TcxGridDBColumn;
    InfoMoneyName_all_child: TcxGridDBColumn;
    InvNumberFull_parent_child: TcxGridDBColumn;
    InvNumber_parent_child: TcxGridDBColumn;
    Blob_11: TcxGridDBColumn;
    Amount_Pay_ch2: TcxGridDBColumn;
    Amount_diff_ch2: TcxGridDBColumn;
    btnOpenInvoiceForm: TcxButton;
    cxButton1: TcxButton;
    mactSetErasedInvoice: TMultiAction;
    actSetErasedInvoice: TdsdUpdateErased;
    spErasedMIChild_Invoice: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountJournalForm);

end.
