-- Function: Считаем Сумму НДС - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_Summ_VAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_VAT(
    IN inSumm          TFloat, -- Сумма с НДС
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN inSumm - zfCalc_Summ_NoVAT (inSumm, inTaxKindValue);
                
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
-- SELECT * FROM zfCalc_Summ_VAT (inSumm:= 119, inTaxKindValue:= 19)
