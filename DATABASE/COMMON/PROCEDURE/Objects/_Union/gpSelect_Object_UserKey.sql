-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_UserKey (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserKey(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     SELECT Object_User.Id
          , Object_User.ObjectCode     
          , Object_User.ValueData
          , ObjectDesc.ItemName
     FROM Object AS Object_User 
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_User.DescId
     WHERE Object_User.DescId = zc_Object_User()
    UNION ALL
     SELECT Object_Role.Id
          , Object_Role.ObjectCode     
          , Object_Role.ValueData
          , ObjectDesc.ItemName
     FROM Object AS Object_Role
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Role.DescId
     WHERE Object_Role.DescId = zc_Object_Role();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UserKey (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := '9818')
