-- Function: Считаем Скидку - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummDiscount (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummDiscount(
    IN inSumm        TFloat, -- Сумма
    IN inDiscountTax TFloat  -- % скидки
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN CAST (COALESCE (inSumm, 0.0) * COALESCE (inDiscountTax, 0.0) / 100 AS NUMERIC (16, 2));
                
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
-- SELECT * FROM zfCalc_SummDiscount (inSumm:= 100, inDiscountTax:= 15)
