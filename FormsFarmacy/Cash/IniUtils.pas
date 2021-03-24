unit IniUtils;

interface

function GetIniFile(out AIniFileName: String):boolean;

function GetValue(const ASection,AParamName,ADefault: String): String;
function GetValueInt(const ASection,AParamName: String; ADefault : Integer): Integer;

//возвраащет тип кассового аппарата;
function iniCashType:String;
//возвращает № кассового места
function iniCashID: Integer;
//возвращает SoldParalel
function iniSoldParallel:Boolean;
//возвращает порт кассового аппарата
function iniPortNumber:String;
//возвращает скорость порта
function iniPortSpeed:String;
//Возвращает путь к локальной базе данных
function iniLocalDataBaseHead: String;
function iniLocalDataBaseBody: String;
function iniLocalDataBaseDiff: String;
//Возвращает код Аптеки
function iniLocalUnitCodeGet: Integer;
function iniLocalUnitCodeSave(AFarmacyCode: Integer): Integer;
//Возвращает имя Аптеки
function iniLocalUnitNameGet: string;
function iniLocalUnitNameSave(AFarmacyName: string): string;
//Возвращает GUID
function iniLocalGUIDGet: string;
function iniLocalGUIDSave(AGUID: string): string;
function iniLocalGUIDNew: string;

function iniCashSerialNumber: String;
//возвращает номер налоговой группы для FP320
function iniTaxGroup7:Integer;

//возвраащет тип POS-терминала;
function iniPosType(ACode : integer):String;
//возвращает порт POS-терминала
function iniPosPortNumber(ACode : integer):Integer;
//возвращает скорость порта POS-терминала
function iniPosPortSpeed(ACode : integer):Integer;

//Регистрационный номер текущего кассового аппарата
function iniLocalCashRegisterGet: string;
function iniLocalCashRegisterSave(ACashRegister: string): string;

//Запись информации о старте программы
procedure InitCashSession(ACheckCashSession : Boolean);
function UpdateOption : Boolean;
procedure AutomaticUpdateProgram;

var gUnitName, gUserName, gPassValue: string;
var gUnitId, gUnitCode : Integer;
var isMainForm_OLD : Boolean;

implementation

uses
  iniFiles, Controls, Classes, SysUtils, Forms, vcl.Dialogs, dsdDB, Data.DB,
  UnilWin, FormStorage, Updater;

const
  FileName: String = '\DEFAULTS.INI';
  LocalDBNameHead: String = 'FarmacyCashHead.dbf';
  LocalDBNameBody: String = 'FarmacyCashBody.dbf';
  LocalDBNameDiff: String = 'FarmacyCashDiff.dbf';



function GetIniFile(out AIniFileName: String):boolean;
var
  dir: string;
  f: TIniFile;
Begin
  result := False;
  dir := ExtractFilePath(Application.exeName)+'ini';
  if not DirectoryExists(dir) AND not ForceDirectories(dir) then
  Begin
    ShowMessage('Пользователь не может получить доступ к файлу настроек.'+#13+
                 'Дальнейшая работа программы невозможна.'+#13+
                 'Сообщите администратору.');
    exit;
  End;
  if not FileExists(dir + FileName) then
  Begin
    f := TiniFile.Create(dir + FileName);
    try
      try
        AIniFileName := dir + FileName;
        F.WriteString('Common','SoldParallel','false');
        F.WriteString('Common','LocalDataBaseHead',ExtractFilePath(Application.ExeName)+LocalDBNameHead);
        F.WriteString('Common','LocalDataBaseBody',ExtractFilePath(Application.ExeName)+LocalDBNameBody);
        F.WriteString('Common','LocalDataBaseDiff',ExtractFilePath(Application.ExeName)+LocalDBNameDiff);
        F.WriteString('TSoldWithCompMainForm','CashType','FP3530T_NEW');
        F.WriteString('TSoldWithCompMainForm','CashId','0');
        F.WriteString('TSoldWithCompMainForm','PortNumber','1');
        F.WriteString('TSoldWithCompMainForm','PortSpeed','19200');
      Except
        ShowMessage('Пользователь не может получить доступ к файлу настроек. Дальнейшая работа программы невозможна. Сообщите администратору.');
        exit;
      end;
    finally
      f.Free;
    end;
  End
  else
    AIniFileName := dir+FileName;
  result := True;
