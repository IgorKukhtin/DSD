unit WeighingProduction_wms;

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
  TWeighingProduction_wmsForm = class(TParentForm)
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
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    LineCode: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    UpdateDate: TcxGridDBColumn;
    GoodsTypeKindName: TcxGridDBColumn;
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
    GuidesStatus: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel8: TcxLabel;
    edUser: TcxButtonEdit;
    GuidesUser: TdsdGuides;
    BarCodeBoxName: TcxGridDBColumn;
    WmsCode: TcxGridDBColumn;
    edOperDate_parent: TcxDateEdit;
    cxLabel12: TcxLabel;
    cxLabel10: TcxLabel;
    edPlaceNumber: TcxCurrencyEdit;
    InsertDate: TcxGridDBColumn;
    spSelectPrintCeh: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    bbOpenDocument: TdxBarButton;
    actUpdateDocument: TdsdInsertUpdateAction;
    GuidesMovementDesc: TdsdGuides;
    edMovementDescName: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel14: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GuidesGoodsKind: TdsdGuides;
    InvNumber_Parent: TcxGridDBColumn;
    GuidesGoodsTypeKind1: TdsdGuides;
    cxLabel15: TcxLabel;
    edGoodsTypeKind_1: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edGoodsTypeKind_2: TcxButtonEdit;
    GuidesGoodsTypeKind2: TdsdGuides;
    cxLabel17: TcxLabel;
    edGoodsTypeKind_3: TcxButtonEdit;
    GuidesGoodsTypeKind3: TdsdGuides;
    edBarCodeBox_1: TcxButtonEdit;
    cxLabel18: TcxLabel;
    GuidesBarCodeBox1: TdsdGuides;
    cxLabel19: TcxLabel;
    edBarCodeBox_2: TcxButtonEdit;
    GuidesBarCodeBox2: TdsdGuides;
    cxLabel20: TcxLabel;
    edBarCodeBox_3: TcxButtonEdit;
    GuidesBarCodeBox3: TdsdGuides;
    cxLabel21: TcxLabel;
    edBox_1: TcxButtonEdit;
    GuidesBox1: TdsdGuides;
    cxLabel22: TcxLabel;
    edBox_2: TcxButtonEdit;
    GuidesBox2: TdsdGuides;
    cxLabel23: TcxLabel;
    edBox_3: TcxButtonEdit;
    GuidesBox3: TdsdGuides;
    Amount: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    BoxName: TcxGridDBColumn;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    bbPrintSticker: TdxBarButton;
    spSelectPrintNoGroup: TdsdStoredProc;
    actPrintNoGroup: TdsdPrintAction;
    bbPrintNoGroup: TdxBarButton;
    actOpenWeighingProductionForm: TdsdOpenForm;
    bbOpenWeighingProductionForm: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingProduction_wmsForm);

end.
