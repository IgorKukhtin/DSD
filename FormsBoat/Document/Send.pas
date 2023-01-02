unit Send;

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
  cxImageComboBox, cxSplitter;

type
  TSendForm = class(TParentForm)
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
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    actMovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecordCost: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    bbShowErasedCost: TdxBarButton;
    bbInsertRecordGoods: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    actOpenFormInvoice: TdsdOpenForm;
    bbOpenFormInvoice: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    actCompleteCost: TdsdChangeMovementStatus;
    actSetErasedCost: TdsdChangeMovementStatus;
    actUnCompleteCost: TdsdChangeMovementStatus;
    actMovementCostProtocolOpenForm: TdsdOpenForm;
    cxLabel12: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edInsertName: TcxButtonEdit;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    ChildViewAddOn: TdsdDBViewAddOn;
    spSelectMIChild: TdsdStoredProc;
    spErasedMIchild: TdsdStoredProc;
    actSetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    GuidesFrom: TdsdGuides;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    Amount_unit: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    InvNumber_OrderClientFull_ch2: TcxGridDBColumn;
    IsErased_ch2: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    Artikel_ch2: TcxGridDBColumn;
    InvNumber_OrderPartner_Full_ch2: TcxGridDBColumn;
    CIN_ch2: TcxGridDBColumn;
    ProductName_ch2: TcxGridDBColumn;
    BrandName_ch2: TcxGridDBColumn;
    spInsert_MI_Send: TdsdStoredProc;
    actInsert_MI_Send: TdsdExecStoredProc;
    macInsert_MI_Send: TMultiAction;
    bbcInsert_MI_Send_Child: TdxBarButton;
    actOpenFormOrderClient: TdsdOpenForm;
    actOpenFormOrderPartner: TdsdOpenForm;
    bbOpenFormOrderClient: TdxBarButton;
    bbOpenFormOrderPartner: TdxBarButton;
    isOn: TcxGridDBColumn;
    EngineNum_ch2: TcxGridDBColumn;
    EngineName_ch2: TcxGridDBColumn;
    spUnErasedMIchild: TdsdStoredProc;
    actSetUnErasedChild: TdsdUpdateErased;
    bbUnErasedChild: TdxBarButton;
    actReport_Goods: TdsdOpenForm;
    actReport_Goods_child: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    bbReport_Goods_child: TdxBarButton;
    AmountSecond: TcxGridDBColumn;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    Panel2: TPanel;
    cxLabel6: TcxLabel;
    edBarCode1: TcxTextEdit;
    cxLabel8: TcxLabel;
    EnterMoveNext1: TEnterMoveNext;
    Panel3: TPanel;
    cxLabel5: TcxLabel;
    edPartNumber: TcxTextEdit;
    cxLabel7: TcxLabel;
    edBarCode2: TcxTextEdit;
    cxLabel9: TcxLabel;
    EnterMoveNext2: TEnterMoveNext;
    Panel4: TPanel;
    edAmount: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    cxLabel10: TcxLabel;
    edBarCode3: TcxTextEdit;
    cxLabel14: TcxLabel;
    EnterMoveNext3: TEnterMoveNext;
    actGoodsItem1: TdsdInsertUpdateAction;
    actGoodsItem2: TdsdInsertUpdateAction;
    actGoodsItem3: TdsdInsertUpdateAction;
    macGoodsItem1: TMultiAction;
    macGoodsItem2: TMultiAction;
    macGoodsItem3: TMultiAction;
    actAdd: TdsdInsertUpdateAction;
    mactAdd: TMultiAction;
    bbUpdateActionMovement: TdxBarButton;
    spBarcode_null: TdsdStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    spGet_dop1: TdsdStoredProc;
    spGet_dop2: TdsdStoredProc;
    spGet_dop3: TdsdStoredProc;
    actGoodsItemGet1: TdsdExecStoredProc;
    actGoodsItemGet2: TdsdExecStoredProc;
    actGoodsItemGet3: TdsdExecStoredProc;
    Ord: TcxGridDBColumn;
    OperDate_protocol: TcxGridDBColumn;
    UserName_protocol: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    actChoiceGuides: TdsdChoiceGuides;
    Article_all: TcxGridDBColumn;
    edSearchArticle: TcxTextEdit;
    lbSearchArticle: TcxLabel;
    FieldFilter_Article: TdsdFieldFilter;
    bbedSearchArticle: TdxBarControlContainerItem;
    bblbSearchArticle: TdxBarControlContainerItem;
    Panel1: TPanel;
    actOrderClientChoiceForm: TOpenChoiceForm;
    cxLabel15: TcxLabel;
    edReceiptGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    actOrderClientInsertForm: TOpenChoiceForm;
    spInsert_MI_Send_byOrder: TdsdStoredProc;
    actInsert_MI_Send_byOrder: TdsdExecStoredProc;
    macInsert_MI_Send_byOrder: TMultiAction;
    bbInsert_MI_Send_byOrder: TdxBarButton;
    spInsert_MI_Send_byOrder_Detail: TdsdStoredProc;
    actInsert_MI_Send_byOrderDetail: TdsdExecStoredProc;
    macInsert_MI_Send_byOrderDetail: TMultiAction;
    bbInsert_MI_Send_byOrderDetail: TdxBarButton;
    spInsert_MI_Send_byOrderInternal: TdsdStoredProc;
    actInsert_MI_Send_byOrderInternal: TdsdExecStoredProc;
    actOrderInternalInsertForm: TOpenChoiceForm;
    macInsert_MI_Send_byOrderInternal: TMultiAction;
    bbInsert_MI_Send_byOrderInternal: TdxBarButton;
    ProdColorName: TcxGridDBColumn;
    Comment_goods: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendForm);

end.
