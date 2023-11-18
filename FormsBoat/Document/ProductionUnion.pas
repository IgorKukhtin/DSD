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
  cxImageComboBox, cxSplitter, Vcl.StdCtrls, cxButtons;

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
    bbShowAll_child: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll_child: TBooleanStoredProcAction;
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
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
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
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbPrintCalc: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
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
    cxLabel5: TcxLabel;
    ceParent: TcxButtonEdit;
    GuidesParent: TdsdGuides;
    Panel3: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableViewMaster: TcxGridDBTableView;
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
    actInsertRecordChild: TInsertRecord;
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
    actChoiceFormReceiptService: TOpenChoiceForm;
    actPersonalChoiceForm: TOpenChoiceForm;
    actSetErasedDetail: TdsdUpdateErased;
    actSetUnErasedDetail: TdsdUpdateErased;
    actInsertRecordDetail: TInsertRecord;
    bbInsertRecordDetail: TdxBarButton;
    bbSetErasedDetail: TdxBarButton;
    bbSetUnErasedDetail: TdxBarButton;
    actUpdateChoiceFormOrderClientItem: TOpenChoiceForm;
    actInsertRecordOrderClientItem: TInsertRecord;
    bbInsertRecordOrderClientItem: TdxBarButton;
    actUpdateChoiceFormBoat: TOpenChoiceForm;
    actInsertRecord_Boat: TInsertRecord;
    bbUpdateChoiceFormOrderClientItem: TdxBarButton;
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
    actSetErasedDetail_All: TdsdUpdateErased;
    SetUnErasedDetail_All: TdsdUpdateErased;
    actUpdateDetail_All: TdsdUpdateDataSet;
    actPersonalChoiceForm_DetAll: TOpenChoiceForm;
    actInsertRecordDetail_All: TInsertRecord;
    actReceiptServiceChoiceForm_DetAll: TOpenChoiceForm;
    bbInsertRecordDetailAll: TdxBarButton;
    bbSetErasedDetail_All: TdxBarButton;
    bbSetUnErasedDetail_All: TdxBarButton;
    actProductionUnionMasterChoiceForm: TOpenChoiceForm;
    MIDetailAllProtocolOpenForm: TdsdOpenForm;
    MIDetailProtocolOpenForm: TdsdOpenForm;
    bbMIDetailAllProtocolOpenForm: TdxBarButton;
    bbMIDetailProtocolOpenForm: TdxBarButton;
    Hours_plan_ch4: TcxGridDBColumn;
    Article_ReceiptService_ch5: TcxGridDBColumn;
    ReceiptServiceCode_ch5: TcxGridDBColumn;
    Hours_plan_ch5: TcxGridDBColumn;
    Price_ch1: TcxGridDBColumn;
    Summ_ch1: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    actPrintCalc: TdsdPrintAction;
    bbsUzel: TdxBarSubItem;
    dxBarSeparator: TdxBarSeparator;
    bbsBoat: TdxBarSubItem;
    bbsGoods: TdxBarSubItem;
    bbsWork: TdxBarSubItem;
    actSetErased_Boat: TdsdUpdateErased;
    actSetUnErased_Boat: TdsdUpdateErased;
    actGoodsChoiceForm: TOpenChoiceForm;
    bbactGoods_ReceiptServiceChoiceForm_Child: TdxBarButton;
    bbChoiceFormReceiptService: TdxBarButton;
    bbReceiptServiceChoiceForm_DetAll: TdxBarButton;
    macErasedMI_Master_list: TMultiAction;
    macErasedMI_Master: TMultiAction;
    bbErasedMI_Master: TdxBarButton;
    cxSplitter3: TcxSplitter;
    Ord: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    actOpenOrderClientForm: TdsdOpenForm;
    bbOpenOrderClientForm: TdxBarButton;
    spInsertUpdate_bySend: TdsdStoredProc;
    actSendInsertForm: TOpenChoiceForm;
    actInsertUpdate_bySend: TdsdExecStoredProc;
    macInsertUpdate_bySend: TMultiAction;
    actRefreshMI_Master: TdsdDataSetRefresh;
    bbInsertUpdate_bySend: TdxBarButton;
    actReport_Goods_master: TdsdOpenForm;
    actReport_Goods_child: TdsdOpenForm;
    bbReport_Goods_master: TdxBarButton;
    bbReport_Goods_child: TdxBarButton;
    cxLabel6: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel7: TcxLabel;
    edInvNumberInvoice: TcxTextEdit;
    cxLabel8: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    actInsertRecordReceiptGoods: TInsertRecord;
    actUpdateChoiceFormReceiptGoods: TOpenChoiceForm;
    macInsertRecordReceiptGoods: TMultiAction;
    bbInsertRecordReceiptGoods: TdxBarButton;
    bbUpdateChoiceFormReceiptGoods: TdxBarButton;
    actOrderClientChoiceForm: TOpenChoiceForm;
    actFormClose: TdsdFormClose;
    bbsView: TdxBarSubItem;
    bbsDoc: TdxBarSubItem;
    bbsOpenForm: TdxBarSubItem;
    bbsPrint: TdxBarSubItem;
    Panel_btn: TPanel;
    btnInsertUpdateMovement: TcxButton;
    btntAdd_limit: TcxButton;
    btnCompleteMovement: TcxButton;
    btnUnCompleteMovement: TcxButton;
    btnSetErased: TcxButton;
    btnShowAll: TcxButton;
    btnInsertAction: TcxButton;
    btnUpdateAction: TcxButton;
    btnCompleteMovement_andSave: TcxButton;
    btnFormClose: TcxButton;
    actCompleteMovement_andSave: TChangeGuidesStatus;
    cbChangeReceipt: TcxCheckBox;
    spUpdate_MI_Child_byOrder: TdsdStoredProc;
    spUpdate_MI_Child_byReceipt: TdsdStoredProc;
    actUpdate_MI_Child_byReceipt: TdsdExecStoredProc;
    actUpdate_MI_Child_byOrder: TdsdExecStoredProc;
    bbUpdate_MI_Child_byOrder: TdxBarButton;
    bbUpdate_MI_Child_byReceipt: TdxBarButton;
    macUpdate_MI_Child_byOrder_list: TMultiAction;
    macUpdate_MI_Child_byOrder: TMultiAction;
    actRefresh_Child: TdsdDataSetRefresh;
    macUpdate_MI_Child_byReceipt_list: TMultiAction;
    macUpdate_MI_Child_byReceipt: TMultiAction;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionForm);

end.
