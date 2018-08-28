unit Report_ProductionUnion_Olap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdGuides,
  cxButtonEdit, dsdPivotGrid;

type
  TReport_ProductionUnion_OlapForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spReport: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    PanelHead: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBPivotGrid: TcxDBPivotGrid;
    pvGoodsName: TcxDBPivotGridField;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    pvMonthDate: TcxDBPivotGridField;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PivotAddOn: TPivotAddOn;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    pvAmount: TcxDBPivotGridField;
    pvChildGoodsGroupName: TcxDBPivotGridField;
    pvPartionGoods: TcxDBPivotGridField;
    pvChildPartionGoods: TcxDBPivotGridField;
    pvChildGoodsCode: TcxDBPivotGridField;
    dxBarStatic: TdxBarStatic;
    pvGoodsKindName: TcxDBPivotGridField;
    pvChildGoodsName: TcxDBPivotGridField;
    pvChildGoodsKindName: TcxDBPivotGridField;
    pvChildAmount: TcxDBPivotGridField;
    pvSumm: TcxDBPivotGridField;
    cxLabel3: TcxLabel;
    cxLabel5: TcxLabel;
    edToGroup: TcxButtonEdit;
    edFromGroup: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cxLabel6: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    edChildGoodsGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edChildGoods: TcxButtonEdit;
    edGoods: TcxButtonEdit;
    cbIsMovement: TcxCheckBox;
    GuidesFromGroup: TdsdGuides;
    GuidesToGroup: TdsdGuides;
    GuidesGoodsGroup: TdsdGuides;
    GuidesChildGoodsGroup: TdsdGuides;
    GuidesGoods: TdsdGuides;
    GuidesChildGoods: TdsdGuides;
    cxLabel7: TcxLabel;
    deStart2: TcxDateEdit;
    cxLabel9: TcxLabel;
    deEnd2: TcxDateEdit;
    cxLabel10: TcxLabel;
    PeriodChoice2: TPeriodChoice;
    cbisPartion: TcxCheckBox;
    cfMainPrice_Calc: TdsdPivotGridCalcFields;
    cfChildPrice_Calc: TdsdPivotGridCalcFields;
    cfPrice_Calc: TdsdPivotGridCalcFields;
    cfPercentOut: TdsdPivotGridCalcFields;
    cfMainPrice_CalcW: TdsdPivotGridCalcFields;
    cfChildPrice_w: TdsdPivotGridCalcFields;
    cfPrice_Calcw: TdsdPivotGridCalcFields;
    cfReceiptPrice_Calc: TdsdPivotGridCalcFields;
    cfReceiptPrice_w: TdsdPivotGridCalcFields;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ProductionUnion_OlapForm);

end.
