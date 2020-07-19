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
    FFileStream: TFileStream;
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
  UConstants,
  USettings;

const
  cLogMsg = '%s  %s' + #13#10;

{ TLogItem }

constructor TLogItem.Create(const AFileName: string);
var
  sFileName: string;
  byteOrderMark: TBytes;
begin
  inherited Create;
  FCS := TCriticalSection.Create;

  sFileName := IncludeTrailingPathDelimiter(TSettings.GetLogFolder) + AFileName;
  ForceDirectories(ExtractFilePath(sFileName));

  if not FileExists(sFileName) then
  begin
    FFileStream := TFileStream.Create(sFileName, fmCreate or fmShareExclusive);
    byteOrderMark := TEncoding.Unicode.GetPreamble;
    FFileStream.Write(byteOrderMark[0], Length(byteOrderMark));
    FreeAndNil(FFileStream);
  end;

  if FileExists(sFileName) then
  begin
    FFileStream := TFileStream.Create(sFileName, fmOpenReadWrite or fmShareDenyNone);
    FFileStream.Position := FFileStream.Size;
  end;
end;

destructor TLogItem.Destroy;
begin
  FreeAndNil(FFileStream);
  FreeAndNil(FCS);
  inherited;
end;

procedure TLogItem.Write(const AMsg: string);
var
  sMsg: string;
begin
  if not TSettings.UseLog then Exit;

  FCS.Enter;
  try
    sMsg := Format(cLogMsg, [FormatDateTime(cDateTimeStr, Now), AMsg]);
    FFileStream.WriteBuffer(sMsg[1], Length(sMsg) * SizeOf(Char));
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
