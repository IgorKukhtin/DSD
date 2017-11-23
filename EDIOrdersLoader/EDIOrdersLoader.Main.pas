unit EDIOrdersLoader.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dsdDB, EDI, Vcl.ActnList,
  dsdAction, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, cxButtons,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, System.IniFiles;

type
  TMainForm = class(TForm)
    TrayIcon: TTrayIcon;
    Timer: TTimer;
    UsageMemo: TMemo;
    OptionsMemo: TMemo;
    LogMemo: TMemo;
    FormParams: TdsdFormParams;
    spGetDefaultEDI: TdsdStoredProc;
    EDI: TEDI;
    ActionList: TActionList;
    actSetDefaults: TdsdExecStoredProc;
    spHeaderOrder: TdsdStoredProc;
    spListOrder: TdsdStoredProc;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    StartButton: TcxButton;
    StopButton: TcxButton;
    actStartEDI: TAction;
    actStopEDI: TAction;
    EDIActionOrdersLoad: TEDIAction;
    procedure TrayIconClick(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actStartEDIExecute(Sender: TObject);
    procedure actStartEDIUpdate(Sender: TObject);
    procedure actStopEDIExecute(Sender: TObject);
    procedure actStopEDIUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FIntervalVal: Integer;
    FProccessing: Boolean;
    procedure AddToLog(S: string);
    procedure StartEDI;
    procedure StopEDI;
    procedure ProccessEDI;
  public
    { Public declarations }
    property IntervalVal: Integer read FIntervalVal;
    property Proccessing: Boolean read FProccessing write FProccessing;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.actStartEDIExecute(Sender: TObject);
begin
  StartEDI;
end;

procedure TMainForm.actStartEDIUpdate(Sender: TObject);
begin
  actStartEDI.Enabled := not Timer.Enabled;
end;

procedure TMainForm.actStopEDIExecute(Sender: TObject);
begin
  StopEDI;
end;

procedure TMainForm.actStopEDIUpdate(Sender: TObject);
begin
  actStopEDI.Enabled := Timer.Enabled;
end;

procedure TMainForm.AddToLog(S: string);
var
  LogStr: string;
  LogFileName: string;
  LogFile: TextFile;
begin
  LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  LogMemo.Lines.Add(LogStr);
  LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyymmdd', Date) + '.log';

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, LogStr);
  CloseFile(LogFile);
end;

procedure TMainForm.AppMinimize(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopEDI;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IntervalStr: string;
begin
  Application.OnMinimize := AppMinimize;
  Timer.Enabled := False;
  Proccessing := False;

  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 0)
  else
    FIntervalVal := 0;

  if IntervalVal > 0 then
    Timer.Interval := IntervalVal * 60 * 1000;

  deStart.EditValue := Date - 1;
  deEnd.EditValue := Date - 1;
  deStart.Enabled := False;
  deEnd.Enabled := False;
  OptionsMemo.Lines.Text := 'Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.';
  LogMemo.Clear;
end;

procedure TMainForm.ProccessEDI;
begin
  if Proccessing then
    Exit;

  Proccessing := True;

  try
    actSetDefaults.Execute;
    AddToLog('Считали начальные установки по EDI');
    AddToLog('Загрузка и обработка EDI начата ...');
    deStart.EditValue := Date - 1;
    deEnd.EditValue := Date - 1;
    AddToLog(' - начальная дата: ' + deStart.EditText);
    AddToLog(' - конечная  дата: ' + deEnd.EditText);
    EDIActionOrdersLoad.Execute;
    AddToLog('Загрузка и обработка EDI закончена');
  except
    on E: Exception do
      AddToLog(E.Message);
  end;

  Proccessing := False;
end;

procedure TMainForm.StartEDI;
begin
  AddToLog('Запуск');

  if IntervalVal > 0 then
    Timer.Enabled := True
  else
    AddToLog('Запуск отменен, т.к. не задан интервал');
end;

procedure TMainForm.StopEDI;
begin
  if Timer.Enabled then
  begin
    while Proccessing do
      Application.ProcessMessages;

    Timer.Enabled := False;
    AddToLog('Остановка');
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  ProccessEDI;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  ShowWindow(Handle, SW_RESTORE);
  SetForegroundWindow(Handle);
end;

end.
