-- Function: Считаем Сумму с НДС - Округление до 2-х знаков

DROP FUNCTION IF EXISTS zfCalc_SummWVAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVAT(
    IN inSumm          TFloat, -- Сумма без НДС
    IN inTaxKindValue  TFloat  -- % НДС
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN CAST (inSumm * (1 + inTaxKindValue/100) AS NUMERIC (16, 2));
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.21                                        *
*/

-- тест
-- SELECT * FROM zfCalc_SummWVAT (inSumm:= 100, inTaxKindValue:= 16)
