-- Function: gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_Desc(
    IN inDescCode    TVarChar,      --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isProfitLoss Boolean,
               isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbInfoMoneyGroupId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры 
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
     vbUserId:= lpGetUserBySession (inSession);

     IF STRPOS (inDescCode, 'zc_Enum_InfoMoneyGroup') = 1
     THEN
         vbInfoMoneyGroupId:= (SELECT Value FROM gpExecSql_Value ('SELECT '||inDescCode||'() :: TVarChar', inSession)) :: Integer;
     END IF;

     IF inDescCode = 'zc_Movement_InfoMoney' 
     THEN 
         RETURN QUERY
         SELECT tmpInfoMoney.Id, tmpInfoMoney.Code, tmpInfoMoney.Name, tmpInfoMoney.NameAll
              , tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName
              , tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode
              , tmpInfoMoney.InfoMoneyDestinationName
              , tmpInfoMoney.isProfitLoss
              , tmpInfoMoney.isErased
         FROM gpSelect_Object_InfoMoney (inSession) AS tmpInfoMoney
         WHERE tmpInfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500()
        UNION
         SELECT NULL AS Id, NULL AS Code, 'Нет значения' ::TVarChar AS Name, 'Нет значения' ::TVarChar AS NameAll
              , NULL AS InfoMoneyGroupId, NULL AS InfoMoneyGroupCode, ''::TVarChar AS InfoMoneyGroupName
              , NULL AS InfoMoneyDestinationId, NULL AS InfoMoneyDestinationCode
              , ''::TVarChar AS InfoMoneyDestinationName
              , FALSE AS isProfitLoss
              , FALSE AS isErased
         ;
     ELSE
     
     -- Результат
     RETURN QUERY 
       WITH tmpDesc AS (SELECT ObjectDesc.Id
                             , CASE WHEN ObjectDesc.Id = zc_Object_Juridical()
                                         THEN zc_ContainerLinkObject_Juridical()
                                    WHEN ObjectDesc.Id = zc_Object_Member()
                                         THEN zc_ContainerLinkObject_Member()
                                    WHEN ObjectDesc.Id = zc_Object_Personal()
                                         THEN zc_ContainerLinkObject_Personal()
                                    ELSE 0
                               END AS DescId
                        FROM ObjectDesc
                        WHERE ObjectDesc.Code = inDescCode
                       )
          , tmpContainer AS (SELECT ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                             FROM tmpDesc
                                  INNER JOIN Object ON Object.DescId = tmpDesc.Id
                                  INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = Object.Id
                                                                AND (ContainerLinkObject.DescId = tmpDesc.DescId
                                                                  OR tmpDesc.DescId = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = ContainerLinkObject.ContainerId
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND ContainerLinkObject_InfoMoney.ObjectId > 0
                                  INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                                      AND Container.DescId = zc_Container_Summ()
                             WHERE vbUserId <> 14599 -- Коротченко Т.Н.
                             GROUP BY ContainerLinkObject_InfoMoney.ObjectId

                            UNION
                             SELECT Object_InfoMoney_View.InfoMoneyId
                             FROM Object_InfoMoney_View
                             WHERE Object_InfoMoney_View.InfoMoneyCode <> 30401 -- Доходы + услуги предоставленные
                                OR vbUserId = 14599 -- Коротченко Т.Н.
                            )
          , tmpLevel AS (SELECT InfoMoneyId FROM lfSelect_Object_InfoMoney_Level (vbUserId))
          , tmpInfoMoney AS (SELECT * FROM gpSelect_Object_InfoMoney (inSession))

       -- Результат
       SELECT tmpInfoMoney.Id, tmpInfoMoney.Code, tmpInfoMoney.Name, tmpInfoMoney.NameAll
            , tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName
            , tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode
            , tmpInfoMoney.InfoMoneyDestinationName
            , tmpInfoMoney.isProfitLoss
            , tmpInfoMoney.isErased
       FROM tmpContainer
            INNER JOIN tmpLevel ON tmpLevel.InfoMoneyId = tmpContainer.InfoMoneyId
            INNER JOIN tmpInfoMoney ON tmpInfoMoney.Id = tmpContainer.InfoMoneyId
      /*UNION
       SELECT tmpInfoMoney.*
       FROM tmpInfoMoney 
       WHERE tmpInfoMoney.Id = 0*/
       ;  
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_InfoMoney_Desc (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.24         *
 04.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney_Desc ('zc_Enum_InfoMoneyGroup_30000', zfCalc_UserAdmin()) ORDER BY Code
-- SELECT * FROM gpSelect_Object_InfoMoney_Desc ('zc_Object_Juridical', zfCalc_UserAdmin()) ORDER BY Code
-- SELECT * FROM gpSelect_Object_InfoMoney_Desc ('zc_Movement_InfoMoney' , zfCalc_UserAdmin()) ORDER BY Code
