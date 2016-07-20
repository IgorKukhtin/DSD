-- Function: gpSelect_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternal(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL TVarChar
             , Service TVarChar
             , Port TVarChar
             , UserName TVarChar
             , Password TVarChar
               ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());

   RETURN QUERY 
   SELECT Object_DiscountExternal.Id             AS Id
        , Object_DiscountExternal.ObjectCode     AS Code
        , Object_DiscountExternal.ValueData      AS Name

        , ObjectString_URL.ValueData       AS URL
        , ObjectString_Service.ValueData   AS Service
        , ObjectString_Port.ValueData      AS Port
        , ObjectString_User.ValueData      AS UserName
        , ObjectString_Password.ValueData  AS Password

   FROM Object AS Object_DiscountExternal
      LEFT JOIN ObjectString AS ObjectString_URL
                             ON ObjectString_URL.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_URL.DescId = zc_ObjectString_DiscountExternal_URL()
      LEFT JOIN ObjectString AS ObjectString_Service
                             ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()
      LEFT JOIN ObjectString AS ObjectString_Port
                             ON ObjectString_Port.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Port.DescId = zc_ObjectString_DiscountExternal_Port()
      LEFT JOIN ObjectString AS ObjectString_User
                             ON ObjectString_User.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_User.DescId = zc_ObjectString_DiscountExternal_User()
      LEFT JOIN ObjectString AS ObjectString_Password
                             ON ObjectString_Password.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternal_Password()

   WHERE Object_DiscountExternal.DescId = zc_Object_DiscountExternal()
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountExternal ('2')
