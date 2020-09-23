unit ReportSoldParamsTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TReportSoldParamsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReportSoldParams = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdatePrice(const Id, UnitId: Integer;
      const PlanDate: TDateTime; const PlanAmount: Real): integer;
    constructor Create; override;
  end;
var
  UnitID: Integer;
  PlanDate: TDateTime;
implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB,
     UnitsTest;
     { TPriceTest }
constructor TReportSoldParams.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReportSoldParams';
  spSelect := 'gpSelect_Object_ReportSoldParams';
  spGet := 'gpGet_Object_ReportSoldParams';
end;

function TReportSoldParams.InsertDefault: integer;
begin
  result := InsertUpdatePrice(0, UnitId, PlanDate, 1.0);
  inherited;
end;

function TReportSoldParams.InsertUpdatePrice(const Id, UnitId: Integer;
      const PlanDate: TDateTime; const PlanAmount: Real): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('ioPlanDate', ftDateTime, ptInput, PlanDate);
  FParams.AddParam('inPlanAmount', ftFloat, ptInput, PlanAmount);
  result := InsertUpdate(FParams);
end;

procedure TReportSoldParams.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inPlanDate', ftDateTime, ptInput, PlanDate);
  FParams.AddParam('inShowAll', ftboolean, ptInput, True);
end;

procedure TReportSoldParamsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\ReportSoldParams\';
  inherited;
end;

procedure TReportSoldParamsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReportSoldParams;
begin
  ObjectTest := TReportSoldParams.Create;
  PlanDate := EncodeDate(2015,09,01);
  UnitID  := TUnit.Create.GetDefault;

  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;

  // Вставка нового плана
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('UnitId').AsInteger = UnitId) AND
            (FieldByName('PlanDate').AsDateTime = PlanDate) AND
            (FieldByName('PlanAmount').AsFloat = 1.0),
            'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TReportSoldParamsTest.Suite);

end.
