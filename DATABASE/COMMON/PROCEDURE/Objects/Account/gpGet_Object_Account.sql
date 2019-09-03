-- Function: gpGet_Object_Account()

DROP FUNCTION IF EXISTS gpGet_Object_Account (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Account(
    IN inId          Integer,       -- Счет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar, 
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar, 
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, 
               AccountKindId Integer, AccountKindCode Integer, AccountKindName TVarChar,
               isPrintDetail Boolean,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Account());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Account()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS AccountGroupId
           , CAST (0 as Integer)    AS AccountGroupCode
           , CAST ('' as TVarChar)  AS AccountGroupName

           , CAST (0 as Integer)    AS AccountDirectionId
           , CAST (0 as Integer)    AS AccountDirectionCode
           , CAST ('' as TVarChar)  AS AccountDirectionName

           , CAST (0 as Integer)   AS InfoMoneyGroupId
           , CAST (0 as Integer)   AS InfoMoneyGroupCode
           , CAST ('' as TVarChar) AS InfoMoneyGroupName

           , CAST (0 as Integer)    AS InfoMoneyDestinationId
           , CAST (0 as Integer)    AS InfoMoneyDestinationCode
           , CAST ('' as TVarChar)  AS InfoMoneyDestinationName

           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST (0 as Integer)    AS InfoMoneyCode
           , CAST ('' as TVarChar)  AS InfoMoneyName

           , CAST (0 as Integer)    AS AccountKindId
           , CAST (0 as Integer)    AS AccountKindCode
           , CAST ('' as TVarChar)  AS AccountKindName
           , CAST (FALSE AS Boolean) AS isPrintDetail
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Account.Id               AS Id
           , Object_Account.ObjectCode       AS Code
           , Object_Account.ValueData        AS Name

           , Object_AccountGroup.Id          AS AccountGroupId
           , Object_AccountGroup.ObjectCode  AS AccountGroupCode
           , Object_AccountGroup.ValueData   AS AccountGroupName
           
           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ObjectCode AS AccountDirectionCode
           , Object_AccountDirection.ValueData  AS AccountDirectionName
           
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupId, lfObject_InfoMoney.InfoMoneyGroupId)     AS InfoMoneyGroupId
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupCode, lfObject_InfoMoney.InfoMoneyGroupCode) AS InfoMoneyGroupCode
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyGroupName, lfObject_InfoMoney.InfoMoneyGroupName) AS InfoMoneyGroupName

           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationId, lfObject_InfoMoney.InfoMoneyDestinationId)     AS InfoMoneyDestinationId
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationCode, lfObject_InfoMoney.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (lfObject_InfoMoneyDestination.InfoMoneyDestinationName, lfObject_InfoMoney.InfoMoneyDestinationName) AS InfoMoneyDestinationName

           , lfObject_InfoMoney.InfoMoneyId     AS InfoMoneyId
           , lfObject_InfoMoney.InfoMoneyCode   AS InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName   AS InfoMoneyName
           
           , Object_AccountKind.Id          AS AccountKindId
           , Object_AccountKind.ObjectCode  AS AccountKindCode
           , Object_AccountKind.ValueData   AS AccountKindName

           , COALESCE (ObjectBoolean_PrintDetail.ValueData, FALSE) :: Boolean AS isPrintDetail

           , Object_Account.isErased      AS isErased

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
            LEFT JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                                 ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()
         
            LEFT JOIN lfSelect_Object_InfoMoneyDestination() AS lfObject_InfoMoneyDestination ON lfObject_InfoMoneyDestination.InfoMoneyDestinationId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountKind
                                 ON ObjectLink_Account_AccountKind.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
            LEFT JOIN Object AS Object_AccountKind ON Object_AccountKind.Id = ObjectLink_Account_AccountKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PrintDetail
                                    ON ObjectBoolean_PrintDetail.ObjectId = Object_Account.Id 
                                   AND ObjectBoolean_PrintDetail.DescId = zc_ObjectBoolean_Account_PrintDetail()

       WHERE Object_Account.Id = inId;
   END IF;      

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Account (Integer, TVarChar)  OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.19          * isPrintDetail
 04.07.13          * + lfSelect...  + AccountKind           
 24.06.13                                         *  errors
 21.06.13          *                              *  создание врем.таблиц
 17.06.13          *

*/

-- тест
--SELECT * FROM gpGet_Object_Account (1, '2')