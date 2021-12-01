unit Report_TestingAttemptsUser;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxDBEdit;

type
  TReport_TestingAttemptsUserForm = class(TAncestorReportForm)
    Code: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Result: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    DateTimeTest: TcxGridDBColumn;
    Attempts: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    PositionName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    ceAttempts1: TcxDBCurrencyEdit;
    ceAttempts2: TcxDBCurrencyEdit;
    ceCount2: TcxDBCurrencyEdit;
    ceCount1: TcxDBCurrencyEdit;
    ceAverAttempts2: TcxDBCurrencyEdit;
    ceAverAttempts1: TcxDBCurrencyEdit;
    cxLabel6: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_TestingAttemptsUserForm);

end.
