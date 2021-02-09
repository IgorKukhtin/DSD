unit WeighingProduction;

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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit;

type
  TWeighingProductionForm = class(TParentForm)
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
    dsdGuidesFrom: TdsdGuides;
    dsdGuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    WeightSkewer1: TcxGridDBColumn;
    CountSkewer1: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    InsertDate: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    WeightTare: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    CountTare: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Count: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edStartWeighing: TcxDateEdit;
    cxLabel7: TcxLabel;
    HeaderSaver: THeaderSaver;
    edMovementDescNumber: TcxTextEdit;
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
    IsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    PartionGoodsDate: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel8: TcxLabel;
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    CountPack: TcxGridDBColumn;
    edOperDate_parent: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumber_parent: TcxTextEdit;
    cxLabel12: TcxLabel;
    cxLabel10: TcxLabel;
    edWeighingNumber: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edPartionGoods: TcxTextEdit;
    edisIncome: TcxCheckBox;
    StartWeighing: TcxGridDBColumn;
    LiveWeight: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    CountSkewer2: TcxGridDBColumn;
    WeightSkewer2: TcxGridDBColumn;
    WeightOther: TcxGridDBColumn;
    cxLabel13: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    spSelectPrintCeh: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    bbOpenDocument: TdxBarButton;
    actUpdateDocument: TdsdInsertUpdateAction;
    MovementDescGuides: TdsdGuides;
    edMovementDescName: TcxButtonEdit;
    StorageLineName: TcxGridDBColumn;
    cxLabel15: TcxLabel;
    edGoodsTypeKind: TcxButtonEdit;
    GuidesGoodsTypeKind: TdsdGuides;
    cxLabel16: TcxLabel;
    GuidesBarCodeBox: TdsdGuides;
    edBarCodeBox: TcxButtonEdit;
    ExecuteDialogUpdateParams: TExecuteDialog;
    actUpdateParams: TdsdExecStoredProc;
    macUpdateParams: TMultiAction;
    spUpdate_Param: TdsdStoredProc;
    bbUpdateParams: TdxBarButton;
    edIsAuto: TcxCheckBox;
    spSelectPrintNoGroup: TdsdStoredProc;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    spSelectPrintBarCode: TdsdStoredProc;
    actPrintBarCode: TdsdPrintAction;
    bbPrintBarCode: TdxBarButton;
    cxLabel17: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    OrderChoiceGuides: TdsdGuides;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    macOpenDocument: TMultiAction;
    bbOpenDocumentMain: TdxBarButton;
    cxLabel22: TcxLabel;
    edPersonalGroup: TcxButtonEdit;
    GuidesPersonalGroup: TdsdGuides;
    cxLabel19: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel20: TcxLabel;
    ed: TcxButtonEdit;
    GuidesSubjectDoc: TdsdGuides;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingProductionForm);

end.
