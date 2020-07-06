unit CarTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TCarTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCar = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateCar(const Id, Code : integer; Name, RegistrationCertificateId: string; CarModelId: Integer): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest;

 constructor TCar.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Car';
  spSelect := 'gpSelect_Object_Car';
  spGet := 'gpGet_Object_Car';
end;

function TCar.InsertDefault: integer;
var
  CarModelId: Integer;
begin
  CarModelId := TCarModel.Create.GetDefault;
  result := InsertUpdateCar(0, -1, 'Автомобиль', 'АЕ НЕ', CarModelId);
  inherited;
end;

function TCar.InsertUpdateCar;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('RegistrationCertificateId', ftString, ptInput, RegistrationCertificateId);
  FParams.AddParam('inCarModelId', ftInteger, ptInput, CarModelId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, 0);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, 0);
  FParams.AddParam('inFuelMasterId', ftInteger, ptInput, 0);
  FParams.AddParam('inFuelChildId', ftInteger, ptInput, 0);
  result := InsertUpdate(FParams);
end;

{ TBranchTest }

procedure TCarTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Car\';
  inherited;
end;

procedure TCarTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCar;
begin
  ObjectTest := TCar.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Автомобиля
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Автомобиль'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  //TestFramework.RegisterTest('Объекты', TCarTest.Suite);

end.
