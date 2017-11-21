unit EDIOrdersLoader.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dsdDB, EDI, Vcl.ActnList,
  dsdAction;

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
    procedure TrayIconClick(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure AddToLog(S: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.AddToLog(S: string);
begin
  LogMemo.Lines.Add(FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S);
end;

procedure TMainForm.AppMinimize(Sender: TObject);
begin
  TrayIcon.Visible := True;
  ShowWindow(Handle, SW_HIDE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IntervalStr: string;
  IntervalVal: Integer;
begin
  Application.OnMinimize := AppMinimize;
  Timer.Enabled := False;

  if FindCmdLineSwitch('interval', IntervalStr) then
    IntervalVal := StrToIntDef(IntervalStr, 0)
  else
    IntervalVal := 0;

  if IntervalVal > 0 then
  begin
    Timer.Interval := IntervalVal * 60 * 1000;
    Timer.Enabled := True;
  end;

  OptionsMemo.Lines.Text := 'Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.';
  LogMemo.Clear;
  AddToLog('Запуск');
  actSetDefaults.Execute;
  AddToLog('Считали начальные установки по EDI');
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
  TrayIcon.Visible := False;
end;

end.
