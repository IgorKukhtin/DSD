unit PersonalTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TPersonalTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonal = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdatePersonal(const Id: integer;
    MemberId, PositionId, UnitId, PersonalGroupId: integer; DateIn, DateOut: TDateTime): integer;
    constructor Create; override;
  end;

implementation

uses DB, dbObjectMeatTest, UtilConst, TestFramework, SysUtils, UnitsTest,
     MemberTest, PositionTest;

{ TdbUnitTest }

procedure TPersonalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Personal\';
  inherited;
end;

procedure TPersonalTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPersonal;
begin
  ObjectTest := TPersonal.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do begin
      Check((FieldByName('MemberCode').AsInteger = -1), 'Не сходятся данные Id = ' + IntToStr(Id));
      Check((FieldByName('MemberName').AsString = 'Физические лица'), 'Не сходятся данные Id = ' + IntToStr(Id));
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TPersonal}
constructor TPersonal.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Personal';
  spSelect := 'gpSelect_Object_Personal';
  spGet := 'gpGet_Object_Personal';
end;

function TPersonal.InsertDefault: integer;
var
  MemberId: Integer;
  PositionId: Integer;
  UnitId: Integer;
  PersonalGroupId: Integer;
begin
  MemberId := TMember.Create.GetDefault;
  PositionId := TPosition.Create.GetDefault;
  UnitId := TUnit.Create.GetDefault;
  PersonalGroupId:= 0;
  result := InsertUpdatePersonal(0, MemberId, PositionId, UnitId, PersonalGroupId, Date,Date);
end;

function TPersonal.InsertUpdatePersonal(const Id: integer;
    MemberId, PositionId, UnitId, PersonalGroupId: integer; DateIn, DateOut: TDateTime): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inPersonalGroupId', ftInteger, ptInput, PersonalGroupId);
  FParams.AddParam('inDateIn', ftDateTime, ptInput, DateIn);
  FParams.AddParam('inDateOut', ftDateTime, ptInput, DateOut);
  result := InsertUpdate(FParams);
end;


initialization
 // TestFramework.RegisterTest('Объекты', TPersonalTest.Suite);

end.
