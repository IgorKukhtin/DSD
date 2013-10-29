-- Function: gpSelect_Object_ProfitLoss(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProfitLoss (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLoss(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar, 
               ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , InfoMoneyCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyDestinationId Integer, InfoMoneyId Integer
             , onComplete Boolean, isErased Boolean
              )
AS
$BODY$
BEGIN

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

           , Object_InfoMoney_View.InfoMoneyCode
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationCode, Object_InfoMoney_View.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyGroupName) AS InfoMoneyGroupName
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationName, Object_InfoMoney_View.InfoMoneyDestinationName) AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationId, Object_InfoMoney_View.InfoMoneyDestinationId) AS InfoMoneyDestinationId
           , Object_InfoMoney_View.InfoMoneyId
           
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
            
            LEFT JOIN Object_InfoMoneyDestination_View ON Object_InfoMoneyDestination_View.InfoMoneyDestinationId = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ProfitLoss_InfoMoney.ChildObjectId
                                           AND Object_InfoMoneyDestination_View.InfoMoneyDestinationId IS NULL
            
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
 29.10.13                                        * add Object_InfoMoney_View
 04.07.13          * + ObjectBoolean_onComplete               
 24.06.13                                         *  errors
 21.06.13          * плюс все поля 
 18.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLoss('2')
