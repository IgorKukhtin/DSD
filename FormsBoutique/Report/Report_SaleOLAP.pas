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
    dsdStoredProc: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBPivotGrid: TcxDBPivotGrid;
    pvLabelName: TcxDBPivotGridField;
    pvGoodsName: TcxDBPivotGridField;
    pvGoodsInfoName: TcxDBPivotGridField;
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
    spGetBalanceParam: TdsdStoredProc;
    FormParams: TdsdFormParams;
    dsdOpenForm1: TdsdOpenForm;
    MultiAction1: TMultiAction;
    dsdExecStoredProc1: TdsdExecStoredProc;
    bbStaticText: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    pvIncome_Amount: TcxDBPivotGridField;
    pvSale_SummCost: TcxDBPivotGridField;
    pvSale_Summ_10204: TcxDBPivotGridField;
    pvSale_Summ_10200: TcxDBPivotGridField;
    pvPeriodName: TcxDBPivotGridField;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    cbTotal: TcxCheckBox;
    bb: TdxBarControlContainerItem;
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
    edPeriodYearStart: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    edPeriodYearEnd: TcxCurrencyEdit;
    cbSize: TcxCheckBox;
    cbGoods: TcxCheckBox;
    pvCurrencyName: TcxDBPivotGridField;
    pvClientName: TcxDBPivotGridField;
    pvOperDate: TcxDBPivotGridField;
    pvOperPrice: TcxDBPivotGridField;
    pvDebt_Amount: TcxDBPivotGridField;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SaleOLAPForm);

end.
