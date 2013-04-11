unit DataBaseObjectTestUnit;

interface
uses TestFramework, AuthenticationUnit, ZConnection, ZDataset, ZStoredProcedure,
     Db, XMLIntf, dsdDataSetWrapperUnit;

type

  TObjectTest = class
  private
    FspInsertUpdate: string;
    FspSelect: string;
    FspGet: string;
    FdsdStoredProc: TdsdStoredProc;
  protected
    FParams: TdsdParams;
    property spGet: string read FspGet write FspGet;
    property spSelect: string read FspSelect write FspSelect;
    property spInsertUpdate: string read FspInsertUpdate write FspInsertUpdate;
    function InsertUpdate(dsdParams: TdsdParams): Integer;
    function InsertDefault: integer; virtual; abstract;
  public
    function GetDefault: integer;
    function GetDataSet: TDataSet;
    function GetRecord(Id: integer): TDataSet;
    constructor Create; virtual;
    destructor Destoy;
  end;

  TCurrencyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    constructor Create; override;
  end;

  TUserTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
    constructor Create; override;
  end;

  TCashTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateCash(const Id: integer; CashName: string; CurrencyId: Integer; BranchId: integer): integer;
    constructor Create; override;
  end;

  TCustomDataBaseObjectTest = class (TTestCase)
  protected
    // Удаление объекта
    procedure DeleteObject(Id: integer);
    // получение поличества записей
    function GetRecordCount(ObjectTest: TObjectTest): integer;
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  end;

  TDataBaseObjectTest = class (TCustomDataBaseObjectTest)
  published
    procedure User_Test;
    procedure Cash_Test;
    procedure Form_Test;
  end;

implementation

uses ZDbcIntfs, SysUtils, StorageUnit, DBClient, XMLDoc, CommonDataUnit, Forms,
     Classes, UtilConvert, ZLibEx, UtilUnit;


{ TObjectTest }

constructor TObjectTest.Create;
begin
  FdsdStoredProc := TdsdStoredProc.Create(nil);
  FParams := TdsdParams.Create(TdsdParam);
end;

destructor TObjectTest.Destoy;
begin
  FdsdStoredProc.Free
end;

function TObjectTest.GetDataSet: TDataSet;
begin
  with FdsdStoredProc do begin
    if (DataSets.Count = 0) or not Assigned(DataSets[0].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspSelect;
    OutputType := otDataSet;
    Params.Clear;
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.GetDefault: integer;
begin
  if GetDataSet.RecordCount > 0 then
     result := GetDataSet.FieldByName('Id').AsInteger
  else
     result := InsertDefault;
end;

function TObjectTest.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.InsertUpdate(dsdParams: TdsdParams): Integer;
begin
  with FdsdStoredProc do begin
    StoredProcName := FspInsertUpdate;
    OutputType := otResult;
    Params.Assign(dsdParams);
    Execute;
    Result := StrToInt(ParamByName('ioId').Value);
  end;
end;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.Cash_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCashTest;
begin
  ObjectTest := TCashTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка кассы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о кассе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'Главная касса'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

    // Получим список касс
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), 'Количество записей не изменилось');
  finally
    DeleteObject(Id);
  end;
end;

procedure TCustomDataBaseObjectTest.DeleteObject(Id: integer);
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
{------------------------------------------------------------------------------}
function TCustomDataBaseObjectTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin
  Result := ObjectTest.GetDataSet.RecordCount;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseObjectTest.User_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUserTest;
begin
  ObjectTest := TUserTest.Create;
  // Получим список пользователей
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка пользователя
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о пользователе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'UserName'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
    // Проверка на дублируемость
    try
      ObjectTest.InsertUpdateUser(0, 'UserName', 'Login', 'Password');
      Check(false, 'Нет сообщения об ошибке InsertUpdate_Object_User Id=0');
    except

    end;
    // Изменение пользователя

    // Получим список пользователей
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), 'Количество записей не изменилось');
  finally
    DeleteObject(Id);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomDataBaseObjectTest.TearDown;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TCustomDataBaseObjectTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;
{------------------------------------------------------------------------------}

{ TCurrencyTest }

constructor TCurrencyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Currency';
  spSelect := 'gpSelect_Object_Currency';
  spGet := 'gpGet_Object_Currency';
end;

function TCurrencyTest.InsertDefault: integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('inCurrencyCode', ftInteger, ptInput, 920);
  FParams.AddParam('inCurrencyName', ftString, ptInput, 'GRN');
  FParams.AddParam('inFullName', ftString, ptInput, 'Гривна');
  result := InsertUpdate(FParams);
end;

{ TUserTest }

constructor TUserTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_User';
  spSelect := 'gpSelect_Object_User';
  spGet := 'gpGet_Object_User';
end;

function TUserTest.InsertDefault: integer;
begin
  result := InsertUpdateUser(0, 'UserName', 'Login', 'Password');
end;

function TUserTest.InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inUserName', ftString, ptInput, UserName);
  FParams.AddParam('inLogin', ftString, ptInput, Login);
  FParams.AddParam('inPassword', ftString, ptInput, Password);
  result := InsertUpdate(FParams);
end;

{ TCashTest }

constructor TCashTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_Cash';
  spSelect := 'gpSelect_Object_Cash';
  spGet := 'gpGet_Object_Cash';
end;

function TCashTest.InsertDefault: integer;
var CurrencyId: Integer;
begin
  with TCurrencyTest.Create do
  try
    CurrencyId := GetDefault
  finally
    Free;
  end;
  result := InsertUpdateCash(0, 'Главная касса', CurrencyId, 0);
end;

function TCashTest.InsertUpdateCash(const Id: integer; CashName: string;
  CurrencyId, BranchId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCashName', ftString, ptInput, CashName);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, BranchId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('DataBaseObjectTest', TDataBaseObjectTest.Suite);

end.
