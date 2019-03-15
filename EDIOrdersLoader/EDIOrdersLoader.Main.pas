unit EDIOrdersLoader.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dsdDB, EDI, Vcl.ActnList,
  dsdAction, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, cxButtons,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, System.IniFiles,
  Data.DB, Datasnap.DBClient;

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
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectSale_EDI: TdsdStoredProc;
    spUpdateEdiOrdspr: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    actExecPrintStoredProc: TdsdExecStoredProc;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    Send_toEDICDS: TClientDataSet;
    spSelectSend_toEDI: TdsdStoredProc;
    spUpdate_EDI_Send: TdsdStoredProc;
    actUpdate_EDI_Send: TdsdExecStoredProc;
    cbLoad: TCheckBox;
    cbSend: TCheckBox;
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
    Hour_onDel: Integer;
    fStartTime: TDateTime;
    procedure AddToLog(S: string);
    procedure StartEDI;
    procedure StopEDI;
    procedure ProccessEDI;
    function fGet_Movement_Edi_stat : Integer;
    function fEdi_LoadData_from : Boolean;
    function fEdi_SendData_to : Boolean;
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
//  actStartEDI.Enabled := not Timer.Enabled;
end;

procedure TMainForm.actStopEDIExecute(Sender: TObject);
begin
  StopEDI;
end;

procedure TMainForm.actStopEDIUpdate(Sender: TObject);
begin
//  actStopEDI.Enabled := Timer.Enabled;
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
  Hour_onDel := -1;

  cbLoad.Checked:= TRUE;
  cbSend.Checked:= TRUE;

  // ��� ������� ������� ��� ���� ���� �� ����, �.�. �� ��� ���������
  isPrevDay_begin:= True;

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
  fStartTime:= Now;
  OptionsMemo.Lines.Text := '������� ��������: ' + IntToStr(IntervalVal) + ' ���.';
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

function TMainForm.fEdi_LoadData_from : Boolean;
var Old_stat : Integer;
    Present: TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    lHoursInterval_del : Integer;
begin
  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  if isPrevDay_begin = false then cbPrevDay.Checked:= true;

  try
    Result:= false;
    //
    AddToLog('.....');
    actSetDefaults.Execute;
    AddToLog('�������� Default ��� EDI : ' + DateTimeToStr(now));

    // �������� - �������� �����
    lHoursInterval_del:= FormParams.ParamByName('HoursInterval_del').Value;

    // ���� ������ ����� � �� "�������" Hour ��� �� ���� ��������
    if ((Hour mod lHoursInterval_del) = 0)
    and (Hour_onDel <> Hour)
    and (spGetDefaultEDI.ParamByName('gIsDelete').Value = TRUE)
    then begin
              //�������������� ������� - "�������� �� ���" - ����� ������ ������ � ����� :)
              FormParams.ParamByName('gIsDelete').Value := TRUE;
              //��������� ������� Hour ���� ������� ��������
              Hour_onDel:= Hour;
         end
    // ��������� ��� �� ���� �������
    else FormParams.ParamByName('gIsDelete').Value := FALSE;

    //
    OptionsMemo.Lines.Clear;
    OptionsMemo.Lines.Add('�����: '+FormatDateTime('dd.mm.yy hh:mm', fStartTime));
    if FormParams.ParamByName('gIsDelete').Value = TRUE
    then OptionsMemo.Lines.Add('������� ��������: ' + IntToStr(IntervalVal) + ' : del = TRUE')
    else OptionsMemo.Lines.Add('������� ��������: ' + IntToStr(IntervalVal) + ' : del = FALSE');
    OptionsMemo.Lines.Add('Host: ' +  FormParams.ParamByName('Host').AsString);
    OptionsMemo.Lines.Add('UserName: ' +  FormParams.ParamByName('UserName').AsString);
    OptionsMemo.Lines.Add('Password: ' +  FormParams.ParamByName('Password').AsString);

     if cbLoad.Checked = FALSE then
     begin
          AddToLog('.....');
          AddToLog('��������� �������� �� EDI');
          Result:= true;
          exit
     end;

    if cbPrevDay.Checked = TRUE
    then deStart.EditValue := Date - 1
    else deStart.EditValue := Date;
    deEnd.EditValue := Date;

    Old_stat:=fGet_Movement_Edi_stat;
    AddToLog('�������� EDI �������� ... <'+IntToStr(Old_stat)+'>');

    if FormParams.ParamByName('gIsDelete').Value = TRUE
    then AddToLog(' - ������ � ' + deStart.EditText + ' �� ' + deEnd.EditText + ' : del = TRUE')
    else AddToLog(' - ������ � ' + deStart.EditText + ' �� ' + deEnd.EditText + ' : del = FALSE');

    EDIActionOrdersLoad.Execute;
    AddToLog('��������� <'+IntToStr(fGet_Movement_Edi_stat - Old_stat)+'> ����������');

    AddToLog('Finish');

    if cbPrevDay.Checked = true then begin cbPrevDay.Checked:= false; isPrevDay_begin:= true; end;

    //
    Result:= TRUE;

  except
     on E: Exception do
        AddToLog(E.Message);
  end;
