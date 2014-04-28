-- Function: gpSelect_Object_BankAccountContract()

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountContract(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccountContract(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , BankAccountId Integer, BankAccountName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , isErased boolean
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_BankAccountContract());

   RETURN QUERY 
     SELECT 
           Object_BankAccountContract.Id AS Id
    
         , Object_BankAccount.Id         AS BankAccountId
         , Object_BankAccount.ValueData  AS BankAccountName

         , Object_InfoMoney_View.InfoMoneyId        AS InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyName_all  AS InfoMoneyName
      
         , Object_BankAccountContract.isErased AS isErased
         
     FROM OBJECT AS Object_BankAccountContract
          LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                               ON ObjectLink_BankAccountContract_BankAccount.ObjectId = Object_BankAccountContract.Id
                              AND ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
          LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_BankAccountContract_BankAccount.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                               ON ObjectLink_BankAccountContract_InfoMoney.ObjectId = Object_BankAccountContract.Id
                              AND ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
          LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_BankAccountContract_InfoMoney.ChildObjectId
     
     WHERE Object_BankAccountContract.DescId = zc_Object_BankAccountContract();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_BankAccountContract (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.14         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccountContract ('2')