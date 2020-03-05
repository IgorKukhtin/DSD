-- Function: gpSelect_Object_DriverSun()

DROP FUNCTION IF EXISTS gpSelect_Object_DriverSun(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DriverSun(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_DriverSun.Id                      AS Id 
        , Object_DriverSun.ObjectCode              AS Code
        , Object_DriverSun.ValueData               AS Name
        , ObjectString_DriverSun_Phone.ValueData   AS Phone
        , Object_DriverSun.isErased                AS isErased
   FROM Object AS Object_DriverSun
        LEFT JOIN ObjectString AS ObjectString_DriverSun_Phone
                               ON ObjectString_DriverSun_Phone.ObjectId = Object_DriverSun.Id 
                              AND ObjectString_DriverSun_Phone.DescId = zc_ObjectString_DriverSun_Phone()
   WHERE Object_DriverSun.DescId = zc_Object_DriverSun();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_DriverSun(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.03.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DriverSun('3')