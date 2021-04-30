unit Report_IlliquidReductionPlanUser;

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
  TReport_IlliquidReductionPlanUserForm = class(TAncestorReportForm)
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
    DetalsDS: TDataSource;
    DetalsCDS: TClientDataSet;
    ceProcUnit: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceProcGoods: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edFilter: TcxTextEdit;
    cxLabel3: TcxLabel;
    dsdFieldFilter: TdsdFieldFilter;
    Price: TcxGridDBColumn;
    RemainsOut: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    Color_font: TcxGridDBColumn;
    cbFilter3: TcxCheckBox;
    cbFilter2: TcxCheckBox;
    cbFilter1: TcxCheckBox;
    Check_Filter: TcxGridDBColumn;
    spGet: TdsdStoredProc;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    Summa: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    cxGridDetals: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    D_AmountAll: TcxGridDBColumn;
    D_AmountStart: TcxGridDBColumn;
    D_AmountSale: TcxGridDBColumn;
    D_ProcSale: TcxGridDBColumn;
    D_Color_calc: TcxGridDBColumn;
    D_SummaPenaltyCount: TcxGridDBColumn;
    D_SummaSale: TcxGridDBColumn;
    D_ProcSaleIlliquid: TcxGridDBColumn;
    D_SummaPenaltySum: TcxGridDBColumn;
    D_SummaPenalty: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    SummaSale: TcxGridDBColumn;
    cePenalty: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cePlanAmount: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_IlliquidReductionPlanUserForm);

end.
