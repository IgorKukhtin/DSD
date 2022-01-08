-- Function: Считаем Сумму по ценам продажи - Округление до 0 знаков

DROP FUNCTION IF EXISTS zfCalc_SummPriceList (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummPriceList(
    IN inAmount        TFloat, -- Кол-во
    IN inOperPriceList TFloat  -- Цена по прайсу
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- Округление до 2-х знаков
    RETURN CASE WHEN ABS (inOperPriceList) < 1
                THEN CAST (COALESCE (inAmount, 0) * COALESCE (inOperPriceList, 0)
                           AS NUMERIC (16, 2))
                ELSE CAST (COALESCE (inAmount, 0) * COALESCE (inOperPriceList, 0)
                           AS NUMERIC (16, 2))
           END;

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
-- SELECT * FROM zfCalc_SummPriceList (inAmount:= 2, inOperPriceList:= 3)
