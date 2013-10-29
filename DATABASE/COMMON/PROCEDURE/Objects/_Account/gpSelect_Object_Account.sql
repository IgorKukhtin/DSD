-- Function: gpSelect_Object_Account(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Account (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Account(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , AccountName_All TVarChar
             , AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar
             , AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar
             , InfoMoneyCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyDestinationId Integer, InfoMoneyId Integer
             , AccountKindId Integer, AccountKindCode Integer, AccountKindName TVarChar
             , onComplete Boolean, isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     RETURN QUERY 
       SELECT
             Object_Account.Id               AS Id
           , Object_Account.ObjectCode       AS Code
           , Object_Account.ValueData        AS Name

           , ('(' || Object_Account.ObjectCode :: TVarChar || ') '
                  || Object_AccountGroup.ValueData || ' '
                  || Object_AccountDirection.ValueData || ' '
                  || Object_Account.ValueData
             ) :: TVarChar AS AccountName_All

           , Object_AccountGroup.Id          AS AccountGroupId
           , Object_AccountGroup.ObjectCode  AS AccountGroupCode
           , Object_AccountGroup.ValueData   AS AccountGroupName
           
           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ObjectCode AS AccountDirectionCode
           , Object_AccountDirection.ValueData  AS AccountDirectionName
           
           , Object_InfoMoney_View.InfoMoneyCode
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationCode, Object_InfoMoney_View.InfoMoneyDestinationCode) AS InfoMoneyDestinationCode
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyGroupName) AS InfoMoneyGroupName
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationName, Object_InfoMoney_View.InfoMoneyDestinationName) AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , COALESCE (Object_InfoMoneyDestination_View.InfoMoneyDestinationId, Object_InfoMoney_View.InfoMoneyDestinationId) AS InfoMoneyDestinationId
           , Object_InfoMoney_View.InfoMoneyId
           
           , Object_AccountKind.Id          AS AccountKindId
           , Object_AccountKind.ObjectCode  AS AccountKindCode
           , Object_AccountKind.ValueData   AS AccountKindName

           , ObjectBoolean_onComplete.ValueData AS onComplete
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
         
            LEFT JOIN Object_InfoMoneyDestination_View ON Object_InfoMoneyDestination_View.InfoMoneyDestinationId = ObjectLink_Account_InfoMoneyDestination.ChildObjectId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Account_InfoMoney.ChildObjectId
                                           AND Object_InfoMoneyDestination_View.InfoMoneyDestinationId IS NULL

            LEFT JOIN ObjectBoolean AS ObjectBoolean_onComplete
                                    ON ObjectBoolean_onComplete.ObjectId = Object_Account.Id 
                                   AND ObjectBoolean_onComplete.DescId = zc_ObjectBoolean_Account_onComplete()
            
            LEFT JOIN ObjectLink AS ObjectLink_Account_AccountKind
                                 ON ObjectLink_Account_AccountKind.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_AccountKind.DescId = zc_ObjectLink_Account_AccountKind()
            LEFT JOIN Object AS Object_AccountKind ON Object_AccountKind.Id = ObjectLink_Account_AccountKind.ChildObjectId

       WHERE Object_Account.DescId = zc_Object_Account();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Account (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.13                                        * add Object_InfoMoney_View
 04.07.13          * + onComplete... +AccountKind...
 03.07.13                                         *  1251Cyr
 24.06.13                                         *  errors
 21.06.13          *                              *  создание врем.таблиц
 17.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Account (zfCalc_UserAdmin())