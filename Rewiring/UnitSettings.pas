unit UnitSettings;

interface

uses System.Classes, System.IniFiles;

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
    class function GetMasterServer: string; static;
    class procedure SetMasterServer(const AValue: string); static;
    class function GetMasterServerIn: string; static;
    class procedure SetMasterServerIn(const AValue: string); static;
    class function GetMasterDatabase: string; static;
    class procedure SetMasterDatabase(const AValue: string); static;
    class function GetMasterPort: Integer; static;
    class procedure SetMasterPort(const AValue: Integer); static;
    class function GetMasterUser: string; static;
    class procedure SetMasterUser(const AValue: string); static;
    class function GetMasterPassword: string; static;
    class procedure SetMasterPassword(const AValue: string); static;
    class function GetMasterUserRun: string; static;
    class procedure SetMasterUserRun(const AValue: string); static;


    class function GetSlaveServer: string; static;
    class procedure SetSlaveServer(const AValue: string); static;
    class function GetSlaveServerIn: string; static;
    class procedure SetSlaveServerIn(const AValue: string); static;
    class function GetSlaveDatabase: string; static;
    class procedure SetSlaveDatabase(const AValue: string); static;
    class function GetSlavePort: Integer; static;
    class procedure SetSlavePort(const AValue: Integer); static;
    class function GetSlaveUser: string; static;
    class procedure SetSlaveUser(const AValue: string); static;
    class function GetSlaveUserRC: string; static;
    class procedure SetSlaveUserRC(const AValue: string); static;
    class function GetSlavePassword: string; static;
    class procedure SetSlavePassword(const AValue: string); static;
    class function GetSlavePasswordRC: string; static;
    class procedure SetSlavePasswordRC(const AValue: string); static;

    class function GetScriptPath: string; static;
    class procedure SetScriptPath(const AValue: string); static;

    class function GetCountThread: integer; static;
    class procedure SetCountThread(const AValue: integer); static;

  public
    class constructor Create;
    class destructor Destroy;
    class function DefaultPort: Integer;

    class property MasterServer: string read GetMasterServer write SetMasterServer;
    class property MasterServerIn: string read GetMasterServerIn write SetMasterServerIn;
    class property MasterDatabase: string read GetMasterDatabase write SetMasterDatabase;
    class property MasterPort: Integer read GetMasterPort write SetMasterPort;
    class property MasterUser: string read GetMasterUser write SetMasterUser;
    class property MasterPassword: string read GetMasterPassword write SetMasterPassword;
    class property MasterUserRun: string read GetMasterUserRun write SetMasterUserRun;
    class property SlaveServer: string read GetSlaveServer write SetSlaveServer;
    class property SlaveServerIn: string read GetSlaveServerIn write SetSlaveServerIn;
    class property SlaveDatabase: string read GetSlaveDatabase write SetSlaveDatabase;
    class property SlavePort: Integer read GetSlavePort write SetSlavePort;
    class property SlaveUser: string read GetSlaveUser write SetSlaveUser;
    class property SlaveUserRC: string read GetSlaveUserRC write SetSlaveUserRC;
    class property SlavePassword: string read GetSlavePassword write SetSlavePassword;
    class property SlavePasswordRC: string read GetSlavePasswordRC write SetSlavePasswordRC;

    class property ScriptPath: string read GetScriptPath write SetScriptPath;

    class property CountThread: Integer read GetCountThread write SetCountThread;

  end;

function IsService: Boolean;

implementation

uses
  System.IOUtils, System.SysUtils, System.SyncObjs, Winapi.SHFolder, Winapi.Windows;

