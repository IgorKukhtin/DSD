-- Function: gpGet_Object_TradeMark (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_TradeMark (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TradeMark(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ColorReport TFloat, ColorBgReport TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_TradeMark());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TradeMark()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as TFloat)     AS ColorReport
           , CAST (0 as TFloat)     AS ColorBgReport

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
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
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_TradeMark (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.16         *
 06.09.13                          *

*/

-- тест
-- SELECT * FROM gpGet_Object_TradeMark (2, '')
