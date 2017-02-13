unit IncomeCashJuridicalTest;

interface

uses dbTest, dbMovementTest;

type
  TIncomeCashJuridicalTest = class (TdbTest)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TIncomeCashJuridical = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateIncomeCashJuridical(const Id: integer; InvNumber: Integer; OperDate: TDateTime;
        CashId, JuridicalId, PaidKindId, InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst;

{ TIncomeCashJuridical }

constructor TIncomeCashJuridical.Create;
begin
  inherited;

end;

function TIncomeCashJuridical.InsertDefault: integer;
begin

end;

function TIncomeCashJuridical.InsertUpdateIncomeCashJuridical(const Id: integer;
  InvNumber: Integer; OperDate: TDateTime; CashId, JuridicalId, PaidKindId,
  InfoMoneyId, ContractId, UnitId: integer): integer;
begin

end;

{ TIncomeCashJuridicalTest }

procedure TIncomeCashJuridicalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\IncomeCashJuridical\';
  inherited;
end;

procedure TIncomeCashJuridicalTest.Test;
begin
  inherited;

end;

end.
