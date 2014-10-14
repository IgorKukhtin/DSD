unit ContactPersonTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TContactPersonTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TContactPerson = class(TObjectTest)
     function InsertDefault: integer; override;
  public
    function InsertUpdateContactPerson(Id, Code: Integer;
       Name, Phone, Mail, Comment: String; ObjectId, ContactPersonKindId: Integer): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TContactPersonTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPerson\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPersonKind\';
  inherited;
end;

procedure TContactPersonTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContactPerson;
begin
  ObjectTest := TContactPerson.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Единицы измерения
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Единице измерения
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Иванов'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TContactPerson}
constructor TContactPerson.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ContactPerson';
  spSelect := 'gpSelect_Object_ContactPerson';
  spGet := 'gpGet_Object_ContactPerson';
end;

function TContactPerson.InsertDefault: integer;
var
   vbObjectId, vbContactPersonKindId: Integer;
begin
  vbObjectId := TJuridical.Create.GetDefault;
  vbContactPersonKindId := 0;
  result := InsertUpdateContactPerson(0, -11, 'Иванов', 'Телефон', 'none@none.com',
            'Comment', vbObjectId, vbContactPersonKindId);
end;

function TContactPerson.InsertUpdateContactPerson;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inPhone', ftString, ptInput, Phone);
  FParams.AddParam('inMail', ftString, ptInput, Mail);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inObjectId', ftInteger, ptInput, ObjectId);
  FParams.AddParam('inContactPersonKindId', ftInteger, ptInput, ContactPersonKindId);
  result := InsertUpdate(FParams);
end;


initialization
  TestFramework.RegisterTest('Объекты', TContactPersonTest.Suite);


end.
