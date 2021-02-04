-- Function: gpGet_Object_BankAccount(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BankAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccount(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , BankId Integer, BankName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , Comment TVarChar
             ) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Bank());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_BankAccount())  AS Code
           , '' :: TVarChar                         AS Name
           ,  0 :: Integer                          AS BankId           
           , '' :: TVarChar                         AS BankName         
           ,  0 :: Integer                          AS CurrencyId       
           , '' :: TVarChar                         AS CurrencyName     
           , '' :: TVarChar                         AS Comment
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_BankAccount.Id            AS Id
           , Object_BankAccount.ObjectCode    AS Code
           , Object_BankAccount.ValueData     AS Name
           , Object_Bank.Id                   AS BankId
           , Object_Bank.ValueData            AS BankName
           , Object_Currency.Id               AS CurrencyId
           , Object_Currency.ValueData        AS CurrencyName
           , ObjectString_Comment.ValueData   AS Comment
       
        FROM  Object AS Object_BankAccount

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                 ON ObjectLink_BankAccount_Currency.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_BankAccount_Currency.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_BankAccount.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Bank_Comment() 

      WHERE Object_BankAccount.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_BankAccount(1,'2')
