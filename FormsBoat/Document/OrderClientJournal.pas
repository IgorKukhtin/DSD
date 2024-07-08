unit OrderClientJournal;

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
  dsdGuides, cxButtonEdit, Vcl.StdCtrls, cxButtons, dsdCommon;

type
  TOrderClientJournalForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
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
    actComplete: TdsdChangeMovementStatus;
    spMovementComplete: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    bbComplete: TdxBarButton;
    actUnComplete: TdsdChangeMovementStatus;
    spMovementUnComplete: TdsdStoredProc;
    bbUnComplete: TdxBarButton;
    N2: TMenuItem;
    bbDelete: TdxBarButton;
    actSetErased: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    VATPercent: TcxGridDBColumn;
    DiscountTax: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSummMVAT: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummVAT: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    DBViewAddOn: TdsdDBViewAddOn;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    InvNumberPartner: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
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
    spMovementReComplete: TdsdStoredProc;
    spReCompete: TdsdExecStoredProc;
    mactSimpleReCompleteList: TMultiAction;
    mactReCompleteList: TMultiAction;
    N1: TMenuItem;
    ExecuteDialog: TExecuteDialog;
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
    spSelectPrint_barcode: TdsdStoredProc;
    actPrintBarcode: TdsdPrintAction;
    bbPrintBarcode: TdxBarButton;
    EngineNum: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    actPrintStructureGoods: TdsdPrintAction;
    bbPrintStructureGoods: TdxBarButton;
    spSelectPrintStructureGoods: TdsdStoredProc;
    spSelectPrintStructureHeader: TdsdStoredProc;
    NPP: TcxGridDBColumn;
    spUpdateMovement_NPP: TdsdStoredProc;
    actUpdateMovement_NPP: TdsdExecStoredProc;
    actChangePercentDialog: TExecuteDialog;
    macChangeNPP: TMultiAction;
    bbChangeNPP: TdxBarButton;
    spUpdate_NPP_Plus: TdsdStoredProc;
    spUpdate_NPP_Minus: TdsdStoredProc;
    actUpdate_NPP_Plus: TdsdExecStoredProc;
    actUpdate_NPP_Minus: TdsdExecStoredProc;
    bbUpdate_NPP_Plus: TdxBarButton;
    bbUpdate_NPP_Minus: TdxBarButton;
    StateText: TcxGridDBColumn;
    StateColor: TcxGridDBColumn;
    OperPrice_load: TcxGridDBColumn;
    BasisPrice_load: TcxGridDBColumn;
    TransportSumm_load: TcxGridDBColumn;
    TotalSumm_transport: TcxGridDBColumn;
    spSelectPrint_Invoice: TdsdStoredProc;
    actPrintMovement_Invoice: TdsdPrintAction;
    bbtPrintMovement_Invoice: TdxBarButton;
    actFormClose: TdsdFormClose;
    Panel_btn: TPanel;
    btnInsert: TcxButton;
    btnUpdate: TcxButton;
    btnComplete: TcxButton;
    btnUnComplete: TcxButton;
    btnSetErased: TcxButton;
    btnFormClose: TcxButton;
    bbsPrint: TdxBarSubItem;
    cxLabel3: TcxLabel;
    edInvNumber_OrderClient: TcxTextEdit;
    FieldFilter_InvNumber: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    cxLabel4: TcxLabel;
    edSearch_ReceiptNumber_Invoice: TcxTextEdit;
    InvNumber_Invoice: TcxGridDBColumn;
    SummDiscount: TcxGridDBColumn;
    Ord: TcxGridDBColumn;
    Comment_Product: TcxGridDBColumn;
    isReserve_Product: TcxGridDBColumn;
    actPrintOffer_TD: TdsdPrintAction;
    actPrintOrderConfirmation_TD: TdsdPrintAction;
    bbPrintOffer_TD: TdxBarButton;
    bbPrintOrderConfirmation_TD: TdxBarButton;
    bbSeparator: TdxBarSeparator;
    spPrintStructureSum: TdsdStoredProc;
    spPrintStructureGoodsSum: TdsdStoredProc;
    actPrintStructureSum: TdsdPrintAction;
    actPrintStructureGoodsSum: TdsdPrintAction;
    bbPrintStructureSum: TdxBarButton;
    bbPrintStructureGoodsSum: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderClientJournalForm);

end.
