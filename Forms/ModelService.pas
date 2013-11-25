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
  DataModul, cxButtonEdit;

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
    bbModelService: TdxBarButton;
    ModelServiceKindChoiceForm: TOpenChoiceForm;
    actInsertMaster: TdsdInsertUpdateAction;
    SelectKindChoiceForm: TOpenChoiceForm;
    UnitFromChoiceFormMaster: TOpenChoiceForm;
    UnitFromChoiceFormChild: TOpenChoiceForm;
    InsertModelService: TInsertRecord;
    ModelServiceChoiceForm: TOpenChoiceForm;
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
