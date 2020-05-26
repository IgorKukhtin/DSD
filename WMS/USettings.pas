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
    class function GetBoolValue(const AParam: string; const ADefVal: Boolean): Boolean;
    class function GetIntValue(const AParam: string; const ADefVal: Integer): Integer;
    class function GetStrValue(const AParam, ADefVal: string): string;
    class procedure SetBoolValue(const AParam: string; const AVal: Boolean);
    class procedure SetIntValue(const AParam: string; const AVal: Integer);
    class procedure SetStrValue(const AParam, AVal: string);
  strict private
    class function GetWMSDatabase: string; static;
    class procedure SetWMSDatabase(const AValue: string); static;
    class function GetAlanServer: string; static;
    class procedure SetAlanServer(const AValue: string); static;
    class function GetTimerInterval: Cardinal; static;
    class procedure SetTimerInterval(const AValue: Cardinal); static;
  public
    class constructor Create;
    class destructor Destroy;
    class function GetLogFolder: string;
    class procedure ApplyDefault;
    class property WMSDatabase: string read GetWMSDatabase write SetWMSDatabase;
    class property AlanServer: string read GetAlanServer write SetAlanServer;
    class property TimerInterval: Cardinal read GetTimerInterval write SetTimerInterval;
  end;

function IsService: Boolean;

implementation

uses
  System.IOUtils
  , System.Classes
  , System.SysUtils
  , System.Win.Registry
  , Winapi.SHFolder
  , Winapi.Windows
  , UConstants;

const
  cAppDataFolder = 'SendDataWMS';

  // INI params
  cINI_Section = 'Settings';
  cAlanServerParam = 'AlanServer';
  cWMSDatabaseParam = 'WMSDatabase';
  cTimerIntervalParam = 'TimerInterval';

  // Default values
  cTimerIntervalDef = 10000;
  cAlanServerDef = 'project-vds.vds.colocall.com';
  cWMSDatabaseDef = '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=wms-db-1.alan.dp.ua)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=wmsdb)))';

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

function GetAppDataFolder: string;
begin
  Result := IncludeTrailingPathDelimiter(GetPublicDocuments) + cAppDataFolder;
end;

function GetINIFolder: string;
begin
  Result := GetAppDataFolder;

//  if IsService then
//    Result := IncludeTrailingPathDelimiter(GetPublicDocuments) + sAppName
//  else
//    Result := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + sAppName;
end;

{ TSettings }

class procedure TSettings.ApplyDefault;
begin
  WMSDatabase := cWMSDatabaseDef;
  AlanServer := cAlanServerDef;
  TimerInterval := cTimerIntervalDef;
end;

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

class destructor TSettings.Destroy;
begin
  FreeAndNil(FIni);
end;

class function TSettings.GetAlanServer: string;
begin
  Result := GetStrValue(cAlanServerParam, cAlanServerDef);
end;

class function TSettings.GetBoolValue(const AParam: string; const ADefVal: Boolean): Boolean;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      begin
        ValueExist := FIni.SectionExists(cINI_Section);
        ValueExist := ValueExist and FIni.ValueExists(cINI_Section, AParam);

        if ValueExist then
          Result := FIni.ReadBool(cINI_Section, AParam, ADefVal)
        else
          FIni.WriteBool(cINI_Section, AParam, ADefVal);
      end;
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class function TSettings.GetIntValue(const AParam: string; const ADefVal: Integer): Integer;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      ValueExist := FIni.SectionExists(cINI_Section);
      ValueExist := ValueExist and FIni.ValueExists(cINI_Section, AParam);

      if ValueExist then
        Result := FIni.ReadInteger(cINI_Section, AParam, ADefVal)
      else
        FIni.WriteInteger(cINI_Section, AParam, ADefVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class function TSettings.GetLogFolder: string;
begin
  Result := GetAppDataFolder + '\Log' ;
end;

class function TSettings.GetStrValue(const AParam, ADefVal: string): string;
var
  ValueExist: Boolean;
begin
  Result := ADefVal;

  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      ValueExist := FIni.SectionExists(cINI_Section);
      ValueExist := ValueExist and FIni.ValueExists(cINI_Section, AParam);

      if ValueExist then
        Result := FIni.ReadString(cINI_Section, AParam, ADefVal)
      else
        FIni.WriteString(cINI_Section, AParam, ADefVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class function TSettings.GetTimerInterval: Cardinal;
begin
  Result := GetIntValue(cTimerIntervalParam, cTimerIntervalDef);
end;

class function TSettings.GetWMSDatabase: string;
begin
  Result := GetStrValue(cWMSDatabaseParam, cWMSDatabaseDef);
end;

class procedure TSettings.SetAlanServer(const AValue: string);
begin
  SetStrValue(cAlanServerParam, AValue);
end;

class procedure TSettings.SetBoolValue(const AParam: string; const AVal: Boolean);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteBool(cINI_Section, AParam, AVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetIntValue(const AParam: string; const AVal: Integer);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteInteger(cINI_Section, AParam, AVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetStrValue(const AParam, AVal: string);
begin
  if Assigned(FIni) then
  begin
    System.TMonitor.Enter(FIni);
    try
      FIni.WriteString(cINI_Section, AParam, AVal);
    finally
      System.TMonitor.Exit(FIni);
    end;
  end;
end;

class procedure TSettings.SetTimerInterval(const AValue: Cardinal);
begin
  SetIntValue(cTimerIntervalParam, AValue);
end;

class procedure TSettings.SetWMSDatabase(const AValue: string);
begin
  SetStrValue(cWMSDatabaseParam, AValue);
end;

end.
