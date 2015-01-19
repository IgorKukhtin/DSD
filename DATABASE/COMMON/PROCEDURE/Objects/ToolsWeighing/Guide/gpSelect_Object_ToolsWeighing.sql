-- Function: gpSelect_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               NameFull TVarChar, NameUser TVarChar, ValueData TVarChar,
               ParentId Integer, ParentName TVarChar,
               isErased boolean, isLeaf boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ToolsWeighing());
--   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
--   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- Результат
   RETURN QUERY
       SELECT
             Object_ToolsWeighing_View.Id
           , Object_ToolsWeighing_View.Code
           , Object_ToolsWeighing_View.Name
           , Object_ToolsWeighing_View.NameFull
           , Object_ToolsWeighing_View.NameUser
           , Object_ToolsWeighing_View.ValueData
           , COALESCE (Object_ToolsWeighing_View.ParentId, 0) AS ParentId
           , Object_ToolsWeighing_View.ParentName
           , Object_ToolsWeighing_View.isErased
           , Object_ToolsWeighing_View.isLeaf
       FROM Object_ToolsWeighing_View

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ToolsWeighing (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing (zfCalc_UserAdmin())
