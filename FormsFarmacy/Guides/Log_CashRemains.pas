unit Log_CashRemains;

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
  TLog_CashRemainsForm = class(TAncestorReportForm)
    CashSessionId: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    UserName: TcxGridDBColumn;
    DoubleCDS: TClientDataSet;
    DoubleDS: TDataSource;
    cxGridDouble: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    DoubleCashSessionId: TcxGridDBColumn;
    DoubleUnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    TimeLogIn: TcxGridDBColumn;
    OldProgram: TcxGridDBColumn;
    OldServise: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    dsdOpenForm1: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    TimeLogOut: TcxGridDBColumn;
    TimeZReport: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    IP: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLog_CashRemainsForm);

end.
