unit USettings;

interface

uses
  System.IniFiles;

type
  TSettings = class
  strict private
    class var
      FIni: TIniFile;
      FIniFolder: string;
  strict private
    class function GetBoolValue(const ASection, AParam: string; const ADefVal: Boolean): Boolean;
    class function GetIntValue(const ASection, AParam: string; const ADefVal: Integer): Integer;
    class function GetStrValue(const ASection, AParam, ADefVal: string): string;
    class procedure SetBoolValue(const ASection, AParam: string; const AVal: Boolean);
    class procedure SetIntValue(const ASection, AParam: string; const AVal: Integer);
    class procedure SetStrValue(const ASection, AParam, AVal: string);
  strict private
    class function GetUseLog: Boolean; static;
    class procedure SetUseLog(const AValue: Boolean); static;
    class function GetUseLogGUI: Boolean; static;
    class procedure SetUseLogGUI(const AValue: Boolean); static;
    class function GetMasterServer: string; static;
    class procedure SetMasterServer(const AValue: string); static;
    class function GetMasterDatabase: string; static;
    class procedure SetMasterDatabase(const AValue: string); static;
    class function GetMasterPort: Integer; static;
    class procedure SetMasterPort(const AValue: Integer); static;
    class function GetMasterUser: string; static;
    class procedure SetMasterUser(const AValue: string); static;
    class function GetMasterPassword: string; static;
    class procedure SetMasterPassword(const AValue: string); static;
    class function GetSlaveServer: string; static;
    class procedure SetSlaveServer(const AValue: string); static;
    class function GetSlaveDatabase: string; static;
    class procedure SetSlaveDatabase(const AValue: string); static;
    class function GetSlavePort: Integer; static;
    class procedure SetSlavePort(const AValue: Integer); static;
    class function GetSlaveUser: string; static;
    class procedure SetSlaveUser(const AValue: string); static;
    class function GetSlavePassword: string; static;
    class procedure SetSlavePassword(const AValue: string); static;
    class function GetReplicaSelectRange: Integer; static;
    class procedure SetReplicaSelectRange(const AValue: Integer); static;
    class function GetReplicaPacketRange: Integer; static;
    class procedure SetReplicaPacketRange(const AValue: Integer); static;
    class function GetReplicaStart: Integer; static;
    class procedure SetReplicaStart(const AValue: Integer); static;
    class function GetLibLocation: string; static;
    class procedure SetLibLocation(const AValue: string); static;
  public
    class constructor Create;
    class destructor Destroy;
    class function GetLogFolder: string;
    class function DefaultPort: Integer;
    class property UseLog: Boolean read GetUseLog write SetUseLog;
    class property UseLogGUI: Boolean read GetUseLogGUI write SetUseLogGUI;
    class property MasterServer: string read GetMasterServer write SetMasterServer;
    class property MasterDatabase: string read GetMasterDatabase write SetMasterDatabase;
    class property MasterPort: Integer read GetMasterPort write SetMasterPort;
    class property MasterUser: string read GetMasterUser write SetMasterUser;
    class property MasterPassword: string read GetMasterPassword write SetMasterPassword;
    class property SlaveServer: string read GetSlaveServer write SetSlaveServer;
    class property SlaveDatabase: string read GetSlaveDatabase write SetSlaveDatabase;
    class property SlavePort: Integer read GetSlavePort write SetSlavePort;
    class property SlaveUser: string read GetSlaveUser write SetSlaveUser;
    class property SlavePassword: string read GetSlavePassword write SetSlavePassword;
    class property ReplicaSelectRange: Integer read GetReplicaSelectRange write SetReplicaSelectRange;
    class property ReplicaPacketRange: Integer read GetReplicaPacketRange write SetReplicaPacketRange;
    class property ReplicaStart: Integer read GetReplicaStart write SetReplicaStart;
    class property LibLocation: string read GetLibLocation write SetLibLocation;
  end;

function IsService: Boolean;

implementation

uses
  System.IOUtils
  , System.Classes
  , System.SysUtils
  , System.SyncObjs
  , Winapi.SHFolder
  , Winapi.Windows
  , UConstants;

var
  mCS: TCriticalSection;

