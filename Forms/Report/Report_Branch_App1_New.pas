unit Report_Branch_App1_New;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox;

type
  TReport_Branch_App1_NewForm = class(TAncestorReportForm)
    PeresortInWeight: TcxGridDBColumn;
    SaleWeight: TcxGridDBColumn;
    Sale_40208_Summ: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    SendOnPriceOutSumm: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    ReturnInSumm: TcxGridDBColumn;
    SendOnPriceOutWeight: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    WeightStart: TcxGridDBColumn;
    WeightEnd: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    PeresortInSumm: TcxGridDBColumn;
    ReturnInWeight: TcxGridDBColumn;
    SaleSumm: TcxGridDBColumn;
    SendOnPriceInSumm: TcxGridDBColumn;
    SendOnPriceInWeight: TcxGridDBColumn;
    Sale_40208_Weight: TcxGridDBColumn;
    LossSumm: TcxGridDBColumn;
    LossWeight: TcxGridDBColumn;
    InventorySumm: TcxGridDBColumn;
    InventoryWeight: TcxGridDBColumn;
    SummInventory_RePrice: TcxGridDBColumn;
    Sale_10500_Summ: TcxGridDBColumn;
    Sale_10500_Weight: TcxGridDBColumn;
    SaleRealSumm: TcxGridDBColumn;
    Sale_10200_Summ: TcxGridDBColumn;
    Sale_10300_Summ: TcxGridDBColumn;
    ReturnInSumm_Vz: TcxGridDBColumn;
    PeresortInSumm_Vz: TcxGridDBColumn;
    PeresortOutSumm_Vz: TcxGridDBColumn;
    SendOnPriceOutSumm_Vz: TcxGridDBColumn;
    PeresortOutWeight_Vz: TcxGridDBColumn;
    SendOnPriceOutWeight_Vz: TcxGridDBColumn;
    PeresortInWeight_Vz: TcxGridDBColumn;
    ReturnInWeight_Vz: TcxGridDBColumn;
    ReturnInRealSumm_A: TcxGridDBColumn;
    ReturnInRealSumm_P: TcxGridDBColumn;
    SaleRealSumm_A: TcxGridDBColumn;
    SaleRealSumm_P: TcxGridDBColumn;
    SaleSumm_Vz: TcxGridDBColumn;
    SaleWeight_Vz: TcxGridDBColumn;
    sbIsUnit: TcxCheckBox;
    UnitName: TcxGridDBColumn;
    actRefreshUnit: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Branch_App1_NewForm);

end.
