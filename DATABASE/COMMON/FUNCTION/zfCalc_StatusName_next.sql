-- Function: zfCalc_StatusName_next()

DROP FUNCTION IF EXISTS zfCalc_StatusName_next (TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_StatusName_next (inStatusName TVarChar, inStatusId Integer, inStatusId_next Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN

   RETURN CASE inStatusId
               WHEN zc_Enum_Status_Complete()   THEN inStatusName
               WHEN zc_Enum_Status_UnComplete() THEN inStatusName
             --WHEN zc_Enum_Status_UnComplete() THEN '***' || inStatusName
               WHEN zc_Enum_Status_Erased()     THEN inStatusName
               ELSE inStatusName
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
-- SELECT zfCalc_StatusName_next ('Не проведен', zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete())
