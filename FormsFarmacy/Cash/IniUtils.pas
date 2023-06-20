unit IniUtils;

interface

function GetIniFile(out AIniFileName: String):boolean;

function GetValue(const ASection,AParamName,ADefault: String): String;
function GetValueInt(const ASection,AParamName: String; ADefault : Integer): Integer;
function GetValueBool(const ASection,AParamName: String; ADefault : Boolean): Boolean;

//���������� ��� ��������� ��������;
function iniCashType:String;
//���������� � ��������� �����
function iniCashID: Integer;
//���������� SoldParalel
function iniSoldParallel:Boolean;
//���������� ���� ��������� ��������
function iniPortNumber:String;
//���������� �������� �����
function iniPortSpeed:String;
//���������� ���� � ��������� ���� ������
function iniLocalDataBaseHead: String;
function iniLocalDataBaseBody: String;
function iniLocalDataBaseDiff: String;
function iniLocalDataBaseSQLite: String;
//���������� ��� ������
function iniLocalUnitCodeGet: Integer;
function iniLocalUnitCodeSave(AFarmacyCode: Integer): Integer;
//���������� ��� ������
function iniLocalUnitNameGet: string;
function iniLocalUnitNameSave(AFarmacyName: string): string;
//���������� GUID
function iniLocalGUIDGet: string;
function iniLocalGUIDSave(AGUID: string): string;
function iniLocalGUIDNew: string;

function iniCashSerialNumber: String;
function iniCashRegister: String;

//���������� ����� ��������� ������ ��� FP320
function iniTaxGroup7:Integer;

//���������� ��� POS-���������;
function iniPosType(ACode : integer):String;
//���������� ���� POS-���������
function iniPosHost(ACode : integer):String;
//���������� ���� POS-���������
function iniPosPortNumber(ACode : integer):Integer;
//���������� �������� ����� POS-���������
function iniPosPortSpeed(ACode : integer):Integer;

// ��� ������-����
//���������� ����� True ������ � �������� ������
function iniVCBatchMode:Boolean;
//���������� host - ����� ����������, �� ������� ���������� DeviceManager
function iniVCURL:String;
//���������� ��'� �������� *
function iniVCDevice_Name:String;
//���������� Token
function iniVCAccess_Token:String;

//���������� ��� �������� ��������;
function iniPrinterType:String;
//���������� ���� ��������
function iniPrinterPortNumber:String;
//���������� �������� ����� ��������
function iniPrinterPortSpeed:String;

//���������� ��������� �� ���
function iniLog_RRO : Boolean;

//��������������� ����� �������� ��������� ��������
function iniLocalCashRegisterGet: string;
function iniLocalCashRegisterSave(ACashRegister: string): string;

//��������������� ����� �������� ��������� ��������
function iniLocalListGoodsDateGet: TDateTime;
function iniLocalListGoodsDateSave: TDateTime;

//������ ���������� � ������ ���������
procedure InitCashSession(ACheckCashSession : Boolean);
function UpdateOption : Boolean;
function NeedTestProgram : Boolean;
function UpdateTestProgram : Boolean;

// �������� � ���������� ���������
procedure AutomaticUpdateProgram;

// �������� � ���������� FarmacyCashServise
procedure AutomaticUpdateFarmacyCashServise;

// �������� � ���������� ��������� ��� �����
procedure AutomaticUpdateProgramTest;

var gUnitName, gUserName, gPassValue: string;
var gUnitId, gUnitCode, gUserCode : Integer;
var isMainForm_OLD : Boolean;

implementation

uses
  iniFiles, Controls, Classes, SysUtils, Forms, vcl.Dialogs, dsdDB, Data.DB,
  UnilWin, FormStorage, Updater, DateUtils;

const
  FileName: String = '\DEFAULTS.INI';
  LocalDBNameHead: String = 'FarmacyCashHead.dbf';
  LocalDBNameBody: String = 'FarmacyCashBody.dbf';
  LocalDBNameDiff: String = 'FarmacyCashDiff.dbf';
  LocalDBNameSQLite: String = 'FarmacyCashSQLite.db';



