unit SaleTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TSaleTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSale = class(TMovementTest)
  private
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementSale(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId, JuridicalId, PaidKindId: Integer; Comment: String): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, PaidKindTest, JuridicalTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TSale }

constructor TSale.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Sale';
  spSelect := 'gpSelect_Movement_Sale';
  spGet := 'gpGet_Movement_Sale';
end;

function TSale.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    UnitID, PaidKindId, JuridicalId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  UnitId := TUnit.Create.GetDefault;
  JuridicalId := TJuridical.Create.GetDefault;
  PaidKindId := TPaidKind.Create.GetDefault;
  result := InsertUpdateMovementSale(Id, InvNumber, OperDate, UnitId, JuridicalId, PaidKindId, 'Test Comment');
end;

function TSale.InsertUpdateMovementSale(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId, JuridicalId, PaidKindId: Integer; Comment: String):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  result := InsertUpdate(FParams);
end;

{ TSaleTest }

procedure TSaleTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Sale\';
  inherited;
end;

procedure TSaleTest.Test;
var
  MovementSale: TSale;
  Id: Integer;
begin
  MovementSale := TSale.Create;
  // создание документа
  Id := MovementSale.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TSaleItem }

initialization

//  TestFramework.RegisterTest('Документы', TSaleTest.Suite);

end.
