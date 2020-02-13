unit Report_MotionOLAP;

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
  TReport_MotionOLAPForm = class(TParentForm)
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
    pvGroupsName3: TcxDBPivotGridField;
    pvGroupsName2: TcxDBPivotGridField;
    pvGroupsName1: TcxDBPivotGridField;
    pvGroupsName4: TcxDBPivotGridField;
    pvPeriodName_doc: TcxDBPivotGridField;
    pvPeriodYear_doc: TcxDBPivotGridField;
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
    pvCompositionName: TcxDBPivotGridField;
    pvGoodsInfoName: TcxDBPivotGridField;
    pvLineFabricaName: TcxDBPivotGridField;
    pvSale_Summ_curr: TcxDBPivotGridField;
    pvSale_Summ_10200_curr: TcxDBPivotGridField;
    pvIncome_Summ: TcxDBPivotGridField;
    pvReturn_Summ_curr: TcxDBPivotGridField;
    pvReturn_Summ_10200_curr: TcxDBPivotGridField;
    pvResult_Summ_curr: TcxDBPivotGridField;
    pvResult_SummCost_curr: TcxDBPivotGridField;
    pvResult_Summ_prof_curr: TcxDBPivotGridField;
    pvResult_Summ_10200_curr: TcxDBPivotGridField;
    pvSale_SummCost_curr: TcxDBPivotGridField;
    pvReturn_SummCost_curr: TcxDBPivotGridField;
    pvTax_Amount: TcxDBPivotGridField;
    pvTax_Summ_curr: TcxDBPivotGridField;
    pvTax_Summ_prof: TcxDBPivotGridField;
    pvRemains_Amount: TcxDBPivotGridField;
    pvRemains_Amount_real: TcxDBPivotGridField;
    pvRemains_Summ: TcxDBPivotGridField;
    pvSale_Amount_real: TcxDBPivotGridField;
    pvResult_Amount_real: TcxDBPivotGridField;
    pvLoss_Amount: TcxDBPivotGridField;
    pvTax_Amount_real: TcxDBPivotGridField;
    pvSendIn_Amount: TcxDBPivotGridField;
    pvSendOut_Amount: TcxDBPivotGridField;
    pvSendIn_Summ: TcxDBPivotGridField;
    pvSendOut_Summ: TcxDBPivotGridField;
    pvDebt_Summ: TcxDBPivotGridField;
    cbMark: TcxCheckBox;
    pvIncomeReal_Summ: TcxDBPivotGridField;
    pvLoss_Summ: TcxDBPivotGridField;
    pvIncomeReal_Amount: TcxDBPivotGridField;
    pvTax_Amount_calc: TcxDBPivotGridField;
    cfTax_Amount: TdsdPivotGridCalcFields;
    pvTax_Amount_calc1: TcxDBPivotGridField;
    pvTax_Amount_calc2: TcxDBPivotGridField;
    pvTax_Summ_prof_calc: TcxDBPivotGridField;
    pvTax_Summ_prof_calc1: TcxDBPivotGridField;
    pvTax_Summ_prof_calc2: TcxDBPivotGridField;
    cfTax_Summ_prof_calc: TdsdPivotGridCalcFields;
    pvTax_Amount_real_calc: TcxDBPivotGridField;
    pvTax_Amount_real_calc1: TcxDBPivotGridField;
    pvTax_Amount_real_calc2: TcxDBPivotGridField;
    pvTax_Summ_curr_calc: TcxDBPivotGridField;
    pvTax_Summ_curr_calc1: TcxDBPivotGridField;
    pvTax_Summ_curr_calc2: TcxDBPivotGridField;
    cfTax_Amount_real_calc: TdsdPivotGridCalcFields;
    cfTax_Summ_curr_calc: TdsdPivotGridCalcFields;
    cxLabel9: TcxLabel;
    edGoodsCode2: TcxCurrencyEdit;
    edGoodsCodeChoice: TcxButtonEdit;
    cxLabel10: TcxLabel;
    GuidesPartionGoods: TdsdGuides;
    RefreshDispatcher1: TRefreshDispatcher;
    spGet_ReportGoods_Params1: TdsdStoredProc;
    spGet_ReportGoods_Params: TdsdStoredProc;
    actRefreshCode: TdsdDataSetRefresh;
    actRefreshChoice: TdsdDataSetRefresh;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MotionOLAPForm);

end.
