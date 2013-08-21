unit dbTest;

interface

uses TestFramework, ZConnection, ZDataset, Classes;

type

  TdbTest = class (TTestCase)
  protected
    ScriptDirectory: String;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
    // получение поличества записей
    procedure DirectoryLoad(Directory: string);
  public
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;


implementation

uses zLibUtil, SysUtils;
{ TdbTest }

function FilesInDir(sMask, sDirPath: String; var iFilesCount: Integer; var saFound: TStrings; bRecurse: Boolean = True): Integer;
var
  sr: TSearchRec;
begin
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


procedure TdbTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbTest.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

procedure TdbTest.DirectoryLoad(Directory: string);
var iFilesCount: Integer;
    saFound: TStrings;
    i: integer;
begin
  saFound := TStringList.Create;
  try
    FilesInDir('*.sql', Directory, iFilesCount, saFound);
    for I := 0 to saFound.Count - 1 do
      ExecFile(saFound[i], ZQuery);
  finally
    saFound.Free
  end;
end;

procedure TdbTest.ProcedureLoad;
var iFilesCount: Integer;
    saFound: TStrings;
    i: integer;
begin
  DirectoryLoad(ScriptDirectory);
end;

procedure TdbTest.Test;
begin

end;

end.
