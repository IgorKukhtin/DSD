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
  strict private
    procedure EnumFiles(const AScriptPath: string);
    procedure LogMsg(const AMsg: string);
  strict private
    function GetShortNames: TStrings;
    function GetFileContent(const AFileName: string): string;
  public
    constructor Create(const AScriptPath: string; AMsgProc: TNotifyMessage);
    destructor Destroy; override;
    property ShortNames: TStrings read GetShortNames;
    function GetScriptContent(AFiles: TStrings): TStrings;
  end;

implementation

uses
  UConstants;

{ TScriptFiles }

constructor TScriptFiles.Create(const AScriptPath: string; AMsgProc: TNotifyMessage);
begin
  inherited Create;

  FMsgProc := AMsgProc;

  FShortNames    := TStringList.Create;
  FFileNames     := TStringList.Create;
  FScriptContent := TStringList.Create;

  EnumFiles(IncludeTrailingPathDelimiter(AScriptPath));
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
  I, iRootLen: Int64;
  arrFiles: TStringDynArray;
  searchOpt: TSearchOption;
  fileMask, sShortName: string;
begin
  try
    searchOpt := TSearchOption.soAllDirectories;
    fileMask  := '*.sql';
    arrFiles  := TDirectory.GetFiles(AScriptPath, fileMask, searchOpt); // массив всех файлов, которые есть в директории AScriptPath

    for I := Low(arrFiles) to High(arrFiles) do
    begin
      FFileNames.Add(arrFiles[I]);
      // В качестве короткого имени файла берем имя файла до последней папки, указанной в AScriptPath
      // Например, AScriptPath = C:\Test\Scripts, тогда полный путь C:\Test\Scripts\app_procedures\sample.sql
      // В качестве короткого имени берем 'app_procedures\sample.sql'
      iRootLen := Length(AScriptPath);
      sShortName := Copy(arrFiles[I], iRootLen + 1, Length(arrFiles[I]) - iRootLen);
      FShortNames.Add(sShortName);
    end;
  except
    on E: Exception do
      LogMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TScriptFiles.GetScriptContent(AFiles: TStrings): TStrings;
var
  I, J: Int64;
  sScriptSQL, sFileName: string;
begin
  Result := FScriptContent;
  Assert(FScriptContent <> nil, 'Ожидается FScriptContent <> nil');

  // AFiles содержит пары вида '1=app_procedures\file.sql'

  try
    Result.Clear;

    for I := 0 to Pred(AFiles.Count) do
    begin
      // получим имя файла из пары '1=app_procedures\file.sql'
      sFileName := AFiles.Values[AFiles.Names[I]];
      // найдем такое же имя в FShortNames
      for J := 0 to Pred(FShortNames.Count) do
        if LowerCase(sFileName) = LowerCase(FShortNames[J]) then
        begin
          sScriptSQL := GetFileContent(FFileNames[J]);
          if Length(Trim(sScriptSQL)) > 0 then
            Result.Add(sScriptSQL);
          Break;
        end;
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
  lenEncPreamble: Int64;
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


end.
