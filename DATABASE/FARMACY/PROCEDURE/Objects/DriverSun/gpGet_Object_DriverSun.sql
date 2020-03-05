-- Function: gpGet_Object_DriverSun()

DROP FUNCTION IF EXISTS gpGet_Object_DriverSun(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DriverSun(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_DriverSun()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Phone
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_DriverSun.Id                     AS Id
            , Object_DriverSun.ObjectCode             AS Code
            , Object_DriverSun.ValueData              AS Name
            , ObjectString_DriverSun_Phone.ValueData  AS Phone
            , Object_DriverSun.isErased               AS isErased
       FROM Object AS Object_DriverSun
            LEFT JOIN ObjectString AS ObjectString_DriverSun_Phone
                                   ON ObjectString_DriverSun_Phone.ObjectId = Object_DriverSun.Id 
                                  AND ObjectString_DriverSun_Phone.DescId = zc_ObjectString_DriverSun_Phone()
       WHERE Object_DriverSun.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DriverSun(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.03.20                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_DriverSun (0, '3')