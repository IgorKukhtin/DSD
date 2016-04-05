--Function: gpSelect_Object_MarginReport(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginReport(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginReport(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginReport());

   RETURN QUERY 
   SELECT Object_MarginReport.Id         AS Id 
        , Object_MarginReport.ObjectCode AS Code
        , Object_MarginReport.ValueData  AS Name
        , Object_MarginReport.isErased   AS isErased
   FROM Object AS Object_MarginReport
   WHERE Object_MarginReport.DescId = zc_Object_MarginReport();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MarginReport(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginReport('2')