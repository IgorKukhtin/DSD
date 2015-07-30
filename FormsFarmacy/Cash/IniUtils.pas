unit IniUtils;

interface

function GetIniFile(out AIniFileName: String):boolean;

function GetValue(const ASection,AParamName,ADefault: String): String;

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

implementation

uses
  iniFiles, Classes, SysUtils, Forms, vcl.Dialogs;

function GetIniFile(out AIniFileName: String):boolean;
var
  dir: string;
  f: TIniFile;
CONST
  FileName: String = '\DEFAULTS.INI';
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
    try
      try
        f := TiniFile.Create(dir + FileName);
        AIniFileName := dir + FileName;
        F.WriteString('TSoldWithCompMainForm','CashType','FP3530T_NEW');
        F.WriteString('TSoldWithCompMainForm','CashId','0');
        F.WriteString('Common','SoldParallel','false');
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

end.
