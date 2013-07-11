unit dbObjectCostTest;

interface
uses dbTest;

type

  TPrimeCostTest = class (TdbTest)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

implementation

{ РасчетСебестоимости }

procedure TPrimeCostTest.ProcedureLoad;
begin
  inherited;

end;

procedure TPrimeCostTest.Test;
begin
  inherited;

end;

end.
