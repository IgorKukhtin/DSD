-- Function: gpGet_Object_InfoMoney(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_InfoMoney (integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoney(
    IN inId          Integer,       -- Группы управленческих аналитик
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               CashFlowId_in Integer, CashFlowName_in TVarChar,
               CashFlowId_out Integer, CashFlowName_out TVarChar,
               isProfitLoss boolean,
               isErased boolean) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_InfoMoney());
      
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
          
           , CAST (0 as Integer)    AS InfoMoneyGroupId
           , CAST (0 as Integer)    AS InfoMoneyGroupCode
           , CAST ('' as TVarChar)  AS InfoMoneyGroupName
                     
           , CAST (0 as Integer)    AS InfoMoneyDestinationId
           , CAST (0 as Integer)    AS InfoMoneyDestinationCode
           , CAST ('' as TVarChar)  AS InfoMoneyDestinationName
           , CAST (0 AS Integer)    AS CashFlowId_in
           , CAST ('' AS TVarChar)  AS CashFlowName_in
           , CAST (0 AS Integer)    AS CashFlowId_out
           , CAST ('' AS TVarChar)  AS CashFlowName_out
           , FALSE                  AS isProfitLoss
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_InfoMoney();
   ELSE
      RETURN QUERY 
      SELECT 
           Object_InfoMoney.Id                   AS Id
         , Object_InfoMoney.ObjectCode           AS Code
         , Object_InfoMoney.ValueData            AS Name
    
         , Object_InfoMoneyGroup.Id              AS InfoMoneyGroupId
         , Object_InfoMoneyGroup.ObjectCode      AS InfoMoneyGroupCode
         , Object_InfoMoneyGroup.ValueData       AS InfoMoneyGroupName
        
         , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
         , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
         , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName

         , Object_CashFlow_in.Id                  AS CashFlowId_in
         , Object_CashFlow_in.ValueData           AS CashFlowName_in

         , Object_CashFlow_out.Id                 AS CashFlowId_out
         , Object_CashFlow_out.ValueData          AS CashFlowName_out

         , COALESCE (ObjectBoolean_ProfitLoss.ValueData, False)  AS isProfitLoss

         , Object_InfoMoney.isErased              AS isErased
      FROM Object AS Object_InfoMoney
          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                               ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                              AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
          LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                               ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                              AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
          LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_in
                               ON ObjectLink_InfoMoney_CashFlow_in.ObjectId = Object_InfoMoney.Id
                              AND ObjectLink_InfoMoney_CashFlow_in.DescId = zc_ObjectLink_InfoMoney_CashFlow_in()
          LEFT JOIN Object AS Object_CashFlow_in ON Object_CashFlow_in.Id = ObjectLink_InfoMoney_CashFlow_in.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_out
                               ON ObjectLink_InfoMoney_CashFlow_out.ObjectId = Object_InfoMoney.Id
                              AND ObjectLink_InfoMoney_CashFlow_out.DescId = zc_ObjectLink_InfoMoney_CashFlow_out()
          LEFT JOIN Object AS Object_CashFlow_out ON Object_CashFlow_out.Id = ObjectLink_InfoMoney_CashFlow_out.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_ProfitLoss
                                  ON ObjectBoolean_ProfitLoss.ObjectId = Object_InfoMoney.Id
                                 AND ObjectBoolean_ProfitLoss.DescId = zc_ObjectBoolean_InfoMoney_ProfitLoss()

     WHERE Object_InfoMoney.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InfoMoney (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.20          * CashFlow
 21.06.13          * + все поля ; IF COALESCE (inId, 0) = 0....             
 00.06.13         

*/

-- тест
-- SELECT * FROM gpSelect_User('2')