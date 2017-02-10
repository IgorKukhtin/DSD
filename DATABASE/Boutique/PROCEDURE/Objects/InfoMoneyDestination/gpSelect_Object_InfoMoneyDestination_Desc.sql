-- Function: gpSelect_Object_InfoMoneyDestination_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyDestination_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyDestination_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoneyDestination());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     SELECT tmp.InfoMoneyDestinationId   AS Id
          , tmp.InfoMoneyDestinationCode AS Code
          , tmp.InfoMoneyDestinationName AS Name
	   
          , tmp.InfoMoneyGroupId
          , tmp.InfoMoneyGroupCode
          , tmp.InfoMoneyGroupName
          , Object_InfoMoneyDestination.isErased AS isErased
     FROM gpSelect_Object_InfoMoney_Desc (inDescCode, inSession) AS tmp
          LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = tmp.InfoMoneyDestinationId
     WHERE tmp.InfoMoneyDestinationId <> 0
     GROUP BY tmp.InfoMoneyDestinationId
            , tmp.InfoMoneyDestinationCode
            , tmp.InfoMoneyDestinationName
	   
            , tmp.InfoMoneyGroupId
            , tmp.InfoMoneyGroupCode
            , tmp.InfoMoneyGroupName
            , Object_InfoMoneyDestination.isErased
    ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyDestination_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyDestination_Desc ('zc_Object_Juridical', zfCalc_UserAdmin()) ORDER BY Code
