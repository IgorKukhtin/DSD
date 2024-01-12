unit Goods_UKTZED;

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
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, ExternalLoad,
  cxButtonEdit;

type
  TGoods_UKTZEDForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
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
    bbGridToExcel: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel1: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GroupStatName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    GoodsPlatformName: TcxGridDBColumn;
    spUpdateParams: TdsdStoredProc;
    CodeUKTZED: TcxGridDBColumn;
    actUpdateDataSource: TdsdUpdateDataSet;
    CodeUKTZED_calc: TcxGridDBColumn;
    CodeUKTZED_group: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting_UKTZEDnew: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    macStartLoad_UKTZEDnew: TMultiAction;
    bbStartLoad_UKTZEDnew: TdxBarButton;
    CodeUKTZED_group_new: TcxGridDBColumn;
    CodeUKTZED_Calc_new: TcxGridDBColumn;
    spGetImportSettingId_byCode: TdsdStoredProc;
    actGetImportSetting_UKTZEDnewByCode: TdsdExecStoredProc;
    macStartLoad_UKTZEDnewByCode: TMultiAction;
    bbStartLoad_UKTZEDnewByCode: TdxBarButton;
    actChoiceGoodsGroupProperty: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
{$R *.dfm}
initialization
  RegisterClass(TGoods_UKTZEDForm);
end.
