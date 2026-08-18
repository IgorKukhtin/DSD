unit Report_SoldTable_Commerc_Olap;

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
  cxButtonEdit, dsdPivotGrid, dsdCommon;

type
  TReport_SoldTable_Commerc_OlapForm = class(TParentForm)
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
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
    dxBarStatic: TdxBarStatic;
    pvMeasureName: TcxDBPivotGridField;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    cfPersentWeight: TdsdPivotGridCalcFields;
    cxLabel5: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    edSearchGoodsName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsGroupNameFull: TcxGridDBColumn;
    ContractNumber: TcxGridDBColumn;
    Goods_Search: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxLabel6: TcxLabel;
    edSearchContractNumber: TcxTextEdit;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    edSearchJuridicalName: TcxTextEdit;
    cxLabel11: TcxLabel;
    edSearchRetailName: TcxTextEdit;
    RetailName: TcxGridDBColumn;
    GoodsName_basis: TcxGridDBColumn;
    pvPersentWeight: TcxDBPivotGridField;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    cxLabel20: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    cxLabel3: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
    cxLabel14: TcxLabel;
    ådTradeMark: TcxButtonEdit;
    GuidesTradeMark: TdsdGuides;
    cxJuridicalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    edSearchPartnerName: TcxTextEdit;
    cxLabel15: TcxLabel;
    cfPersentSumm: TdsdPivotGridCalcFields;
    pvPersentSumm: TcxDBPivotGridField;
    edSearchMember: TcxTextEdit;
    cxLabel10: TcxLabel;
    edSearchUnit: TcxTextEdit;
    cxLabel16: TcxLabel;
    edSearchPosition: TcxTextEdit;
    cxLabel17: TcxLabel;
    Member_Search: TcxGridDBColumn;
    Position_Search: TcxGridDBColumn;
    Unit_Search: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SoldTable_Commerc_OlapForm);

end.
