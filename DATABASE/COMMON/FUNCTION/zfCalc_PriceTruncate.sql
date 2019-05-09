-- Function: zfCalc_PriceTruncate

DROP FUNCTION IF EXISTS zfCalc_PriceTruncate (TFloat, TFloat, Boolean);
DROP FUNCTION IF EXISTS zfCalc_PriceTruncate (TDateTime, TFloat, TFloat, Boolean);


CREATE OR REPLACE FUNCTION zfCalc_PriceTruncate(
    IN inOperDate            TDateTime , -- 
    IN inChangePercent       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inIsWithVAT           Boolean     -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF COALESCE (inChangePercent, 0) = 0
     THEN
         RETURN (inPrice);
     ELSEIF COALESCE (inOperDate, zc_DateEnd()) < zc_DateStart_PriceTruncate()
     THEN
         -- возвращаем результат, уже округленный до 2-х знаков
         RETURN (CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) AS NUMERIC (16, 2)));
     ELSE
         -- возвращаем результат, уже округленный до 2-х знаков
         RETURN (CASE WHEN COALESCE (inIsWithVAT, FALSE) = TRUE
                           -- если цена с НДС, тогда со скидкой должна делиться на 6
                           THEN 6 * CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) / 6 AS Numeric (16, 2))
                      -- если цена БЕЗ НДС, тогда со скидкой должна делиться на 5
                      ELSE 5 * CAST (COALESCE (inPrice, 0) * (1 + inChangePercent / 100) / 5 AS Numeric (16, 2))
                 END :: TFloat
                );
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.19                                        *
*/

-- тест
-- SELECT zfCalc_PriceTruncate (inOperDate:= CURRENT_DATE, inChangePercent:= 5, inPrice:= 7, inIsWithVAT:= FALSE), zfCalc_PriceTruncate (inOperDate:= CURRENT_DATE, inChangePercent:= 5, inPrice:= 7, inIsWithVAT:= TRUE)
