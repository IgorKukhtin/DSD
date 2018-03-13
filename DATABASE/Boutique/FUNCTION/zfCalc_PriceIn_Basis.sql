-- Function: Считаем Цену по Входным ценам - !!!в Базовой Валюте!!! - Округление до 2 знаков + !!!оставили в inCountForPrice!!!

DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (Integer, TFloat, TFloat, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_PriceIn_Basis (Integer, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_PriceIn_Basis(
    IN inCurrencyId    Integer, -- В какой валюте
    IN inOperPrice     TFloat , -- Цена Входная, в валюте
    IN inCurrencyValue TFloat , -- Курс
    IN inParValue      TFloat   -- Номинал
)
RETURNS TFloat
AS
$BODY$
BEGIN

    IF inCurrencyId = zc_Currency_Basis()
    THEN
        -- ничего не делаем, у нас и так валюта Basis
        RETURN inOperPrice;
    ELSE
        -- Округление до 2 знаков - УМНОЖАЕМ на КУРС, т.е. если что - в курсе будет 1/inCurrencyValue
        RETURN CAST (COALESCE (inOperPrice, 0)
                   * COALESCE (inCurrencyValue, 0) / CASE WHEN inParValue > 0 THEN inParValue ELSE 1 END
                     AS NUMERIC (16, 2));
    END IF;

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
-- SELECT * FROM zfCalc_PriceIn_Basis (inCurrencyId:= 1, inOperPrice:= 100, inCurrencyValue:= 25.55, inParValue:= 1)
