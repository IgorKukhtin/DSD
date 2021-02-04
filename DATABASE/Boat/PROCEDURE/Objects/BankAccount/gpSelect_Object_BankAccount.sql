-- Function: gpSelect_Object_BankAccount (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , BankId Integer, BankName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
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
           , Object_Insert.ValueData          AS InsertName
           , ObjectDate_Insert.ValueData      AS InsertDate
           , Object_BankAccount.isErased      AS isErased           
       FROM Object AS Object_BankAccount
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
    
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 
     
            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_BankAccount.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
     WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
      AND (Object_BankAccount.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccount (TRUE, zfCalc_UserAdmin())