unit DataBaseObjectTestUnit;

interface
uses TestFramework, AuthenticationUnit, ZConnection, ZDataset, ZStoredProcedure,
     Db, XMLIntf;

type
  TDataBaseObjectTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ZStoredProcedure: TZStoredProc;
    lUser: TUser;
    // добавление изменение пользователя
    procedure InsertUpdate_Object_User(var Id: integer; UserName, Login, Password: string; Session: string);
    //
    function Select_User: TDataSet;
    //
    function Get_User(Id: integer): IXMLDocument;
    // добавляет или изменяет данные об объекте
    function lpInsertUpdate_Object(Id, DescId, ObjectCode: integer; ValueData: String): Variant;
    // добавляет или изменяет строковое данное об объекте
    procedure lpInsertUpdate_ObjectString(DescId, ObjectId: integer; ValueData: String);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure User_Test;
    procedure gpSetErased;
    procedure lpInsertUpdate_Object_Test;
    procedure lpInsertUpdate_ObjectString_Test;
  end;

implementation

uses ZDbcIntfs, SysUtils, StorageUnit, DBClient, XMLDoc;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.gpSetErased;
begin

end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.InsertUpdate_Object_User(var Id: integer; UserName, Login,
  Password: string; Session: string);
const
  pXML =
  '<xml Session = "%s" >' +
    '<gpInsertUpdate_Object_User OutputType="otResult">' +
      '<ioId        DataType="ftInteger" Value="%d" />' +
      '<inUserName  DataType="ftString"  Value="%s" />' +
      '<inLogin     DataType="ftString"  Value="%s" />' +
      '<inPassword  DataType="ftString"  Value="%s" />' +
    '</gpInsertUpdate_Object_User>' +
  '</xml>';
begin
  with LoadXMLData(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Session, Id, UserName, Login, Password]))).DocumentElement do
       Id := GetAttribute('ioid');
end;
{------------------------------------------------------------------------------}
function TDataBaseObjectTest.lpInsertUpdate_Object(Id, DescId,
  ObjectCode: integer; ValueData: String): Variant;
begin
  ZStoredProcedure.StoredProcName := 'lpInsertUpdate_Object';
  ZStoredProcedure.Params.Clear;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'ioId', ptInputOutput).Value := Id;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inDescId', ptInput).Value := DescId;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inObjectCode', ptInput).Value := ObjectCode;
  ZStoredProcedure.Params.CreateParam(ftString, 'inValueData', ptInput).Value := ValueData;
  ZStoredProcedure.ExecProc;
  result := ZStoredProcedure.Params.ParamByName('ioId').Value;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdate_ObjectString(DescId,
  ObjectId: integer; ValueData: String);
begin
  ZStoredProcedure.StoredProcName := 'lpInsertUpdate_ObjectString';
  ZStoredProcedure.Params.Clear;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inDescId', ptInput).Value := DescId;
  ZStoredProcedure.Params.CreateParam(ftInteger, 'inObjectId', ptInput).Value := ObjectId;
  ZStoredProcedure.Params.CreateParam(ftString, 'inValueData', ptInput).Value := ValueData;
  ZStoredProcedure.ExecProc;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdate_ObjectString_Test;
var
  ObjectId: integer;
begin
  ObjectId := lpInsertUpdate_Object(-1, 1, 45454545, 'test');
  lpInsertUpdate_ObjectString(1, ObjectId, 'test');
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.lpInsertUpdate_Object_Test;
var
  Id: integer;
begin
  lpInsertUpdate_Object(0, 1, 45454545, 'test');
  lpInsertUpdate_Object(-1, 1, 45454545, 'test');
  Id := lpInsertUpdate_Object(-1, 1, 45454545, 'test');

  Check(Id = -1, IntToStr(Id));
end;
{------------------------------------------------------------------------------}
function TDataBaseObjectTest.Get_User(Id: integer): IXMLDocument;
const
   pXML =
  '<xml Session = "%s">' +
    '<gpGet_User OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</gpGet_User>' +
  '</xml>';
begin
  result := LoadXMLData(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [lUser.Session, Id])))
end;
{------------------------------------------------------------------------------}
function TDataBaseObjectTest.Select_User: TDataSet;
const
   pXML =
  '<xml Session = "%s" >' +
    '<gpSelect_User OutputType="otDataSet"/>' +
  '</xml>';
begin
  result := TClientDataSet.Create(nil);
  TClientDataSet(result).XMLData := TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [lUser.Session]));
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.User_Test;
var Id: integer;
    lRecordCount: Integer;
begin
  // Получим список пользователей
  with Select_User do
    try
      lRecordCount := RecordCount;
    finally
       Free;
    end;
  Id := -1;
  // Вставка пользователя
  InsertUpdate_Object_User(Id, 'UserName', 'Login', 'Password', lUser.Session);

  // Получение данных о пользователе
  with Get_User(Id).DocumentElement do
    Check((GetAttribute('id') = -1) and (GetAttribute('name') = 'UserName'), 'Не сходятся данные Id = ' + GetAttribute('id'));

  // Проверка на дублируемость
  Id := 0;
  InsertUpdate_Object_User(Id, 'UserName', 'Login', 'Password', lUser.Session);
  Check(false, 'Нет сообщения об ошибке InsertUpdate_Object_User Id=0');

  // Изменение пользователя

  // Получим список пользователей
  with Select_User do
    try
      Check((RecordCount = lRecordCount + 1), 'Количество записей не изменилось');
    finally
       Free;
    end;

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
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', lUser);
  ZConnection.StartTransaction;

end;
{------------------------------------------------------------------------------}
initialization
  TestFramework.RegisterTest('DataBaseObjectTest', TDataBaseObjectTest.Suite);

end.
