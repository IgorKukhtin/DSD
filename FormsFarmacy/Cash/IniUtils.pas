unit IniUtils;

interface

function GetIniFile(out AIniFileName: String):boolean;

function GetValue(const ASection,AParamName,ADefault: String): String;

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
//���������� ��� ������
function iniLocalUnitNameGet: string;
function iniLocalUnitNameSave(AFarmacyName: string): string;
//���������� GUID
function iniLocalGUIDGet: string;
function iniLocalGUIDSave(AGUID: string): string;

function iniCashSerialNumber: String;
//���������� ����� ��������� ������ ��� FP320
function iniTaxGroup7:Integer;

//���������� ��� POS-���������;
function iniPosType(ACode : integer):String;
//���������� ���� POS-���������
function iniPosPortNumber(ACode : integer):Integer;
//���������� �������� ����� POS-���������
function iniPosPortSpeed(ACode : integer):Integer;

//��������������� ����� �������� ��������� ��������
function iniLocalCashRegisterGet: string;
function iniLocalCashRegisterSave(ACashRegister: string): string;

//������ ���������� � ������ ���������
procedure InitCashSession;
function UpdateOption : Boolean;
procedure AutomaticUpdateProgram;

var gUnitName, gUserName, gPassValue: string;
var gUnitId : Integer;
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

function iniLocalUnitNameGet: string;
begin
  Result := GetValue('Common','FarmacyName', '');
end;

function iniLocalUnitNameSave(AFarmacyName: string): string;
var
  f: TIniFile;
begin
  Result := GetValue('Common','FarmacyName', '');
  if Result = '' then
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


function iniCashSerialNumber: String;
begin
  Result := GetValue('TSoldWithCompMainForm','FP320SERIAL','');
End;

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

procedure InitCashSession;
var
  sp : TdsdStoredProc;
begin
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
                       GetBinaryPlatfotmSuffics(ParamStr(0)));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
    begin
      if MessageDlg('���������� ����� ������ ���������! ��������', mtInformation, mbOKCancel, 0) = mrOk then
        if UpdateOption then TUpdater.AutomaticUpdateProgramStart;
    end;
  except
    on E: Exception do
       ShowMessage('�� �������� �������������� ����������.'#13#10'���������� � ������������.'#13#10 + E.Message);
  end;
end;


end.
