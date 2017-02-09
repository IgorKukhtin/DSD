-- Function: gpGet_Object_BankAccountContract(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BankAccountContract(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccountContract(
    IN inId          Integer,       -- ключ объекта <Расчетные счета(оплата нам по любому договору)
    IN inSession     TVarChar       --
)
RETURNS TABLE (Id INTEGER
             , BankAccountId Integer, BankAccountName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_BankAccountContract());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
          
           , CAST (0 as Integer)   AS BankAccountId
           , CAST ('' as TVarChar) AS BankAccountName

           , CAST (0 as Integer)   AS InfoMoneyId
           , CAST ('' as TVarChar) AS InfoMoneyName

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (NULL AS Boolean) AS isErased
           
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_BankAccountContract.Id      AS Id
          
         , Object_BankAccount.Id         AS BankAccountId
         , Object_BankAccount.ValueData  AS BankAccountName

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

     WHERE Object_BankAccountContract.Id = inId;
     
  END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BankAccountContract(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
  ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.15         * add Unit
 25.04.14         *              

*/

-- тест
-- SELECT * FROM gpGet_Object_BankAccountContract (100, '2')