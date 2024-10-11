unit PriceListItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  Vcl.ExtCtrls, cxPC, dxDockControl, dxDockPanel, cxContainer, dsdGuides,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, cxCurrencyEdit, ExternalLoad,
  dsdCommon;

type
  TPriceListItemForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsName: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    edShowDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    edOperDate: TcxDateEdit;
    EndDate: TcxGridDBColumn;
    ValuePrice: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    actPriceListGoods: TdsdOpenForm;
    bbPriceListGoodsItem: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    isErased: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    ObjectId: TcxGridDBColumn;
    PriceListTaxDialoglOpenForm: TdsdOpenForm;
    bbPriceListTaxDialog: TdxBarButton;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    dsdStoredProcPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    PrintItemsCDS: TClientDataSet;
    bbPrint: TdxBarButton;
    spInsertUpdate_Separate: TdsdStoredProc;
    actInsertUpdate_Separate: TdsdExecStoredProc;
    bbInsertUpdate_Separate: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    actPrintGrid: TdsdPrintAction;
    bbPrintGrid: TdxBarButton;
    TradeMarkName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    value1: TcxGridDBColumn;
    value2_4: TcxGridDBColumn;
    value5_6: TcxGridDBColumn;
    valueprice_kg: TcxGridDBColumn;
    valuepricewithvat_kg: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spInsertUpdate_Zero: TdsdStoredProc;
    actInsertUpdate_Zero: TdsdExecStoredProc;
    macUpdate_Zero: TMultiAction;
    macUpdate_Zero_list: TMultiAction;
    bbUpdate_Zero: TdxBarButton;
    spGet_error: TdsdStoredProc;
    actGet_error: TdsdExecStoredProc;
    actInsertRecordTradeMark: TInsertRecord;
    actChoiceFormTradeMark: TOpenChoiceForm;
    bbInsertRecord_TradeMark: TdxBarButton;
    bbChoiceFormTradeMark: TdxBarButton;
    DescName: TcxGridDBColumn;
    PriceListCode: TcxGridDBColumn;
    PriceListName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListItemForm);

end.
