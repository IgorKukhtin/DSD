-- Function: Переводим из Валюты - Умножением, т.е. в ГРН

DROP FUNCTION IF EXISTS zfCalc_CurrencyFrom (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyFrom(
    IN inAmount        TFloat, -- Сумма в Валюте
    IN inCurrencyValue TFloat, -- Курс
    IN inParValue      TFloat  -- Номинал
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- БЕЗ округления
    RETURN COALESCE (inAmount, 0)
         * COALESCE (inCurrencyValue, 0)
         / CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
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
-- SELECT * FROM zfCalc_CurrencyFrom (inAmount:= 2, inCurrencyValue:= 5, inParValue:= 1)
