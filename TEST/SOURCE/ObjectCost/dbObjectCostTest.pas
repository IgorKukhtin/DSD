unit dbObjectCostTest;

interface
uses dbTest;

type

  РасчетСебестоимости = class (TdbTest)
  published
    procedure ЗагрузкаПроцедур; override;
    procedure Тестирование; override;
  end;

implementation

{ РасчетСебестоимости }

procedure РасчетСебестоимости.ЗагрузкаПроцедур;
begin
  inherited;

end;

procedure РасчетСебестоимости.Тестирование;
begin
  inherited;

end;

end.
