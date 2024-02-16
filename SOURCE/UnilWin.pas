(*
     Описание:
     Файл содержит ряд системных утилит.

     История изменений:

     Автор         Дата создания      Изменял            Дата модификации
     Кухтин И.В.   24.01.2008
вставлены
    {получение информации о версии программы}
    Function GetFileVersion(const FileName:String):TVersionInfo;
    {получение информации о версии в виде строки}
    Function GetFileVersionString(const FileName:String):String;
    {возващает файл в виде строки}
    function FileReadString(const FileName: String): String;
    {записать строку в файл}
    procedure FileWriteString(const FileName: String; Data: String);
    {запускаем приложение}
    function Execute(const CommandLine, WorkingDirectory : string) : integer;



*)
unit UnilWin;

interface
uses Windows, Classes;

type

  TVersionInfo = Record
    VerHigh, VerLow: Integer;
  End;

{получение информации о версии программы}
Function GetFileVersion(const FileName:String):TVersionInfo;
{получение информации о версии в виде строки}
Function GetFileVersionString(const FileName:String):String;
{возващает файл в виде строки}
function FileReadString(const FileName: String): AnsiString;
{записать строку в файл}
procedure FileWriteString(const FileName: String; Data: AnsiString);
{запускаем приложение}
function Execute(const CommandLine, WorkingDirectory : string) : integer;
{ищем файлы в директории}
function FilesInDir(sMask, sDirPath: String; var iFilesCount: Integer; var saFound: TStrings; bRecurse: Boolean = True): Integer;
// Функция проверяет разрядность EXE файлам
function GetFilePlatfotm64(aFileName: string): boolean;
{Функция возвращает суффикс к 64 разрядным EXE файлам}
function GetBinaryPlatfotmSuffics(aFileName, aSuffics: string): string;
// Функция возвращает разрядность системы
function IsWow64: Boolean;

implementation

uses SysUtils, ShellAPI, System.RegularExpressions;

function FilesInDir(sMask, sDirPath: String; var iFilesCount: Integer; var saFound: TStrings; bRecurse: Boolean = True): Integer;
var
  sr: TSearchRec;
begin
  result := 0;
  try
    if FindFirst(sDirPath + sMask, faAnyFile, sr) = 0 then
    begin
      repeat
        if  (sr.Name <> '.') and (sr.Name <> '..') and (sr.Attr and faDirectory = 0) then
        begin
          Inc(iFilesCount);
          if saFound <> nil then
             if saFound.IndexOf(sDirPath + sr.Name) < 0 then
                saFound.Add(sDirPath + sr.Name);
        end
      until
        FindNext(sr) <> 0;
      end;
    FindClose(sr);
    // Если надо идти по поддиректориям, то снимаем маску и запускаем еще разок
    if bRecurse then begin
      if FindFirst(sDirPath + '*' , faAnyFile, sr) = 0 then
      begin
        repeat
          if  (sr.Name <> '.') and (sr.Name <> '..') and (sr.Attr and faDirectory <> 0) then
              FilesInDir(sMask,sDirPath + sr.name + '\',iFilesCount,saFound,bRecurse);
        until
          FindNext(sr) <> 0;
        end;
      FindClose(sr);
    end;
  except
    Result := -1;
  end;
end;


function Execute(const CommandLine, WorkingDirectory : string) : integer;
var
  R : boolean;
  ProcessInformation : TProcessInformation;
  StartupInfo : TStartupInfo;
  S: string;
//  ExCode : integer;
begin
  Result := 0;
  FillChar(StartupInfo, sizeof(TStartupInfo), 0);
  with StartupInfo do begin
    cb := sizeof(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;
  end;
  R := CreateProcess(
    nil, // pointer to name of executable module
    PChar(CommandLine), // pointer to command line string
    nil,// pointer to process security attributes
    nil,// pointer to thread security attributes
    false, // handle inheritance flag
    0, // creation flags
    nil,// pointer to new environment block
    PChar(WorkingDirectory), // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInformation // pointer to PROCESS_INFORMATION
   );
  if not R then
    begin
           SetLength(S, 256);
           FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError, LOCALE_USER_DEFAULT, PChar(S), Length(S), nil);
           raise Exception.Create(S);
   end
end;

procedure FileWriteString(const FileName: String; Data: AnsiString);
var
  FileHandle: hFile;
  FileSize, Dummy: DWord;
  S: String;
  Buffer: PChar;
begin
  FileHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                           CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
   begin
    try
      FileSize := Length(Data);
      GetMem(Buffer, FileSize);
      Move(Data[1], Buffer^, FileSize);
      if not WriteFile(FileHandle, Buffer^, FileSize, Dummy, nil) then begin
         SetLength(S, 256);
         FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError, LOCALE_USER_DEFAULT, PChar(S), Length(S), nil);
         raise Exception.Create(S);
      end;
    finally
      CloseHandle(FileHandle);
    end
   end;
end;


function FileReadString(const FileName: String): AnsiString;
var
  FileHandle: hFile;
  FileSize, Dummy: DWord;
  Buffer: PChar;
begin
  Result := '';
  FileHandle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                           OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
   begin
    FileSize := GetFileSize(FileHandle, @Dummy);
    GetMem(Buffer, FileSize);
    try
      if ReadFile(FileHandle, Buffer^, FileSize, Dummy, nil) then
       begin
        SetLength(Result, FileSize);
        Move(Buffer^, Result[1], FileSize);
       end;
    finally
      FreeMEM(Buffer);
    end;
    CloseHandle(FileHandle);
   end;
