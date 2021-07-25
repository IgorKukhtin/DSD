-- Function: Считаем Сумму по ценам продажи Со Скидкой - Округление до 0 знаков

DROP FUNCTION IF EXISTS zfCalc_SummChangePercentNext (TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummChangePercentNext(
    IN inAmount             TFloat, -- Кол-во
    IN inOperPriceList      TFloat, -- Цена по прайсу, в ГРН
    IN inChangePercent      TFloat, -- % скидки №1
    IN inChangePercentNext  TFloat  -- % скидки №2
)
RETURNS TFloat
AS
$BODY$
BEGIN

     RETURN zfCalc_SummChangePercent (1, zfCalc_SummChangePercent (inAmount, inOperPriceList, inChangePercent), inChangePercentNext);
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.21                                        *
*/

-- тест
-- SELECT * FROM zfCalc_SummChangePercentNext (inAmount:= 1, inOperPriceList:= 1000, inChangePercent:= 40, inChangePercentNext:= 10)
