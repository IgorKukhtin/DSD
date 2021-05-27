unit Report_IlliquidReductionPlanList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorReport, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxDropDownEdit, cxCalendar,
  dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, cxCheckBox;

type
  TReport_IlliquidReductionPlanListForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    AmountStart: TcxGridDBColumn;
    AmountSale: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    edUserName: TcxTextEdit;
    edUserCode: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxGridDetals: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    D_AmountAll: TcxGridDBColumn;
    D_ProcSale: TcxGridDBColumn;
    D_Color_calc: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetalsDS: TDataSource;
    DetalsCDS: TClientDataSet;
    DBViewAddOnDetals: TdsdDBViewAddOn;
    D_AmountSale: TcxGridDBColumn;
    ceProcUnit: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceProcGoods: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    cePenalty: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    Price: TcxGridDBColumn;
    RemainsOut: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    Color_font: TcxGridDBColumn;
    D_AmountStart: TcxGridDBColumn;
    D_SummaPenaltyCount: TcxGridDBColumn;
    cbFilter3: TcxCheckBox;
    cbFilter2: TcxCheckBox;
    cbFilter1: TcxCheckBox;
    dsdFieldFilter: TdsdFieldFilter;
    Check_Filter: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    SummaSale: TcxGridDBColumn;
    cePlanAmount: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    D_SummaSale: TcxGridDBColumn;
    D_ProcSaleIlliquid: TcxGridDBColumn;
    D_SummaPenaltySum: TcxGridDBColumn;
    D_SummaPenalty: TcxGridDBColumn;
    D_UnitName: TcxGridDBColumn;
    cePenaltySum: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_IlliquidReductionPlanListForm);

end.