end;

Function GetFileVersionString(const FileName:String):String;
begin
  result:='';
  with GetFileVersion(FileName) do begin
    result:= IntToStr(VerHigh shr 16)+'.'+IntToStr((VerHigh shl 16) shr 16)+'.'+
             IntToStr(VerLow shr 16)+'.'+IntToStr((VerLow shl 16) shr 16)
  end
end;

Function GetFileVersion(const FileName:String):TVersionInfo;
Var
  Dummy:DWord;
  Data:Pointer;
  VersionInfo:PVSFixedFileInfo;
  Size:Integer;
  versionName: String;
  I, J, L: Integer;
  List: TStringList;
  Res: TArray<string>;
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
Begin
  if AnsiLowerCase(ExtractFileExt(FileName)) = '.apk' then
  begin
    Result.VerHigh:=0;
    Result.VerLow:=0;
    if FileExists(ExtractFilePath(ParamStr(0)) + '\APKVersion.txt') then DeleteFile(ExtractFilePath(ParamStr(0)) + '\APKVersion.txt');

    StartInfo.wShowWindow := SW_HIDE;
    StartInfo.dwFlags := STARTF_USESHOWWINDOW;

    // Запускаем процесс получения версии apk
    // Ожидаем завершения приложения
    if CreateProcess(nil, PChar('cmd.exe /c aapt.exe dump badging ' + ExtractFileName(FileName) + ' > APKVersion.txt'), nil, nil, false,
                     CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                     PChar(ExtractFilePath(FileName)), StartInfo, ProcInfo) then
    begin
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
      // Free the Handles
      CloseHandle(ProcInfo.hProcess);
      CloseHandle(ProcInfo.hThread);
    end;

    // ShellExecute(0,'open','cmd.exe',PWideChar('/c aapt.exe dump badging ' + ExtractFileName(FileName) + ' > APKVersion.txt'), PWideChar(ExtractFileDir(ParamStr(0))), SW_HIDE);

    if FileExists(ExtractFilePath(ParamStr(0)) + '\APKVersion.txt') then
    begin
      List := TStringList.Create;
      try
        List.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\APKVersion.txt');
        if List.Count = 0 then Exit;

        Res := TRegEx.Split(List.Strings[0], ' ');
        for I := 0 to High(Res) do
          if Pos('versionname', AnsiLowerCase(Res[I])) = 1 then versionName := StringReplace(Copy(Res[I], Pos('=', Res[I]) + 1, Length(Res[I])), '''', '', [rfReplaceAll]);

        J := 0;
        Res := TRegEx.Split(versionName, '\.');
        for I := High(Res) downto 0 do
        begin
          case J of
            0 : if TryStrToInt(Res[I], L) then Result.VerLow := Result.VerLow + L;
            1 : if TryStrToInt(Res[I], L) then Result.VerLow := Result.VerLow + L * 65536;
            2 : if TryStrToInt(Res[I], L) then Result.VerHigh := Result.VerHigh + L;
            3 : if TryStrToInt(Res[I], L) then Result.VerHigh := Result.VerHigh + L * 65536;
          end;
          Inc(J);
        end;
      finally
        List.Free;
        if FileExists(ExtractFilePath(ParamStr(0)) + '\APKVersion.txt') then DeleteFile(ExtractFilePath(ParamStr(0)) + '\APKVersion.txt')
      end;
    end;
  end else
  begin
    Size:=GetFileVersionInfoSize(PChar(FileName),Dummy);
    If Size=0 Then
    Begin
      Result.VerHigh:=0;
      Result.VerLow:=0;
    End;
     GetMem(Data,Size);
    Try
      If Not GetFileVersionInfo(PChar(FileName),0,Size,Data) Then
      Begin
        Result.VerHigh:=0;
        Result.VerLow:=0;
        Exit;
      End;
      VerQueryValue(Data,'\',Pointer(VersionInfo),Dummy);
      With Result,VersionInfo^ Do
      Begin
        VerHigh:=dwFileVersionMS;
        VerLow:=dwFileVersionLS;
      End;
    Finally
      FreeMem(Data);
    End;
  end;
End;

// Функция проверяет разрядность EXE файлам
function GetFilePlatfotm64(aFileName: string): boolean;
var
  bt: Cardinal;
begin
  Result := False;
  // Если не 64 то нет смысла выполнять
  if not IsWow64 then Exit;

  // Если EXE 64 то дописуем
  if (POS('.exe', LowerCase(aFileName)) > 0) then
  begin
  if FileExists(aFileName) then
    if GetBinaryType(PWideChar(aFileName), bt) then
      if bt = 6 then Result := True;
  end;
end;

// Функция возвращает суффикс к 64 разрядным EXE файлам
function GetBinaryPlatfotmSuffics(aFileName, aSuffics: string): string;
begin
  Result := '';
  // Если не 64 то нет смысла выполнять
  if not IsWow64 then Exit;

  if aSuffics <> '' then
  begin
    if LowerCase(aSuffics) = 'win64' then Result := '.win64';
    Exit;
  end;

  // Если EXE 64 то дописуем .win64
  if GetFilePlatfotm64(aFileName) then Result := '.win64';
end;

// Функция возвращает разрядность системы
function IsWow64: Boolean;
begin
  case TOSVersion.Architecture of
    arIntelX64 : Result := True;
    ELSE Result := False;
  end;
end;

end.
