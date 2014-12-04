unit ContactPersonTest;

interface

uses dbTest, dbObjectTest, ObjectTest, DB;

type

  TContactPersonTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TContactPerson = class(TObjectTest)
     function InsertDefault: integer; override;
  public
    FContactPersonKindId: Integer;
    FPartnerId: Integer;
    function GetRecord(Id: integer): TDataSet; override;
    function InsertUpdateContactPerson(Id, Code: Integer;
       Name, Phone, Mail, Comment: String; ObjectId, ContactPersonKindId: Integer): integer;
    constructor Create; override;
  end;


implementation

uses DBClient, dsdDB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TContactPersonTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPerson\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPersonKind\';
  inherited;
  FileLoad(ProcessPath + 'OBJECT\ContactPerson.sql');
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

function TContactPerson.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Params.AddParam('inPartnerId', ftInteger, ptInput, FPartnerId);
    Params.AddParam('inContactPersonKindId', ftInteger, ptInput, FContactPersonKindId);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TContactPerson.InsertDefault: integer;
begin
  FPartnerId := TJuridical.Create.GetDefault;
  FContactPersonKindId := 0;
  result := InsertUpdateContactPerson(0, -11, 'Иванов', 'Телефон', 'none@none.com',
            'Comment', FPartnerId, FContactPersonKindId);
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
  FParams.AddParam('inObjectId_Partner', ftInteger, ptInput, 0);
  FParams.AddParam('inObjectId_Juridical', ftInteger, ptInput, ObjectId);
  FParams.AddParam('inObjectId_Contract', ftInteger, ptInput, 0);
  FParams.AddParam('inContactPersonKindId', ftInteger, ptInput, ContactPersonKindId);
  result := InsertUpdate(FParams);
end;


initialization
  TestFramework.RegisterTest('Объекты', TContactPersonTest.Suite);


end.
