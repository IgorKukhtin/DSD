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
    cbPrevDay: TCheckBox;
    spGetStatMovementEDI: TdsdStoredProc;
    actGet_Movement_Edi_stat: TdsdExecStoredProc;
    procedure TrayIconClick(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actStartEDIExecute(Sender: TObject);
    procedure actStartEDIUpdate(Sender: TObject);
    procedure actStopEDIExecute(Sender: TObject);
    procedure actStopEDIUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FIntervalVal: Integer;
    FProccessing: Boolean;
    isPrevDay_begin: Boolean;
    procedure AddToLog(S: string);
    procedure StartEDI;
    procedure StopEDI;
    procedure ProccessEDI;
    function fGet_Movement_Edi_stat : Integer;
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
  Application.ProcessMessages;
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
  Application.ProcessMessages;
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

  isPrevDay_begin:= False;

  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1;

  if IntervalVal > 0 then
    Timer.Interval := IntervalVal * 60 * 1000;

  if cbPrevDay.Checked = TRUE
  then deStart.EditValue := Date - 1
  else deStart.EditValue := Date;

  deEnd.EditValue := Date ;
  deStart.Enabled := False;
  deEnd.Enabled := False;
  OptionsMemo.Lines.Text := 'Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.';
  LogMemo.Clear;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
      ActiveControl:= cbPrevDay;
      if not Timer.Enabled then MainForm.StartEDI;
end;

function TMainForm.fGet_Movement_Edi_stat : Integer;
begin
     actGet_Movement_Edi_stat.Execute;
     Result:= spGetStatMovementEDI.ParamByName('gpGet_Movement_Edi_stat').Value;
end;

procedure TMainForm.ProccessEDI;
var Old_stat : Integer;
    Present: TDateTime;
    Hour, Min, Sec, MSec: Word;
    IntervalStr: string;
begin
  ActiveControl:= cbPrevDay;

  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  if Proccessing then
    Exit;

  Timer.Enabled:=False;
  Proccessing := True;

  if (Hour>=0) and (Hour<7) then
  begin
       AddToLog('..... Нет Загрузки .....');
       Proccessing := False;
       Timer.Enabled:=True;
       isPrevDay_begin := false;
       exit;
  end;

  if isPrevDay_begin = false then cbPrevDay.Checked:= true;

  try
    AddToLog('.....');
    actSetDefaults.Execute;
    AddToLog('Обновили Default для EDI');

    OptionsMemo.Lines.Clear;
    OptionsMemo.Lines.Add('Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.');
    OptionsMemo.Lines.Add('Host: ' +  FormParams.ParamByName('Host').AsString);
    OptionsMemo.Lines.Add('UserName: ' +  FormParams.ParamByName('UserName').AsString);
    OptionsMemo.Lines.Add('Password: ' +  FormParams.ParamByName('Password').AsString);

    if cbPrevDay.Checked = TRUE
    then deStart.EditValue := Date - 1
    else deStart.EditValue := Date;
    deEnd.EditValue := Date;

    Old_stat:=fGet_Movement_Edi_stat;
    AddToLog('Загрузка EDI началась ... <'+IntToStr(Old_stat)+'>');

    AddToLog(' - Период с ' + deStart.EditText + ' по ' + deEnd.EditText);

    EDIActionOrdersLoad.Execute;
    AddToLog('Загружено <'+IntToStr(fGet_Movement_Edi_stat - Old_stat)+'> Документов');

    AddToLog('Finish');

    if cbPrevDay.Checked = true then begin cbPrevDay.Checked:= false; isPrevDay_begin:= true; end;

  except
    on E: Exception do
      AddToLog(E.Message);
  end;

  Proccessing := False;
  //
  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1;

  if Hour > 18 then
  begin
    Timer.Interval := (IntervalVal * 3)  * 60 * 1000;
    AddToLog('Текущий интервал изменен до : ' + IntToStr(IntervalVal * 3) + ' мин.');
  end
  else
    Timer.Interval := (IntervalVal * 1)  * 60 * 1000;

  Timer.Enabled:=True;

end;

procedure TMainForm.StartEDI;
begin
  AddToLog('Запуск ...');

  if IntervalVal > 0 then
    ProccessEDI
    // Timer.Enabled := True
  else
    AddToLog('Запуск отменен, т.к. не определен интервал');
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
