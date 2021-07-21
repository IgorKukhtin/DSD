-- Function: zfCalc_SummaCheck

DROP FUNCTION IF EXISTS zfCalc_SummaCheck (TFloat, Boolean, Boolean, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_SummaCheck(
    IN inSumma         TFloat   , -- 
    IN inRoundingDown  Boolean  , -- 
    IN inRoundingTo10  Boolean  , -- 
    IN inRoundingTo50  Boolean  -- 
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbResult TFloat;
BEGIN
    -- результат
    IF COALESCE (inRoundingDown, False) = True
    THEN
      IF COALESCE (inRoundingTo50, False) = True
      THEN
        vbResult := TRUNC(COALESCE (inSumma, 0))::NUMERIC (16, 2); 
        IF inSumma > 0 AND (inSumma - vbResult) >= 0.5
        THEN
          vbResult := vbResult + 0.5;
        ELSEIF inSumma < 0 AND ABS(inSumma - vbResult) >= 0.5
        THEN
          vbResult := vbResult - 0.5;
        END IF;        
      ELSEIF COALESCE (inRoundingTo10, False) = True
      THEN
        vbResult := TRUNC(COALESCE (inSumma, 0), 1)::NUMERIC (16, 2);      
      ELSE
        vbResult := TRUNC(COALESCE (inSumma, 0), 2)::NUMERIC (16, 2);
      END IF;    
    ELSE
      IF COALESCE (inRoundingTo50, False) = True
      THEN
        vbResult := TRUNC(COALESCE (inSumma, 0))::NUMERIC (16, 2); 
        IF inSumma > 0 AND (inSumma - vbResult) >= 0.75
        THEN
          vbResult := vbResult + 1;
        ELSEIF inSumma > 0 AND (inSumma - vbResult) >= 0.25
        THEN
          vbResult := vbResult + 0.5;
        ELSEIF inSumma < 0 AND ABS(inSumma - vbResult) >= 0.75
        THEN
          vbResult := vbResult - 1;
        ELSEIF inSumma < 0 AND ABS(inSumma - vbResult) >= 0.25
        THEN
          vbResult := vbResult - 0.5;
        END IF;        
      ELSEIF COALESCE (inRoundingTo10, False) = True
      THEN
        vbResult := COALESCE (inSumma, 0)::NUMERIC (16, 1)::NUMERIC (16, 2);            
      ELSE
        vbResult := COALESCE (inSumma, 0)::NUMERIC (16, 2);      
      END IF;    
    
    END IF;
    
    RETURN vbResult;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.21                                                       *
*/

-- тест
-- SELECT zfCalc_SummaCheck (10.999, True, True, True)