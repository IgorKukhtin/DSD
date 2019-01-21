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
             , onComplete Boolean, isPrintDetail Boolean
             , isErased Boolean
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
     -- Результат
     RETURN QUERY 
       SELECT
             View_Account.AccountId   AS Id
           , View_Account.AccountCode AS Code
           , View_Account.AccountName AS Name

           , View_Account.AccountName_all AS AccountName_All

           , View_Account.AccountGroupId
           , View_Account.AccountGroupCode
           , View_Account.AccountGroupName
           
           , View_Account.AccountDirectionId
           , View_Account.AccountDirectionCode
           , View_Account.AccountDirectionName
           
           , View_Account.InfoMoneyCode
           , View_Account.InfoMoneyDestinationCode
           , View_Account.InfoMoneyGroupName
           , View_Account.InfoMoneyDestinationName
           , View_Account.InfoMoneyName
           , View_Account.InfoMoneyDestinationId
           , View_Account.InfoMoneyId
           
           , View_Account.AccountKindId
           , View_Account.AccountKindCode
           , View_Account.AccountKindName

           , View_Account.onComplete
           , View_Account.isPrintDetail
           , View_Account.isErased

       FROM Object_Account_View AS View_Account;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Account (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.01.19          * isPrintDetail
 02.11.13                                        * add Object_Account.ObjectCode < 100000
 29.10.13                                        * add Object_InfoMoney_View
 04.07.13          * + onComplete... +AccountKind...
 03.07.13                                         *  1251Cyr
 24.06.13                                         *  errors
 21.06.13          *                              *  создание врем.таблиц
 17.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Account (zfCalc_UserAdmin()) ORDER BY Code