function GetIniFile(out AIniFileName: String):boolean;
var
  dir: string;
  f: TIniFile;
Begin
  result := False;
  dir := ExtractFilePath(Application.exeName)+'ini';
  if not DirectoryExists(dir) AND not ForceDirectories(dir) then
  Begin
    ShowMessage('������������ �� ����� �������� ������ � ����� ��������.'+#13+
                 '���������� ������ ��������� ����������.'+#13+
                 '�������� ��������������.');
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
        ShowMessage('������������ �� ����� �������� ������ � ����� ��������. ���������� ������ ��������� ����������. �������� ��������������.');
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

function GetValueBool(const ASection,AParamName: String; ADefault : Boolean): Boolean;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := False;
    exit;
  End;
  ini := TiniFile.Create(IniFileName);
  Result := ini.ReadBool(ASection,AParamName,ADefault);
  ini.Free;
End;

function GetValueDateTime(const ASection, AParamName: String; ADefault : TDateTime): TDateTime;
var
  ini: TiniFile;
  IniFileName : String;
Begin
  if not GetIniFile(IniFileName) then
  Begin
    Result := Now();
    exit;
  End;
  ini := TiniFile.Create(IniFileName);
  Result := ini.ReadDateTime(ASection, AParamName, ADefault);
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

//���������� ���� � ��������� ���� ������
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

function iniLocalDataBaseSQLite: String;
var
  f: TIniFile;
begin
  Result := GetValue('Common','LocalDataBaseSQLite','');
  if Result = '' then
  Begin
    Result := ExtractFilePath(Application.ExeName)+LocalDBNameSQLite;
    f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
    try
      f.WriteString('Common','LocalDataBaseSQLite',Result);
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

function iniCashRegister: String;
begin
  Result := GetValue('Common','CashRegister', '');
end;

//���������� ����� ��������� ������ ��� FP320 7%
function iniTaxGroup7:Integer;
var
  s: String;
begin
  S := GetValue('TSoldWithCompMainForm','FP320_TAX7','1');
  if not tryStrToInt(S,Result) then
    Result := 1;
End;

//���������� ��� POS-���������;
function iniPosType(ACode : integer):String;
begin
  Result := GetValue('TSoldWithCompMainForm','PosType' + IntToStr(ACode),'');
end;

//���������� ���� POS-���������
function iniPosHost(ACode : integer):String;
begin
  Result := GetValue('TSoldWithCompMainForm', 'PosHost' + IntToStr(ACode), 'http://localhost:3000');
end;

//���������� ���� POS-���������
function iniPosPortNumber(ACode : integer):Integer;
var
  S: String;
begin
  S := GetValue('TSoldWithCompMainForm','PosPortNumber' + IntToStr(ACode),'');
  if not tryStrToInt(S,Result) then
    Result := 0;
end;

//���������� �������� ����� POS-���������
function iniPosPortSpeed(ACode : integer):Integer;
 var
  S: String;
begin
  S := GetValue('TSoldWithCompMainForm','PosPortSpeed' + IntToStr(ACode),'');
  if not tryStrToInt(S,Result) then
    Result := 0;
end;

// ��� ������-����
//���������� ����� True ������ � �������� ������
function iniVCBatchMode:Boolean;
begin
  Result := GetValueBool('TSoldWithCompMainForm','VCBatchMode', False);
end;
//���������� host - ����� ����������, �� ������� ���������� DeviceManager
function iniVCURL:String;
begin
  Result := GetValue('TSoldWithCompMainForm','VCURL','');
end;
//���������� ��'� �������� *
function iniVCDevice_Name:String;
begin
  Result := GetValue('TSoldWithCompMainForm','VCDevice_Name','');
end;
//���������� Token
function iniVCAccess_Token:String;
begin
  Result := GetValue('TSoldWithCompMainForm','VCAccess_Token','');
end;

//���������� ��������� �� ���
function iniLog_RRO: Boolean;
 var
  S: String;
