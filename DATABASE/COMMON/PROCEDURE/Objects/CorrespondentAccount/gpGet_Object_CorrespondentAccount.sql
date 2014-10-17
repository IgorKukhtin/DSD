-- Function: gpGet_Object_Account(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_CorrespondentAccount(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CorrespondentAccount(
    IN inId          Integer,       -- ключ объекта <Счета>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               BankAccountId Integer, BankAccountName TVarChar,
               BankId Integer, BankName TVarChar
               ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_CorrespondentAccount()) AS Code
           , CAST ('' as TVarChar) AS Name
           , CAST (NULL AS Boolean)AS isErased
           , CAST (0 as Integer)   AS BankAccountId
           , CAST ('' as TVarChar) AS BankAccountName
           , CAST (0 as Integer)   AS BankId
           , CAST ('' as TVarChar) AS BankName;

   ELSE
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
       WHERE Object_CorrespondentAccount.Id = inId;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CorrespondentAccount(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.10.14                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_CorrespondentAccount(1,'2')