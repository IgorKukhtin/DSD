-- Function: gpSelect_Object_TradeMark (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TradeMark (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TradeMark(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ColorReport TFloat, ColorBgReport TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TradeMark());

   RETURN QUERY 
   SELECT
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , ObjectFloat_ColorReport.ValueData     AS ColorReport
       , ObjectFloat_ColorBgReport.ValueData   AS ColorBgReport
       , Object.isErased   AS isErased
   FROM Object
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                ON ObjectFloat_ColorReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorBgReport
                                ON ObjectFloat_ColorBgReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorBgReport.DescId = zc_ObjectFloat_TradeMark_ColorBgReport()

   WHERE Object.DescId = zc_Object_TradeMark();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_TradeMark (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.16         * 
 06.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_TradeMark('2')
