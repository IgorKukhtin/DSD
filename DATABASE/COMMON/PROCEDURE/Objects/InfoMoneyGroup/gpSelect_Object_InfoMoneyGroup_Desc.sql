-- Function: gpSelect_Object_InfoMoneyGroup_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyGroup_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyGroup_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoneyGroup());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
     SELECT tmp.InfoMoneyGroupId   AS Id
          , tmp.InfoMoneyGroupCode AS Code
          , tmp.InfoMoneyGroupName AS Name
          , Object_InfoMoneyGroup.isErased AS isErased

     FROM gpSelect_Object_InfoMoney_Desc (inDescCode, inSession) AS tmp
          LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = tmp.InfoMoneyGroupId
     WHERE tmp.InfoMoneyGroupId <> 0
     GROUP BY tmp.InfoMoneyGroupId
            , tmp.InfoMoneyGroupCode
            , tmp.InfoMoneyGroupName
            , Object_InfoMoneyGroup.isErased
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyGroup_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyGroup_Desc ('zc_Object_Juridical', zfCalc_UserAdmin()) ORDER BY Code
