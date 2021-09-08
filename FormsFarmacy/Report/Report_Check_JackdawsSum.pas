unit Report_Check_JackdawsSum;

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
  TReport_Check_JackdawsSumForm = class(TAncestorReportForm)
    UnitCode: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    SummaRRO: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    SummaReturnIn: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    SummaJackdaws2: TcxGridDBColumn;
    SummaChech: TcxGridDBColumn;
    bbUpdateDateCompensation: TdxBarButton;
    dxBarButton1: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chOperDate: TcxGridDBColumn;
    chInvNumber: TcxGridDBColumn;
    chJackdawsChecksName: TcxGridDBColumn;
    chTotalSumm: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spJackdawsCheck: TdsdStoredProc;
    JackdawsCheckDS: TDataSource;
    JackdawsCheckCDS: TClientDataSet;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton2: TdxBarButton;
    DBViewAddOnCh: TdsdDBViewAddOn;
    chisRetrievedAccounting: TcxGridDBColumn;
    RetrievedAccounting: TcxGridDBColumn;
    spUpdate_RetrievedAccounting: TdsdStoredProc;
    actUpdate_RetrievedAccounting: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    ColorRA_calc: TcxGridDBColumn;
    chSummaReceivedFact: TcxGridDBColumn;
    SummaReceived: TcxGridDBColumn;
    SummaReceivedDelta: TcxGridDBColumn;
    spUpdate_SummaReceivedFact: TdsdStoredProc;
    actSummaDialogForm: TExecuteDialog;
    actUpdate_SummaReceivedFact: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    SummaOther: TcxGridDBColumn;
    actUpdateJackdawsCheckCDS: TdsdUpdateDataSet;
    spUpdate_RetrievedAccountingCDC: TdsdStoredProc;
    actSummaReceivedToJson: TdsdDataToJsonAction;
    CommentChecking: TcxGridDBColumn;
    actInputCommentChecking: TExecuteDialog;
    actUpdate_CommentChecking: TdsdExecStoredProc;
    spUpdate_CommentChecking: TdsdStoredProc;
    bbUpdate_CommentChecking: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Check_JackdawsSumForm);

end.
