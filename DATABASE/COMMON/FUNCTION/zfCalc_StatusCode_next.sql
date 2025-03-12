-- Function: zfCalc_StatusCode_next()

DROP FUNCTION IF EXISTS zfCalc_StatusCode_next (Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_StatusCode_next (inStatusId Integer, inStatusId_next Integer)
RETURNS Integer
AS
$BODY$
BEGIN

   RETURN CASE inStatusId
               WHEN zc_Enum_Status_Complete()   THEN 2
               WHEN zc_Enum_Status_UnComplete() THEN 4 -- 4 or 1 
               WHEN zc_Enum_Status_Erased()     THEN 3
               ELSE 1
          END
         ;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.03.25                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Status('2')
-- SELECT zfCalc_StatusCode_next (zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete())
