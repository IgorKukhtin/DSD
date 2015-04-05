-- Function: gpSelect_Object_AccountGroup_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AccountGroup_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccountGroup_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_AccountGroup());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
     SELECT tmp.AccountGroupId   AS Id
          , tmp.AccountGroupCode AS Code
          , tmp.AccountGroupName AS Name
          , Object_AccountGroup.isErased AS isErased

     FROM gpSelect_Object_Account_Desc (inDescCode, inSession) AS tmp
          LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = tmp.AccountGroupId
     WHERE tmp.AccountGroupId <> 0
     GROUP BY tmp.AccountGroupId
            , tmp.AccountGroupCode
            , tmp.AccountGroupName
            , Object_AccountGroup.isErased
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AccountGroup_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_AccountGroup_Desc ('zc_Object_Goods', zfCalc_UserAdmin()) ORDER BY Code
