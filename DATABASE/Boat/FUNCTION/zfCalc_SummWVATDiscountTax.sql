-- Function: Считаем Сумму со Скидкой - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummWVATDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVATDiscountTax(
    IN inSumm          TFloat, -- Сумма
    IN inDiscountTax   TFloat, -- % скидки
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN CAST (zfCalc_SummDiscountTax (inSumm, inDiscountTax) * (1 + inTaxKindValue/100) AS NUMERIC (16, 2));
                
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
-- SELECT * FROM zfCalc_SummWVATDiscountTax (inSumm:= 100, inDiscountTax:= 0, inTaxKindValue:= 16)
