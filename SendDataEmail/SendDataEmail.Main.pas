unit SendDataEmail.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dsdDB, EDI, Vcl.ActnList,
  dsdAction, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, cxButtons,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, System.IniFiles,
  Data.DB, Datasnap.DBClient, cxStyles, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxDBData, dsdInternetAction, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid;

type
  TMainForm = class(TForm)
    TrayIcon: TTrayIcon;
    Timer: TTimer;
    LogMemo: TMemo;
    FormParams: TdsdFormParams;
    ActionList: TActionList;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    StartButton: TcxButton;
    StopButton: TcxButton;
    actStartEmail: TAction;
    actStopEmail: TAction;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    spGet_Export_FileName: TdsdStoredProc;
    spSelect_Export: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    mactExport: TMultiAction;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    spGet_Export_Email: TdsdStoredProc;
    actGet_Export_Email: TdsdExecStoredProc;
    actSMTPFile: TdsdSMTPFileAction;
    OptionsMemo: TMemo;
    procedure TrayIconClick(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actStartEmailExecute(Sender: TObject);
    procedure actStartEmailUpdate(Sender: TObject);
    procedure actStopEmailExecute(Sender: TObject);
    procedure actStopEmailUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FIntervalVal: Integer;
    FProccessing: Boolean;
    procedure AddToLog(S: string);
    procedure ProccessEmail;
    procedure StartEmail;
    procedure StopEmail;
  public
    { Public declarations }
    property IntervalVal: Integer read FIntervalVal;
    property Proccessing: Boolean read FProccessing write FProccessing;
  end;

var
  MainForm: TMainForm;

implementation
{$R *.dfm}
//-------------------------------------------------------------------------------------------
procedure TMainForm.actStartEmailExecute(Sender: TObject);
begin
  StartEmail;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.actStartEmailUpdate(Sender: TObject);
begin
//  actStartEDI.Enabled := not Timer.Enabled;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.actStopEmailExecute(Sender: TObject);
begin
  StopEmail;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.actStopEmailUpdate(Sender: TObject);
begin
//  actStopEDI.Enabled := Timer.Enabled;
end;
//-------------------------------------------------------------------------------------------
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
//-------------------------------------------------------------------------------------------
procedure TMainForm.AppMinimize(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopEmail;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  IntervalStr: string;
begin
  Application.OnMinimize := AppMinimize;
  Timer.Enabled := False;
  Proccessing := False;

  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1000;

  if IntervalVal > 0 then
    Timer.Interval := IntervalVal * 60 * 1000
  else
    Timer.Interval := 1 * 1 * 1000;
  //
  OptionsMemo.Lines.Text := 'Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.';
  LogMemo.Clear;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not Timer.Enabled then MainForm.StartEmail;
end;


procedure TMainForm.StartEmail;
begin
  AddToLog('Запуск ...');

  if IntervalVal > 0 then
  begin
    StartButton.Enabled:= FALSE;
    StopButton.Enabled := TRUE;
    //
    ProccessEmail;
    // Timer.Enabled := True;
  end
  else
    AddToLog('Запуск не выполнен, т.к. не определен интервал');
end;

procedure TMainForm.StopEmail;
begin
  if Timer.Enabled then
  begin
    while Proccessing do
      Application.ProcessMessages;

    Timer.Enabled := False;
    AddToLog('Остановка');
    //
    StartButton.Enabled:= TRUE;
    StopButton.Enabled := FALSE;
  end;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
  ProccessEmail;
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  ShowWindow(Handle, SW_RESTORE);
  SetForegroundWindow(Handle);
end;
//-------------------------------------------------------------------------------------------
procedure TMainForm.ProccessEmail;
var Present: TDateTime;
    Hour, Min, Sec, MSec: Word;
    IntervalStr: string;
begin
  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  if Proccessing then
    Exit;

  Proccessing := True;
  Timer.Enabled:=False;

  //
  // !!! Только Отправка !!!
  try mactExport.Execute;
      AddToLog('Sending Email: file <' + FormParams.ParamByName('inFileName').AsString + '>'
              +'  on: ' + ExportEmailCDS.FieldByName('AddressFrom').AsString
              + ' => '  + ExportEmailCDS.FieldByName('AddressTo').AsString
              );
  except
        on E: Exception do begin
          AddToLog(' error : ' + E.Message);
          AddToLog('not Sending Email: file <' + FormParams.ParamByName('inFileName').AsString + '>'
                  +'  on: ' + ExportEmailCDS.FieldByName('AddressFrom').AsString
                  + ' => '  + ExportEmailCDS.FieldByName('AddressTo').AsString
                   );
        end;
  end;
  //
  //
  Proccessing := False;
  Timer.Enabled:=True;

end;
//-------------------------------------------------------------------------------------------
end.
