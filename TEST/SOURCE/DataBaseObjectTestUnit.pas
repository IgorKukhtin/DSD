unit DataBaseObjectTestUnit;

interface
uses TestFramework, ZConnection, ZDataset, ZStoredProcedure;

type
  TDataBaseObjectTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ZStoredProcedure: TZStoredProc;
    // добавление изменение пользователя
    procedure InsertUpdateUser(var Id: integer; UserName, Login, Password: string);
    // добавляет или изменяет данные об объекте
    function lpInsertUpdateObject(Id, DescId, ObjectCode: integer; ValueData: String): Variant;
    // добавляет или изменяет строковое данное об объекте
    procedure lpInsertUpdateObjectString(DescId, ObjectId: integer; ValueData: String);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure UserTest;
    procedure gpSetErased;
    procedure lpInsertUpdateObjectTest;
    procedure lpInsertUpdateObjectStringTest;
  end;

implementation

uses ZDbcIntfs, Db, SysUtils;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.gpSetErased;
begin

end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.InsertUpdateUser(var Id: integer; UserName, Login,
  Password: string);
begin
  ZStoredProcedure.StoredProcName := 'gpInsertUpdateUser';
  ZStoredProcedure.Params.Clear;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'ioId', ptInputOutput).Value := Id;
  ZStoredProcedure.Params.CreateParam(ftString, 'inUserName', ptInput).Value := UserName;
  ZStoredProcedure.Params.CreateParam(ftString, 'inLogin', ptInput).Value := Login;
  ZStoredProcedure.Params.CreateParam(ftString, 'inPassword', ptInput).Value := Password;
  ZStoredProcedure.ExecProc;
  Id := ZStoredProcedure.Params.ParamByName('ioId').Value;
end;
{------------------------------------------------------------------------------}
function TDataBaseObjectTest.lpInsertUpdateObject(Id, DescId,
  ObjectCode: integer; ValueData: String): Variant;
begin
  ZStoredProcedure.StoredProcName := 'lpInsertUpdateObject';
  ZStoredProcedure.Params.Clear;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'ioId', ptInputOutput).Value := Id;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inDescId', ptInput).Value := DescId;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inObjectCode', ptInput).Value := ObjectCode;
  ZStoredProcedure.Params.CreateParam(ftString, 'inValueData', ptInput).Value := ValueData;
  ZStoredProcedure.ExecProc;
  result := ZStoredProcedure.Params.ParamByName('ioId').Value;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdateObjectString(DescId,
  ObjectId: integer; ValueData: String);
begin
  ZStoredProcedure.StoredProcName := 'lpInsertUpdateObjectString';
  ZStoredProcedure.Params.Clear;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inDescId', ptInput).Value := DescId;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inObjectId', ptInput).Value := ObjectId;
  ZStoredProcedure.Params.CreateParam(ftString, 'inValueData', ptInput).Value := ValueData;
  ZStoredProcedure.ExecProc;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdateObjectStringTest;
var
  ObjectId: integer;
begin
  ObjectId := lpInsertUpdateObject(-1, 1, 45454545, 'test');
  lpInsertUpdateObjectString(1, ObjectId, 'test');
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdateObjectTest;
var
  Id: integer;
begin
  lpInsertUpdateObject(0, 1, 45454545, 'test');
  lpInsertUpdateObject(-1, 1, 45454545, 'test');
  Id := lpInsertUpdateObject(-1, 1, 45454545, 'test');

  Check(Id = -1, IntToStr(Id));
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.UserTest;
var Id: integer;
begin
  Id := -1;

  // Вставка пользователя
  InsertUpdateUser(Id, 'UserName', 'Login', 'Password');

  Check(Id = -1);

  // Изменение пользователя

end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.TearDown;
begin
  inherited;
  ZConnection.Rollback;
  ZConnection.Connected := false;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.SetUp;
begin
  inherited;
  ZConnection := TZConnection.Create(nil);
  ZConnection.HostName := 'localhost';
  ZConnection.Port := 5432;
  ZConnection.Protocol := 'postgresql-9';
  ZConnection.User := 'postgres';
  ZConnection.Database := 'dsd';
  ZConnection.TransactIsolationLevel := tiSerializable;
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZStoredProcedure := TZStoredProc.Create(nil);
  ZQuery.Connection := ZConnection;
  ZStoredProcedure.Connection := ZConnection;
  ZConnection.AutoCommit := true;
  ZConnection.StartTransaction;
end;
{------------------------------------------------------------------------------}
initialization
  TestFramework.RegisterTest('DataBaseObjectTest', TDataBaseObjectTest.Suite);

end.
