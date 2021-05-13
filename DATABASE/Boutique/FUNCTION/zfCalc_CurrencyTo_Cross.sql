-- Function: zfCalc_CurrencyTo_Cross

DROP FUNCTION IF EXISTS zfCalc_CurrencyTo_Cross (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_CurrencyTo_Cross(
    IN inCurrencyValue      TFloat, -- Курс в EUR
    IN inCurrencyValueCross TFloat  -- Кросс-Курс
)
RETURNS NUMERIC (20, 10)
AS
$BODY$
BEGIN
    -- округление 2 знака
    RETURN ROUND (inCurrencyValue / CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END, 2);
    -- НЕТ округления
    --RETURN inCurrencyValue / CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.21                                        *
*/

-- тест
-- SELECT * FROM zfCalc_CurrencyTo_Cross (inCurrencyValue:= 33, inCurrencyValueCross:= 1.2)
