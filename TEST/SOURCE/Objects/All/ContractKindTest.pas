unit ContractKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TContractKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TContractKind = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContractKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     {TContractKindTest}
constructor TContractKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ContractKind';
  spSelect := 'gpSelect_Object_ContractKind';
  spGet := 'gpGet_Object_ContractKind';
end;

function TContractKind.InsertDefault: integer;
begin
  result := InsertUpdateContractKind(0, -1, 'Вид договора');
  inherited;
end;

function TContractKind.InsertUpdateContractKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TContractKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractKind\';
  inherited;
end;

procedure TContractKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContractKind;
begin
  ObjectTest := TContractKind.Create;
  // Получим список
   RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Вида договора
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Вида договора
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид договора'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  //TestFramework.RegisterTest('Объекты', TContractKindTest.Suite);

end.
