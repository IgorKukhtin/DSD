-- Function: Считаем Сумму со Скидкой - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummDiscountTax(
    IN inSumm          TFloat, -- Сумма без скидки
    IN inDiscountTax   TFloat  -- % скидки
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF inDiscountTax <> 0
     THEN
         -- округлили до 2-х знаков
         RETURN CAST (COALESCE (inSumm, 0.0) * (1 - COALESCE (inDiscountTax, 0.0) / 100) AS NUMERIC (16, 2));
     ELSE
         RETURN inSumm;
     END IF;

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
-- SELECT * FROM zfCalc_SummDiscountTax (inSumm:= 100, inDiscountTax:= 15)
