-- Function: lfGet_Object_Account_byInfoMoney (Integer, Integer, Integer)

-- DROP FUNCTION lfGet_Object_Account_byInfoMoney (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Account_byInfoMoney (IN inAccountGroupId Integer, IN inAccountDirectionId Integer, IN inInfoMoneyDestinationId Integer)
RETURNS Integer
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN (
       SELECT 
            Object_Account.Id           
       FROM Object AS Object_Account
                 JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                 ON ObjectLink_Account_AccountGroup.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()

                 JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                 ON ObjectLink_Account_AccountDirection.ObjectId = Object_Account.Id 
                                AND ObjectLink_Account_AccountDirection.DescId = zc_ObjectLink_Account_AccountDirection()

                 JOIN ObjectLink AS ObjectLink_Account_InfoMoney
                                 ON ObjectLink_Account_InfoMoney.ObjectId = Object_Account.Id
                                AND ObjectLink_Account_InfoMoney.DescId = zc_ObjectLink_Account_InfoMoney()

       WHERE ObjectLink_Account_AccountGroup.ChildObjectId = inAccountGroupId AND ObjectLink_Account_AccountDirection.ChildObjectId = inAccountDirectionId 
         AND ObjectLink_Account_InfoMoneyDestination.ChildObjectId = inInfoMoneyDestinationId AND Object_Account.DescId = zc_Object_Account());

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_Account_byInfoMoney (Integer, Integer, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.13                                        * rename
 13.08.13                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Account_byInfoMoney ()
