{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* FormDumpRestore.pas - unit dump - restore                                    *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FormDumpRestore;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MinJobs, Vcl.Buttons;

const
  WM_NEWOUTPUT = WM_USER + 1;
  WM_TERMIMINATE_PROCCESS = WM_USER +2;
type
  TDumpRestoreForm = class(TForm)
    mmLog: TMemo;
    edPath: TEdit;
    rbDump: TRadioButton;
    rbRestore: TRadioButton;
    lblPathScript: TLabel;
    btnExecute: TButton;
    lblProcess: TLabel;
    lblDirBin: TLabel;
    edDirBin: TEdit;
    edHostDump: TEdit;
    edDBDump: TEdit;
    edUserDump: TEdit;
    edHostRestore: TEdit;
    edDBRestore: TEdit;
    edUserRestore: TEdit;
    lblHost: TLabel;
    lblDB: TLabel;
    lblUser: TLabel;
    lblLog: TLabel;
    chbDrop: TCheckBox;
    sbCleraLog: TSpeedButton;
    lblPassword: TLabel;
    edPswDump: TEdit;
    edPswRestore: TEdit;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbDumpClick(Sender: TObject);
    procedure sbCleraLogClick(Sender: TObject);
  private
    { Private declarations }
    FInputR, FInputW: THandle;
    FOutputR, FOutputW: THandle;
    FThread: THandle;
    FJob: THandle;
    FTerminated: Boolean;
    Fpi: TProcessInformation;
    FOutputStr: array of string;
    procedure InternalReadOutputPipe;
    procedure InternalWaitProcess;
    procedure InintJobOwner;
    procedure WWNewOutput(var message: TMessage); message WM_NEWOUTPUT;
    procedure WMTermiminateProccess (var message: TMessage); message WM_TERMIMINATE_PROCCESS;
    procedure RunJob(const Path, Params: string);
    procedure UpdateControl(RunningProcess: Boolean);
  public
    { Public declarations }
    procedure InitPipe;
    procedure ClosePipe;
  end;

var
  DumpRestoreForm: TDumpRestoreForm;

implementation

{$R *.dfm}


function func_output(f: TDumpRestoreForm): Integer;
  begin
    Result := 0;
    try
      f.InternalReadOutputPipe;
    except
      Result := -1;
    end;
  end;

function func_wait(f: TDumpRestoreForm): Integer;
  begin
    Result := 0;
    try
      f.InternalWaitProcess;
    except
      Result := -1;
    end;
  end;
{ TDumpRestoreForm }

procedure TDumpRestoreForm.btnExecuteClick(Sender: TObject);
var
  s, pg_app, pg_param: string;
  a: AnsiString;
begin

    if Fpi.hProcess <> 0 then
      begin
        TerminateProcess(Fpi.hProcess, INVALID_HANDLE_VALUE);
        exit;
      end;
  if rbDump.Checked then
    begin
      pg_app    := 'pg_dump.exe';
      if chbDrop.Checked  then s := '-c ' else s := '';
      pg_param  := Format('-U %s %s -s -v -N _replica -h %s -f %s %s', [edUserDump.Text, s, edHostDump.Text, edPath.Text, edDBDump.Text]);
      a := edPswDump.Text+sLineBreak;
    end
  else
    begin
      pg_app := 'psql.exe';      //-e
      pg_param  := Format('-U %s -h %s -d %s -f %s', [edUserRestore.Text, edHostRestore.Text, edDBRestore.Text,  edPath.Text]);
      a := edPswRestore.Text+sLineBreak;
    end;

  if edDirBin.Text <> '' then
    s := IncludeTrailingPathDelimiter(edDirBin.Text) + pg_app else
    s := pg_app;

    RunJob(s, pg_param);
    FileWrite(FInputW, a[1], Length(a));

    mmLog.Lines.Add(Format(
      '[%s] process running - pid: %d, name: %s', [TimeToStr(Now), Fpi.dwProcessId, pg_app]));
    UpdateControl(true);
end;

procedure TDumpRestoreForm.ClosePipe;
var
  att: TSecurityAttributes;
begin
  if FInputR <> 0  then
    CloseHandle(FInputR);
  if FInputW <> 0  then
    CloseHandle(FInputW);
  if FOutputW <> 0  then
    CloseHandle(FOutputW);
  if FOutputR <> 0  then
    begin
      CloseHandle(FOutputR);
      SuspendThread(FThread);
    end;

  FInputR   := 0;
  FInputW   := 0;
  FOutputR  := 0;
  FOutputW  := 0;

end;

procedure TDumpRestoreForm.FormActivate(Sender: TObject);
begin
  if not FTerminated then exit;
  //InintJobOwner;
  InitPipe;

end;

procedure TDumpRestoreForm.FormCreate(Sender: TObject);
begin
  FTerminated := true;
  mmLog.Lines.Clear;
end;

procedure TDumpRestoreForm.FormDestroy(Sender: TObject);
begin
  FTerminated := true;
  if FJob <> 0 then
    begin
      CloseHandle(FJob);
      FJob := 0;
    end;
  ClosePipe;
  if FThread <> 0 then
    begin
      ResumeThread(FThread);
      CloseHandle(FThread);
      FThread := 0;
    end;
end;



procedure TDumpRestoreForm.InintJobOwner;
const
  JobName = 'replica-pg2pg:pg_dump_restore';
var
  Limit: TJobObjectExtendedLimitInformation;
begin
  FJob := CreateJobObject(nil, JobName);
  Win32Check(FJob <> 0);
  ZeroMemory(@Limit, SizeOf(TJobObjectExtendedLimitInformation));
  Limit.BasicLimitInformation.LimitFlags := JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
  Win32Check(SetInformationJobObject(FJob, JobObjectExtendedLimitInformation,
      @Limit, SizeOf(TJobObjectExtendedLimitInformation)));
end;

procedure TDumpRestoreForm.InitPipe;
var
  att: TSecurityAttributes;
begin
  try
    if FThread = 0  then
      begin
        FThread := BeginThread(nil, 0, @func_output, Self, CREATE_SUSPENDED, PDWORD(nil)^);
        Win32Check(FThread <> 0);
      end;

    att.nLength := SizeOf(att);
    att.lpSecurityDescriptor := nil;
    att.bInheritHandle := true;
    Win32Check(CreatePipe(FInputR, FInputW, @att, 0));
    Win32Check(CreatePipe(FOutputR, FOutputW, @att, 0));
    Win32Check(SetHandleInformation(FInputW, HANDLE_FLAG_INHERIT, 0));
    Win32Check(SetHandleInformation(FOutputR, HANDLE_FLAG_INHERIT, 0));
    FTerminated := false;
    ResumeThread(FThread);
  except
    on E: Exception do
      begin
        mmLog.Lines.Add(
          Format('[%s] An error occurred during initialization. ClassName: %s Message: %s',
           [TimeToStr(Now), E.ClassName, E.Message]));
        ClosePipe;
        raise E;
      end;
  end;

end;

procedure TDumpRestoreForm.InternalReadOutputPipe;
var
  dwReads, index, i: Integer;
  buf: array [0..64 * 1024 -1 ] of AnsiChar;
  Output: array of string;
begin
  index := 0 ;
  while not FTerminated do
    begin
      dwReads := -1;
      if FOutputR <> 0 then
        dwReads := FileRead(FOutputR, buf[index], Length(buf)-index-1)  else
        SwitchToThread;

      if (dwReads <> -1)  then
        begin
          i := index;
          index := index + dwReads;
          buf[index] := #0;
          if StrPos(@buf[i], sLineBreak) <> nil then
            begin
              buf[index-2] := #0;
              SendMessage(Handle, WM_NEWOUTPUT, 0, LPARAM(@buf[0]));
              index := 0;
            end;

//          Output := nil;
//          Pointer(Output) := InterlockedExchangePointer(Pointer(FOutputStr), Pointer(Output));
//          SetLength(Output, Length(Output)+1);
//          Output[High(Output)] := AnsiString(buf);
//          Pointer(Output) := InterlockedExchangePointer(Pointer(FOutputStr), Pointer(Output));
//          PostMessage(Handle, WM_NEWOUTPUT, 0, 0);


//          if FOutputLog <> 0 then
//            FileWrite(FOutputLog, buf[0], dwReads);
//          HandleDataOutput(@buf, dwReads);
//          if Assigned(FOnOutputLog) then
//            FOnOutputLog(Self, @Buf, dwReads);

        end;
    end;

end;

procedure TDumpRestoreForm.InternalWaitProcess;
var
  code: Cardinal;
begin
  WaitForSingleObject(Fpi.hProcess, INFINITE);
  GetExitCodeProcess(Fpi.hProcess, code);
  sleep(100);    //< need switch to thread for reading output pipe
  SendMessage(Handle, WM_TERMIMINATE_PROCCESS, code, 0);
end;

procedure TDumpRestoreForm.rbDumpClick(Sender: TObject);
begin
  edHostDump.Enabled  := rbDump.Checked;
  edDBDump.Enabled    := rbDump.Checked;
  edUserDump.Enabled  := rbDump.Checked;
  edPswDump.Enabled   := rbDump.Checked;


  edHostRestore.Enabled := rbRestore.Checked;
  edDBRestore.Enabled   := rbRestore.Checked;
  edUserRestore.Enabled := rbRestore.Checked;
  edPswRestore.Enabled  := rbRestore.Checked;
end;

procedure TDumpRestoreForm.RunJob(const Path, Params: string);
var
  si: TStartupInfo;
  pi: TProcessInformation;
  P1, P2: PChar;
  h: THandle;
  s: string;
begin

  ZeroMemory(@si, SizeOf(TStartupInfo));
  si.cb          := SizeOf(TStartupInfo);
  si.hStdInput   := FInputR;
  si.hStdOutput  := FOutputW;
  si.hStdError   := FOutputW;
  si.dwFlags     := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  si.wShowWindow := SW_HIDE;

  if Path <> '' then P1 := PChar(Path) else P1 := nil;
  if Params <> '' then
    begin
      if Path <> '' then
        s := '"'+Path + '" '+Params else
        s := Params;
      P2 := PChar(s);
    end
  else P2 := nil;
//  Win32Check(CreateProcess(P1, P2, nil, nil, true,
//                           CREATE_BREAKAWAY_FROM_JOB or CREATE_SUSPENDED, nil, nil, si, pi));
//  try
//    if not AssignProcessToJobObject(FJob, pi.hProcess) then
//      begin
//        si.cb := GetLastError;
//        TerminateProcess(PI.hProcess, DWORD(-1));
//        SetLastError(si.cb);
//        RaiseLastOSError;
//      end;
//    ResumeThread(pi.hThread);
//  finally
//    CloseHandle(pi.hThread);
//    CloseHandle(PI.hProcess);
//  end;

  SetEnvironmentVariable('OSTYPE', 'msys');
  Win32Check(CreateProcess(P1, P2, nil, nil, true, 0, nil, nil, si, pi));
  try

    Fpi := pi;
    h := BeginThread(nil, 0, @func_wait, Self, 0, PDWORD(nil)^);
    Win32Check(h <> 0);
    CloseHandle(h);
  except
    on E: Exception do
      begin
        TerminateProcess(pi.hProcess, INVALID_HANDLE_VALUE);
        CloseHandle(pi.hThread);
        CloseHandle(PI.hProcess);

        mmLog.Lines.Add(
          Format('[%s] An error occurred when the process starts. ClassName: %s Message: %s',
           [TimeToStr(Now), E.ClassName, E.Message]));
        raise E;
      end;
  end;

end;

procedure TDumpRestoreForm.sbCleraLogClick(Sender: TObject);
begin
  mmLog.Lines.Clear;
end;

procedure TDumpRestoreForm.UpdateControl(RunningProcess: Boolean);
begin
  if RunningProcess then
    begin
      btnExecute.Caption := 'ABORT';
      lblProcess.Visible := true;
    end
  else
    begin
      btnExecute.Caption := 'START';
      lblProcess.Visible := false;
    end;
end;

procedure TDumpRestoreForm.WMTermiminateProccess(var message: TMessage);
begin
  if message.WParam = INVALID_HANDLE_VALUE then
    mmLog.Lines.Add(Format(
      '[%s] process stoped  - pid: %d, ExitCode: -1 (aborted by user)', [TimeToStr(Now), Fpi.dwProcessId]))
  else
    mmLog.Lines.Add(Format(
      '[%s] process stoped  - pid: %d, ExitCode: %d', [TimeToStr(Now), Fpi.dwProcessId, message.WParam]));
  UpdateControl(false);
  FillChar(Fpi, SizeOf(Fpi), 0);
end;

procedure TDumpRestoreForm.WWNewOutput(var message: TMessage);
var
  Output: array of string;
  I: Integer;
  s: AnsiString;
begin
  s := PAnsiChar(message.LParam);
  mmLog.Lines.Add(s);
//  FileWrite(FInputW, Pointer(cmd)^, Length(cmd));
//  Output := nil;
//  Pointer(Output) := InterlockedExchangePointer(Pointer(FOutputStr), Pointer(Output));
//  for I := 0 to Length(Output) -1 do
//    mmLog.Lines.Add(Output[i]);
end;

end.
