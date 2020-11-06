unit Log;

interface

uses
  SysUtils;

type
  TSeverityLevel = (sevOperation, sevOperationDetail, sevException);

  TTraceLevel = (trcOperation, trcOperationDetail, trcException);

  TLog = class
  private
    FLogFileName: TFileName;
    FTraceLevel: TTraceLevel;
    FShowSeverityLevelInLog: boolean;
    FEnabled: boolean;
    procedure SetTraceLevel(const Value: TTraceLevel);
    procedure SetLogFileName(const Value: TFileName);
  protected
  public
    constructor Create(AEnabled: boolean);
    procedure AddToLog(Msg: string; SeverityLevel: TSeverityLevel = sevOperation);
    property Enabled: boolean read FEnabled write FEnabled;
    property LogFileName: TFileName read FLogFileName write SetLogFileName;
    property ShowSeverityLevelInLog: boolean read fShowSeverityLevelInLog
      write fShowSeverityLevelInLog;
    property TraceLevel: TTraceLevel read FTraceLevel write SetTraceLevel;
  end;


  var
    Logger: TLog;

implementation

constructor TLog.Create(AEnabled: boolean);
begin
  LogFileName:= 'default.log';
  TraceLevel:= trcOperation;
  FEnabled := AEnabled;
end;

procedure TLog.AddToLog(Msg: string; SeverityLevel: TSeverityLevel);
var
  F: TextFile;
begin
  if not Enabled then
     exit;
  case SeverityLevel of
    sevOperation:
      if (Ord(TraceLevel) = 0) or (Ord(TraceLevel) = 1) then
      begin
        if ShowSeverityLevelInLog then
          Msg:= DateTimeToStr(Now) + ' [Operation] ' + Msg
        else
          Msg:= DateTimeToStr(Now) + ' ' + Msg;
      end
      else
        Exit;
    sevOperationDetail:
      if (Ord(TraceLevel) = 1) then
      begin
        if ShowSeverityLevelInLog then
          Msg:= DateTimeToStr(Now) + ' [OperationDetail] ' + Msg
        else
          Msg:= DateTimeToStr(Now) + ' ' + Msg;
      end
      else
        Exit;
    sevException:
        if ShowSeverityLevelInLog then
          Msg:= DateTimeToStr(Now) + ' [Exception] ' + Msg
        else
          Msg:= DateTimeToStr(Now) + ' ' + Msg;
  end;

  if not FileExists(LogFileName) then
  begin
    AssignFile(F, LogFileName);
    Rewrite(F);
  end
  else
  begin
    AssignFile(F, LogFileName);
    Append(F);
  end;
  Writeln(F, Msg);
  Flush(F);
  CloseFile(F);
end;

procedure TLog.SetLogFileName(const Value: TFileName);
begin
  FLogFileName := Value;
end;

procedure TLog.SetTraceLevel(const Value: TTraceLevel);
begin
  FTraceLevel:= Value;
end;

initialization

  Logger := TLog.Create(false);

finalization

  Logger.Free;

end.

