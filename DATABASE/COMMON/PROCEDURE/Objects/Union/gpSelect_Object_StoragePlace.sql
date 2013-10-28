-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_StoragePlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoragePlace(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY
     SELECT Object_Unit_View.Id       
          , Object_Unit_View.Code     
          , Object_Unit_View.Name
          , Object_Unit_View.isErased
     FROM Object_Unit_View
    UNION ALL
     SELECT Object_Personal_View.PersonalId AS Id       
          , Object_Personal_View.PersonalCode     
          , Object_Personal_View.PersonalName
          , Object_Personal_View.isErased
     FROM Object_Personal_View;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ObjectFrom_byIncomeFuel (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectFrom_byIncomeFuel (inOperDate := CURRENT_DATE, inSession := zfCalc_UserAdmin())