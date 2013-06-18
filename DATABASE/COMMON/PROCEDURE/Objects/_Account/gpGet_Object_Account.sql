-- Function: gpGet_Object_Account()

--DROP FUNCTION gpGet_Object_Account();

CREATE OR REPLACE FUNCTION gpGet_Object_Account(
    IN inId          Integer,       -- Счет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,  AccountGroupName TVarChar, AccountGroupId Integer,
               AccountDirectionName TVarChar, AccountDirectionId Integer, InfoMoneyDestinationName TVarChar, InfoMoneyDestinationId Integer,
               InfoMoneyName TVarChar, InfoMoneyId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
     
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST ('' as TVarChar)  AS AccountGroupName
           , CAST (0 as Integer)    AS AccountGroupId
           , CAST ('' as TVarChar)  AS AccountDirectionName
           , CAST (0 as Integer)    AS AccountDirectionId
           , CAST ('' as TVarChar)  AS InfoMoneyDestinationName
           , CAST (0 as Integer)    AS InfoMoneyDestinationId
           , CAST ('' as TVarChar)  AS InfoMoneyName
           , CAST (0 as Integer)    AS InfoMoneyId
       FROM Object 
       WHERE Object.DescId = zc_Object_Account();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Account.Id               AS Id
           , Object_Account.ObjectCode       AS Code
           , Object_Account.ValueData        AS Name
           , Object_Account.isErased         AS isErased
           
           , Object_AccountGroup.ValueData   AS AccountGroupName
           , Object_AccountGroup.Id          AS AccountGroupId

           , Object_AccountDirection.ValueData      AS AccountDirectionName
           , Object_AccountDirection.Id             AS AccountDirectionId

           , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
           , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId

           , Object_InfoMoney.ValueData      AS InfoMoneyName
           , Object_InfoMoney.Id             AS InfoMoneyId

       FROM Object AS Object_Account
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                     ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id
                    AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
            LEFT JOIN Object AS Object_AccountGroup ON Object_AccountGroup.Id = ObjectLink_Account_AccountGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                     ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id
                    AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()
            LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Account_AccountDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoneyDestination
                     ON ObjectLink_Account_InfoMoneyDestination.ObjectId = Object_Account.Id
                    AND ObjectLink_Account_InfoMoneyDestination.DescId = zc_ObjectLink_Account_InfoMoneyDestination()
            LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_Account_InfoMoneyDestination.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                     ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                    AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Account_InfoMoney.ChildObjectId
         
       WHERE Object_Account.Id = inId;
   END IF;      
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Account(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Account('2')