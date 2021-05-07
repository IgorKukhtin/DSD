-- Function: gpSelect_Object_DriverSun()

DROP FUNCTION IF EXISTS gpSelect_Object_DriverSun(boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DriverSun(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Phone TVarChar, ChatIDSendVIP Integer
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_DriverSun.Id                        AS Id 
        , Object_DriverSun.ObjectCode                AS Code
        , Object_DriverSun.ValueData                 AS Name
        , ObjectString_DriverSun_Phone.ValueData     AS Phone
        , DriverSun_ChatIDSendVIP.ValueData::Integer AS ChatIDSendVIP
        , Object_DriverSun.isErased                  AS isErased
   FROM Object AS Object_DriverSun
        LEFT JOIN ObjectString AS ObjectString_DriverSun_Phone
                               ON ObjectString_DriverSun_Phone.ObjectId = Object_DriverSun.Id 
                              AND ObjectString_DriverSun_Phone.DescId = zc_ObjectString_DriverSun_Phone()
        LEFT JOIN ObjectFloat AS DriverSun_ChatIDSendVIP
                              ON DriverSun_ChatIDSendVIP.ObjectId = Object_DriverSun.Id 
                             AND DriverSun_ChatIDSendVIP.DescId = zc_ObjectFloat_DriverSun_ChatIDSendVIP()
   WHERE Object_DriverSun.DescId = zc_Object_DriverSun()
     AND (Object_DriverSun.isErased = False OR COALESCE(inIsErased, False) = True);
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_DriverSun(boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.20                                                       *
 05.03.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DriverSun(False, '3')