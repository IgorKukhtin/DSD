unit ReasonDifferencesTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TReasonDifferencesTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReasonDifferences = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdateReasonDifferences(const Id, Code: Integer; const Name: String): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;
     { TPriceTest }
constructor TReasonDifferences.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReasonDifferences';
  spSelect := 'gpSelect_Object_ReasonDifferences';
  spGet := 'gpGet_Object_ReasonDifferences';
end;

function TReasonDifferences.InsertDefault: integer;
begin
  result := InsertUpdateReasonDifferences(0, -1, 'Тестовая причина разногласия');
  inherited;
end;

function TReasonDifferences.InsertUpdateReasonDifferences(const Id, Code: Integer; const Name: String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('ioCode', ftInteger, ptInputOutput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TReasonDifferences.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsShowDel', ftboolean, ptInput, False);
end;

procedure TReasonDifferencesTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\ReasonDifferences\';
  inherited;
end;

procedure TReasonDifferencesTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReasonDifferences;
begin
  ObjectTest := TReasonDifferences.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка новой причины

  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Code').AsInteger = -1) AND
            (FieldByName('Name').AsString = 'Тестовая причина разногласия'),
            'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TReasonDifferencesTest.Suite);

end.
