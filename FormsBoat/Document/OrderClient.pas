unit OrderClient;

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
  TOrderClientForm = class(TParentForm)
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
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel9: TcxLabel;
    ceComment_Invoice: TcxTextEdit;
    cxLabel6: TcxLabel;
    edProduct: TcxButtonEdit;
    GuidesProduct: TdsdGuides;
    cxLabel12: TcxLabel;
    GuidesBrand: TdsdGuides;
    edBrand: TcxButtonEdit;
    edCIN: TcxTextEdit;
    cxLabel13: TcxLabel;
    cxLabel14: TcxLabel;
    edDiscountNextTax: TcxCurrencyEdit;
    DBViewAddOnProdColorItems: TdsdDBViewAddOn;
    ProdColorItemsDS: TDataSource;
    spSelect_ProdColorItems: TdsdStoredProc;
    spInsertUpdateProdColorItems: TdsdStoredProc;
    spErasedColor: TdsdStoredProc;
    spUnErasedColor: TdsdStoredProc;
    ProdColorItemsCDS: TClientDataSet;
    Panel1: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    CIN: TcxGridDBColumn;
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
    ProdOptItemsCDS: TClientDataSet;
    DBViewAddOnProdOptItems: TdsdDBViewAddOn;
    ProdOptItemsDS: TDataSource;
    spErasedOpt: TdsdStoredProc;
    spSelect_ProdOptItems: TdsdStoredProc;
    spUnErasedOpt: TdsdStoredProc;
    spInsertUpdateProdOptItems: TdsdStoredProc;
    cxTopSplitter: TcxSplitter;
    Panel4: TPanel;
    PanelProdColorItems: TPanel;
    cxGridProdColorItems: TcxGrid;
    cxGridDBTableViewProdColorItems: TcxGridDBTableView;
    isEnabled_ch1: TcxGridDBColumn;
    NPP_ch1: TcxGridDBColumn;
    Code_ch1: TcxGridDBColumn;
    ProdColorGroupName_ch1: TcxGridDBColumn;
    ProdColorPatternName_ch1: TcxGridDBColumn;
    isDiff_ch1: TcxGridDBColumn;
    ProdColorName_ch1: TcxGridDBColumn;
    IsProdOptions_ch1: TcxGridDBColumn;
    GoodsGroupNameFull_ch1: TcxGridDBColumn;
    GoodsGroupName_ch1: TcxGridDBColumn;
    GoodsCode_ch1: TcxGridDBColumn;
    Article_ch1: TcxGridDBColumn;
    GoodsName_ch1: TcxGridDBColumn;
    MeasureName_ch1: TcxGridDBColumn;
    EKPrice_ch1: TcxGridDBColumn;
    BasisPrice_ch1: TcxGridDBColumn;
    BasisPriceWVAT_ch1: TcxGridDBColumn;
    EKPrice_summ_ch1: TcxGridDBColumn;
    Basis_summ_ch1: TcxGridDBColumn;
    BasisWVAT_summ_ch1: TcxGridDBColumn;
    Comment_ch1: TcxGridDBColumn;
    InsertDate_ch1: TcxGridDBColumn;
    InsertName_ch1: TcxGridDBColumn;
    isErased_ch1: TcxGridDBColumn;
    Color_fon_ch1: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    Panel2: TPanel;
    PanelProdOptItems: TPanel;
    cxGridProdOptItems: TcxGrid;
    cxGridDBTableViewProdOptItems: TcxGridDBTableView;
    isEnabled_ch2: TcxGridDBColumn;
    NPP_ch2: TcxGridDBColumn;
    DiscountTax_ch2: TcxGridDBColumn;
    Code_ch2: TcxGridDBColumn;
    ProdOptPatternName_ch2: TcxGridDBColumn;
    ProdOptionsName_ch2: TcxGridDBColumn;
    ProdColorName_ch2: TcxGridDBColumn;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsGroupName_ch2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    Article_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    PartNumber_ch2: TcxGridDBColumn;
    EKPrice_ch2: TcxGridDBColumn;
    SalePrice_ch2: TcxGridDBColumn;
    SalePriceWVAT_ch2: TcxGridDBColumn;
    EKPrice_summ_ch2: TcxGridDBColumn;
    Sale_summ_ch2: TcxGridDBColumn;
    SaleWVAT_summ_ch2: TcxGridDBColumn;
    Comment_ch2: TcxGridDBColumn;
    InsertDate_ch2: TcxGridDBColumn;
    InsertName_ch2: TcxGridDBColumn;
    IsErased_ch2: TcxGridDBColumn;
    Color_fon_ch2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Panel3: TPanel;
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
    cxTabSheet1: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    GoodsGroupNameFull_ch3: TcxGridDBColumn;
    GoodsGroupName_ch3: TcxGridDBColumn;
    Article_Object_ch3: TcxGridDBColumn;
    ObjectCode_ch3: TcxGridDBColumn;
    ObjectName_ch3: TcxGridDBColumn;
    MeasureName_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    OperPrice_ch3: TcxGridDBColumn;
    CountForPrice_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    UnitName_ch3: TcxGridDBColumn;
    AmountPartner_ch3: TcxGridDBColumn;
    spSelectMI_Child: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    DBViewAddOnChild: TdsdDBViewAddOn;
    cxTabSheet2: TcxTabSheet;
    cxGridInfo: TcxGrid;
    cxGridDBTableViewInfo: TcxGridDBTableView;
    Text_Info: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    DBViewAddOnInfo: TdsdDBViewAddOn;
    InfoCDS: TClientDataSet;
    InfoDS: TDataSource;
    spSelectMovement_Info: TdsdStoredProc;
    spUpdateMovementInfo: TdsdStoredProc;
    CodeInfo: TcxGridDBColumn;
    InsertRecordInfo: TInsertRecord;
    actUpdateDataSetInfoDS: TdsdUpdateDataSet;
    bbInsertRecordInfo: TdxBarButton;
    actRefreshInfo: TdsdDataSetRefresh;
    actMovementProtocolInfoOpenForm: TdsdOpenForm;
    bbProtocolInfoOpen: TdxBarButton;
    DBViewAddOn: TdsdDBViewAddOn;
    PartnerName_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    Article_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    DescName_ch3: TcxGridDBColumn;
    TotalSumm_unit_ch3: TcxGridDBColumn;
    TotalSumm_partner_ch3: TcxGridDBColumn;
    TotalSumm_ch3: TcxGridDBColumn;
    ProdOptionsName_ch3: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderClientForm);

end.
