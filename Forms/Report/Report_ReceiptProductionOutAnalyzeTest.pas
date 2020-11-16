unit Report_ReceiptProductionOutAnalyzeTest;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, Vcl.Grids, Vcl.DBGrids, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox;

type
  TReport_ReceiptProductionOutAnalyzeTestForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edFromUnit: TcxButtonEdit;
    FromUnitGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edToUnit: TcxButtonEdit;
    ToUnitGuides: TdsdGuides;
    GoodsGroupNameFull_ch: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    edPriceList_1: TcxButtonEdit;
    PriceList_1_Guides: TdsdGuides;
    cxLabel6: TcxLabel;
    edPriceList_2: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edPriceList_3: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edPriceList_sale: TcxButtonEdit;
    PriceList_2_Guides: TdsdGuides;
    PriceList_3_Guides: TdsdGuides;
    PriceList_sale_Guides: TdsdGuides;
    cxGridLevel1: TcxGridLevel;
    ChildView: TcxGridDBTableView;
    GoodsId_ch: TcxGridDBColumn;
    OperCount: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PricePlan1: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildViewAddOn: TdsdDBViewAddOn;
    PricePlan2: TcxGridDBColumn;
    PricePlan3: TcxGridDBColumn;
    OperSummPlan1: TcxGridDBColumn;
    OperSummPlan2: TcxGridDBColumn;
    OperSummPlan3: TcxGridDBColumn;
    OperCountIn_ch: TcxGridDBColumn;
    OperCountIn_Weight_ch: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GoodsKindId: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    OperSumm: TcxGridDBColumn;
    OperCountPlan: TcxGridDBColumn;
    OperCountPlan_Weight: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    OperCount_Weight: TcxGridDBColumn;
    OperSummIn_ch: TcxGridDBColumn;
    PriceIn_ch: TcxGridDBColumn;
    OperSummPlan1_real: TcxGridDBColumn;
    OperSummPlan2_real: TcxGridDBColumn;
    OperSummPlan3_real: TcxGridDBColumn;
    GoodsKindId_ch: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    MasterKey: TcxGridDBColumn;
    MasterKey_ch: TcxGridDBColumn;
    PartionGoodsDate_ch: TcxGridDBColumn;
    GoodsKindName_complete_ch: TcxGridDBColumn;
    TaxSumm_ch: TcxGridDBColumn;
    TaxSumm_min: TcxGridDBColumn;
    TaxSumm_max: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    actPrint_Reserve: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrint_Reserve: TdxBarButton;
    OperSummPlan_real: TcxGridDBColumn;
    OperSummPlan_real_ch: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    cbPartionGoods: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    CuterCount: TcxGridDBColumn;
    OperCount_gp_real: TcxGridDBColumn;
    TaxGP_real: TcxGridDBColumn;
    TaxGP_plan: TcxGridDBColumn;
    OperCount_gp_plan: TcxGridDBColumn;
    actPrint_TaxReal: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    Price_sale: TcxGridDBColumn;
    OperCount_ReWork: TcxGridDBColumn;
    LossGP_real: TcxGridDBColumn;
    LossGP_plan: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint_fact: TdsdPrintAction;
    bbPrint_fact: TdxBarButton;
    OperSummPlan_real_two: TcxGridDBColumn;
    OperCountPlan_two: TcxGridDBColumn;
    OperCountPlan_Weight_two: TcxGridDBColumn;
    OperSummPlan1_two: TcxGridDBColumn;
    OperSummPlan2_two: TcxGridDBColumn;
    OperSummPlan3_two: TcxGridDBColumn;
    LossGP_plan_two: TcxGridDBColumn;
    OperSummPlan_real_two_ch: TcxGridDBColumn;
    OperCountPlan_two_ch: TcxGridDBColumn;
    OperCountPlan_Weight_two_ch: TcxGridDBColumn;
    OperSummPlan1_two_ch: TcxGridDBColumn;
    OperSummPlan2_two_ch: TcxGridDBColumn;
    OperSummPlan3_two_ch: TcxGridDBColumn;
    actPrint_two: TdsdPrintAction;
    bbPrint_two: TdxBarButton;
    actPrint_fact_two: TdsdPrintAction;
    bbPrint_fact_two: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ReceiptProductionOutAnalyzeTestForm)


end.
