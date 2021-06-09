--Function: gpSelect_Object_OrderPeriodKind(TVarChar)

--DROP FUNCTION gpSelect_Object_OrderPeriodKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderPeriodKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar, Week TFloat
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderPeriodKind());

   RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectString_Enum.ValueData AS EnumName
           , ObjectFloat_Week.ValueData  AS Week
           , Object.isErased   AS isErased
       FROM Object
            LEFT JOIN ObjectString AS ObjectString_Enum
                                   ON ObjectString_Enum.ObjectId = Object.Id
                                  AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
            LEFT JOIN ObjectFloat AS ObjectFloat_Week
                                  ON ObjectFloat_Week.ObjectId = Object.Id
                                 AND ObjectFloat_Week.DescId = zc_ObjectFloat_OrderPeriodKind_Week()
       WHERE Object.DescId = zc_Object_OrderPeriodKind()
     ;
  
END;$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderPeriodKind('2')