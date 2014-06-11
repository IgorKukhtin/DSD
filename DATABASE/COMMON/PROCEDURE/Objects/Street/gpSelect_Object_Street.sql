-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Street (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Street(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar 
             , PostalCode TVarChar
             , StreetKindId Integer, StreetKindName TVarChar
             , CityId Integer, CityName TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Street_View.Id
           , Object_Street_View.Name
           
           , Object_Street_View.PostalCode
           
           , Object_Street_View.StreetKindId
           , Object_Street_View.StreetKindName
         
           , Object_Street_View.CityId
           , Object_Street_View.CityName

           , Object_Street_View.ProvinceCityId
           , Object_Street_View.ProvinceCityName
           
           , Object_Street_View.isErased
           
       FROM Object_Street_View;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Street(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.14                        * 
 31.05.14          * 
        
*/

-- тест
-- SELECT * FROM gpSelect_Object_Street (zfCalc_UserAdmin())