begin
  S := GetValue('TSoldWithCompMainForm','Log_RRO', 'False');
  if not TryStrToBool(S, Result) then Result := False;
end;

//���������� ��� �������� ��������;
function iniPrinterType:String;
begin
  Result := GetValue('TSoldWithCompMainForm','PrinterType','');
end;

//���������� ���� ��������
function iniPrinterPortNumber:String;
begin
  Result := GetValue('TSoldWithCompMainForm','PrinterPortNumber','');
end;

//���������� �������� ����� ��������
function iniPrinterPortSpeed:String;
begin
  Result := GetValue('TSoldWithCompMainForm','PrinterPortSpeed','');
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

//���� ��������� �������� ��������
function iniLocalListGoodsDateGet: TDateTime;
begin
  Result := GetValueDateTime('Common','ListGoodsDate',IncDay(Now(), - 1));
end;

function iniLocalListGoodsDateSave: TDateTime;
var
  f: TIniFile;
begin
  Result := Now();
  f := TIniFile.Create(ExtractFilePath(Application.ExeName)+'ini\'+FileName);
  try
    f.WriteDateTime('Common','ListGoodsDate',Result);
  finally
    f.Free;
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
  Result := False;
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

function NeedTestProgram : Boolean;
var
  sp : TdsdStoredProc;
begin
  Result := False;
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpGet_CheckoutTesting_CashGUID';
      sp.Params.Clear;
      sp.Params.AddParam('inCashSessionId', ftString, ptInput, iniLocalGUIDGet);
      sp.Params.AddParam('outOk', ftBoolean, ptOutput, False);
      sp.Execute;
      Result := sp.Params.ParamByName('outOk').Value;
    except
    end;
  finally
    freeAndNil(sp);
  end;
end;

function UpdateTestProgram : Boolean;
var
  sp : TdsdStoredProc;
begin
  Result := True;
  sp := TdsdStoredProc.Create(nil);
  try
    try
      sp.OutputType := otResult;
      sp.StoredProcName := 'gpUpdate_Object_CheckoutTesting_Cash';
      sp.Params.Clear;
      sp.Params.AddParam('inCashSessionId', ftString, ptInput, iniLocalGUIDGet);
      sp.Execute;
    except
      Result := False;
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
      if MessageDlg('���������� ����� ������ ���������! ��������?', mtInformation, mbOKCancel, 0) = mrOk then
        if UpdateOption then TUpdater.AutomaticUpdateProgramStart;
    end;
  except
    on E: Exception do
       ShowMessage('�� �������� �������������� ����������.'#13#10'���������� � ������������.'#13#10 + E.Message);
  end;
end;

procedure AutomaticUpdateFarmacyCashServise;
var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
begin
  try
    Application.ProcessMessages;
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion('FarmacyCashServise.exe',
                       GetBinaryPlatfotmSuffics(ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe', ''));
    LocalVersionInfo := UnilWin.GetFileVersion(ExtractFileDir(ParamStr(0)) + '\FarmacyCashServise.exe');
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
    begin
      if MessageDlg('���������� ����� ������ FCash Service! ��������?', mtInformation, mbOKCancel, 0) = mrOk then
        if UpdateOption then TUpdater.AutomaticUpdateProgramStart;
    end;
  except
    on E: Exception do
       ShowMessage('�� �������� �������������� ����������.'#13#10'���������� � ������������.'#13#10 + E.Message);
  end;
end;

// �������� � ���������� ��������� ��� �����
procedure AutomaticUpdateProgramTest;
begin
  try
    Application.ProcessMessages;
    if NeedTestProgram then
    begin
      if MessageDlg('���������� �������� ������ ���������! ��������?', mtInformation, mbOKCancel, 0) = mrOk then
      begin
        if TUpdater.AutomaticUpdateProgramTestStart then
        begin
          UpdateTestProgram;
          Application.Terminate
        end;
      end;
    end;
  except
    on E: Exception do
       ShowMessage('�� �������� �������������� ����������.'#13#10'���������� � ������������.'#13#10 + E.Message);
  end;
end;


end.
