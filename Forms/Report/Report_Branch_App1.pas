unit Report_Branch_App1;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus;

type
  TReport_Branch_App1Form = class(TAncestorReportForm)
    PeresortWeight: TcxGridDBColumn;
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
    PeresortSumm: TcxGridDBColumn;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Branch_App1Form);

end.
