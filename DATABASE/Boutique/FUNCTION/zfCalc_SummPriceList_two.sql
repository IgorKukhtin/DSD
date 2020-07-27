-- Function: Считаем Сумму по ценам продажи - Округление до 0 знаков

DROP FUNCTION IF EXISTS zfCalc_SummPriceList (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummPriceList(
    IN inAmount        TFloat, -- Кол-во
    IN inOperPriceList TFloat, -- Цена по прайсу, в ГРН
    IN inChangePercent TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- Округление до 0 знаков
    RETURN CAST (zfCalc_SummPriceList (inAmount, inOperPriceList) -- Округление до 0 знаков
               * (1 - COALESCE (inChangePercent, 0) / 100)
                AS NUMERIC (16, 0)); -- еще раз округлили до 0 знаков

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.17                                        *
*/

-- тест
-- SELECT * FROM zfCalc_SummPriceList (inAmount:= 2, inOperPriceList:= 3, inChangePercent: 1)
