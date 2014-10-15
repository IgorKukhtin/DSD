-- Function: gpSelect_Object_CorrespondentAccount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CorrespondentAccount(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CorrespondentAccount(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               BankAccountId Integer, BankAccountName TVarChar,
               BankId Integer, BankName TVarChar
               ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
       SELECT
             Object_CorrespondentAccount.Id                     AS Id
           , Object_CorrespondentAccount.ObjectCode             AS Code
           , Object_CorrespondentAccount.ValueData              AS Name
           , Object_CorrespondentAccount.isErased               AS isErased
           , CorrespondentAccount_BankAccount.Id                AS BankAccountId
           , CorrespondentAccount_BankAccount.ValueData         AS BankAccountName
           , CorrespondentAccount_Bank.Id                       AS BankId
           , CorrespondentAccount_Bank.ValueData                AS BankName

       FROM Object AS Object_CorrespondentAccount
        LEFT JOIN ObjectLink AS OL_CorrespondentAccount_BankAccount
                             ON OL_CorrespondentAccount_BankAccount.ObjectId = Object_CorrespondentAccount.Id
                            AND OL_CorrespondentAccount_BankAccount.DescId = zc_ObjectLink_CorrespondentAccount_BankAccount()
        LEFT JOIN ObjectLink AS OL_CorrespondentAccount_Bank
                             ON OL_CorrespondentAccount_Bank.ObjectId = Object_CorrespondentAccount.Id
                            AND OL_CorrespondentAccount_Bank.DescId = zc_ObjectLink_CorrespondentAccount_Bank()
        LEFT JOIN Object AS CorrespondentAccount_BankAccount ON CorrespondentAccount_BankAccount.Id = OL_CorrespondentAccount_BankAccount.ChildObjectId
        LEFT JOIN Object AS CorrespondentAccount_Bank ON CorrespondentAccount_Bank.Id = OL_CorrespondentAccount_Bank.ChildObjectId
       WHERE Object_CorrespondentAccount.DescId = zc_Object_CorrespondentAccount();

END;$BODY$

  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CorrespondentAccount (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.10.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Object_CorrespondentAccount('2')