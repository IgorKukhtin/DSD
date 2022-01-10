-- Function: Считаем Сумму БЕЗ НДС - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_Summ_NoVAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_NoVAT(
    IN inSumm          TFloat, -- Сумма с НДС
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     IF inTaxKindValue > 0
     THEN
         RETURN CAST (inSumm / (1 + COALESCE (inTaxKindValue, 0) /100) AS NUMERIC (16, 2));
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
-- SELECT * FROM zfCalc_Summ_NoVAT (inSumm:= 119, inTaxKindValue:= 19)