const
  // Replica
  cReplicaSection    = 'Replica';
  cReplicaStartParam = 'StartID';
  cReplicaSelectRangeParam = 'SelectRange';
  cReplicaPacketRangeParam = 'PacketRange';


  // Settings
  cSettingsSection  = 'Settings';
  cUseLogParam      = 'UseLog';
  cUseLogGUIParam   = 'UseLogGUI';
  cLibLocationParam = 'PostgresLibLocation';

  // Master
  cMasterSection       = 'Master';
  cMasterServerParam   = 'Server';
  cMasterDatabaseParam = 'Database';
  cMasterPortParam     = 'Port';
  cMasterUserParam     = 'User';
  cMasterPasswParam    = 'Password';

  // Slave
  cSlaveSection       = 'Slave';
  cSlaveServerParam   = 'Server';
  cSlaveDatabaseParam = 'Database';
  cSlavePortParam     = 'Port';
  cSlaveUserParam     = 'User';
  cSlavePasswParam    = 'Password';

  // Default values
  cDefPort = 5432;
  cDefUser = 'admin';
  cDefReplicaSelectRange = 10000;
  cDefReplicaPacketRange = 1000;
  cDefReplicaStart = 1;

function IsService: Boolean;
var
  C: Cardinal;
  Data: USEROBJECTFLAGS;
begin
  GetUserObjectInformation(GetProcessWindowStation, UOI_FLAGS, @Data, SizeOf(Data), C);
  Result := (Data.dwFlags and WSF_VISIBLE <> WSF_VISIBLE)
  or FindCmdLineSwitch('INSTALL', ['-', '/'], True)
  or FindCmdLineSwitch('UNINSTALL', ['-', '/'], True);
end;

function GetPublicDocuments: string;
var
  LStr: array[0 .. MAX_PATH] of Char;
const
  CSIDL_COMMON_DOCUMENTS = $002E;
begin
  SetLastError(ERROR_SUCCESS);

  if SHGetFolderPath(0, CSIDL_COMMON_DOCUMENTS, 0, 0, @LStr) = S_OK then
    Result := LStr;
end;

function GetAppName: string;
begin
  Result := ExtractFileName(ParamStr(0));
  Result := ChangeFileExt(Result, '');
end;

function GetAppDataFolder: string;
begin
  if IsService then
    Result := IncludeTrailingPathDelimiter(GetPublicDocuments) + GetAppName
  else
    {$IFDEF DEBUG}
    Result := ExtractFilePath(ParamStr(0));
    {$ELSE}
    Result := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + GetAppName;
    {$ENDIF}
end;

function GetINIFolder: string;
begin
  Result := GetAppDataFolder;
end;

{ TSettings }

class constructor TSettings.Create;
var
  sIniFile: string;
  tmpFS: TFileStream;
begin
  FIniFolder := GetINIFolder;

  if not TDirectory.Exists(FIniFolder) then
    TDirectory.CreateDirectory(FIniFolder);

  FIniFolder := IncludeTrailingPathDelimiter(FIniFolder);
  sIniFile := FIniFolder + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');
  if not TFile.Exists(sIniFile) then
  begin
    tmpFS := TFile.Create(sIniFile);
    tmpFS.Free;
  end;

  Assert(TFile.Exists(sIniFile));
  try
    FIni := TIniFile.Create(sIniFile);
  except
    FIni := nil;
  end;
end;

class function TSettings.DefaultPort: Integer;
begin
  Result := cDefPort;
end;

class destructor TSettings.Destroy;
begin
  FreeAndNil(FIni);
end;

class function TSettings.GetBoolValue(const ASection, AParam: string; const ADefVal: Boolean): Boolean;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      begin
        ValueExist := FIni.SectionExists(ASection);
        ValueExist := ValueExist and FIni.ValueExists(ASection, AParam);

        if ValueExist then
          Result := FIni.ReadBool(ASection, AParam, ADefVal)
        else
          FIni.WriteBool(ASection, AParam, ADefVal);
      end;
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;


class function TSettings.GetIntValue(const ASection, AParam: string; const ADefVal: Integer): Integer;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      ValueExist := FIni.SectionExists(ASection);
      ValueExist := ValueExist and FIni.ValueExists(ASection, AParam);

      if ValueExist then
        Result := FIni.ReadInteger(ASection, AParam, ADefVal)
      else
        FIni.WriteInteger(ASection, AParam, ADefVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class function TSettings.GetLibLocation: string;
begin
  Result := GetStrValue(cSettingsSection, cLibLocationParam, EmptyStr);
end;

class function TSettings.GetLogFolder: string;
begin
  mCS.Enter;
  try
    Result := GetAppDataFolder + '\Log' ;
  finally
    mCS.Leave;
  end;
end;

class function TSettings.GetMasterDatabase: string;
begin
  Result := GetStrValue(cMasterSection, cMasterDatabaseParam, EmptyStr);
end;

class function TSettings.GetMasterPassword: string;
begin
  Result := GetStrValue(cMasterSection, cMasterPasswParam, EmptyStr);
end;

class function TSettings.GetMasterPort: Integer;
begin
  Result := GetIntValue(cMasterSection, cMasterPortParam, cDefPort);
end;

class function TSettings.GetMasterServer: string;
begin
  Result := GetStrValue(cMasterSection, cMasterServerParam, EmptyStr);
end;

class function TSettings.GetMasterUser: string;
begin
  Result := GetStrValue(cMasterSection, cMasterUserParam, cDefUser);
end;

class function TSettings.GetReplicaPacketRange: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaPacketRangeParam, cDefReplicaPacketRange);
end;