end;

function TMainForm.fEdi_SendData_to : Boolean;
var Err_str: String;
    i : Integer;
begin
     if cbSend.Checked = FALSE then
     begin
          AddToLog('.....');
          AddToLog('��������� �������� � EDI');
          Result:= true;
          exit
     end;

     Result:= false;

     spSelectSend_toEDI.Execute;
     Send_toEDICDS.First;
     if Send_toEDICDS.RecordCount = 0 then
     begin
          AddToLog('.....');
          AddToLog('��� �������� � EDI <' + IntToStr(Send_toEDICDS.RecordCount) + '>');

          Result:= true;
          exit
     end;

     AddToLog('.....');
     AddToLog('�������� �������� � EDI : <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
     i:= 1;

     with Send_toEDICDS do
     while not EOF do
     begin
          Application.ProcessMessages;
          FormParams.ParamByName('MovementId_toEDI').Value   := FieldByName('Id').AsInteger;
          FormParams.ParamByName('MovementId_sendEDI').Value := FieldByName('MovementId').AsInteger;
          Application.ProcessMessages;
          // ����������� ���������
          try
              if FieldByName('isEdiOrdspr').AsBoolean  = true then mactOrdspr.Execute;
              if FieldByName('isEdiInvoice').AsBoolean = true then mactInvoice.Execute;
              if FieldByName('isEdiDesadv').AsBoolean  = true then mactDesadv.Execute;
              FormParams.ParamByName('Err_str_toEDI').Value := '';
              //
              Application.ProcessMessages;
              // ��������� ��� �������� ������
              AddToLog('����������� ��� ������ � : <' + IntToStr(i) + '>');
              actUpdate_EDI_Send.Execute;
          except
              FormParams.ParamByName('Err_str_toEDI').Value := '������ ��� ��������';
              if FieldByName('isEdiOrdspr').AsBoolean  = true then AddToLog('isEdiOrdspr  =  <true>');
              if FieldByName('isEdiInvoice').AsBoolean = true then AddToLog('isEdiInvoice =  <true>');
              if FieldByName('isEdiDesadv').AsBoolean  = true then AddToLog('isEdiDesadv  =  <true>');
              AddToLog('������ ��� �������� � : <' + IntToStr(i) + '> <' + FieldByName('Id').AsString + '>');
              //
              Application.ProcessMessages;
              // ��������� ��� ������
              actUpdate_EDI_Send.Execute;
          end;
          //
          AddToLog('��������� � : <' + IntToStr(i) + '> �� <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
          //
          Next;
          i:= i+1;
     end;

     AddToLog('����������� �������� � EDI : <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
     AddToLog('.....');

end;

procedure TMainForm.ProccessEDI;
var Present: TDateTime;
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

  if ((Hour>=0) and (Hour<7)) or (Hour>=23)
  then
  begin
       // !!! ������ �������� !!!
       fEdi_SendData_to;
       //
       //
       AddToLog('..... ��� �������� .....');
       Proccessing := False;
       Timer.Enabled:=True;
       isPrevDay_begin := false;
       exit;
  end;

  //
  // !!! ������ �������� !!!
  try fEdi_LoadData_from;
  except
        AddToLog('**** ������ *** LoadData - from ***');
  end;
  //
  // !!! ������ �������� !!!
  try fEdi_SendData_to;
  except
        AddToLog('**** ������ *** SendData - to ***');
  end;
  //
  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1;

  if Hour > 18 then
  begin
    //Timer.Interval := (IntervalVal * 15)  * 60 * 1000;
    //AddToLog('������� �������� ������� �� : ' + IntToStr(IntervalVal * 15) + ' ���.');
    Timer.Interval := 30  * 60 * 1000;
    AddToLog('������� �������� ������� �� : ' + IntToStr(30) + ' ���.');
  end
  else
    Timer.Interval := (IntervalVal * 1)  * 60 * 1000;

  Proccessing := False;
  Timer.Enabled:=True;

end;

procedure TMainForm.StartEDI;
begin
  AddToLog('������ ...');

  if IntervalVal > 0 then
  begin
    StartButton.Enabled:= FALSE;
    StopButton.Enabled := TRUE;
    //
    ProccessEDI;
    // Timer.Enabled := True;
  end
  else
    AddToLog('������ �� ��������, �.�. �� ��������� ��������');
end;

procedure TMainForm.StopEDI;
begin
  if Timer.Enabled then
  begin
    while Proccessing do
      Application.ProcessMessages;

    Timer.Enabled := False;
    AddToLog('���������');
    //
    StartButton.Enabled:= TRUE;
    StopButton.Enabled := FALSE;
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
