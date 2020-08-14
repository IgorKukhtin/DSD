unit USettings;

interface

uses
  System.Classes
  , System.IniFiles;

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
    class function GetWriteCommandsToFile: Boolean; static;
    class procedure SetWriteCommandsToFile(const AValue: Boolean); static;
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
    class function GetReplicaLastId: Integer; static;
    class procedure SetReplicaLastId(const AValue: Integer); static;
    class function GetLibLocation: string; static;
    class procedure SetLibLocation(const AValue: string); static;
    class function GetMasterDriverID: string; static;
    class procedure SetMasterDriverID(const AValue: string); static;
    class function GetSlaveDriverID: string; static;
    class procedure SetSlaveDriverID(const AValue: string); static;
    class function GetStopIfError: Boolean; static;
    class procedure SetStopIfError(const AValue: Boolean); static;
    class function GetCompareDeviationOnly: Boolean; static;
    class procedure SetCompareDeviationOnly(const AValue: Boolean); static;
    class function GetReconnectTimeoutMinute: Integer; static;
    class procedure SetReconnectTimeoutMinute(const AValue: Integer); static;
    class function GetScriptPath: string; static;
    class procedure SetScriptPath(const AValue: string); static;
    class function GetDDLLastId: Integer; static;
    class procedure SetDDLLastId(const AValue: Integer); static;
  public
    class constructor Create;
    class destructor Destroy;
    class function GetLogFolder: string;
    class function DefaultPort: Integer;
    class property UseLog: Boolean read GetUseLog write SetUseLog;
    class property UseLogGUI: Boolean read GetUseLogGUI write SetUseLogGUI;
    class property WriteCommandsToFile: Boolean read GetWriteCommandsToFile write SetWriteCommandsToFile;
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
    class property ReplicaLastId: Integer read GetReplicaLastId write SetReplicaLastId;
    class property LibLocation: string read GetLibLocation write SetLibLocation;
    class property MasterDriverID: string read GetMasterDriverID write SetMasterDriverID;
    class property SlaveDriverID: string read GetSlaveDriverID write SetSlaveDriverID;
    class property StopIfError: Boolean read GetStopIfError write SetStopIfError;
    class property CompareDeviationOnly: Boolean read GetCompareDeviationOnly write SetCompareDeviationOnly;
    class property ReconnectTimeoutMinute: Integer read GetReconnectTimeoutMinute write SetReconnectTimeoutMinute;
    class property ScriptPath: string read GetScriptPath write SetScriptPath;
    class property DDLLastId: Integer read GetDDLLastId write SetDDLLastId;
    class procedure WriteScriptFiles(AList: TStrings);
    class procedure ReadScriptFiles(AList: TStrings);
  end;

function IsService: Boolean;

implementation

uses
  System.IOUtils
  , System.SysUtils
  , System.SyncObjs
  , Winapi.SHFolder
  , Winapi.Windows
  , UConstants;

var
  mCS: TCriticalSection;

const
  // INI-file name
  cININame = 'ConnDef.ini';

  // Replica
  cReplicaSection          = 'Replica';
  cReplicaLastIdParam      = 'LastId';
  cReplicaSelectRangeParam = 'SelectRange';
  cReplicaPacketRangeParam = 'PacketRange';
  cReplicaDDLLastIdParam   = 'DDLLastId';

  // Settings
  cSettingsSection       = 'Settings';
  cUseLogParam           = 'UseLog';
  cUseLogGUIParam        = 'UseLogGUI';
  cWriteCommandsParam    = 'WriteCommandsToFile';
  cLibLocationParam      = 'PostgresLibLocation';
  cStopIfErrorParam      = 'StopIfError';
  cCompareDeviationParam = 'CompareDeviationOnly';
  cReconnectTimeoutParam = 'ReconnectTimeoutMinute';
  cScriptFilesPathParam  = 'ScriptFilesPath';
  cScriptFilesUsedParam  = 'ScriptFilesUsed';

  // Master
  cMasterSection       = 'postgress_master';
  cMasterServerParam   = 'Server';
  cMasterDatabaseParam = 'Database';
  cMasterPortParam     = 'Port';
  cMasterUserParam     = 'User_name';
  cMasterPasswParam    = 'Password';
  cMasterDriverID      = 'DriverID';

  // Slave
  cSlaveSection       = 'postgress_slave';
  cSlaveServerParam   = 'Server';
  cSlaveDatabaseParam = 'Database';
  cSlavePortParam     = 'Port';
  cSlaveUserParam     = 'User_name';
  cSlavePasswParam    = 'Password';
  cSlaveDriverID      = 'DriverID';

  // Scripts
  cScriptSection = 'scripts';

  // Default values
  cDefPort = 5432;
  cDefUser = 'admin';
  cDefDriverID = 'PG';
  cDefReplicaSelectRange = 10000;
  cDefReplicaPacketRange = 1000;
  cDefReplicaLastId = 0;
  cDefReconnectTimeoutMinute = 15;
  cDefScriptFilesPath = '..\scripts';
  cDefDDLLastId = 0;

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
    Result := ExtractFilePath(ParamStr(0));
