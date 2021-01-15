unit Report_Check_QuantityComparison;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit, cxGridBandedTableView, cxGridDBBandedTableView;

type
  TReport_Check_QuantityComparisonForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actGet_MovementFormClass: TdsdExecStoredProc;
    mactOpenDocument: TMultiAction;
    actOpenDocument: TdsdOpenForm;
    MovementProtocolOpenForm: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    edRetail: TcxButtonEdit;
    cxLabel3: TcxLabel;
    RetailGuides: TdsdGuides;
    ceUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    UnitGuides: TdsdGuides;
    HeaderCDS: TClientDataSet;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    UnitName: TcxGridDBBandedColumn;
    Count: TcxGridDBBandedColumn;
    CountPrev: TcxGridDBBandedColumn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    CrossDBViewAddOnPrev: TCrossDBViewAddOn;
    AverageCheck: TcxGridDBBandedColumn;
    CountCash: TcxGridDBBandedColumn;
    CountCashLess: TcxGridDBBandedColumn;
    AverageCheckPrev: TcxGridDBBandedColumn;
    CountCashPrev: TcxGridDBBandedColumn;
    CountCashLessPrev: TcxGridDBBandedColumn;
    CrossDBViewAddOn1: TCrossDBViewAddOn;
    CrossDBViewAddOn2: TCrossDBViewAddOn;
    CrossDBViewAddOn3: TCrossDBViewAddOn;
    CrossDBViewAddOn4: TCrossDBViewAddOn;
    CrossDBViewAddOn5: TCrossDBViewAddOn;
    CrossDBViewAddOn6: TCrossDBViewAddOn;
    ceYearsAgo: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_Check_QuantityComparisonForm);

end.
