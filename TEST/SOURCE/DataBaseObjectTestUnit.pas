unit DataBaseObjectTestUnit;

interface
uses TestFramework, AuthenticationUnit, ZConnection, ZDataset, ZStoredProcedure,
     Db, XMLIntf, dsdDataSetWrapperUnit;

type
  TDataBaseObjectTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    ZStoredProcedure: TZStoredProc;
    FdsdDataSetWrapper: TdsdDataSetWrapper;
    // добавление изменение пользователя
    procedure InsertUpdate_Object_User(var Id: integer; UserName, Login, Password: string; Session: string);
    //
    function Select_User: TDataSet;
    //
    function Get_User(Id: integer): IXMLDocument;
    //
    procedure DeleteObject(Id: integer);
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
    procedure Form_Test;
    procedure gpSetErased;
    procedure lpInsertUpdate_Object_Test;
    procedure lpInsertUpdate_ObjectString_Test;
  end;

implementation

uses ZDbcIntfs, SysUtils, StorageUnit, DBClient, XMLDoc, CommonDataUnit, Forms,
     Classes, UtilConvert, ZLibEx;

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
procedure TDataBaseObjectTest.DeleteObject(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Object OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Object>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.Form_Test;
const  pXML =
  '<xml Session = "%s" >' +
    '<gpInsertUpdate_Object_Form OutputType="otResult">' +
      '<inFormName  DataType="ftString"  Value="%s" />' +
      '<inFormData  DataType="ftBlob"  Value="%s" />' +
    '</gpInsertUpdate_Object_Form>' +
  '</xml>';

     pGetXML =
     '<xml Session = "%s">' +
        '<gpGet_Object_Form OutputType="otBlob">' +
           '<inFormName DataType="ftString" Value="%s"/>' +
        '</gpGet_Object_Form>' +
      '</xml>';
  var id: integer;
      FormStr: String;
      Form: TForm;
      Stream: TStringStream;
      MemoryStream: TMemoryStream;
begin
  // Нужно создать форму, сохранить ее в строку
  Form := TForm.Create(nil);
  Form.Caption := 'Проверка';
  Stream := TStringStream.Create;
  MemoryStream := TMemoryStream.Create;
  try
    MemoryStream.WriteComponent(Form);
    MemoryStream.Position := 0;
    ObjectBinaryToText(MemoryStream, Stream);
    FormStr := Stream.DataString;
  finally
    Form.Free;
    Stream.Free;
    MemoryStream.Free;
  end;
  // Строку в базу

  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [gc_User.Session, 'Form1', gfStrToXmlStr(FormStr)]));

  FormStr := TStorageFactory.GetStorage.ExecuteProc(Format(pGetXML, [gc_User.Session, 'Form1']));

  // Потом считать это все.
  Form := TForm.CreateNew(Application);
  Stream := TStringStream.Create(FormStr);
  MemoryStream := TMemoryStream.Create;
  try
    // Преобразовать текст в бинарные данные
    ObjectTextToBinary(Stream, MemoryStream);
    // Вернуть смещение
    MemoryStream.Position := 0;
    // Прочитать компонент из потока
    MemoryStream.ReadComponent(Form);
    Check (Form.Caption = 'Проверка', 'Не правильный заголовок формы');
  finally
    Form.Free;
    Stream.Free;
    MemoryStream.Free;
  end;
end;

function TDataBaseObjectTest.Get_User(Id: integer): IXMLDocument;
const
   pXML =
  '<xml Session = "%s">' +
    '<gpGet_Object_User OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</gpGet_Object_User>' +
  '</xml>';
begin
  result := LoadXMLData(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [gc_User.Session, Id])))
end;
{------------------------------------------------------------------------------}
function TDataBaseObjectTest.Select_User: TDataSet;
begin
  with FdsdDataSetWrapper do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := 'gpSelect_Object_User';
    Execute;
    result := DataSets[0].DataSet;
  end
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
  InsertUpdate_Object_User(Id, 'UserName', 'Login', 'Password', gc_User.Session);

  // Получение данных о пользователе
  with Get_User(Id).DocumentElement do
    Check((GetAttribute('id') = -1) and (GetAttribute('name') = 'UserName'), 'Не сходятся данные Id = ' + GetAttribute('id'));

  // Проверка на дублируемость
  Id := 0;
  try
    InsertUpdate_Object_User(Id, 'UserName', 'Login', 'Password', gc_User.Session);
    Check(false, 'Нет сообщения об ошибке InsertUpdate_Object_User Id=0');
  except

  end;
  // Изменение пользователя

  // Получим список пользователей
  with Select_User do
    try
      Check((RecordCount = lRecordCount + 1), 'Количество записей не изменилось');
    finally
       Free;
    end;

  DeleteObject(-1);

end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.TearDown;
begin
  inherited;
  ZConnection.Rollback;
  ZConnection.Connected := false;
  ZConnection.Free;
  ZQuery.Free;
  ZStoredProcedure.Free;
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
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ',gc_User);
  ZConnection.StartTransaction;
  FdsdDataSetWrapper := TdsdDataSetWrapper.Create(nil);
end;
{------------------------------------------------------------------------------}
initialization
  TestFramework.RegisterTest('DataBaseObjectTest', TDataBaseObjectTest.Suite);

end.
