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
        Name: string): integer;
    constructor Create; override;
  end;
implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;


constructor TBranch.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Branch';
  spSelect := 'gpSelect_Object_Branch';
  spGet := 'gpGet_Object_Branch';
end;

function TBranch.InsertDefault: integer;
begin
  result := InsertUpdateBranch(0, -4, 'TEST Филиал');
  inherited;
end;

function TBranch.InsertUpdateBranch;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
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
