-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_StoragePlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoragePlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
     SELECT Object_Unit_View.Id
          , Object_Unit_View.Code     
          , Object_Unit_View.Name
          , ObjectDesc.ItemName
          , Object_Unit_View.isErased
     FROM Object_Unit_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit_View.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
    UNION ALL
     SELECT Object_Personal_View.PersonalId AS Id       
          , Object_Personal_View.PersonalCode     
          , Object_Personal_View.PersonalName
          , ObjectDesc.ItemName
          , Object_Personal_View.isErased
     FROM Object_Personal_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Personal_View.DescId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ObjectFrom_byIncomeFuel (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.13                                        * add tmpUserTransport
 09.11.13                                        * add ItemName
 28.10.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := '9818')
