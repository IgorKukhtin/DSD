-- Function: Расчет кросс-курса

DROP FUNCTION IF EXISTS zfCalc_CurrencyCross_calc (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyCross_calc(
    IN inCurrencyValue_from TFloat ,
    IN inCurrencyValue_to   TFloat 
)
RETURNS TFloat
AS
$BODY$
BEGIN
    -- округление
    RETURN CAST (COALESCE (inCurrencyValue_from / CASE WHEN inCurrencyValue_to > 0 THEN inCurrencyValue_to ELSE 1 END, 0) AS NUMERIC (16, 2))
          ;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.21                                        *
*/

-- тест
-- SELECT * FROM zfCalc_CurrencyCross_calc (inCurrencyValue_from:= 33, inCurrencyValue_to:= 28)
