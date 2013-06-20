-- Function: gpGet_Object_ProfitLoss()

--DROP FUNCTION gpGet_Object_ProfitLoss();

CREATE OR REPLACE FUNCTION gpGet_Object_ProfitLoss(
    IN inId          Integer,       -- Счет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,  ProfitLossGroupName TVarChar, ProfitLossGroupId Integer,
               ProfitLossDirectionName TVarChar, ProfitLossDirectionId Integer, InfoMoneyDestinationName TVarChar, InfoMoneyDestinationId Integer,
               InfoMoneyName TVarChar, InfoMoneyId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProfitLoss());
     
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST ('' as TVarChar)  AS ProfitLossGroupName
           , CAST (0 as Integer)    AS ProfitLossGroupId
           , CAST ('' as TVarChar)  AS ProfitLossDirectionName
           , CAST (0 as Integer)    AS ProfitLossDirectionId
           , CAST ('' as TVarChar)  AS InfoMoneyDestinationName
           , CAST (0 as Integer)    AS InfoMoneyDestinationId
           , CAST ('' as TVarChar)  AS InfoMoneyName
           , CAST (0 as Integer)    AS InfoMoneyId
       FROM Object 
       WHERE Object.DescId = zc_Object_ProfitLoss();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ProfitLoss.Id               AS Id
           , Object_ProfitLoss.ObjectCode       AS Code
           , Object_ProfitLoss.ValueData        AS Name
           , Object_ProfitLoss.isErased         AS isErased
           
           , Object_ProfitLossGroup.ValueData   AS ProfitLossGroupName
           , Object_ProfitLossGroup.Id          AS ProfitLossGroupId

           , Object_ProfitLossDirection.ValueData   AS ProfitLossDirectionName
           , Object_ProfitLossDirection.Id          AS ProfitLossDirectionId

           , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
           , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId

           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_InfoMoney.Id                AS InfoMoneyId

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
         
       WHERE Object_ProfitLoss.Id = inId;
   END IF;      
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_ProfitLoss(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_ProfitLoss('2')