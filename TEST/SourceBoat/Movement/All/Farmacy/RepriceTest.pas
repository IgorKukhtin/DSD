unit RepriceTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TRepriceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReprice = class(TMovementTest)
  private
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementReprice(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId: Integer; GUID: String): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TReprice }

constructor TReprice.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Reprice';
  spSelect := 'gpSelect_Movement_Reprice';
  spGet := 'gpGet_Movement_Reprice';
end;

function TReprice.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    UnitID : Integer;
    GUID: String;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  UnitId := TUnit.Create.GetDefault;
  GUID := '{TEST GUID}';
  result := InsertUpdateMovementReprice(Id, InvNumber, OperDate, UnitId, GUID);
end;

function TReprice.InsertUpdateMovementReprice(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId: Integer; GUID: String):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inGUID', ftString, ptInput, GUID);
  result := InsertUpdate(FParams);
end;

{ TRepriceTest }

procedure TRepriceTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Reprice\';
  inherited;
end;

procedure TRepriceTest.Test;
var
  MovementReprice: TReprice;
  Id: Integer;
begin
  MovementReprice := TReprice.Create;
  // создание документа
  Id := MovementReprice.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TRepriceItem }

initialization

  TestFramework.RegisterTest('Документы', TRepriceTest.Suite);

end.