End;

function GetValue(const ASection,AParamName,ADefault: String): String;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := '';
    exit;
  End;
  ini := TiniFile.Create(IniFileName);
  Result := ini.ReadString(ASection,AParamName,ADefault);
  ini.Free;
End;

function GetValueInt(const ASection,AParamName: String; ADefault : Integer): Integer;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := 0;
    exit;
  End;
  ini := TiniFile.Create(IniFileName);
  Result := ini.ReadInteger(ASection,AParamName,ADefault);
  ini.Free;
End;

function iniCashType:String;
begin
  Result := GetValue('TSoldWithCompMainForm','CashType','FP3530T_NEW');
end;

function iniCashID: Integer;
Begin
  if not TryStrToInt(GetValue('TSoldWithCompMainForm','CashId','0'),Result) then
    Result := 0;
End;

function iniSoldParallel:Boolean;
Begin
  Result := GetValue('Common','SoldParallel','false') = 'true';
End;

function iniPortNumber:String;
begin
  Result := GetValue('TSoldWithCompMainForm','PortNumber','1');
end;

function iniPortSpeed:String;
begin
  Result := GetValue('TSoldWithCompMainForm','PortSpeed','19200');
end;

//Возвращает путь к локальной базе данных
function iniLocalDataBaseHead: String;
var
  f: TIniFile;
begin
  Result := GetValue('Common','LocalDataBaseHead','');
  if Result = '' then
  Begin
    Result := ExtractFilePath(Application.ExeName)+LocalDBNameHead;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','LocalDataBaseHead',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalDataBaseBody: String;
var
  f: TIniFile;
begin
  Result := GetValue('Common','LocalDataBaseBody','');
  if Result = '' then
  Begin
    Result := ExtractFilePath(Application.ExeName)+LocalDBNameBody;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','LocalDataBaseBody',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalDataBaseDiff: String;
var
  f: TIniFile;
begin
  Result := GetValue('Common','LocalDataBaseDiff','');
  if Result = '' then
  Begin
    Result := ExtractFilePath(Application.ExeName)+LocalDBNameDiff;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','LocalDataBaseDiff',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalUnitCodeGet: Integer;
begin
  Result := GetValueInt('Common','FarmacyCode', 0);
end;

function iniLocalUnitCodeSave(AFarmacyCode: Integer): Integer;
var
  f: TIniFile;
