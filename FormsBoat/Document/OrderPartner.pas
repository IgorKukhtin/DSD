unit OrderPartner;

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
  cxImageComboBox, cxSplitter, cxBlobEdit;

type
  TOrderPartnerForm = class(TParentForm)
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
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrintAgilis: TdxBarButton;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    cxLabel5: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    edDiscountTax: TcxCurrencyEdit;
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
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrintOld: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    actGoodsKindChoice: TOpenChoiceForm;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecord: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    actShowErasedCost: TBooleanStoredProcAction;
    bbShowErasedCost: TdxBarButton;
    InsertRecordGoods: TInsertRecord;
    bbInsertRecordGoods: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    actCheckDescService: TdsdExecStoredProc;
    actCheckDescTransport: TdsdExecStoredProc;
    actOpenFormService: TdsdOpenForm;
    actOpenFormTransport: TdsdOpenForm;
    macOpenFormService: TMultiAction;
    macOpenFormTransport: TMultiAction;
    bbOpenFormTransport: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel14: TcxLabel;
    edDiscountNextTax: TcxCurrencyEdit;
    Panel1: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    OperPriceWithVAT: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    SummWithVAT: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    Panel4: TPanel;
    cxSplitter1: TcxSplitter;
    cxLabel17: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    edInsertName: TcxButtonEdit;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintOffer: TdsdStoredProc;
    spSelectPrintStructure: TdsdStoredProc;
    spSelectPrintOrderConfirmation: TdsdStoredProc;
    actPrintAgilis: TdsdPrintAction;
    actPrintStructure: TdsdPrintAction;
    actPrintOrderConfirmation: TdsdPrintAction;
    bbPrintStructure: TdxBarButton;
    bbPrintTender: TdxBarButton;
    spSelectMI_Child: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    actDBViewAddOnChild: TdsdDBViewAddOn;
    InsertRecordInfo: TInsertRecord;
    actUpdateDataSetInfoDS: TdsdUpdateDataSet;
    bbInsertRecordInfo: TdxBarButton;
    actRefreshInfo: TdsdDataSetRefresh;
    actMovementProtocolInfoOpenForm: TdsdOpenForm;
    bbProtocolInfoOpen: TdxBarButton;
    cxLabel6: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    Article_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    AmountPartner_ch3: TcxGridDBColumn;
    OperPrice_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    spInsert_MI_byOrderClient: TdsdStoredProc;
    actInsert_MI_byOrderClient: TdsdExecStoredProc;
    bbInsert_MI_byOrderClient: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    OperDate_ch3: TcxGridDBColumn;
    SetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    spErasedMIChild: TdsdStoredProc;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    macErasedMI_Master_list: TMultiAction;
    macErasedMI_Master: TMultiAction;
    bbErasedMI_Master: TdxBarButton;
    GoodsId_ch3: TcxGridDBColumn;
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    cxLabel9: TcxLabel;
    ceComment_Invoice: TcxTextEdit;
    GuidesInvoice: TdsdGuides;
    EngineNum_ch3: TcxGridDBColumn;
    EngineName_ch3: TcxGridDBColumn;
    TotalAmountPartner: TcxGridDBColumn;

  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderPartnerForm);

end.
