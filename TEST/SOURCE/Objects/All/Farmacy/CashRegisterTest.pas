unit CashRegisterTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TCashRegisterTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCashRegister = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdateCashRegister(const Id,Code: Integer; const Name: String): integer;
    constructor Create; override;
  end;

  TCashRegisterKind = class(TObjectTest)
  public
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB, GoodsTest,
     UnitsTest;
     { TCashRegisterTest }
constructor TCashRegister.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_CashRegister';
  spSelect := 'gpSelect_Object_CashRegister';
  spGet := 'gpGet_Object_CashRegister';
end;

function TCashRegister.InsertDefault: integer;
begin
  result := InsertUpdateCashRegister(0, -1, 'CashRegister_Test');
  inherited;
end;

function TCashRegister.InsertUpdateCashRegister(const Id,Code: Integer; const Name: String): integer;
var
  CashRegisterKindId: Integer;
begin
  with TCashRegisterKind.Create.GetDataSet do begin
    CashRegisterKindId := FieldByName('Id').AsInteger;
  end;
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inCashRegisterKindId', ftInteger, ptInput, CashRegisterKindId);
  result := InsertUpdate(FParams);
end;

procedure TCashRegister.SetDataSetParam;
begin
  inherited;
end;

procedure TCashRegisterTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\CashRegisterKind\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\CashRegister\';
  inherited;
end;

procedure TCashRegisterTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCashRegister;
begin
  ObjectTest := TCashRegister.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка новой цены

  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Code').AsInteger = -1) AND
            (FieldByName('Name').AsString = 'CashRegister_Test'),
            'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TCashRegisterKind }

constructor TCashRegisterKind.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_CashRegisterKind';
end;

initialization
  TestFramework.RegisterTest('Объекты', TCashRegisterTest.Suite);

end.
