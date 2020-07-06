unit TradeMarkTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TTradeMarkTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TTradeMark = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateTradeMark(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TTradeMarkTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\TradeMark\';
  inherited;
end;

procedure TTradeMarkTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TTradeMark;
begin
  ObjectTest := TTradeMark.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Бизнеса
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Бизнесе
    with ObjectTest.GetRecord(Id) do
         Check((FieldByName('Name').AsString = 'Торговая марка'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TTradeMarkTest }

constructor TTradeMark.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_TradeMark';
  spSelect := 'gpSelect_Object_TradeMark';
  spGet := 'gpGet_Object_TradeMark';
end;

function TTradeMark.InsertDefault: integer;
begin
  result := InsertUpdateTradeMark(0, -1, 'Торговая марка');
  inherited;
end;

function TTradeMark.InsertUpdateTradeMark;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

initialization
 // TestFramework.RegisterTest('Объекты', TTradeMarkTest.Suite);

end.
