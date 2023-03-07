-- Function: zfCalc_PriceCash

DROP FUNCTION IF EXISTS zfCalc_PriceChange (TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_PriceChange(
    IN inPrice         TFloat   , -- 
    IN inFixPrice      TFloat   , -- 
    IN inFixPercent    TFloat   , -- 
    IN inFixDiscount   TFloat     -- 
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbResult TFloat;
BEGIN

    vbResult := inPrice;

    -- результат
    IF COALESCE (inFixPercent, 0) > 0
    THEN
      vbResult := Round(inPrice  * (100.0 - COALESCE (inFixPercent, 0)) / 100.0, 2);
    ELSEIF COALESCE (inFixDiscount, 0) > 0 AND Round(inPrice - COALESCE (inFixDiscount, 0), 2) > 0
    THEN
      vbResult := Round(inPrice - COALESCE (inFixDiscount, 0), 2);
    ELSEIF COALESCE (inFixPrice, 0) > 0 AND inPrice > COALESCE (inFixPrice, 0)
    THEN
      vbResult := inFixPrice;
    END IF; 
    
    RETURN ROUND(vbResult, 2);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.07.21                                                       *
*/

-- тест
-- 
SELECT zfCalc_PriceChange (10.601, 0, 0, 0)