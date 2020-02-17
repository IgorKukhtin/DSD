-- Function: gpGet_Object_MemberBankAccount()

DROP FUNCTION IF EXISTS gpGet_Object_MemberBankAccount(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberBankAccount(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , BankAccountId Integer, BankAccountName TVarChar 
             , MemberId Integer, MemberName TVarChar
             , isAll Boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name

           , 0                      AS BankAccountId
           , CAST ('' as TVarChar)  AS BankAccountName
           , 0                      AS MemberId
           , CAST ('' as TVarChar)  AS MemberName

           , CAST(FALSE AS Boolean) AS isAll
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_MemberBankAccount.Id         AS Id
           , Object_MemberBankAccount.ValueData  AS Name
           , Object_BankAccount.Id               AS BankAccountId
           , Object_BankAccount.ValueData        AS BankAccountName
           , Object_Member.Id                    AS MemberId
           , Object_Member.ValueData             AS MemberName

           , COALESCE (ObjectBoolean_All.ValueData,FALSE)  ::Boolean AS isAll

       FROM Object AS Object_MemberBankAccount
           LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                   ON ObjectBoolean_All.ObjectId = Object_MemberBankAccount.Id 
                                  AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()

           LEFT JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = Object_MemberBankAccount.Id 
                               AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
           LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_MemberBankAccount_Member
                                ON ObjectLink_MemberBankAccount_Member.ObjectId = Object_MemberBankAccount.Id 
                               AND ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_MemberBankAccount_Member.ChildObjectId

       WHERE Object_MemberBankAccount.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberBankAccount (0, '2')