unit RouteTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TRouteTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TRoute = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRoute(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

       {TRouteTest }
constructor TRoute.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Route';
  spSelect := 'gpSelect_Object_Route';
  spGet := 'gpGet_Object_Route';
end;

function TRoute.InsertDefault: integer;
begin
  result := InsertUpdateRoute(0, -111, 'Маршрут-test');
  inherited;
end;

function TRoute.InsertUpdateRoute(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inUnitId', ftInteger, ptInput, 0);
  FParams.AddParam('inBranchId', ftInteger, ptInput, 0);
  FParams.AddParam('inRouteKindId', ftInteger, ptInput, 0);
  FParams.AddParam('inFreightId', ftInteger, ptInput, 0);

  result := InsertUpdate(FParams);
end;

 procedure TRouteTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Route\';
  inherited;
end;

procedure TRouteTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRoute;
begin
  ObjectTest := TRoute.Create;
  // Получим список
    RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о маршруте
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Маршрут-test'), 'Не сходятся данные Id = ' + IntToStr(Id));

  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  TestFramework.RegisterTest('Объекты', TRouteTest.Suite);


end.
