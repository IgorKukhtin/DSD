unit Goods;

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
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dxSkinsdxBarPainter,
  dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxButtonEdit,
  cxCurrencyEdit, ExternalLoad;

type
  TGoodsForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel1: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    FuelName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    IsPartionCount: TcxGridDBColumn;
    IsPartionSumm: TcxGridDBColumn;
    GroupStatName: TcxGridDBColumn;
    GoodsTagName: TcxGridDBColumn;
    GoodsGroupAnalystName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    GoodsPlatformName: TcxGridDBColumn;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    spUpdateisPartionCount: TdsdStoredProc;
    actUpdateisPartionCount: TdsdExecStoredProc;
    bbisPartionCount: TdxBarButton;
    actUpdateisPartionSumm: TdsdExecStoredProc;
    bbisPartionSumm: TdxBarButton;
    spUpdateisPartionSumm: TdsdStoredProc;
    InDate: TcxGridDBColumn;
    PartnerInName: TcxGridDBColumn;
    spUpdateGoods_In: TdsdStoredProc;
    actDatePeriodDialog: TExecuteDialog;
    actUpdateGoods_In: TdsdExecStoredProc;
    macUpdateGoods_In: TMultiAction;
    bbUpdateGoods_In: TdxBarButton;
    FormParams: TdsdFormParams;
    actUpdateDataSet: TdsdUpdateDataSet;
    spUpdateAsset: TdsdStoredProc;
    actChoiceAsset: TOpenChoiceForm;
    AssetName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    PriceIn: TcxGridDBColumn;
    spUpdate_WeightTare: TdsdStoredProc;
    actUpdate_WeightTare: TdsdExecStoredProc;
    macUpdate_WeightTare: TMultiAction;
    macUpdate_WeightTareList: TMultiAction;
    ExecuteDialogWeightTare: TExecuteDialog;
    bbUpdate_WeightTareList: TdxBarButton;
    actGetImportSetting_Goods_Price: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    Name_BUH: TcxGridDBColumn;
    Date_BUH: TcxGridDBColumn;
    spUpdate_Name_BUH: TdsdStoredProc;
    actUpdate_Name_BUH: TdsdExecStoredProc;
    macUpdate_Name_BUH: TMultiAction;
    ExecuteDialog_Name_BUH: TExecuteDialog;
    bbUpdate_Name_BUH: TdxBarButton;
    isNameOrig: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}
initialization
  RegisterClass(TGoodsForm);
end.
