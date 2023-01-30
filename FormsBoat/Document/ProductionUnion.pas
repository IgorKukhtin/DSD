unit ProductionUnion;

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
  TProductionUnionForm = class(TParentForm)
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
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    actUnion_Goods_ReceiptServiceChoiceForm: TOpenChoiceForm;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actProductChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecordCost: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    actShowErasedCost: TBooleanStoredProcAction;
    bbShowErasedCost: TdxBarButton;
    InsertRecordProduct: TInsertRecord;
    bbInsertRecordGoods: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    actOpenFormInvoice: TdsdOpenForm;
    bbOpenFormInvoice: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    actUpdateClientDataMIChild: TdsdUpdateDataSet;
    actCompleteCost: TdsdChangeMovementStatus;
    actSetErasedCost: TdsdChangeMovementStatus;
    actUnCompleteCost: TdsdChangeMovementStatus;
    InsertRecordReceiptGoods: TInsertRecord;
    actReceiptGoodsChoiceForm: TOpenChoiceForm;
    MovementItemChildProtocolOpenForm: TdsdOpenForm;
    cxLabel12: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edInsertName: TcxButtonEdit;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    ChildViewAddOn: TdsdDBViewAddOn;
    spSelectMIChild: TdsdStoredProc;
    spErasedMIchild: TdsdStoredProc;
    SetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    GuidesFrom: TdsdGuides;
    spUnErasedMIchild: TdsdStoredProc;
    spInsertUpdateMIChild: TdsdStoredProc;
    SetUnErasedChild: TdsdUpdateErased;
    bbSetUnErasedChild: TdxBarButton;
    actShowAllChild: TBooleanStoredProcAction;
    bbShowAllChild: TdxBarButton;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    Panel2: TPanel;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    NPP_ch1: TcxGridDBColumn;
    DescName_ch1: TcxGridDBColumn;
    GoodsGroupNameFull_ch1: TcxGridDBColumn;
    GoodsGroupName_ch1: TcxGridDBColumn;
    ObjectCode_ch1: TcxGridDBColumn;
    Article_ch1: TcxGridDBColumn;
    ObjectName_ch1: TcxGridDBColumn;
    ProdColorName_ch1: TcxGridDBColumn;
    MeasureName_ch1: TcxGridDBColumn;
    Value_ch1: TcxGridDBColumn;
    Value_service_ch1: TcxGridDBColumn;
    Amount_ch1: TcxGridDBColumn;
    Amount_diff_ch1: TcxGridDBColumn;
    Comment_ch1: TcxGridDBColumn;
    IsErased_ch1: TcxGridDBColumn;
    Color_value_ch1: TcxGridDBColumn;
    Color_Level_ch1: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    Panel1: TPanel;
    cxLabel5: TcxLabel;
    ceParent: TcxButtonEdit;
    GuidesParent: TdsdGuides;
    Panel3: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ObjectCode: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    CIN: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    ReceiptProdModelName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    bbChildProtocol: TdxBarButton;
    spUpdate_MI_Child: TdsdStoredProc;
    actUpdate_MI_Child: TdsdExecStoredProc;
    bbUpdate_MI_Child: TdxBarButton;
    EngineNum: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    ProdColorName: TcxGridDBColumn;
    Comment_goods: TcxGridDBColumn;
    Comment_goods_ch1: TcxGridDBColumn;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    DetailViewAddOn: TdsdDBViewAddOn;
    cxGrid_Detail: TcxGrid;
    cxGridDBTableView_Det: TcxGridDBTableView;
    Article_ch4: TcxGridDBColumn;
    ReceiptServiceCode_ch4: TcxGridDBColumn;
    ReceiptServiceName_ch4: TcxGridDBColumn;
    PersonalCode_ch4: TcxGridDBColumn;
    PersonalName_ch4: TcxGridDBColumn;
    Amount_ch4: TcxGridDBColumn;
    OperPrice_ch4: TcxGridDBColumn;
    Hours_ch4: TcxGridDBColumn;
    Summ_ch4: TcxGridDBColumn;
    Comment_ch4: TcxGridDBColumn;
    isErased_ch4: TcxGridDBColumn;
    cxGridLevel_Det: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    spInsertUpdateMIDetail: TdsdStoredProc;
    spUnErasedMIDetail: TdsdStoredProc;
    spErasedMIDetail: TdsdStoredProc;
    spSelectMI_Detail: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    actReceiptServiceChoiceForm: TOpenChoiceForm;
    actPersonalChoiceForm: TOpenChoiceForm;
    SetErasedDetail: TdsdUpdateErased;
    SetUnErasedDetail: TdsdUpdateErased;
    InsertRecordDetail: TInsertRecord;
    bbInsertRecordDetail: TdxBarButton;
    bbSetErasedDetail: TdxBarButton;
    bbSetUnErasedDetail: TdxBarButton;
    actChoiceFormOrderClientItem: TOpenChoiceForm;
    InsertRecordOrderClientItem: TInsertRecord;
    bbInsertRecordOrderClientItem: TdxBarButton;
    actOrderClientInsertBoatForm: TOpenChoiceForm;
    InsertRecordBoat: TInsertRecord;
    bbChoiceFormOrderClientItem: TdxBarButton;
    bbInsertRecordBoat: TdxBarButton;
    bbOrderClientInsertBoatForm: TdxBarButton;
    cxTabSheetDetail: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGridDBTableView_DetAll: TcxGridDBTableView;
    ReceiptServiceName_ch5: TcxGridDBColumn;
    PersonalCode_ch5: TcxGridDBColumn;
    PersonalName_ch5: TcxGridDBColumn;
    Amount_ch5: TcxGridDBColumn;
    OperPrice_ch5: TcxGridDBColumn;
    Hours_ch5: TcxGridDBColumn;
    Summ_ch54: TcxGridDBColumn;
    Comment_ch5: TcxGridDBColumn;
    isErased_ch5: TcxGridDBColumn;
    DescName_master_ch5: TcxGridDBColumn;
    Article_master_ch5: TcxGridDBColumn;
    GoodsCode_master_ch5: TcxGridDBColumn;
    GoodsName_master_ch5: TcxGridDBColumn;
    Amount_master_ch5: TcxGridDBColumn;
    InvNumberFull_OrderClient_ch5: TcxGridDBColumn;
    CIN_OrderClient_ch5: TcxGridDBColumn;
    ProductName_OrderClient_ch5: TcxGridDBColumn;
    FromName_OrderClient_ch5: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spSelectMI_DetailAll: TdsdStoredProc;
    DetailViewAddOn_All: TdsdDBViewAddOn;
    DetailDS_All: TDataSource;
    DetailCDS_All: TClientDataSet;
    spUnErasedMIDetail_All: TdsdStoredProc;
    spErasedMIDetailAll: TdsdStoredProc;
    spInsertUpdateMIDetailAll: TdsdStoredProc;
    SetErasedDetail_All: TdsdUpdateErased;
    SetUnErasedDetail_All: TdsdUpdateErased;
    actUpdateDetailrDS_All: TdsdUpdateDataSet;
    actPersonalChoiceForm_DetAll: TOpenChoiceForm;
    InsertRecordDetailAll: TInsertRecord;
    actReceiptServiceChoiceForm_DetAll: TOpenChoiceForm;
    bbInsertRecordDetailAll: TdxBarButton;
    bbSetErasedDetail_All: TdxBarButton;
    bbSetUnErasedDetail_All: TdxBarButton;
    actMasterChoiceForm: TOpenChoiceForm;
    MIDetailAllProtocolOpenForm: TdsdOpenForm;
    MIDetailProtocolOpenForm: TdsdOpenForm;
    bbMIDetailAllProtocolOpenForm: TdxBarButton;
    bbMIDetailProtocolOpenForm: TdxBarButton;
    Hours_plan_ch4: TcxGridDBColumn;
    Article_ReceiptService_ch5: TcxGridDBColumn;
    ReceiptServiceCode_ch5: TcxGridDBColumn;
    Hours_plan_ch5: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionForm);

end.
