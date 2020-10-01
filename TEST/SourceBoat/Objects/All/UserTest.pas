unit UserTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TUserTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TUser = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id, Code: integer; UserName, Password, PrinterName : string; MemberId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;

{ TUserTest }

constructor TUser.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_User';
  spSelect := 'gpSelect_Object_User';
  spGet := 'gpGet_Object_User';
end;

function TUser.InsertDefault: integer;
begin
  result := InsertUpdateUser(0, -2, 'UserName', 'Password', 'PrinterName', 0);
  inherited;
end;

function TUser.InsertUpdateUser(const Id, Code: integer; UserName, Password, PrinterName: string; MemberId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inUserName', ftString, ptInput, UserName);
  FParams.AddParam('inPassword', ftString, ptInput, Password);
  FParams.AddParam('inPrinterName', ftString, ptInput, PrinterName);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, 0);
  result := InsertUpdate(FParams);

end;

procedure TUserTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\User\';
  inherited;
end;

 procedure TUserTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUser;
begin
  ObjectTest := TUser.Create;
  // Получим список пользователей
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка пользователя
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о пользователе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'UserName'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
    // Получим список пользователей
    Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  TestFramework.RegisterTest('Объекты', TUserTest.Suite);
end.
