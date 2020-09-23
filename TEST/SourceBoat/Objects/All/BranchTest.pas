unit BranchTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TBranchTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBranch = class(TObjectTest)
     function InsertDefault: integer; override;
  public
   function InsertUpdateBranch(const Id: integer; Code: Integer;
        Name, InvNumber: string; PersonalBookkeeper: Integer;
        IsMedoc, IsPartionDoc: Boolean): integer;
    constructor Create; override;
  end;
implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, PersonalTest, Data.DB, Variants;


constructor TBranch.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Branch';
  spSelect := 'gpSelect_Object_Branch';
  spGet := 'gpGet_Object_Branch';
end;

function TBranch.InsertDefault: integer;
var
  PersonalBookkeeper: Integer;
begin
//  PersonalBookkeeper := TPersonal.Create.GetDefault;
  PersonalBookkeeper := 0;
  result := InsertUpdateBranch(0, -4, 'TEST Филиал', '-99',PersonalBookkeeper, False, False);
  inherited;
end;

function TBranch.InsertUpdateBranch;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inPersonalBookkeeperId', ftInteger, ptInput, null (*PersonalBookkeeper*));
  FParams.AddParam('inIsMedoc', ftBoolean, ptInput, IsMedoc);
  FParams.AddParam('inIsPartionDoc', ftBoolean, ptInput, IsPartionDoc);
  result := InsertUpdate(FParams);
end;

{ TBranchTest }

procedure TBranchTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Branch\';
  inherited;
end;

procedure TBranchTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBranch;
begin
  ObjectTest := TBranch.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;

  if ObjectTest.GetDataSet.Locate('Name', 'TEST Филиал', []) then
     Id := ObjectTest.GetDataSet.FieldByName('Id').AsInteger
  else
     // Вставка Филиала
     Id := ObjectTest.InsertDefault;

  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'TEST Филиал'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TBranchTest.Suite);


end.
