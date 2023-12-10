unit InvoiceJournal;

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
  Vcl.StdCtrls, cxButtons, cxSplitter;

type
  TInvoiceJournalForm = class(TAncestorJournal_boatForm)
    ObjectName: TcxGridDBColumn;
    ProductName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    bbAddBonus: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    InfoMoneyName_all: TcxGridDBColumn;
    bbPrint1: TdxBarButton;
    bbisCopy: TdxBarButton;
    actMasterPost: TDataSetPost;
    UnitCode: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
    bbUpdateMoneyPlace: TdxBarButton;
    AmountIn_NotVAT: TcxGridDBColumn;
    AmountOut_NotVAT: TcxGridDBColumn;
    AmountIn_VAT: TcxGridDBColumn;
    AmountOut_VAT: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    Color_Pay: TcxGridDBColumn;
    actOpenBankAccountJournalByInvoice: TdsdOpenForm;
    bbOpenBankAccountJournalByInvoice: TdxBarButton;
    InvNumber_parent: TcxGridDBColumn;
    DescName_parent: TcxGridDBColumn;
    actOpenIncomeCostByInvoice: TdsdOpenForm;
    bbOpenIncomeCostByInvoice: TdxBarButton;
    bbtPrint: TdxBarButton;
    Panel_btn: TPanel;
    btnUpdate: TcxButton;
    btnComplete: TcxButton;
    btnUnComplete: TcxButton;
    btnSetErased: TcxButton;
    btnFormClose: TcxButton;
    cxLabel4: TcxLabel;
    edSearchInvNumber_OrderClient: TcxTextEdit;
    edSearchInvNumber_Invoice: TcxTextEdit;
    cxLabel3: TcxLabel;
    edSearchObjectName: TcxTextEdit;
    lbSearchArticle: TcxLabel;
    FieldFilter_Article: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    actOpenIncomeByInvoice: TdsdOpenForm;
    bbOpenIncomeByInvoice: TdxBarButton;
    InvoiceKindName: TcxGridDBColumn;
    isAuto: TcxGridDBColumn;
    ItemCDS: TClientDataSet;
    ItemDS: TDataSource;
    ItemViewAddOn: TdsdDBViewAddOn;
    spSelectMI: TdsdStoredProc;
    cxGrid_Item: TcxGrid;
    cxGridDBTableView_Det: TcxGridDBTableView;
    Article_ch4: TcxGridDBColumn;
    GoodsCode_ch4: TcxGridDBColumn;
    GoodsName_ch4: TcxGridDBColumn;
    OperPrice_ch4: TcxGridDBColumn;
    Amount_ch4: TcxGridDBColumn;
    Comment_ch4: TcxGridDBColumn;
    isErased_ch4: TcxGridDBColumn;
    cxGridLevel_Det: TcxGridLevel;
    actSetVisible_Grid_Item: TBooleanSetVisibleAction;
    cxButton5: TcxButton;
    actInsertAction: TdsdInsertUpdateAction;
    actUpdateAction: TdsdInsertUpdateAction;
    mactUpdateAction: TMultiAction;
    mactInsertAction: TMultiAction;
    bbsGoods: TdxBarSubItem;
    bbInsertAction: TdxBarButton;
    bbUpdateAction: TdxBarButton;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    actSetErasedItem: TdsdUpdateErased;
    actSetUnErasedItem: TdsdUpdateErased;
    bbSetUnErased: TdxBarButton;
    bbSetErasedItem: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    cxSplitter_Bottom_Item: TcxSplitter;
    actInsert_PrePay: TdsdInsertUpdateAction;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    actInsert_Pay: TdsdInsertUpdateAction;
    actInsert_Service: TdsdInsertUpdateAction;
    actInsert_Proforma: TdsdInsertUpdateAction;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    spGetReportName: TdsdStoredProc;
    actInvoiceReportName: TdsdExecStoredProc;
    mactPrint_Invoice: TMultiAction;
    actPrintInvoice: TdsdPrintAction;
    bbPrint_Invoice: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInvoiceJournalForm);

end.