begin
  Result := GetValueInt('Common','FarmacyCode', 0);
  if Result <> AFarmacyCode then
  Begin
    Result := AFarmacyCode;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteInteger('Common','FarmacyCode',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalUnitNameGet: string;
begin
  Result := GetValue('Common','FarmacyName', '');
end;

function iniLocalUnitNameSave(AFarmacyName: string): string;
var
  f: TIniFile;
begin
  Result := GetValue('Common','FarmacyName', '');
  if Result <> AFarmacyName then
  Begin
    Result := AFarmacyName;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','FarmacyName',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalGUIDGet: string;
begin
  Result := GetValue('Common','CashSessionGUID', '');
end;

function iniLocalGUIDSave(AGUID: string): string;
var
  f: TIniFile;
begin
  Result := GetValue('Common','CashSessionGUID', '');
  if Result = '' then
  Begin
    Result := AGUID;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','CashSessionGUID',Result);
    finally
      f.Free;
    end;
  End;
end;

function iniLocalGUIDNew: string;
var
  f: TIniFile;
  G: TGUID;
begin
  CreateGUID(G);
  Result := GUIDToString(G);
  f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
  try
    f.WriteString('Common','CashSessionGUID',Result);
  finally
    f.Free;
  end;
end;

function iniCashSerialNumber: String;
begin
  Result := GetValue('TSoldWithCompMainForm','FP320SERIAL','');
End;

//возвращает номер налоговой группы для FP320 7%
function iniTaxGroup7:Integer;
var
  s: String;
begin
  S := GetValue('TSoldWithCompMainForm','FP320_TAX7','1');
  if not tryStrToInt(S,Result) then
    Result := 1;
End;

//возвраащет тип POS-терминала;
function iniPosType(ACode : integer):String;
begin
  Result := GetValue('TSoldWithCompMainForm','PosType' + IntToStr(ACode),'');
end;

//возвращает порт POS-терминала
function iniPosPortNumber(ACode : integer):Integer;
var
  S: String;
begin
  S := GetValue('TSoldWithCompMainForm','PosPortNumber' + IntToStr(ACode),'');
  if not tryStrToInt(S,Result) then
    Result := 0;
end;

//возвращает скорость порта POS-терминала
function iniPosPortSpeed(ACode : integer):Integer;
 var
  S: String;
begin
  S := GetValue('TSoldWithCompMainForm','PosPortSpeed' + IntToStr(ACode),'');
  if not tryStrToInt(S,Result) then
    Result := 0;
end;

function iniLocalCashRegisterGet: string;
begin
  Result := GetValue('Common','CashRegister', '');
end;

function iniLocalCashRegisterSave(ACashRegister: string): string;
var
  f: TIniFile;
begin
  Result := GetValue('Common','CashRegister', '');
  if (ACashRegister <> '') and (Result <> ACashRegister) then
  Begin
    Result := ACashRegister;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','CashRegister',Result);
    finally
      f.Free;
    end;
  End;
end;

procedure CheckCashSession;
var
  sp : TdsdStoredProc;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpGet_CashSession_Busy';
      sp.Params.Clear;
      sp.Params.AddParam('inCashSessionId', ftString, ptInput, iniLocalGUIDGet);
      sp.Params.AddParam('outisBusy', ftBoolean, ptOutput, False);
      sp.Execute;
      if sp.Params.ParamByName('outisBusy').Value then iniLocalGUIDNew;
    except
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure InitCashSession(ACheckCashSession : Boolean);
var
  sp : TdsdStoredProc;
begin
  if ACheckCashSession then CheckCashSession;
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpInsertUpdate_CashSession';
      sp.Params.Clear;
      sp.Params.AddParam('inCashSessionId', ftString, ptInput, iniLocalGUIDGet);
      sp.Execute;
    except
    end;
  finally
    freeAndNil(sp);
  end;
end;

function UpdateOption : Boolean;
var
  sp : TdsdStoredProc;
begin
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpUpdate_CashSession_StartUpdate';
      sp.Params.Clear;
      sp.Params.AddParam('inCashSessionId', ftString, ptInput, iniLocalGUIDGet);
      sp.Params.AddParam('outStartOk', ftBoolean, ptOutput, False);
      sp.Params.AddParam('outMessage', ftString, ptOutput, '');
      sp.Execute;
      Result := sp.Params.ParamByName('outStartOk').Value;
      if not Result then
      begin
          ShowMessage(sp.Params.ParamByName('outMessage').Value);
      end;
    except
    end;
  finally
    freeAndNil(sp);
  end;
end;

procedure AutomaticUpdateProgram;
var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
begin
  try
    Application.ProcessMessages;
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)),
                       GetBinaryPlatfotmSuffics(ParamStr(0), ''));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
    begin
      if MessageDlg('Обнаружена новая версия программы! Обновить', mtInformation, mbOKCancel, 0) = mrOk then
        if UpdateOption then TUpdater.AutomaticUpdateProgramStart;
    end;
  except
    on E: Exception do
       ShowMessage('Не работает автоматическое обновление.'#13#10'Обратитесь к разработчику.'#13#10 + E.Message);
  end;
end;


end.
