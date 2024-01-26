program SignFile;

uses
  MidasLib,
  Vcl.Forms,
  Vcl.Dialogs,
  System.SysUtils,
  Winapi.Windows,
  System.IniFiles,
  EUSignCP in '..\SOURCE\EUSignCP\EUSignCP.pas',
  EUSignCPOwnUI in '..\SOURCE\EUSignCP\EUSignCPOwnUI.pas';

{$R *.res}

var apath, FileKeyName, Pass, FileName, FileNameSign: AnsiString;
    ResultFileName, UserName : String;
    CPInterface: PEUSignCP;
    CertOwnerInfo : TEUCertOwnerInfo;
    Param : DWORD;
    nError : integer;

function AddResult(AName, AText : String): Boolean;
var
  f: TIniFile;
begin

  f := TiniFile.Create(ResultFileName);

  try
    try
      F.WriteString('SignResult', AName, AText);
    Except
    end;
  finally
    f.Free;
  end;

end;

begin

  // Получим данные
  apath := ParamStr(1);
  FileKeyName := ParamStr(2);
  Pass := ParamStr(3);
  FileName := ParamStr(4);
  FileNameSign := FileName + '.p7s';

  ResultFileName := ExtractFilePath(ParamStr(0)) + 'SignFileResult.dat';

  if (apath = '') or (FileKeyName = '') or (Pass = '') or (FileName = '') then
  begin
    AddResult('Ошибка', 'Не переданы все параметры.');
    Exit;
  end;

  if FileExists(String(FileNameSign)) then DeleteFile(PWideChar(FileNameSign));
  if FileExists(String(ResultFileName)) then DeleteFile(PWideChar(ResultFileName));

  if not EULoadDLL(apath) then
  begin
    AddResult('Ошибка', 'Не загружена библиотеки подписи: ' + EUDLLName);
    Exit;
  end;

  CPInterface := EUGetInterface();
  if CPInterface = nil then
  begin
    EUUnloadDLL();
    AddResult('Ошибка', 'Не загружена библиотеки подписи: ' + EUDLLName);
    Exit;
  end;

  CPInterface.SetUIMode(false);
  EUInitializeOwnUI(CPInterface, true);
  try

    nError := CPInterface.Initialize();
    if nError <> EU_ERROR_NONE then
    begin
      AddResult('Ошибка', 'Инициализации библиотеки подписи: ' + EUDLLName);
    end;

    CPInterface.SetUIMode(false);

    Param := EU_SIGN_TYPE_CADES_X_LONG;
    CPInterface.SetRuntimeParameter(PAnsiChar(EU_SIGN_TYPE_PARAMETER), @Param, sizeof(Param));

    try
      CPInterface.ResetPrivateKey;
    except
      on E: Exception do
      begin
        AddResult('Ошибка', 'В библиотеке подписи: ' + E.Message);
        Exit;
      end;
    end;

    try

      // проверка
      if not FileExists(String(FileKeyName)) then
      begin
        AddResult('Ошибка', 'Файл не найден : <'+String(FileKeyName)+'>');
        Exit;
      end;

      nError := CPInterface.ReadPrivateKeyFile (PAnsiChar(FileKeyName), PAnsiChar(Pass), @CertOwnerInfo); // бухгалтер
      if nError <> EU_ERROR_NONE then
      begin
        AddResult('Ошибка', 'В библиотеке при загрузке электронного ключа: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;

      UserName := String(CertOwnerInfo.SubjectFullName);
    except
      on E: Exception do
      begin
        AddResult('Ошибка', 'В библиотеке при загрузке электронного ключа:' + E.Message);
        Exit;
      end;
    end;

    try
      // 2.Неарспедственно подпись
      // проверка
      if not FileExists(String(FileName)) then
      begin
        AddResult('Ошибка', 'Файл еTTN не найден : <'+String(FileName)+'>');
        Exit;
      end;

      nError := CPInterface.SignFile(PAnsiChar(FileName), PAnsiChar(FileNameSign), True);
      if nError <> EU_ERROR_NONE then
      begin
        AddResult('Ошибка', 'В библиотеке при надожении подписи: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;
    except
      on E: Exception do
      begin
        AddResult('Ошибка', 'В библиотеке при наложении подписи:' + E.Message);
      end;
    end;

    AddResult('UserName', UserName);
    AddResult('FileNameSign', FileNameSign);
  finally
    CPInterface.Finalize;
    EUUnloadDLL();
  end;
end.
