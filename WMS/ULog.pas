unit ULog;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  System.SyncObjs;

type
  TLogItem = class
  strict private
    FLogFile: TextFile;
    FCS: TCriticalSection;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    procedure Write(const AMsg: string);
  end;

  TLog = class
  strict private
    FLogs: TDictionary<string, TLogItem>;
  strict private
    function GetLogItem(const AFileName: string): TLogItem;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Write(AFileName, AMsg: string);
  end;

implementation

uses
  USettings;

{ TLogItem }

constructor TLogItem.Create(const AFileName: string);
var
  sFileName: string;
begin
  inherited Create;
  FCS := TCriticalSection.Create;

  sFileName := IncludeTrailingPathDelimiter(TSettings.GetLogFolder) + AFileName;
  ForceDirectories(ExtractFilePath(sFileName));

  AssignFile(FLogFile, sFileName);
  if FileExists(sFileName) then
    Append(FLogFile)
  else
    Rewrite(FLogFile);
end;

destructor TLogItem.Destroy;
begin
  CloseFile(FLogFile);
  FreeAndNil(FCS);
  inherited;
end;

procedure TLogItem.Write(const AMsg: string);
begin
  FCS.Enter;
  try
    WriteLn(FLogFile, AMsg);
    Flush(FLogFile);
  finally
    FCS.Leave;
  end;
end;


{ TLog }

constructor TLog.Create;
begin
  inherited;
  FLogs := TDictionary<string, TLogItem>.Create;
end;

destructor TLog.Destroy;
var
  tmpPair: TPair<string, TLogItem>;
begin
  for tmpPair in FLogs do
    tmpPair.Value.Free;

  FreeAndNil(FLogs);
  inherited;
end;

function TLog.GetLogItem(const AFileName: string): TLogItem;
begin
  if not FLogs.TryGetValue(AFileName, Result) then
  begin
    FLogs.Add(AFileName, TLogItem.Create(AFileName));
    Result := FLogs.Items[AFileName];
  end;
end;

procedure TLog.Write(AFileName, AMsg: string);
begin
  GetLogItem(AFileName).Write(AMsg);
end;

end.
