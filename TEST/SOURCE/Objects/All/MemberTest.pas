unit MemberTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TMemberTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TMember = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateMember(const Id, Code : integer; Name, INN: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

{ TMemberTest }
constructor TMember.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Member';
  spSelect := 'gpSelect_Object_Member';
  spGet := 'gpGet_Object_Member';
end;

function TMember.InsertDefault: integer;
begin
  result := InsertUpdateMember(0, -1, 'Физические лица','123');
end;

function TMember.InsertUpdateMember(const Id, Code: Integer;
  Name, INN : string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inINN', ftString, ptInput, INN);
  FParams.AddParam('inDriverCertificate', ftString, ptInput, '');
  FParams.AddParam('inComment', ftString, ptInput, '');
  result := InsertUpdate(FParams);
end;

procedure TMemberTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Member\';
  inherited;
end;


procedure TMemberTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMember;
begin
  ObjectTest := TMember.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Физические лица'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TMemberTest.Suite);

end.
