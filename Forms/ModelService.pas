unit ModelService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  DataModul, cxButtonEdit, cxSplitter, cxCurrencyEdit, dsdCommon;

type
  TModelServiceForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelectMaster: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    clIsErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    clName: TcxGridDBColumn;
    cxGridModelServiceItemMaster: TcxGrid;
    cxGridDBTableViewModelServiceItemMaster: TcxGridDBTableView;
    clMovementDescName: TcxGridDBColumn;
    clRatio: TcxGridDBColumn;
    clFromName: TcxGridDBColumn;
    clToName: TcxGridDBColumn;
    clSelectKindName: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clmsimIsErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridStaffListCost: TcxGrid;
    cxGridDBTableViewModelServiceItemChild: TcxGridDBTableView;
    clmsicFromName: TcxGridDBColumn;
    clsfcComment: TcxGridDBColumn;
    clmsicToName: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    ModelServiceItemMasterCDS: TClientDataSet;
    ModelServiceItemMasterDS: TDataSource;
    spSelectModelServiceItemMaster: TdsdStoredProc;
    clCode: TcxGridDBColumn;
    spInsertUpdateObjectModelServiceItemMaster: TdsdStoredProc;
    actUpdateModelServiceItemMaster: TdsdUpdateDataSet;
    UnitFromChoiceForm: TOpenChoiceForm;
    ModelServiceItemChildCDS: TClientDataSet;
    ModelServiceItemChildDS: TDataSource;
    spSelectModelServiceItemChild: TdsdStoredProc;
    spInsertUpdateObjectModelServiceItemChild: TdsdStoredProc;
    actUpdateModelServiceItemChild: TdsdUpdateDataSet;
    clmsComment: TcxGridDBColumn;
    clUnitName: TcxGridDBColumn;
    clModelServiceKindName: TcxGridDBColumn;
    actUpdateModelService: TdsdUpdateDataSet;
    bbInsert: TdxBarButton;
    ModelServiceKindChoiceForm: TOpenChoiceForm;
    actInsert: TdsdInsertUpdateAction;
    SelectKindChoiceForm: TOpenChoiceForm;
    UnitFromChoiceFormMaster: TOpenChoiceForm;
    UnitFromChoiceFormChild: TOpenChoiceForm;
    GoodsFromChoiceForm: TOpenChoiceForm;
    GoodsToChoiceForm: TOpenChoiceForm;
    MovementDescChoiceForm: TOpenChoiceForm;
    actUpdate: TdsdInsertUpdateAction;
    bbUpdate: TdxBarButton;
    spErasedUnErasedMaster: TdsdStoredProc;
    dsdSetErasedMaster: TdsdUpdateErased;
    bbErasedMaster: TdxBarButton;
    dsdSetUnErasedMaster: TdsdUpdateErased;
    bbUnErasedMaster: TdxBarButton;
    dsdDBViewAddOnMaster: TdsdDBViewAddOn;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    dsdSetErasedChild: TdsdUpdateErased;
    spErasedUnErasedChild: TdsdStoredProc;
    dsdSetUnErasedChild: TdsdUpdateErased;
    bbErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    isErasedChild: TcxGridDBColumn;
    cxLeftSplitter: TcxSplitter;
    cxSplitterBottom: TcxSplitter;
    DocumentKindChoiceForm: TOpenChoiceForm;
    ToCode: TcxGridDBColumn;
    FromCode: TcxGridDBColumn;
    FromGoodsKindChoiceForm: TOpenChoiceForm;
    ToGoodsKindChoiceForm: TOpenChoiceForm;
    FromGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    ToGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    GoodsGroupFromChoiceForm: TOpenChoiceForm;
    bbGroupFromChoice: TdxBarButton;
    GoodsGroupToChoiceForm: TOpenChoiceForm;
    bbGoodsGroupToChoice: TdxBarButton;
    ToStorageLineChoiceForm: TOpenChoiceForm;
    FromStorageLineChoiceForm: TOpenChoiceForm;
    ProtocolOpenForm: TdsdOpenForm;
    ProtocolOpenMaster: TdsdOpenForm;
    ProtocolOpenChild: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    bbProtocolMaster: TdxBarButton;
    bbProtocolChild: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    isTrainee: TcxGridDBColumn;
    GoodsCode_to: TcxGridDBColumn;
    GoodsName_to: TcxGridDBColumn;
    GoodsGroupName_to: TcxGridDBColumn;
    GoodsGroupNameFull_to: TcxGridDBColumn;
    GroupStatName_to: TcxGridDBColumn;
    GoodsGroupAnalystName_to: TcxGridDBColumn;
    TradeMarkName_to: TcxGridDBColumn;
    GoodsTagName_to: TcxGridDBColumn;
    GoodsPlatformName_to: TcxGridDBColumn;
    actShowbyGroup: TBooleanStoredProcAction;
    bbShowbyGroup: TdxBarButton;
    DescName_from: TcxGridDBColumn;
    DescName_to: TcxGridDBColumn;
    dsdGridToExcelChild: TdsdGridToExcel;
    bbGridToExcelChild: TdxBarButton;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TModelServiceForm);
end.
