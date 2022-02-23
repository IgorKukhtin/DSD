-- Function: Считаем Сумму с НДС и со Скидкой - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummWVATDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVATDiscountTax(
    IN inSumm          TFloat, -- Сумма без НДС
    IN inDiscountTax   TFloat, -- % скидки
    IN inTaxKindValue  TFloat  -- % НДС
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 4-х знаков
     RETURN CAST (zfCalc_SummWVAT (zfCalc_SummDiscountTax (inSumm, inDiscountTax), inTaxKindValue) AS NUMERIC (16, 4));
                
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
