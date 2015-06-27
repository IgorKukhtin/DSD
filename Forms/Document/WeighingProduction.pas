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
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colWeightSkewer1: TcxGridDBColumn;
    colCountSkewer1: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    coInsertDate: TcxGridDBColumn;
    colUpdateDate: TcxGridDBColumn;
    colRealWeight: TcxGridDBColumn;
    colWeightTare: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colCountTare: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colCount: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edStartWeighing: TcxDateEdit;
    edMovementDescName: TcxCurrencyEdit;
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
    colIsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    colPartionGoodsDate: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel8: TcxLabel;
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
    clGoodsGroupNameFull: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    colCountPack: TcxGridDBColumn;
    edOperDate_parent: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumber_parent: TcxTextEdit;
    cxLabel12: TcxLabel;
    cxLabel10: TcxLabel;
    edWeighingNumber: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edPartionGoods: TcxTextEdit;
    edisIncome: TcxCheckBox;
    colStartWeighing: TcxGridDBColumn;
    colLiveWeight: TcxGridDBColumn;
    colHeadCount: TcxGridDBColumn;
    colCountSkewer2: TcxGridDBColumn;
    colWeightSkewer2: TcxGridDBColumn;
    colWeightOther: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingProductionForm);

end.
