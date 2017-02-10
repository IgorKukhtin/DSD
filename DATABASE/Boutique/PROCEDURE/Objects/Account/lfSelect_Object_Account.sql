-- Function: lfSelect_Object_Account ()

DROP FUNCTION IF EXISTS lfSelect_Object_Account ();

CREATE OR REPLACE FUNCTION lfSelect_Object_Account()

RETURNS TABLE (AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar, 
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar, 
               AccountId Integer, AccountCode Integer, AccountName TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar,
               AccountKindId Integer, AccountKindCode Integer, AccountKindName TVarChar,
               onComplete Boolean)
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY 
       SELECT 
             Object_AccountGroup.Id            AS AccountGroupId
           , Object_AccountGroup.ObjectCode    AS AccountGroupCode
           , Object_AccountGroup.ValueData     AS AccountGroupName
          
           , Object_AccountDirection.Id           AS AccountDirectionId
           , Object_AccountDirection.ObjectCode   AS AccountDirectionCode
           , Object_AccountDirection.ValueData    AS AccountDirectionName
          
           , Object_Account.Id           AS AccountId
           , Object_Account.ObjectCode   AS AccountCode
           , Object_Account.ValueData    AS AccountName
          
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
           
           , COALESCE (ObjectBoolean_onComplete.ValueData, FALSE)  AS onComplete
           
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
ALTER FUNCTION lfSelect_Object_Account () OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.07.13                                        * ISNULL (ObjectBoolean_onComplete.ValueData, FALSE)
 04.07.13          * add onComplete
 03.07.13                                        * 1251Cyr
 29.06.13          *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Account ()
