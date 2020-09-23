unit AlternativeGroupTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAlternativeGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TAlternativeGroup = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdateAlternativeGroup(const Id: Integer; const Name: String): integer;
    constructor Create; override;
  end;
var
  AlternativeGroup_Value: Double;
  MCS_Value: Double;
  GoodsId: Integer;
  UnitID: Integer;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     { TAlternativeGroupTest }
constructor TAlternativeGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AlternativeGroup';
  spSelect := 'gpSelect_Object_AlternativeGroup';
  spGet := 'gpGet_Object_AlternativeGroup';
end;

function TAlternativeGroup.InsertDefault: integer;
begin
  result := InsertUpdateAlternativeGroup(0, 'AlternativeGroup_Test_Name');
  inherited;
end;

function TAlternativeGroup.InsertUpdateAlternativeGroup(const Id: Integer; const Name: String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TAlternativeGroup.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsShowDel', ftboolean, ptInput, False);
end;

procedure TAlternativeGroupTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\AlternativeGroup\';
  inherited;
end;

procedure TAlternativeGroupTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAlternativeGroup;
begin
  ObjectTest := TAlternativeGroup.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка новой группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'AlternativeGroup_Test_Name'),
            'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TAlternativeGroupTest.Suite);

end.
