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
unit FMX.UnilWin;

interface
uses System.Classes, System.IOUtils, FMX.DialogService, System.ZLib,
     {$IFDEF MSWINDOWS} System.Win.ComObj, Winapi.ActiveX, Winapi.Windows, Winapi.ShellAPI, Winapi.Messages, {$ENDIF}
     {$IFDEF LINUX} FMX.frxLinuxFonts, FMUX.Api, {$ENDIF}
     {$IF DEFINED(MACOS) and not DEFINED(IOS)} Macapi.AppKit, Macapi.Foundation, {$ENDIF}
     {$IF DEFINED(ANDROID)}Androidapi.JNI.JavaTypes, Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
     Androidapi.JNI.Webkit, Androidapi.JNI.Net, Androidapi.JNI.Support, Androidapi.JNI.App, {$ENDIF}
     {$IF DEFINED(IOS)} FMX.iOS.UExternalFileViewer, {$ENDIF}
     System.SysUtils;

type

  TVersionInfo = Record
    VerHigh, VerLow: Integer;
  End;

{Открытие файла программой по умолчанию}
procedure ShellExecute(fName: String);
{Процедура по символьно переводит строку в набор цифр}
function ConvertConvert(Stream: TStream): String;
{Процедура по символьно переводит набор цифр в поток}
procedure ReConvertConvertStream(S: String; Stream: TStream);
// Процедура по символьно переводит набор цифр в битовій массив
function ReConvertConvertBute(S: String) : TBytes;
{Вырезает дату из Stream}
function StreamToString(Stream: TStream): String;
{получение информации о версии программы}
Function GetFileVersion(const FileName:String):TVersionInfo;
{получение информации о версии в виде строки}
Function GetFileVersionString(const FileName:String):String;
{возващает файл в виде строки}
function FileReadString(const FileName: String): String;
{записать строку в файл}
procedure FileWriteString(const FileName: String; Data: TBytes);
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

uses System.RegularExpressions;

{Открытие файла программой по умолчанию}
{$IFDEF MSWINDOWS}
procedure ShellExecute(fName: String);
begin
  Winapi.ShellAPI.ShellExecute(0, 'open', PChar(fName), '', '', 1);
end;
{$ENDIF}

{$IF DEFINED(MACOS) and not DEFINED(IOS)}
procedure ShellExecute(fName: String);
var
  wspace: NSWorkspace;
begin
  wspace := TNSWorkspace.Create;
  try
    if FileExists(fName) then
      wspace.openFile(NSSTR(fName));
  finally
    wspace.release;
  end;
end;
{$ENDIF}

{$IF DEFINED(IOS)}
procedure ShellExecute(fName: String);
var
  FileViewer: TiOSExternalFileViewer;
begin
  FileViewer := TiOSExternalFileViewer.Create(Nil);
  try
    FileViewer.OpenFile(fName);
  finally
    FileViewer.Free;
  end;
end;
{$ENDIF}

{$IF DEFINED(ANDROID)}
procedure ShellExecute(fName: String);
var
  intent: JIntent;
  ExtFile: string;
  ExtToMime: JString;
  DataFile: JFile;
  URI: Jnet_Uri;
begin
  ExtFile := AnsiLowerCase(StringReplace(TPath.GetExtension(fName), '.', '',[]));
  ExtToMime := TJMimeTypeMap.JavaClass.getSingleton.getMimeTypeFromExtension(StringToJString(ExtFile));

  DataFile := TJfile.JavaClass.init(StringToJstring(fName));
  URI := TAndroidHelper.JFileToJURI(DataFile);

  Intent := TJIntent.Create();
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  Intent.setDataAndType(URI, ExtToMime);
  TAndroidHelper.Activity.startActivity(Intent);
end;
{$ENDIF}

{$IFDEF LINUX}
procedure ShellExecute(fName: String);
begin
  FmuxOpenFile(PChar(fName));
end;
{$ENDIF}

// Процедура по символьно переводит строку в набор цифр
function ConvertConvert(Stream: TStream): String;
var i: integer;
    SS: TBytesStream;
begin
  SS := TBytesStream.Create;
  try
    Stream.Position := 0;
    ZCompressStream(Stream, SS);
    result := '';
    for I := 0 to SS.Size - 1 do
      result := result + IntToHex(byte(SS.Bytes[i]),2);
  finally
    SS.Free;
  end;
end;

{Процедура по символьно переводит набор цифр в поток}
procedure ReConvertConvertStream(S: String; Stream: TStream);
var i: integer; B: TBytes; SS: TBytesStream;
begin
  SetLength(B, Length(S) div 2);
  for i := 0 to High(B) do
     B[i] := StrToInt('$' + s[i * 2 + 1] + s[i * 2 + 2]);

  SS := TBytesStream.Create(B);
  try
    SS.Position := 0;
    ZDecompressStream(SS, Stream);
  finally
    SS.Free;
  end;
end;

// Процедура по символьно переводит набор цифр в битовій массив
function ReConvertConvertBute(S: String) : TBytes;
var i: integer; B: TBytes;
begin
  SetLength(B, Length(S) div 2);
  for i := 0 to High(B) do
     B[i] := StrToInt('$' + s[i * 2 + 1] + s[i * 2 + 2]);

  ZDecompress(B, Result);
end;

// Вырезает дату из Stream
function StreamToString(Stream: TStream): String;
begin
    with TStringStream.Create('') do
    try
        CopyFrom(Stream, Stream.Size - Stream.Position);
        Result := DataString;
    finally
        Free;
    end;
end;

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
{$IFDEF MSWINDOWS}
var
  R : boolean;
  ProcessInformation : TProcessInformation;
  StartupInfo : TStartupInfo;
  S: string;
{$ENDIF}
//  ExCode : integer;
begin
  Result := 0;
{$IFDEF MSWINDOWS}
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
{$ENDIF}
end;

procedure FileWriteString(const FileName: String; Data: TBytes);
var
  Str: TBytesStream;
begin
  Str := TBytesStream.Create(Data);
  try
    Str.SaveToFile(FileName);
  finally
    Str.Free;
  end;
end;


function FileReadString(const FileName: String): String;
var
  Str: TStringStream;
begin
  Result := '';
  Str := TStringStream.Create;
  try
    Str.LoadFromFile(FileName);
    Result := Str.DataString;
  finally
    Str.Free;
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
{$IFDEF MSWINDOWS}
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
{$ENDIF}
Begin
{$IFDEF MSWINDOWS}
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
{$ENDIF}
End;

// Функция проверяет разрядность EXE файлам
function GetFilePlatfotm64(aFileName: string): boolean;
{$IFDEF MSWINDOWS}
var
  bt: Cardinal;
{$ENDIF}
begin
  Result := False;
{$IFDEF MSWINDOWS}
  // Если не 64 то нет смысла выполнять
  if not IsWow64 then Exit;

  // Если EXE 64 то дописуем
  if (POS('.exe', LowerCase(aFileName)) > 0) then
  begin
  if FileExists(aFileName) then
    if GetBinaryType(PWideChar(aFileName), bt) then
      if bt = 6 then Result := True;
  end;
{$ENDIF}
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

