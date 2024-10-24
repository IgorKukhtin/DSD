unit OrderClientJournalChoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxImageComboBox, Vcl.Menus, dsdAddOn, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarExtItems, cxCurrencyEdit, ChoicePeriod, System.Contnrs, cxLabel,
  dsdGuides, cxButtonEdit, Vcl.StdCtrls, cxButtons;

type
  TOrderClientJournalChoiceForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    bbEdit: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalSummPVAT: TcxGridDBColumn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PopupMenu: TPopupMenu;
    VATPercent: TcxGridDBColumn;
    DiscountTax: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm_transport: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    DBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    actMovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocol: TdxBarButton;
    spSelectPrintOld: TdsdStoredProc;
    bbPrint: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    FormParams: TdsdFormParams;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    Comment: TcxGridDBColumn;
    actExecuteDialog: TExecuteDialog;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    actPrintStickerTermo: TdsdPrintAction;
    bbPrintStickerTermo: TdxBarButton;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintOffer: TdsdStoredProc;
    spSelectPrintStructure: TdsdStoredProc;
    spSelectPrintOrderConfirmation: TdsdStoredProc;
    actPrintOrderConfirmation: TdsdPrintAction;
    actPrintStructure: TdsdPrintAction;
    actPrintOffer: TdsdPrintAction;
    cxLabel6: TcxLabel;
    edClient: TcxButtonEdit;
    GuidesClient: TdsdGuides;
    actChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    BarCode: TcxGridDBColumn;
    actUpdate: TdsdInsertUpdateAction;
    EngineNum: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    StateText: TcxGridDBColumn;
    StateColor: TcxGridDBColumn;
    DateBegin: TcxGridDBColumn;
    ModelName: TcxGridDBColumn;
    actFormClose: TdsdFormClose;
    Panel_btn: TPanel;
    btnFormClose: TcxButton;
    btnChoiceGuides: TcxButton;
    bbsPrint: TdxBarSubItem;
    cxLabel3: TcxLabel;
    edInvNumber_OrderClient: TcxTextEdit;
    FieldFilter_InvNumber: TdsdFieldFilter;
    btnClientChoiceForm: TcxButton;
    actClientChoiceForm: TOpenChoiceForm;
    actSetNull_GuidesClient: TdsdSetDefaultParams;
    btnSetNull_GuidesClient: TcxButton;
    cxLabel4: TcxLabel;
    edSearch_ReceiptNumber_Invoice: TcxTextEdit;
    isPay: TcxGridDBColumn;
    InvNumber_Invoice: TcxGridDBColumn;
    InvNumberFull_Invoice_find: TcxGridDBColumn;
    InvoiceKindName_find: TcxGridDBColumn;
    Amount_Invoice: TcxGridDBColumn;
    Amount_Invoice_pay: TcxGridDBColumn;
    Amount_Order_pay: TcxGridDBColumn;
    Amount_Invoice_find: TcxGridDBColumn;
    Amount_Invoice_pay_find: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    isInvoice_oth: TcxGridDBColumn;
    miUpdate: TMenuItem;
    Comment_Product: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderClientJournalChoiceForm);

end.
