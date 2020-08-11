unit UScriptFiles;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.IOUtils,
  UDefinitions;

type
  TScriptFiles = class
  strict private
    FMsgProc: TNotifyMessage;
    FShortNames: TStringList;
    FFileNames: TStringList;
    FScriptContent: TStringList;
    FFilesUsed: string; // список тех скриптов, которые будем применять
    FFilesUsedArr: TStringDynArray;
  strict private
    procedure EnumFiles(const AScriptPath: string);
    procedure LogMsg(const AMsg: string);
    procedure SetFilesUsed(const AValue: string);
  strict private
    function GetShortNames: TStrings;
    function GetScriptContent: TStrings;
    function GetFileContent(const AFileName: string): string;
    function MakeFilesUsedArray(const AFileList: string): TStringDynArray;
  public
    constructor Create(const AScriptPath, AFilesUsed: string; AMsgProc: TNotifyMessage);
    destructor Destroy; override;
    property ScriptContent: TStrings read GetScriptContent;
    property ShortNames: TStrings read GetShortNames;
    property FilesUsed: string read FFilesUsed write SetFilesUsed;
  end;

implementation

uses
  UConstants;

{ TScriptFiles }

constructor TScriptFiles.Create(const AScriptPath, AFilesUsed: string; AMsgProc: TNotifyMessage);
begin
  inherited Create;

  FMsgProc := AMsgProc;
  FFilesUsed  := AFilesUsed; // из всех имеющихся в каталоге скриптов будем применять только эти

  FShortNames    := TStringList.Create;
  FFileNames     := TStringList.Create;
  FScriptContent := TStringList.Create;

  EnumFiles(AScriptPath);
end;

destructor TScriptFiles.Destroy;
begin
  FreeAndNil(FShortNames);
  FreeAndNil(FFileNames);
  FreeAndNil(FScriptContent);
  inherited;
end;

procedure TScriptFiles.EnumFiles(const AScriptPath: string);
var
  I, J: Integer;
  arrFiles: TStringDynArray;
  searchOpt: TSearchOption;
  fileMask, sShortName: string;
begin
  try
    FFilesUsedArr := MakeFilesUsedArray(FFilesUsed); // массив коротких имен файлов, которые определены пользователем для выполнения

    searchOpt := TSearchOption.soAllDirectories;
    fileMask  := '*.sql';
    arrFiles  := TDirectory.GetFiles(AScriptPath, fileMask, searchOpt); // массив всех файлов, которые есть в директории AScriptPath

    // если в Настройках пользователь сохранил имена скриптов, которые нужно выполнить
    if Length(FFilesUsedArr) > 0 then
      for I := Low(arrFiles) to High(arrFiles) do
        for J := Low(FFilesUsedArr) to High(FFilesUsedArr) do
        begin
          sShortName := ExtractFileName(arrFiles[I]);
          if sShortName = FFilesUsedArr[J] then
          begin
            FFileNames.Add(arrFiles[I]);
            FShortNames.Add(sShortName);
          end;
        end;

    // если в Настройках нет сохраненных имен скриптов, тогда берем все файлы из директории AScriptPath
    if Length(FFilesUsedArr) = 0 then
      for I := Low(arrFiles) to High(arrFiles) do
      begin
        FFileNames.Add(arrFiles[I]);
        FShortNames.Add(ExtractFileName(arrFiles[I]));
      end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TScriptFiles.GetScriptContent: TStrings;
var
  I: Integer;
  sScriptSQL: string;
begin
  Result := FScriptContent;
  Assert(FScriptContent <> nil, 'Ожидается FScriptContent <> nil');

  try
    Result.Clear;

    for I := 0 to Pred(FFileNames.Count) do
    begin
      sScriptSQL := GetFileContent(FFileNames[I]);
       if Length(Trim(sScriptSQL)) > 0 then
         Result.Add(sScriptSQL);
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TScriptFiles.GetFileContent(const AFileName: string): string;
var
  tmpFS: TFileStream;
  tmpBuffer: TBytes;
  tmpEncoding: TEncoding;
  lenEncPreamble: Integer;
const
  cErrFileNotExits = 'Файл %s не существует';
begin
  Result := '';

  try
    if FileExists(AFileName) then
    begin
      tmpFS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
      try
        tmpFS.Position := 0;
        SetLength(tmpBuffer, tmpFS.Size);
        tmpFS.ReadBuffer(Pointer(tmpBuffer)^, tmpFS.Size);
        tmpEncoding := nil; // из Справки: "Note: The AEncoding parameter should have the value NIL, otherwise its value is used to detect the encoding."
        lenEncPreamble := TEncoding.GetBufferEncoding(tmpBuffer, tmpEncoding); // Return Value of GetBufferEncoding is the length of the preamble in the Buffer of bytes.
        Result := tmpEncoding.GetString(tmpBuffer, lenEncPreamble, Length(tmpBuffer) - lenEncPreamble);
      finally
        FreeAndNil(tmpFS);
      end;
    end
    else
      raise Exception.CreateFmt(cErrFileNotExits, [AFileName]);
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TScriptFiles.GetShortNames: TStrings;
begin
  Result := FShortNames;
end;

procedure TScriptFiles.LogMsg(const AMsg: string);
begin
  if Assigned(FMsgProc) then FMsgProc(AMsg);
end;

function TScriptFiles.MakeFilesUsedArray(const AFileList: string): TStringDynArray;
var
  I: Integer;
  tmpSL: TStringList;
begin
  SetLength(Result, 0);

  tmpSL := TStringList.Create;
  try
    tmpSL.CommaText := AFileList;
    SetLength(Result, tmpSL.Count);

    for I := Low(Result) to High(Result) do
      Result[I] := Trim(tmpSL[I]);
  finally
    FreeAndNil(tmpSL);
  end;
end;

procedure TScriptFiles.SetFilesUsed(const AValue: string);
begin
  FFilesUsed := StringReplace(AValue, ' ', '', [rfIgnoreCase, rfReplaceAll]);
  FFilesUsed := StringReplace(FFilesUsed, #13#10, '', [rfIgnoreCase, rfReplaceAll]);
end;

end.
