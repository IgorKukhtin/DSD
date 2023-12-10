unit ProductEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  dsdGuides, cxMaskEdit, cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxDropDownEdit, cxCalendar, cxCheckBox, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxClasses, Vcl.ExtCtrls, Data.DB, Datasnap.DBClient,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxPC, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxImageComboBox;

type
  TProductEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    actDataSetRefresh: TdsdDataSetRefresh;
    actInsertUpdateGuides: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel3: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel6: TcxLabel;
    edHours: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    edDateStart: TcxDateEdit;
    edDateBegin: TcxDateEdit;
    edDateSale: TcxDateEdit;
    edCIN: TcxTextEdit;
    cxLabel10: TcxLabel;
    edEngineNum: TcxTextEdit;
    cxLabel11: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesBrand: TdsdGuides;
    cxLabel12: TcxLabel;
    edModel: TcxButtonEdit;
    GuidesModel: TdsdGuides;
    cxLabel13: TcxLabel;
    edEngine: TcxButtonEdit;
    GuidesProdEngine: TdsdGuides;
    cbBasicConf: TcxCheckBox;
    cbProdColorPattern: TcxCheckBox;
    cxLabel14: TcxLabel;
    edReceiptProdModel: TcxButtonEdit;
    GuidesReceiptProdModel: TdsdGuides;
    edDiscountNextTax: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edClienttext: TcxLabel;
    edClient: TcxButtonEdit;
    GuidesClient: TdsdGuides;
    edDiscountTax: TcxCurrencyEdit;
    RefreshDispatcher: TRefreshDispatcher;
    spGetCIN: TdsdStoredProc;
    actGetCIN: TdsdDataSetRefresh;
    spChangeStatus: TdsdStoredProc;
    cxLabel8: TcxLabel;
    GuidesStatus: TdsdGuides;
    cxLabel17: TcxLabel;
    edInvNumberOrderClient: TcxTextEdit;
    cxLabel18: TcxLabel;
    edOperDateOrderClient: TcxDateEdit;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    BarManager: TdxBarManager;
    bbCompleteMovement: TdxBarButton;
    bbDeleteMovement: TdxBarButton;
    bbDeleteDocument: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    actComplete: TdsdChangeMovementStatus;
    actSetErased: TdsdChangeMovementStatus;
    ceStatus: TcxButtonEdit;
    cxLabel19: TcxLabel;
    edTotalSummPVAT: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    edTotalSummMVAT: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    edTotalSummVAT: TcxCurrencyEdit;
    ceStatusInvoice: TcxButtonEdit;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    edOperDateInvoice: TcxDateEdit;
    cxLabel24: TcxLabel;
    edInvNumberInvoice: TcxTextEdit;
    cxLabel25: TcxLabel;
    ceAmountInInvoice: TcxCurrencyEdit;
    ceAmountInInvoiceAll: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    cxLabel27: TcxLabel;
    ceAmountInBankAccount: TcxCurrencyEdit;
    ceAmountInBankAccountAll: TcxCurrencyEdit;
    cxLabel28: TcxLabel;
    GuidesStatusInvoice: TdsdGuides;
    spChangeStatusInvoice: TdsdStoredProc;
    UnCompleteMovementInvoice: TChangeGuidesStatus;
    CompleteMovementInvoice: TChangeGuidesStatus;
    DeleteMovementInvoice: TChangeGuidesStatus;
    cxLabel29: TcxLabel;
    edVATPercentOrderClient: TcxCurrencyEdit;
    cxLabel30: TcxLabel;
    edAmountIn_rem: TcxCurrencyEdit;
    edAmountIn_remAll: TcxCurrencyEdit;
    cxLabel31: TcxLabel;
    cxButton3: TcxButton;
    edInvNumberOrderClient_load: TcxTextEdit;
    cxLabel32: TcxLabel;
    cxButton4: TcxButton;
    actLoadAgilis: TdsdLoadAgilis;
    ClientDataSet: TClientDataSet;
    DS: TDataSource;
    mactLoadAgilis_all: TMultiAction;
    mactInsertUpdate_load: TMultiAction;
    actInsertUpdate_load: TdsdExecStoredProc;
    spInsertUpdate_load: TdsdStoredProc;
    cxLabel33: TcxLabel;
    edOperPrice_load: TcxCurrencyEdit;
    edTransportSumm_load: TcxCurrencyEdit;
    cxLabel34: TcxLabel;
    actLoadFile_Doc: TdsdLoadFile_https;
    actLoadFile_Photo: TdsdLoadFile_https;
    spInsertUpdate_ProductDocument: TdsdStoredProc;
    mactLoad_Doc: TMultiAction;
    actInsertUpdate_Doc: TdsdExecStoredProc;
    actInsertUpdate_Photo: TdsdExecStoredProc;
    spInsertUpdate_ProductPhoto: TdsdStoredProc;
    mactLoad_Photo: TMultiAction;
    spGet_ProductDocument: TdsdStoredProc;
    spGet_ProductPhoto: TdsdStoredProc;
    actGet_ProductPhoto: TdsdExecStoredProc;
    actGet_ProductDocument: TdsdExecStoredProc;
    cxLabel35: TcxLabel;
    edNPP: TcxCurrencyEdit;
    HeaderExit: THeaderExit;
    actGet: TdsdExecStoredProc;
    mactGet: TMultiAction;
    actInsertUpdate: TdsdExecStoredProc;
    cxLabel36: TcxLabel;
    edSummTax: TcxCurrencyEdit;
    cxLabel37: TcxLabel;
    edSummReal: TcxCurrencyEdit;
    cxLabel38: TcxLabel;
    cxLabel39: TcxLabel;
    ceAmountInInvoice2: TcxCurrencyEdit;
    ceAmountInInvoiceAll2: TcxCurrencyEdit;
    cxLabel40: TcxLabel;
    ceAmountInBankAccount2: TcxCurrencyEdit;
    ceAmountInBankAccountAll2: TcxCurrencyEdit;
    cxLabel41: TcxLabel;
    edSummaBank: TcxCurrencyEdit;
    cxLabel42: TcxLabel;
    cxLabel43: TcxLabel;
    edOperDateBankAccount: TcxDateEdit;
    spInsertUpdateBank: TdsdStoredProc;
    edInvNumberBankAccount3: TcxTextEdit;
    edInvNumberBankAccountText: TcxLabel;
    cxLabel45: TcxLabel;
    ceBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    InvoiceCDS: TClientDataSet;
    InvoiceDS: TDataSource;
    dsdDBViewAddOnInvoice: TdsdDBViewAddOn;
    BarManagerBar1: TdxBar;
    dxBarDockControl3: TdxBarDockControl;
    dxBarDockControl1: TdxBarDockControl;
    BarManagerBar2: TdxBar;
    BankCDS: TClientDataSet;
    BankDS: TDataSource;
    dsdDBViewAddOnBank: TdsdDBViewAddOn;
    spMovementCompleteInv: TdsdStoredProc;
    spMovementSetErasedInv: TdsdStoredProc;
    spMovementUnCompleteInv: TdsdStoredProc;
    actInsertInv: TdsdInsertUpdateAction;
    actUpdateInv: TdsdInsertUpdateAction;
    bbInsertInv: TdxBarButton;
    bbUpdateInv: TdxBarButton;
    actCompleteInv: TdsdChangeMovementStatus;
    actUnCompleteInv: TdsdChangeMovementStatus;
    actSetErasedInv: TdsdChangeMovementStatus;
    bbCompleteInv: TdxBarButton;
    bbUnCompleteInv: TdxBarButton;
    bbSetErasedInv: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    spSelectInvoice: TdsdStoredProc;
    actShowErasedInv: TBooleanStoredProcAction;
    bbShowErasedInv: TdxBarButton;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colStatus: TcxGridDBColumn;
    ReceiptNumber: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    PlanDate: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Amount_BankAccount: TcxGridDBColumn;
    Amount_rem: TcxGridDBColumn;
    VATPercent: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InvNumber_parent: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    Color_Pay: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    StatusCode_ch2: TcxGridDBColumn;
    InvNumber_ch2: TcxGridDBColumn;
    OperDate_ch2: TcxGridDBColumn;
    BankAccountNamech2: TcxGridDBColumn;
    BankNamech2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    MoneyPlaceName_ch2: TcxGridDBColumn;
    Amount_diff_ch2: TcxGridDBColumn;
    isDiff_ch2: TcxGridDBColumn;
    Comment_ch2: TcxGridDBColumn;
    InsertName_ch2: TcxGridDBColumn;
    InsertDate_ch2: TcxGridDBColumn;
    UpdateName_ch2: TcxGridDBColumn;
    UpdateDate_ch2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spMovementCompleteBank: TdsdStoredProc;
    spMovementSetErasedBank: TdsdStoredProc;
    spMovementUnCompleteBank: TdsdStoredProc;
    actInsertBank: TdsdInsertUpdateAction;
    actUpdateBank: TdsdInsertUpdateAction;
    actCompleteBank: TdsdChangeMovementStatus;
    actUnCompleteBank: TdsdChangeMovementStatus;
    actSetErasedBank: TdsdChangeMovementStatus;
    bbCompleteBank: TdxBarButton;
    bbInsertBank: TdxBarButton;
    bbSetErasedBank: TdxBarButton;
    bbUnCompleteBank: TdxBarButton;
    bbUpdateBank: TdxBarButton;
    actShowErasedBank: TBooleanStoredProcAction;
    spSelectBank: TdsdStoredProc;
    bbShowErasedBank: TdxBarButton;
    spSelectPrint: TdsdStoredProc;
    actPrintInvoice: TdsdPrintAction;
    bbPrintInvoice: TdxBarButton;
    actMovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
    actMovementProtocolOpenFormBank: TdsdOpenForm;
    bbProtocolOpenFormBank: TdxBarButton;
    actDataSetRefreshInv: TdsdDataSetRefresh;
    actDataSetRefreshBank: TdsdDataSetRefresh;
    bbDataSetRefreshInv: TdxBarButton;
    bbDataSetRefreshBank: TdxBarButton;
    macInsertInv: TMultiAction;
    actSelectInvoice: TdsdExecStoredProc;
    PrintItemsCDS: TClientDataSet;
    cxLabel44: TcxLabel;
    edTaxKind: TcxButtonEdit;
    GuidesTaxKind: TdsdGuides;
    InvNumber_Invoice_Full_ch2: TcxGridDBColumn;
    cxButton5: TcxButton;
    InvoiceKindName: TcxGridDBColumn;
    InvoiceKindName_vh2: TcxGridDBColumn;
    isAuto: TcxGridDBColumn;
    ReceiptNumber_Invoice_ch2: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductEditForm);

end.
