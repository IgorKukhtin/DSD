-- Function: Переводим в Валюту - Делением, т.е. из USD -> EUR

DROP FUNCTION IF EXISTS zfCalc_CurrencyCross (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyCross(
    IN inAmount        TFloat, -- Сумма в USD
    IN inCurrencyValue TFloat, -- Кросс-курс
    IN inParValue      TFloat  -- Номинал для Кросс-курса
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- Округление
    RETURN CAST (CASE WHEN inCurrencyValue > 0
                           THEN COALESCE (inAmount, 0)
                              / inCurrencyValue
                              * CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
                      ELSE 0
                 END
                 AS NUMERIC (16, 0))
          ;

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
-- SELECT * FROM zfCalc_CurrencyCross (inAmount:= 600, inCurrencyValue:= 1.2, inParValue:= 1)