const
  // Master
  cMasterSection       = 'postgress_master';
  cMasterServerParam   = 'Server';
  cMasterServerInParam = 'ServerIn';
  cMasterDatabaseParam = 'Database';
  cMasterPortParam     = 'Port';
  cMasterUserParam     = 'User_name';
  cMasterPasswParam    = 'Password';
  cMasterUserRunParam  = 'User_nameRun';
  cMasterDriverID      = 'DriverID';

  // Slave
  cSlaveSection       = 'postgress_slave';
  cSlaveServerParam   = 'Server';
  cSlaveServerInParam = 'ServerIn';
  cSlaveDatabaseParam = 'Database';
  cSlavePortParam     = 'Port';
  cSlaveUserParam     = 'User_name';
  cSlavePasswParam    = 'Password';
  cSlaveDriverID      = 'DriverID';
  cSlaveUserRCParam   = 'User_name_rc';
  cSlavePasswRCParam  = 'Passwordv_rc';

  // Default values
  cDefPort            = 5432;
  cDefUser            = 'postgres';
  cDefScriptFilesPath = '..\Rewiring\scripts';

  // Settings
  cSettingsSection      = 'Settings';
  cScriptFilesPathParam = 'ScriptFilesPath';
  cCountThreadParam     = 'CountThread';

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

  sIniFile := FIniFolder + 'Rewiring.ini';

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

class function TSettings.DefaultPort: Integer;
begin
  Result := cDefPort;
end;

// Master

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

class function TSettings.GetMasterServerIn: string;
begin
  Result := GetStrValue(cMasterSection, cMasterServerInParam, EmptyStr);
end;

class function TSettings.GetMasterUser: string;
begin
  Result := GetStrValue(cMasterSection, cMasterUserParam, cDefUser);
end;

class function TSettings.GetMasterUserRun: string;
begin
  Result := GetStrValue(cMasterSection, cMasterUserRunParam, EmptyStr);
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

class procedure TSettings.SetMasterServerIn(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterServerInParam, AValue);
end;

class procedure TSettings.SetMasterUser(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterUserParam, AValue);
end;

class procedure TSettings.SetMasterUserRun(const AValue: string);
begin
  SetStrValue(cMasterSection, cMasterUserRunParam, AValue);
end;

// Slave

class function TSettings.GetSlavePassword: string;
begin
  Result := GetStrValue(cSlaveSection, cSlavePasswParam, EmptyStr);
end;

class function TSettings.GetSlavePasswordRC: string;
begin
  Result := GetStrValue(cSlaveSection, cSlavePasswRCParam, EmptyStr);
end;

class function TSettings.GetSlavePort: Integer;
begin
  Result := GetIntValue(cSlaveSection, cSlavePortParam, cDefPort);
end;

class function TSettings.GetSlaveServer: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveServerParam, EmptyStr);
end;

class function TSettings.GetSlaveServerIn: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveServerInParam, EmptyStr);
end;

class function TSettings.GetSlaveUser: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveUserParam, cDefUser);
end;

class function TSettings.GetSlaveUserRC: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveUserRCParam, '');
end;

class function TSettings.GetSlaveDatabase: string;
begin
  Result := GetStrValue(cSlaveSection, cSlaveDatabaseParam, EmptyStr);
end;

class procedure TSettings.SetSlaveDatabase(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveDatabaseParam, AValue);
end;

class procedure TSettings.SetSlavePassword(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlavePasswParam, AValue);
end;

class procedure TSettings.SetSlavePasswordRC(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlavePasswRCParam, AValue);
end;

class procedure TSettings.SetSlavePort(const AValue: Integer);
begin
  SetIntValue(cSlaveSection, cSlavePortParam, AValue);
end;

class procedure TSettings.SetSlaveServer(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveServerParam, AValue);
end;

class procedure TSettings.SetSlaveServerIn(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveServerInParam, AValue);
end;

class procedure TSettings.SetSlaveUser(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveUserParam, AValue);
end;

class procedure TSettings.SetSlaveUserRC(const AValue: string);
begin
  SetStrValue(cSlaveSection, cSlaveUserRCParam, AValue);
end;

class function TSettings.GetScriptPath: string;
begin
  Result := GetStrValue(cSettingsSection, cScriptFilesPathParam, cDefScriptFilesPath);
end;

class procedure TSettings.SetScriptPath(const AValue: string);
begin
  SetStrValue(cSettingsSection, cScriptFilesPathParam, AValue);
end;

class function TSettings.GetCountThread: integer;
begin
  Result := GetIntValue(cSettingsSection, cCountThreadParam, 3);
end;

class procedure TSettings.SetCountThread(const AValue: integer);
begin
  SetIntValue(cSettingsSection, cCountThreadParam, AValue);
end;


end.
