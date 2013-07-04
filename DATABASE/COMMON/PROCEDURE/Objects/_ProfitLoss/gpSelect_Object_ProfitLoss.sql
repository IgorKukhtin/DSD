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
               onComplete boolean, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProfitLoss());
   
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

           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupId, lfObject_InfoMoney.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupCode, lfObject_InfoMoney.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupName, lfObject_InfoMoney.InfoMoneyGroupName) AS InfoMoneyGroupName

           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationId, lfObject_InfoMoney.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationCode, lfObject_InfoMoney.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationName, lfObject_InfoMoney.InfoMoneyDestinationName) AS InfoMoneyDestinationName

           , lfObject_InfoMoney.InfoMoneyId     AS InfoMoneyId
           , lfObject_InfoMoney.InfoMoneyCode   AS InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName   AS InfoMoneyName
           
           , ObjectBoolean_onComplete.ValueData AS onComplete
           , Object_ProfitLoss.isErased          AS isErased
           
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
            
            LEFT JOIN lfSelect_Object_InfoMoneyDestination() AS lfObject_InfoMoneyDestination ON lfObject_InfoMoneyDestination.InfoMoneyDestinationId = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId
            
            LEFT JOIN ObjectBoolean AS ObjectBoolean_onComplete
                                    ON ObjectBoolean_onComplete.ObjectId = Object_ProfitLoss.Id 
                                   AND ObjectBoolean_onComplete.DescId = zc_ObjectBoolean_ProfitLoss_onComplete()
            
       WHERE Object_ProfitLoss.DescId = zc_Object_ProfitLoss();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ProfitLoss (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.13          * + ObjectBoolean_onComplete               
 24.06.13                                         *  errors
 21.06.13          * плюс все поля 
 18.06.13          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLoss('2')