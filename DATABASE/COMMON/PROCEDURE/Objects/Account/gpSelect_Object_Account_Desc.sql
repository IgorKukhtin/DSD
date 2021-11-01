-- Function: gpSelect_Object_Account_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Account_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Account_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , AccountName_All TVarChar
             , AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar
             , AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar
             , InfoMoneyCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyDestinationId Integer, InfoMoneyId Integer
             , AccountKindId Integer, AccountKindCode Integer, AccountKindName TVarChar
             , onComplete Boolean
             , isPrintDetail Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Account());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmpDesc AS (SELECT ObjectDesc.Id
                             , CASE WHEN ObjectDesc.Id = zc_Object_Juridical()
                                         THEN zc_ContainerLinkObject_Juridical()
                                    WHEN ObjectDesc.Id = zc_Object_Goods()
                                         THEN zc_ContainerLinkObject_Goods()
                                    WHEN ObjectDesc.Id = zc_Object_Cash()
                                         THEN zc_ContainerLinkObject_Cash()
                                    WHEN ObjectDesc.Id = zc_Object_Member()
                                         THEN zc_ContainerLinkObject_Member()
                                    WHEN ObjectDesc.Id = zc_Object_Personal()
                                         THEN zc_ContainerLinkObject_Personal()
                                    ELSE 0
                               END AS DescId
                        FROM ObjectDesc
                        WHERE ObjectDesc.Code = inDescCode
                       )
          , tmpContainer AS (SELECT DISTINCT Container.ObjectId AS AccountId
                             FROM tmpDesc
                                  INNER JOIN Object ON Object.DescId = tmpDesc.Id
                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = Object.Id
                                                                AND (ContainerLinkObject.DescId = tmpDesc.DescId
                                                                  OR tmpDesc.DescId = 0)
                                  INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                      AND Container.DescId = zc_Container_Summ()
                             WHERE 1=0
                            )
          , tmpLevel AS (SELECT AccountId FROM lfSelect_Object_Account_Level (vbUserId) WHERE 1=0)
          , tmpAccount AS (SELECT * FROM gpSelect_Object_Account (inSession))

       -- Результат
       /*SELECT tmpAccount.*
       FROM tmpContainer
            INNER JOIN tmpLevel ON tmpLevel.AccountId = tmpContainer.AccountId
            INNER JOIN tmpAccount ON tmpAccount.Id = tmpContainer.AccountId
      UNION*/
       SELECT tmpAccount.*
       FROM tmpAccount --WHERE inDescCode = ''
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Account_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Account_Desc ('zc_Object_Cash', zfCalc_UserAdmin()) ORDER BY Code
-- SELECT * FROM gpSelect_Object_Account_Desc ('zc_Object_Juridical', zfCalc_UserAdmin()) ORDER BY Code
