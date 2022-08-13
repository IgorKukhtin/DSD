-- Function: gpGet_Object_TradeMark (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_TradeMark (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TradeMark(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ColorReportId Integer, ColorBgReportId Integer, Text1 TVarChar, Text2 TVarChar
             , RetailId Integer, RetailName TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_TradeMark());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TradeMark()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)     AS ColorReportId
           , CAST (0 as Integer)     AS ColorBgReportId
           
           , CAST ('' as TVarChar)   AS Text1
           , CAST ('' as TVarChar)   AS Text2

           , CAST (0 as Integer)     AS RetailId
           , CAST ('' as TVarChar)   AS RetailName

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
         
           , COALESCE (ObjectFloat_ColorReport.ValueData,0)   ::Integer   AS ColorReportId
           , COALESCE (ObjectFloat_ColorBgReport.ValueData,0) ::Integer   AS ColorBgReportId
           , CASE WHEN COALESCE (ObjectFloat_ColorReport.ValueData,-1)   = -1 THEN '' ELSE 'Текст' END ::TVarChar  AS Text1
           , CASE WHEN COALESCE (ObjectFloat_ColorBgReport.ValueData,-1) = -1 THEN '' ELSE 'Фон'   END ::TVarChar  AS Text2  
           
           , Object_Retail.Id         AS RetailId
           , Object_Retail.ValueData  AS RetailName
         
           , Object.isErased   AS isErased
       FROM Object 
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                ON ObjectFloat_ColorReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()
          LEFT JOIN ObjectFloat AS ObjectFloat_ColorBgReport
                                ON ObjectFloat_ColorBgReport.ObjectId = Object.Id 
                               AND ObjectFloat_ColorBgReport.DescId = zc_ObjectFloat_TradeMark_ColorBgReport()   

          LEFT JOIN ObjectLink AS ObjectLink_Retail
                               ON ObjectLink_Retail.ObjectId = Object.Id
                              AND ObjectLink_Retail.DescId = zc_ObjectLink_TradeMark_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId
       WHERE Object.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_TradeMark (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.22         *
 05.12.16         *
 06.09.13                          *

*/

-- тест
-- SELECT * FROM gpGet_Object_TradeMark (2, '')
