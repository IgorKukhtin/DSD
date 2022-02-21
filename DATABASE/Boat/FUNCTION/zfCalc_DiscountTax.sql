-- Function: Считаем % Скидки - Округление до 1-ого знака

DROP FUNCTION IF EXISTS zfCalc_DiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_DiscountTax(
    IN inSummDiscountTax TFloat, -- Сумма со скидкой
    IN inSumm            TFloat  -- Сумма без скидки
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN CAST (CASE WHEN inSumm <> 0 THEN COALESCE (inSummDiscountTax, 0.0) * 100 / inSumm ELSE 0 END AS NUMERIC (16, 1));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.21                                        *
*/

-- тест
-- SELECT * FROM zfCalc_DiscountTax (inSummDiscountTax:= 100, inSumm:= 150)
