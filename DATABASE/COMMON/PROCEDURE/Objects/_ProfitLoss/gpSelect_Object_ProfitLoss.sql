-- Function: gpSelect_Object_ProfitLoss(TVarChar)

--DROP FUNCTION gpSelect_Object_ProfitLoss(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLoss(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, 
               isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProfitLoss());
   
   -- таблица для справочника уп-назначения (на самом деле это три спраочника)
   CREATE TEMP TABLE tmpInfoMoney2 (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
                                   InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar);

   -- таблица для 
   CREATE TEMP TABLE tmpInfoMoney (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
                                   InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
                                   InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar);
   
   -- Выбираем данные для справочника уп-назначения (на самом деле это три спраочника)
   INSERT INTO tmpInfoMoney (InfoMoneyGroupId, InfoMoneyGroupCode, InfoMoneyGroupName, 
                             InfoMoneyDestinationId, InfoMoneyDestinationCode, InfoMoneyDestinationName, 
                             InfoMoneyId, InfoMoneyCode, InfoMoneyName)
     SELECT 
           Object_InfoMoneyGroup.ObjectCode 
          ,Object_InfoMoneyGroup.Id
          ,Object_InfoMoneyGroup.ValueData
          
          ,Object_InfoMoneyDestination.ObjectCode
          ,Object_InfoMoneyDestination.Id
          ,Object_InfoMoneyDestination.ValueData
          
          ,Object_InfoMoney.ObjectCode
          ,Object_InfoMoney.Id
          ,Object_InfoMoney.ValueData
          
     FROM Object AS Object_InfoMoney
         
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                   ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id 
                  AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
            LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                   ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id 
                  AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
            LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId

     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();

   -- группируем данные из справочника уп-назначения (по двум справоникам)
   INSERT INTO tmpInfoMoney2 (InfoMoneyGroupId, InfoMoneyGroupCode, InfoMoneyGroupName, InfoMoneyDestinationId, InfoMoneyDestinationCode, InfoMoneyDestinationName)
      SELECT tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationName
      FROM tmpInfoMoney
      GROUP BY tmpInfoMoney.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationName;

     RETURN QUERY 
        SELECT 
             Object_ProfitLoss.Id               AS Id
           , Object_ProfitLoss.ObjectCode       AS Code
           , Object_ProfitLoss.ValueData        AS Name
           
           , Object_ProfitLossGroup.Id          AS ProfitLossGroupId
           , Object_ProfitLossGroup.ObjectCode  AS ProfitLossGroupCode
           , Object_ProfitLossGroup.ValueData   AS ProfitLossGroupName
           
           , Object_ProfitLossDirection.Id          AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ObjectCode  AS ProfitLossDirectionCode
           , Object_ProfitLossDirection.ValueData   AS ProfitLossDirectionName

           , COALESCE (tmpInfoMoney2.InfoMoneyGroupId, tmpInfoMoney.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (tmpInfoMoney2.InfoMoneyGroupCode, tmpInfoMoney.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (tmpInfoMoney2.InfoMoneyGroupName, tmpInfoMoney.InfoMoneyGroupName) AS InfoMoneyGroupName

           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationId, tmpInfoMoney.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationCode, tmpInfoMoney.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (tmpInfoMoney2.InfoMoneyDestinationName, tmpInfoMoney.InfoMoneyDestinationName) AS InfoMoneyDestinationName

           , tmpInfoMoney.InfoMoneyId     AS InfoMoneyId
           , tmpInfoMoney.InfoMoneyCode   AS InfoMoneyCode
           , tmpInfoMoney.InfoMoneyName   AS InfoMoneyName
           
           , Object_ProfitLoss.isErased         AS isErased
       FROM Object AS Object_ProfitLoss
            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossGroup
                     ON ObjectLink_ProfitLoss_ProfitLossGroup.ObjectId = Object_ProfitLoss.Id
                    AND ObjectLink_ProfitLoss_ProfitLossGroup.DescId = zc_ObjectLink_ProfitLoss_ProfitLossGroup()
            LEFT JOIN Object AS Object_ProfitLossGroup ON Object_ProfitLossGroup.Id = ObjectLink_ProfitLoss_ProfitLossGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_ProfitLossDirection
                     ON ObjectLink_ProfitLoss_ProfitLossDirection.ObjectId = Object_ProfitLoss.Id
                    AND ObjectLink_ProfitLoss_ProfitLossDirection.DescId = zc_ObjectLink_ProfitLoss_ProfitLossDirection()
            LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_ProfitLoss_ProfitLossDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_InfoMoneyDestination
                     ON ObjectLink_ProfitLoss_InfoMoneyDestination.ObjectId = Object_ProfitLoss.Id
                    AND ObjectLink_ProfitLoss_InfoMoneyDestination.DescId = zc_ObjectLink_ProfitLoss_InfoMoneyDestination()
            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_InfoMoney
                     ON ObjectLink_ProfitLoss_InfoMoney.ObjectId = Object_ProfitLoss.Id
                    AND ObjectLink_ProfitLoss_InfoMoney.DescId = zc_ObjectLink_ProfitLoss_InfoMoney()
            
            LEFT JOIN tmpInfoMoney2 ON tmpInfoMoney2.InfoMoneyDestinationId = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId
            LEFT JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId
       WHERE Object_ProfitLoss.DescId = zc_Object_ProfitLoss();
  
   DROP TABLE tmpInfoMoney;
   DROP TABLE tmpInfoMoney2;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ProfitLoss (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          * плюс все поля 
 18.06.13          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLoss('2')