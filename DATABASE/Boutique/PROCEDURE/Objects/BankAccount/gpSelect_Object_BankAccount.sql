-- Function: gpSelect_Object_BankAccount (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, JuridicalName TVarChar, BankName TVarChar, CurrencyName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_BankAccount());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_BankAccount.Id                  AS Id
           , Object_BankAccount.ObjectCode          AS Code
           , Object_BankAccount.ValueData           AS Name
           , Object_Juridical.ValueData             AS JuridicalName
           , Object_Bank.ValueData                  AS BankName
           , Object_Currency.ValueData              AS CurrencyName
           , Object_BankAccount.isErased            AS isErased           
       FROM Object AS Object_BankAccount

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Juridical
                                 ON ObjectLink_BankAccount_Juridical.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_BankAccount_Juridical.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                 ON ObjectLink_BankAccount_Currency.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_BankAccount_Currency.ChildObjectId


     WHERE Object_BankAccount.DescId = zc_Object_BankAccount()
              AND (Object_BankAccount.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
10.05.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Bank (TRUE, zfCalc_UserAdmin())