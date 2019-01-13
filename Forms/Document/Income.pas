unit Income;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxImageComboBox;

type
  TIncomeForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    AmountPartner: TcxGridDBColumn;
    AmountPacker: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    LiveWeight: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    edChangePercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    HeaderSaver: THeaderSaver;
    edInvNumberPartner: TcxTextEdit;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    edPacker: TcxButtonEdit;
    PackerGuides: TdsdGuides;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    IsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    clInfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GuidesFrom: TdsdGuides;
    spGetTotalSumm: TdsdStoredProc;
    cxLabel12: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edCurrencyDocument: TcxButtonEdit;
    CurrencyDocumentGuides: TdsdGuides;
    cxLabel15: TcxLabel;
    edCurrencyPartner: TcxButtonEdit;
    CurrencyPartnerGuides: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    clInfoMoneyName_all: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    cbCalcAmountPartner: TcxCheckBox;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    actGoodsKindChoice: TOpenChoiceForm;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    AmountRemains: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    Amount_unit: TcxGridDBColumn;
    Amount_diff: TcxGridDBColumn;
    cxLabel25: TcxLabel;
    edInvNumberTransport: TcxButtonEdit;
    TransportChoiceGuides: TdsdGuides;
    HeaderSaver2: THeaderSaver;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    cxTabSheet1: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    clComment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ClientDataCost: TClientDataSet;
    DataSourceCost: TDataSource;
    spSelect_IncomeCost_byParent: TdsdStoredProc;
    InsertRecord1: TInsertRecord;
    CostJournalChoiceForm: TOpenChoiceForm;
    bbInsertRecord: TdxBarButton;
    spInsertUpdate_IncomeCost: TdsdStoredProc;
    actUpdateClientDataCost: TdsdUpdateDataSet;
    ItemName: TcxGridDBColumn;
    MasterStatusCode: TcxGridDBColumn;
    MasterComment: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    spUnComplete_IncomeCost: TdsdStoredProc;
    spComplete_IncomeCost: TdsdStoredProc;
    spSetErased_IncomeCost: TdsdStoredProc;
    actCompleteCost: TdsdChangeMovementStatus;
    actSetErasedCost: TdsdChangeMovementStatus;
    actUnCompleteCost: TdsdChangeMovementStatus;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    actShowErasedCost: TBooleanStoredProcAction;
    bbShowErasedCost: TdxBarButton;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    cxLabel19: TcxLabel;
    edInvNumberInvoice: TcxButtonEdit;
    InvoiceGuides: TdsdGuides;
    spUpdateOrder: TdsdStoredProc;
    HeaderSaver3: THeaderSaver;
    cxLabel17: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    OrderGuides: TdsdGuides;
    edJuridicalFrom: TcxButtonEdit;
    JuridicalFromGuides: TdsdGuides;
    InsertRecordGoods: TInsertRecord;
    bbInsertRecordGoods: TdxBarButton;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    actPrintStickerTermo: TdsdPrintAction;
    bbPrintStickerTermo: TdxBarButton;
    bb: TdxBarButton;
    cxLabel21: TcxLabel;
    edParValue: TcxCurrencyEdit;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeForm);

end.
