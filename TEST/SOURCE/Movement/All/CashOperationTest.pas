unit CashOperationTest;

interface

uses dbTest, dbMovementTest;

type
  TCashOperationTest = class (TdbTest)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCashOperation = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateCashOperation(const Id: integer; InvNumber: Integer; OperDate: TDateTime;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst;

{ TIncomeCashJuridical }

constructor TCashOperation.Create;
begin
  inherited;

end;

function TCashOperation.InsertDefault: integer;
begin

end;

function TCashOperation.InsertUpdateCashOperation(const Id: integer; InvNumber: Integer; OperDate: TDateTime;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId: integer): integer;
begin

end;

{ TIncomeCashJuridicalTest }

procedure TCashOperationTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_Cash\';
  inherited;
end;

procedure TCashOperationTest.Test;
var JuridicalId: integer;
begin
  inherited;
  // Создаем Юр лицо

  // Создаем кассу
  // Создаем документ

end;

end.
