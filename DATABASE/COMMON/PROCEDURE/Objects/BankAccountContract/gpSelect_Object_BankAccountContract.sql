-- Function: gpSelect_Object_BankAccountContract()

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountContract(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccountContract(
    IN inSession     TVarChar       -- 
)
RETURNS TABLE (Id Integer
             , BankAccountId Integer, BankAccountName TVarChar, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
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
         , (Object_BankAccount_View.BankName || ' ' || Object_BankAccount.ValueData) :: TVarChar AS BankAccountName
         , (Object_BankAccount_View.BankName || ' ' || Object_BankAccount.ValueData) :: TVarChar AS Name

         , Object_InfoMoney_View.InfoMoneyId        AS InfoMoneyId
         , Object_InfoMoney_View.InfoMoneyName_all  AS InfoMoneyName

         , Object_Unit.Id         AS UnitId
         , Object_Unit.ValueData  AS UnitName
      
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
     
          LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                               ON ObjectLink_BankAccountContract_Unit.ObjectId = Object_BankAccountContract.Id
                              AND ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_BankAccountContract_Unit.ChildObjectId

          LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = Object_BankAccount.Id

     WHERE Object_BankAccountContract.DescId = zc_Object_BankAccountContract();
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_BankAccountContract (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
  ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.15         * add Unit
 25.04.14         * 
*/

-- Тест
-- SELECT * FROM gpSelect_Object_BankAccountContract ('2')
