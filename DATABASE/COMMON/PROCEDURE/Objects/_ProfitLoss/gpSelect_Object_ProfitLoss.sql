-- Function: gpSelect_Object_ProfitLoss(TVarChar)

--DROP FUNCTION gpSelect_Object_ProfitLoss(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLoss(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProfitLoss());

     RETURN QUERY 
       SELECT 
             Object_ProfitLoss.Id            AS Id
           , Object_ProfitLoss.ObjectCode    AS Code
           , Object_ProfitLoss.ValueData     AS Name
           , Object_ProfitLoss.isErased      AS isErased
           
           , Object_ProfitLossGroup.Id       AS ProfitLossGroupId
           , Object_ProfitLossDirection.Id   AS ProfitLossDirectionId
           , Object_InfoMoneyDestination.Id  AS InfoMoneyDestinationId
           , Object_InfoMoney.Id             AS InfoMoneyId

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
            LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_ProfitLoss_InfoMoneyDestination.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProfitLoss_InfoMoney
                     ON ObjectLink_ProfitLoss_InfoMoney.ObjectId = Object_ProfitLoss.Id
                    AND ObjectLink_ProfitLoss_InfoMoney.DescId = zc_ObjectLink_ProfitLoss_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ProfitLoss_InfoMoney.ChildObjectId
       WHERE Object_ProfitLoss.DescId = zc_Object_ProfitLoss();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_ProfitLoss(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *
 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLoss('2')