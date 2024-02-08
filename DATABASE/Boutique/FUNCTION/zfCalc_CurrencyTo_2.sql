-- Function: Переводим в Валюту - Делением, т.е. из ГРН

DROP FUNCTION IF EXISTS zfCalc_CurrencyTo_2 (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyTo_2(
    IN inAmount        TFloat, -- Сумма в ГРН
    IN inCurrencyValue TFloat, -- Курс
    IN inParValue      TFloat  -- Номинал
)
RETURNS TFloat
AS
$BODY$
BEGIN
    -- БЕЗ округления
    RETURN CAST (CASE WHEN inCurrencyValue > 0
                          THEN COALESCE (inAmount, 0)
                             / inCurrencyValue
                             * CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
                     ELSE 0
                END
           AS NUMERIC (16, 2));

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
-- SELECT zfCalc_CurrencyTo_2 (inAmount:= 2, inCurrencyValue:= 5.5, inParValue:= 1), zfCalc_CurrencyTo (inAmount:= 2, inCurrencyValue:= 5.5, inParValue:= 1)
