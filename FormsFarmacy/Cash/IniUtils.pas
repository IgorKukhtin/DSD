unit IniUtils;

interface

function GetValue(const ASection,AParamName,ADefault: String): String;

//���������� ��� ��������� ��������;
function iniCashType:String;
//���������� SoldParalel
function iniSoldParallel:Boolean;
//���������� ���� ��������� ��������
function iniPortNumber:String;
//���������� �������� �����
function iniPortSpeed:String;

implementation

uses
  iniFiles, Classes, SysUtils, Forms;

function GetValue(const ASection,AParamName,ADefault: String): String;
var
  ini: TiniFile;
Begin
  ini := TiniFile.Create(ExtractFilePath(Application.exeName)+'\ini\DEFAULTS.INI');
  Result := ini.ReadString(ASection,AParamName,ADefault);
  ini.Free;
End;

function iniCashType:String;
begin
  Result := GetValue('TSoldWithCompMainForm','CashType','FP3530T_NEW');
end;

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

end.
