unit Report_ZReportLog;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter;

type
  TReport_ZReportLogForm = class(TAncestorReportForm)
    UnitCode: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    SummaCash: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    SummaTotal: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    SummaCard: TcxGridDBColumn;
    bbUpdateDateCompensation: TdxBarButton;
    dxBarButton1: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chDateZReport: TcxGridDBColumn;
    chZReport: TcxGridDBColumn;
    chFiscalNumber: TcxGridDBColumn;
    chSummaCard: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spJackdawsCheck: TdsdStoredProc;
    ZReportDS: TDataSource;
    ZReportCDS: TClientDataSet;
    dxBarButton2: TdxBarButton;
    DBViewAddOnCh: TdsdDBViewAddOn;
    chSummaCash: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    ColorRA_calc: TcxGridDBColumn;
    chSummaTotal: TcxGridDBColumn;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ZReportLogForm);

end.
