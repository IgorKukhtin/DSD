-- Function: gpSelect_Object_Member_Desc (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_Desc (TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_Desc(
    IN inDescCode    TVarChar,      --
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
             , isOfficial Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);


   -- Результат
   RETURN QUERY 
       WITH tmpDesc AS (SELECT ObjectDesc.Id
                             , CASE WHEN ObjectDesc.Id = zc_Object_Member()
                                         THEN zc_ContainerLinkObject_Member()
                                    ELSE 0
                               END AS DescId
                        FROM ObjectDesc
                        WHERE ObjectDesc.Code = inDescCode
                       )
          , tmpContainer AS (SELECT ContainerLinkObject.ObjectId AS MemberId
                             FROM tmpDesc
                                  INNER JOIN Object ON Object.DescId = tmpDesc.Id
                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = Object.Id
                                                                AND (ContainerLinkObject.DescId = tmpDesc.DescId
                                                                  OR tmpDesc.DescId = 0)
                                  INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                      AND Container.DescId = zc_Container_Summ()
                             GROUP BY ContainerLinkObject.ObjectId
                            )
          , tmpMember AS (SELECT * FROM gpSelect_Object_Member (inIsShowAll, inSession))

       -- Результат
       SELECT tmpMember.*
       FROM tmpContainer
            INNER JOIN tmpMember ON tmpMember.Id = tmpContainer.MemberId
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Member_Desc (TVarChar, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.15                                        *
*/
-- тест
-- SELECT * FROM gpSelect_Object_Member_Desc ('zc_Object_Member', FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Member_Desc ('zc_Object_Member', TRUE, zfCalc_UserAdmin())
