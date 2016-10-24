-- FunctiON: gpGet_Period (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Period (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Period(
    IN inSessiON           TVarChar   -- сессия пользователя
)
RETURNS TABLE (StartDate TDateTime
             , EndDate TDateTime
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
         SELECT CURRENT_DATE::TDateTime          AS StartDate
              , CURRENT_DATE::TDateTime          AS EndDate
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.16         *
*/

-- тест
-- SELECT * FROM gpGet_Period (inSessiON:= '5'::TVarChar)
