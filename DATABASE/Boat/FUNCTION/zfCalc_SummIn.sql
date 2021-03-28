-- Function: Считаем Сумму по Входным ценам  - Округление до 2 знаков

DROP FUNCTION IF EXISTS zfCalc_SummIn (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummIn(
    IN inAmount        TFloat, -- Кол-во
    IN inOperPrice     TFloat, -- Цена Входная
    IN inCountForPrice TFloat  -- Цена за количество
)
RETURNS TFloat
AS
$BODY$
BEGIN

    -- Округление до 2 знаков
    RETURN CAST (COALESCE (inAmount, 0) * COALESCE (inOperPrice, 0) / CASE WHEN inCountForPrice > 0 THEN inCountForPrice ELSE 1 END
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
-- SELECT * FROM zfCalc_SummIn (inAmount:= 2, inOperPrice:= 3, inCountForPrice:= 1)
