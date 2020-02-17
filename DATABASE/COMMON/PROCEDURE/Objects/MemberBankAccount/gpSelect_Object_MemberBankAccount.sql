-- Function: gpSelect_Object_MemberBankAccount()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberBankAccount(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberBankAccount(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , BankAccountId Integer, BankAccountName TVarChar 
             , MemberId Integer, MemberName TVarChar
             , isAll Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberBankAccount());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY 
       SELECT 
             Object_MemberBankAccount.Id         AS Id
           , Object_MemberBankAccount.ValueData  AS Name
           , Object_BankAccount.Id               AS BankAccountId
           , Object_BankAccount.ValueData        AS BankAccountName
           , Object_Member.Id                    AS MemberId
           , Object_Member.ValueData             AS MemberName

           , COALESCE (ObjectBoolean_All.ValueData,FALSE)  ::Boolean   AS isAll

           , Object_MemberBankAccount.isErased   AS isErased

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

   WHERE Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberBankAccount('2')