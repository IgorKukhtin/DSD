-- Function: Считаем

DROP FUNCTION IF EXISTS zfCalc_Value_ForCount (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Value_ForCount(
    IN inValue     TFloat , -- 
    IN inForCount  TFloat   -- 
)
RETURNS NUMERIC (16, 8)
AS
$BODY$
BEGIN
     -- округлили до 2-х знаков
     RETURN COALESCE (inValue, 0) / CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END;
                
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
-- SELECT * FROM zfCalc_Value_ForCount (inValue:= 1.2345, inForCount:= 1000)