//    {$IFDEF DEBUG}
//    Result := ExtractFilePath(ParamStr(0));
//    {$ELSE}
//    Result := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + GetAppName;
//    {$ENDIF}
end;

function GetINIFolder: string;
begin
  Result := GetAppDataFolder;
end;

{ TSettings }

class constructor TSettings.Create;
var
  sIniFile, sMstDriverID, sSlvDriverID: string;
  tmpFS: TFileStream;
begin
  FIniFolder := GetINIFolder;

  if not TDirectory.Exists(FIniFolder) then
    TDirectory.CreateDirectory(FIniFolder);

  FIniFolder := IncludeTrailingPathDelimiter(FIniFolder);
  // ��� ������������� � ������ ���������� ������������ ����������� ��� ��� INI-�����
  sIniFile := FIniFolder + cININame;
//  sIniFile := FIniFolder + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');

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

  // ��������� [postgress_master].DriverID � [postgress_slave].DriverID �� ������������ � ���� ���������
  // � ��������� � ���� INI-���� ��� ������������� � ������ ����������
  sMstDriverID := GetMasterDriverID;
  sSlvDriverID := GetSlaveDriverID;
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

class function TSettings.GetCompareDeviationOnly: Boolean;
begin
  Result := GetBoolValue(cSettingsSection, cCompareDeviationParam, False);
end;

class function TSettings.GetDDLLastId: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaDDLLastIdParam, cDefDDLLastId);
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

class function TSettings.GetMasterDriverID: string;
begin
  Result := GetStrValue(cMasterSection, cMasterDriverID, cDefDriverID);
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

class function TSettings.GetReconnectTimeoutMinute: Integer;
begin
  Result := GetIntValue(cSettingsSection, cReconnectTimeoutParam, cDefReconnectTimeoutMinute);
end;

class function TSettings.GetReplicaPacketRange: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaPacketRangeParam, cDefReplicaPacketRange);
end;

class function TSettings.GetReplicaSelectRange: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaSelectRangeParam, cDefReplicaSelectRange);
end;

class function TSettings.GetReplicaLastId: Integer;
begin
  Result := GetIntValue(cReplicaSection, cReplicaLastIdParam, cDefReplicaLastId);
end;

class function TSettings.GetScriptPath: string;
begin
  Result := GetStrValue(cSettingsSection, cScriptFilesPathParam, cDefScriptFilesPath);
end;

class function TSettings.GetSlaveDatabase: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveDatabaseParam, EmptyStr);
end;

class function TSettings.GetSlaveDriverID: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveDriverID, cDefDriverID);
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

class function TSettings.GetStopIfError: Boolean;
begin
  Result := GetBoolValue(cSettingsSection, cStopIfErrorParam, False);
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

class function TSettings.GetWriteCommandsToFile: Boolean;
begin
  Result := GetBoolValue(cSettingsSection, cWriteCommandsParam, True);
end;

class procedure TSettings.ReadScriptFiles(AList: TStrings);
begin
  FIni.ReadSectionValues(cScriptSection, AList);
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

class procedure TSettings.SetCompareDeviationOnly(const AValue: Boolean);
begin
  SetBoolValue(cSettingsSection, cCompareDeviationParam, AValue);
end;

class procedure TSettings.SetDDLLastId(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaDDLLastIdParam, AValue);
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

class procedure TSettings.SetMasterDriverID(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterDriverID, AValue);
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

class procedure TSettings.SetReconnectTimeoutMinute(const AValue: Integer);
begin
  SetIntValue(cSettingsSection, cReconnectTimeoutParam, AValue);
end;

class procedure TSettings.SetReplicaPacketRange(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaPacketRangeParam, AValue);
end;

class procedure TSettings.SetReplicaSelectRange(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaSelectRangeParam, AValue);
end;

class procedure TSettings.SetReplicaLastId(const AValue: Integer);
begin
  SetIntValue(cReplicaSection, cReplicaLastIdParam, AValue);
end;

class procedure TSettings.SetScriptPath(const AValue: string);
begin
  SetStrValue(cSettingsSection, cScriptFilesPathParam, AValue);
end;

class procedure TSettings.SetSlaveDatabase(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveDatabaseParam, AValue);
end;

class procedure TSettings.SetSlaveDriverID(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveDriverID, AValue);
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

class procedure TSettings.SetStopIfError(const AValue: Boolean);
begin
  SetBoolValue(cSettingsSection, cStopIfErrorParam, AValue);
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

class procedure TSettings.SetWriteCommandsToFile(const AValue: Boolean);
begin
  SetBoolValue(cSettingsSection, cWriteCommandsParam, AValue);
end;

class procedure TSettings.WriteScriptFiles(AList: TStrings);
var
  I: Integer;
begin
  Assert(AList <> nil, '��������� AList <> nil');
  FIni.EraseSection(cScriptSection);

  for I := 0 to Pred(AList.Count) do
    SetStrValue(cScriptSection, IntToStr(I + 1), AList[I]);
end;

initialization
  mCS := TCriticalSection.Create;

finalization
  FreeAndNil(mCS);

end.
