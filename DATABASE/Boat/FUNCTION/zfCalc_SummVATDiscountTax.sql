-- Function: Считаем Сумму НДС - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummVATDiscountTax (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummVATDiscountTax(
    IN inSumm          TFloat, -- Сумма БЕЗ НДС
    IN inDiscountTax   TFloat, -- % скидки
    IN inTaxKindValue  TFloat  -- % НДС
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN zfCalc_SummWVATDiscountTax (inSumm, inDiscountTax, inTaxKindValue) - zfCalc_SummDiscountTax (inSumm, inDiscountTax);
                
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
-- SELECT * FROM zfCalc_SummVATDiscountTax (inSumm:= 100, inDiscountTax:= 0, inTaxKindValue:= 19)
