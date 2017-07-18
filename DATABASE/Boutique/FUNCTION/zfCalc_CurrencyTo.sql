-- Function: Переводим в Валюту - Делением, т.е. из ГРН

DROP FUNCTION IF EXISTS zfCalc_CurrencyTo (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyTo(
    IN inAmount        TFloat, -- Сумма в ГРН
    IN inCurrencyValue TFloat, -- Курс
    IN inParValue      TFloat  -- Номинал
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- БЕЗ округления
    RETURN COALESCE (inAmount, 0)
         / CASE WHEN inCurrencyValue > 0 THEN inCurrencyValue ELSE 0 END
         * CASE WHEN inParValue      > 0 THEN inParValue      ELSE 1 END
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
-- SELECT * FROM zfCalc_CurrencyTo (inAmount:= 2, inCurrencyValue:= 5, inParValue:= 1)
