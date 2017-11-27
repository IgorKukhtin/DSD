unit GoodsReportSale;

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
  DataModul, cxButtonEdit, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  Vcl.ExtCtrls, dsdGuides, cxSplitter, cxGridChartView, cxGridDBChartView;

type
  TGoodsReportSaleForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    spSelect: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    GoodsKindName: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actUpdateDataSet: TdsdUpdateDataSet;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbUpdateIsOfficial: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    Amount1: TcxGridDBColumn;
    bbUpdateParams: TdxBarButton;
    FormParams: TdsdFormParams;
    bbInsertUpdate: TdxBarButton;
    Panel: TPanel;
    UnitName: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    deEnd: TcxDateEdit;
    cxLabel3: TcxLabel;
    deUpdate: TcxDateEdit;
    cxLabel9: TcxLabel;
    ceWeek: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    edUpdateName: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    spGet_GoodsReportSaleInf: TdsdStoredProc;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdExecStoredProc;
    macInsertUpdate: TMultiAction;
    MeasureName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgNumDays: TcxGridDBChartDataGroup;
    grChartLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    spSelectChild: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsReportSaleForm);

end.