class function TSettings.GetReplicaSelectRange: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaSelectRangeParam, cDefReplicaSelectRange);
end;

class function TSettings.GetReplicaStart: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaStartParam, cDefReplicaStart);
end;

class function TSettings.GetSlaveDatabase: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveDatabaseParam, EmptyStr);
end;

class function TSettings.GetSlavePassword: string;
begin
  Result := GetStrValue(cSlaveSection, cSlavePasswParam, EmptyStr);
end;

class function TSettings.GetSlavePort: Integer;
begin
  Result := GetIntValue(cSlaveSection, cSlavePortParam, cDefPort);
end;

class function TSettings.GetSlaveServer: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveServerParam, EmptyStr);
end;

class function TSettings.GetSlaveUser: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveUserParam, cDefUser);
end;

class function TSettings.GetStrValue(const ASection, AParam, ADefVal: string): string;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      ValueExist := FIni.SectionExists(ASection);
      ValueExist := ValueExist and FIni.ValueExists(ASection, AParam);

      if ValueExist then
        Result := FIni.ReadString(ASection, AParam, ADefVal)
      else
        FIni.WriteString(ASection, AParam, ADefVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class function TSettings.GetUseLog: Boolean;
begin
  mCS.Enter;
  try
    Result := GetBoolValue(cSettingsSection, cUseLogParam, True);
  finally
    mCS.Leave;
  end;
end;

class function TSettings.GetUseLogGUI: Boolean;
begin
  Result := GetBoolValue(cSettingsSection, cUseLogGUIParam, True);
end;

class procedure TSettings.SetBoolValue(const ASection, AParam: string; const AVal: Boolean);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteBool(ASection, AParam, AVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetIntValue(const ASection, AParam: string; const AVal: Integer);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteInteger(ASection, AParam, AVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetLibLocation(const AValue: string);
begin
  SetStrValue(cSettingsSection, cLibLocationParam, AValue);
end;

class procedure TSettings.SetMasterDatabase(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterDatabaseParam, AValue);
end;

class procedure TSettings.SetMasterPassword(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterPasswParam, AValue);
end;

class procedure TSettings.SetMasterPort(const AValue: Integer);
begin
  SetIntValue(cMasterSection, cMasterPortParam, AValue);
end;

class procedure TSettings.SetMasterServer(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterServerParam, AValue);
end;

class procedure TSettings.SetMasterUser(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterUserParam, AValue);
end;

class procedure TSettings.SetReplicaPacketRange(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaPacketRangeParam, AValue);
end;

class procedure TSettings.SetReplicaSelectRange(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaSelectRangeParam, AValue);
end;

class procedure TSettings.SetReplicaStart(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaStartParam, AValue);
end;

class procedure TSettings.SetSlaveDatabase(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveDatabaseParam, AValue);
end;

class procedure TSettings.SetSlavePassword(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlavePasswParam, AValue);
end;

class procedure TSettings.SetSlavePort(const AValue: Integer);
begin
  SetIntValue(cSlaveSection, cSlavePortParam, AValue);
end;

class procedure TSettings.SetSlaveServer(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveServerParam, AValue);
end;

class procedure TSettings.SetSlaveUser(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveUserParam, AValue);
end;

class procedure TSettings.SetStrValue(const ASection, AParam, AVal: string);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteString(ASection, AParam, Trim(AVal));
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetUseLog(const AValue: Boolean);
begin
  mCS.Enter;
  try
    SetBoolValue(cSettingsSection, cUseLogParam, AValue);
  finally
    mCS.Leave;
  end;
end;


class procedure TSettings.SetUseLogGUI(const AValue: Boolean);
begin
  SetBoolValue(cSettingsSection, cUseLogGUIParam, AValue);
end;

initialization
  mCS := TCriticalSection.Create;

finalization
  FreeAndNil(mCS);

end.
