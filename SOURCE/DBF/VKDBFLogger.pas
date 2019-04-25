{**********************************************************************************}
{                                                                                  }
{ Project vkDBF - dbf ntx clipper compatibility delphi component                   }
{                                                                                  }
{ This Source Code Form is subject to the terms of the Mozilla Public              }
{ License, v. 2.0. If a copy of the MPL was not distributed with this              }
{ file, You can obtain one at http://mozilla.org/MPL/2.0/.                         }
{                                                                                  }
{ The Initial Developer of the Original Code is Vlad Karpov (KarpovVV@protek.ru).  }
{                                                                                  }
{ Contributors:                                                                    }
{   Sergey Klochkov (HSerg@sklabs.ru)                                              }
{                                                                                  }
{ You may retrieve the latest version of this file at the Project vkDBF home page, }
{ located at http://sourceforge.net/projects/vkdbf/                                }
{                                                                                  }
{**********************************************************************************}
unit VKDBFLogger;

{$I VKDBF.DEF}

interface

uses
  Windows, Messages, SysUtils, Classes, syncobjs;

const

  LogRecordInfoLength = 1001;

  SubsystemInfoLength = 11;

  LogRecordsBufferLength = 256;

  DifferenceThreshold = 200;

  WriteBufferLength = 4096;

type

  TVKDBFLogRecord = packed record
    null: Word;
    SystemTime: TSystemTime;
    ThreadID: DWORD;
    Level: Word;
    SubSystem: array[0..Pred(SubsystemInfoLength)] of AnsiChar;
    info: array[0..Pred(LogRecordInfoLength)] of AnsiChar;
  end;

  TVKDBFLogWriteFields = set of (lwfDateTime, lwfThreadID, lwfLevel, lwfSubSystem, lwfInfo);

  TVKDBFLogAbstract = class
  private
    FLogSuffix: string;
    FLogDir: string;
    FOwner: TObject;
    FLogFile: string;
    FDateFormat: string;
    FOutFields: TVKDBFLogWriteFields;
    FLevelThreshold: Word;
  public
    constructor Create;
    procedure Open; virtual; abstract;
    procedure Close; virtual; abstract;
    function IsOpen: boolean; virtual; abstract;
    procedure Write(Info: AnsiString; Level: Word = 6; SubSystem: AnsiString = 'NA'); virtual; abstract;
    procedure Flush; virtual; abstract;
    procedure FlushCriticalVolume; virtual; abstract;
    function GetLastInfo(rCount: Integer): AnsiString; virtual; abstract;
    property Owner: TObject read FOwner write FOwner;
    property LogDir: string read FLogDir write FLogDir;
    property LogSuffix: string read FLogSuffix write FLogSuffix;
    property LogFile: string read FLogFile write FLogFile;
    property DateFormat: string read FDateFormat write FDateFormat;
    property OutFields: TVKDBFLogWriteFields read FOutFields write FOutFields;
    property LevelThreshold: Word read FLevelThreshold write FLevelThreshold;
  end;

  TVKDBFLoggerEvent = class
  private
    FHandle: THandle;
    FLastError: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function WaitFor(Timeout: DWORD): TWaitResult;
    procedure SetEvent;
    procedure ResetEvent;
  end;

  TVKDBFLogDemon = class(TThread)
  private
    FFullFlushThreshold: Integer;
    FFullFlushCounter: Integer;
    FLog: TVKDBFLogAbstract;
    FLoggerEvent: TVKDBFLoggerEvent;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StopWaitFor;
    property Log: TVKDBFLogAbstract read FLog write FLog;
    property FullFlushThreshold: Integer read FFullFlushThreshold write FFullFlushThreshold;
  end;

  TVKDBFLog = class;

  TOnAfterWriteLog = procedure (sender: TVKDBFLog; Level: Word) of object;

  TOnFlushLogRecord = procedure (sender: TVKDBFLog; var LogRecord: TVKDBFLogRecord) of object;

  TVKDBFLog = class(TVKDBFLogAbstract)
  private
    FFullFlushThreshold: Integer;
    LogDemon: TVKDBFLogDemon;
    cs: TCriticalSection;
    FLogHandler: Integer;
    csBuf: TCriticalSection;
    RecBuf: array[0..Pred(LogRecordsBufferLength)] of TVKDBFLogRecord;
    BeginIndex: Integer;
    EndIndex: Integer;
    WriteBuffer: array[0..Pred(WriteBufferLength)] of AnsiChar;
    WriteBufferPointer: Integer;
    FOnAfterWriteLog: TOnAfterWriteLog;
    FOnFlushLogRecord: TOnFlushLogRecord;
    procedure FlushInternal;
    procedure WriteInternal(Info: AnsiString; Level: Word = 6; SubSystem: AnsiString = 'NA');
  public
    procedure Open; override;
    function IsOpen: boolean; override;
    procedure Write(Info: AnsiString; Level: Word = 6; SubSystem: AnsiString = 'NA'); override;
    procedure Flush; override;
    procedure FlushCriticalVolume; override;
    procedure Close; override;
    function GetLastInfo(rCount: Integer): AnsiString; override;
    constructor Create(AOwner: TObject; ALogDir, ALogSuffix: string; FlushThreshold: Integer = 5);
    destructor Destroy; override;
    property FullFlushThreshold: Integer read FFullFlushThreshold;
    property Owner;
    property LogDir;
    property LogSuffix;
    property LogFile;
    property DateFormat;
    property OutFields;
    property LevelThreshold;
    property OnAfterWriteLog: TOnAfterWriteLog read FOnAfterWriteLog write FOnAfterWriteLog;
    property OnFlushLogRecord: TOnFlushLogRecord read FOnFlushLogRecord write FOnFlushLogRecord;
  end;

{$IFDEF VKDBF_LOGGIN}
var
  log: TVKDBFLog;
{$ENDIF}

implementation

uses
  AnsiStrings;

function Modulo(Index: Integer): Integer;
begin
  Result := ( Index and Pred(LogRecordsBufferLength) );
end;

procedure IncMod(var Index: Integer);
begin
  Inc(Index);
  Index := Modulo(Index);
end;

function Min(A,B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

{ TVKDBFLogAbstract }

constructor TVKDBFLogAbstract.Create;
begin
  inherited Create;
  FDateFormat := 'dd.mm.yyyy hh:nn:ss:zzz';
  FOutFields := [lwfDateTime, lwfThreadID, lwfLevel, lwfSubSystem, lwfInfo];
  FLevelThreshold := 10;
end;

{ TVKDBFLoggerEvent }

constructor TVKDBFLoggerEvent.Create;
begin
  FHandle := CreateEvent(nil, False, False, nil);
end;

destructor TVKDBFLoggerEvent.Destroy;
begin
  CloseHandle(FHandle);
  inherited Destroy;
end;

procedure TVKDBFLoggerEvent.ResetEvent;
begin
  Windows.ResetEvent(FHandle);
end;

procedure TVKDBFLoggerEvent.SetEvent;
begin
  Windows.SetEvent(FHandle);
end;

function TVKDBFLoggerEvent.WaitFor(Timeout: DWORD): TWaitResult;
begin
  case WaitForSingleObject(FHandle, Timeout) of
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_OBJECT_0: Result := wrSignaled;
    WAIT_TIMEOUT: Result := wrTimeout;
    WAIT_FAILED:
      begin
        Result := wrError;
        FLastError := GetLastError;
      end;
  else
    Result := wrError;
  end;
end;

{ TVKDBFLogDemon }

constructor TVKDBFLogDemon.Create;
begin
  inherited Create(True);
  FFullFlushThreshold := 5;
  FFullFlushCounter := 0;
  FLoggerEvent := TVKDBFLoggerEvent.Create;
end;

destructor TVKDBFLogDemon.Destroy;
begin
  FreeAndNil(FLoggerEvent);
  inherited Destroy;
end;

procedure TVKDBFLogDemon.Execute;
var
  currenttime: TTimeStamp;
begin
  while not Terminated do begin
    currenttime := DateTimeToTimeStamp(Now);
    if ( (currenttime.Time mod 86400000) + 1 < 10000 ) then begin
      Synchronize(Log.Close);
      Synchronize(Log.Open);
      FLoggerEvent.WaitFor(10010);
    end else
      FLoggerEvent.WaitFor(2000);
    Synchronize(Log.FlushCriticalVolume);
    Inc(FFullFlushCounter);
    if FFullFlushCounter = FFullFlushThreshold then begin
      FFullFlushCounter := 0;
      Synchronize(Log.Flush);
    end;
  end;
end;

procedure TVKDBFLogDemon.StopWaitFor;
begin
  FLoggerEvent.SetEvent;
end;

{ TVKDBFLog }

procedure TVKDBFLog.Close;
begin
  cs.Acquire;
  try
    if FLogHandler > 0 then begin
      Flush;
      FileClose(FLogHandler);
      FLogHandler := -1;
    end;
  finally
    cs.Release;
  end;
end;

constructor TVKDBFLog.Create(AOwner: TObject; ALogDir, ALogSuffix: string; FlushThreshold: Integer = 5);
begin
  inherited Create;
  FOnAfterWriteLog := nil;
  FOnFlushLogRecord := nil;
  FFullFlushThreshold := FlushThreshold;
  WriteBufferPointer := 0;
  csBuf := TCriticalSection.Create;
  cs := TCriticalSection.Create;
  FLogHandler := -1;
  Owner := AOwner;
  LogDir := ALogDir;
  LogSuffix := ALogSuffix;
  Open;
  LogDemon := TVKDBFLogDemon.Create;
  LogDemon.FreeOnTerminate := False;
  LogDemon.Log := self;
  LogDemon.Priority := tpLowest;
  LogDemon.FullFlushThreshold := FFullFlushThreshold;
  LogDemon.Resume;
end;

destructor TVKDBFLog.Destroy;
begin
  LogDemon.Terminate;
  LogDemon.StopWaitFor;
  FreeAndNil(LogDemon);
  Close;
  FreeAndNil(cs);
  FreeAndNil(csBuf);
  inherited Destroy;
end;

procedure TVKDBFLog.Flush;
begin
  cs.Acquire;
  try
    csBuf.Acquire;
    try
      FlushInternal;
    finally
      csBuf.Release;
    end;
  finally
    cs.Release;
  end;
end;

procedure TVKDBFLog.FlushCriticalVolume;
var
  Difference: Integer;
begin
  csBuf.Acquire;
  try
    Difference := Modulo(BeginIndex - EndIndex);
    if Difference >= DifferenceThreshold then begin
      cs.Acquire;
      try
        FlushInternal;
      finally
        cs.Release;
      end;
    end;
  finally
    csBuf.Release;
  end;
end;

procedure TVKDBFLog.FlushInternal;
var
  i, j: Integer;
  TmpStr: AnsiString;
  pTmpStr: pAnsiChar;

  procedure FlushWriteBuffer;
  begin
    FileWrite(FLogHandler, WriteBuffer, WriteBufferPointer);
    WriteBufferPointer := 0;
  end;

  procedure PutWriteBuffer(s: AnsiChar);
  begin
    WriteBuffer[WriteBufferPointer] := s;
    Inc(WriteBufferPointer);
    if WriteBufferPointer = WriteBufferLength then FlushWriteBuffer;
  end;

begin
  while EndIndex <> BeginIndex do begin
    if RecBuf[EndIndex].Level < FLevelThreshold then begin

      if lwfDateTime in FOutFields then begin
        TmpStr := AnsiString(FormatDateTime(FDateFormat, SystemTimeToDateTime(RecBuf[EndIndex].SystemTime)));
        pTmpStr := pAnsiChar(TmpStr);
        i := 0;
        while pTmpStr[i] <> #0 do begin
          PutWriteBuffer(pTmpStr[i]);
          Inc(i);
        end;
        PutWriteBuffer(#32);
      end;
      if lwfThreadID in FOutFields then begin
        Str(RecBuf[EndIndex].ThreadID:10, TmpStr);
        pTmpStr := pAnsiChar(TmpStr);
        i := 0;
        while pTmpStr[i] <> #0 do begin
          PutWriteBuffer(pTmpStr[i]);
          Inc(i);
        end;
        PutWriteBuffer(#32);
      end;
      if lwfLevel in FOutFields then begin
        Str(RecBuf[EndIndex].Level:5, TmpStr);
        pTmpStr := pAnsiChar(TmpStr);
        i := 0;
        while pTmpStr[i] <> #0 do begin
          PutWriteBuffer(pTmpStr[i]);
          Inc(i);
        end;
        PutWriteBuffer(#32);
      end;
      if lwfSubSystem in FOutFields then begin
        i := 0;
        while RecBuf[EndIndex].SubSystem[i] <> #0 do begin
          PutWriteBuffer(RecBuf[EndIndex].SubSystem[i]);
          Inc(i);
        end;
        for j := i to SubsystemInfoLength do PutWriteBuffer(#32);
      end;
      if lwfInfo in FOutFields then begin
        i := 0;
        while RecBuf[EndIndex].info[i] <> #0 do begin
          PutWriteBuffer(RecBuf[EndIndex].info[i]);
          Inc(i);
        end;
      end;
      PutWriteBuffer(#13);
      PutWriteBuffer(#10);

      if assigned(FOnFlushLogRecord) then
        try
          FOnFlushLogRecord(self, RecBuf[EndIndex]);
        except
        end;

    end;
    IncMod(EndIndex);
  end;
  FlushWriteBuffer;
end;

function TVKDBFLog.GetLastInfo(rCount: Integer): AnsiString;
var
  rrCount, rBeg, i: Integer;
  TmpStr: AnsiString;
begin
  Result := '';
  csBuf.Acquire;
  try
    rrCount := Min(rCount, LogRecordsBufferLength);
    rBeg := Modulo(BeginIndex - rrCount);
    while rBeg <> BeginIndex do begin
      if RecBuf[rBeg].null = 0 then begin
        if lwfDateTime in FOutFields then begin
          Result := Result +
              AnsiString( FormatDateTime( FDateFormat,
                              SystemTimeToDateTime(RecBuf[rBeg].SystemTime))) + ' ';
        end;
        if lwfThreadID in FOutFields then begin
          Str(RecBuf[rBeg].ThreadID:10, TmpStr);
          Result := Result + TmpStr + ' ';
        end;
        if lwfLevel in FOutFields then begin
          Str(RecBuf[rBeg].Level:5, TmpStr);
          Result := Result + TmpStr + ' ';
        end;
        if lwfSubSystem in FOutFields then begin
          i := 0;
          while RecBuf[EndIndex].SubSystem[i] <> #0 do Inc(i);
          Result := Result + RecBuf[rBeg].SubSystem + StringOfChar(AnsiChar(#32), SubsystemInfoLength - i);
        end;
        if lwfInfo in FOutFields then begin
          Result := Result + RecBuf[rBeg].info;
        end;
        Result := Result + #13#10;
      end;
      IncMod(rBeg);
    end;
  finally
    csBuf.Release;
  end;
end;

function TVKDBFLog.IsOpen: boolean;
begin
  cs.Acquire;
  try
    Result := ( FLogHandler > 0 );
  finally
    cs.Release;
  end;
end;

procedure TVKDBFLog.Open;
var
  dateString: string;
  i: Integer;
begin
  cs.Acquire;
  try
    // Открываем файл лога
    dateString := FormatDateTime('yyyymmdd', Now);
    LogFile := LogDir + dateString + LogSuffix + '.log';
    if not FileExists(LogFile) then begin
      FLogHandler := FileCreate(LogFile);
      if FLogHandler = -1 then
        raise Exception.Create('TVKDBFLog.Open: Не могу создать файл лога ' + LogFile);
      FileClose(FLogHandler);
      FLogHandler := -1;
    end;
    FLogHandler := FileOpen(LogFile, fmOpenWrite or fmShareDenyNone);
    if FLogHandler = -1 then
       raise Exception.Create('TVKDBFLog.Open: Не могу открыть файл лога ' + LogFile);
    FileSeek(FLogHandler, 0, 2);
    csBuf.Acquire;
    try
      BeginIndex := 0;
      EndIndex := 0;
      for i := 0 to Pred(LogRecordsBufferLength) do
        RecBuf[i].null := 1;
    finally
      csBuf.Release;
    end;
  finally
    cs.Release;
  end;
end;

procedure TVKDBFLog.Write(Info: AnsiString; Level: Word = 6; SubSystem: AnsiString = 'NA');
begin
  WriteInternal(Info, Level, SubSystem);
  if Assigned(FOnAfterWriteLog) then
    try
      FOnAfterWriteLog(self, Level);
    except
      WriteInternal('TVKDBFLog.Write: Ошибка при вызове события OnAfterWriteLog в логе ''' + AnsiString(LogSuffix) + ''' !', 0, SubSystem);
    end;
end;

procedure TVKDBFLog.WriteInternal(Info: AnsiString; Level: Word = 6; SubSystem: AnsiString = 'NA');
var
  InfoLen, SubSystemLen, PieceLen: Integer;
  pInfo, pSubSystem: PAnsiChar;
begin
  csBuf.Acquire;
  try
    pSubSystem := PAnsiChar(SubSystem);
    SubSystemLen := Length(SubSystem);
    if SubSystemLen > Pred(SubsystemInfoLength) then SubSystemLen := Pred(SubsystemInfoLength);
    pInfo := PAnsiChar(Info);
    InfoLen := Length(Info);
    repeat
      if  EndIndex = Modulo(BeginIndex + 1) then FlushCriticalVolume;
      //
      PieceLen := Min(Pred(LogRecordInfoLength), InfoLen);
      RecBuf[BeginIndex].null := 0;
      GetLocalTime(RecBuf[BeginIndex].SystemTime);
      RecBuf[BeginIndex].ThreadID := GetCurrentThreadID;
      RecBuf[BeginIndex].Level := Level;
      {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLCopy(RecBuf[BeginIndex].SubSystem, pSubSystem, SubSystemLen);
      RecBuf[BeginIndex].SubSystem[SubSystemLen] := #0;
      {$IFDEF DELPHIXE4}AnsiStrings.{$ENDIF}StrLCopy(RecBuf[BeginIndex].info, pInfo, PieceLen);
      RecBuf[BeginIndex].info[PieceLen] := #0;
      IncMod(BeginIndex);
      Inc(pInfo, PieceLen);
      Dec(InfoLen, PieceLen);
    until ( InfoLen = 0 );
    if Level < 4 then Flush;
  finally
    csBuf.Release;
  end;
end;

{$IFDEF VKDBF_LOGGIN}

initialization

  log := TVKDBFLog.Create(nil, '', 'VKDBF');

finalization

  FreeAndNil(log);

{$ENDIF}

end.
