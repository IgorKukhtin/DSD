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
    //
    procedure FileLoad(FileName: string);
  public
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  var
    // Список добавленных Id
    InsertedIdObjectList: TStringList;
    // Список добавленных дефолтов
    DefaultValueList: TStringList;
      // Список добавленных Id
    InsertedIdMovementItemList: TStringList;
      // Список добавленных Id
    InsertedIdMovementList: TStringList;


implementation

uses zLibUtil, SysUtils, ObjectTest, UnilWin;
{ TdbTest }

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
  if Assigned(InsertedIdMovementItemList) then
     with TMovementItemTest.Create do
       while InsertedIdMovementItemList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementItemList[0]));

  if Assigned(InsertedIdMovementList) then
     with TMovementTest.Create do
       while InsertedIdMovementList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementList[0]));

  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectList[0]));

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
    TStringList(saFound).Sort;
    for I := 0 to saFound.Count - 1 do
      ExecFile(saFound[i], ZQuery);
  finally
    saFound.Free
  end;
end;

procedure TdbTest.FileLoad(FileName: string);
begin
  ExecFile(FileName, ZQuery);
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

initialization

  InsertedIdObjectList := TStringList.Create;
  InsertedIdObjectList.Sorted := true;

  DefaultValueList := TStringList.Create;

  InsertedIdMovementItemList := TStringList.Create;
  InsertedIdMovementItemList.Sorted := true;;

  InsertedIdMovementList := TStringList.Create;
  InsertedIdMovementList.Sorted := true;

end.
