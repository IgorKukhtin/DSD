unit Report_SaleOLAP;

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
  cxButtonEdit;

type
  TReport_SaleOLAPForm = class(TParentForm)
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
    pvLabelName: TcxDBPivotGridField;
    pvGoodsName: TcxDBPivotGridField;
    pvGoodsSizeName: TcxDBPivotGridField;
    pvPartnerName: TcxDBPivotGridField;
    pvSale_Summ_10100: TcxDBPivotGridField;
    pvSale_Summ_10201: TcxDBPivotGridField;
    pvSale_Amount: TcxDBPivotGridField;
    pvSale_Summ: TcxDBPivotGridField;
    pvSale_Summ_10202: TcxDBPivotGridField;
    pvSale_Summ_10203: TcxDBPivotGridField;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    pvBrandName: TcxDBPivotGridField;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PivotAddOn: TPivotAddOn;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    pvIncome_Amount: TcxDBPivotGridField;
    pvSale_SummCost: TcxDBPivotGridField;
    pvSale_Summ_10204: TcxDBPivotGridField;
    pvSale_Summ_10200: TcxDBPivotGridField;
    pvPeriodName: TcxDBPivotGridField;
    cxLabel4: TcxLabel;
    edPartner: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edBrand: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    GuidesBrand: TdsdGuides;
    cxLabel5: TcxLabel;
    edPeriod: TcxButtonEdit;
    GuidesPeriod: TdsdGuides;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    cbSize: TcxCheckBox;
    cbGoods: TcxCheckBox;
    pvCurrencyName: TcxDBPivotGridField;
    pvClientName: TcxDBPivotGridField;
    pvOperPrice: TcxDBPivotGridField;
    pvDebt_Amount: TcxDBPivotGridField;
    pvGroupsName1: TcxDBPivotGridField;
    pvGroupsName2: TcxDBPivotGridField;
    pvGroupsName3: TcxDBPivotGridField;
    pvGroupsName4: TcxDBPivotGridField;
    pvPeriodName_doc: TcxDBPivotGridField;
    pvPeriodYear_doc: TcxDBPivotGridField;
    pvMonthName_doc: TcxDBPivotGridField;
    pvDayName_doc: TcxDBPivotGridField;
    cxLabel7: TcxLabel;
    edUnit: TcxButtonEdit;
    cbOperPrice: TcxCheckBox;
    cbYear: TcxCheckBox;
    cbPeriodAll: TcxCheckBox;
    cbClient_doc: TcxCheckBox;
    cbOperDate_doc: TcxCheckBox;
    cbDay_doc: TcxCheckBox;
    dxBarStatic: TdxBarStatic;
    cbDiscount: TcxCheckBox;
    GuidesUnit: TdsdGuides;
    pvDiscountSaleKindName: TcxDBPivotGridField;
    pvChangePercent: TcxDBPivotGridField;
    pvSale_SummCost_diff: TcxDBPivotGridField;
    pvReturn_SummCost_diff: TcxDBPivotGridField;
    pvResult_SummCost_diff: TcxDBPivotGridField;
    pvSale_Summ_prof: TcxDBPivotGridField;
    pvReturn_Summ_prof: TcxDBPivotGridField;
    pvResult_Summ_prof: TcxDBPivotGridField;
    edStartYear: TcxButtonEdit;
    edEndYear: TcxButtonEdit;
    GuidesStartYear: TdsdGuides;
    GuidesEndYear: TdsdGuides;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SaleOLAPForm);

end.
