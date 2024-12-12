-- Function: gpGet_Object_Account(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BankAccount(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccount(
    IN inId          Integer,       -- ключ объекта <Счета>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               JuridicalId Integer, JuridicalName TVarChar,
               BankId Integer, BankName TVarChar,
               CurrencyId Integer, CurrencyName TVarChar,
               AccountId Integer, AccountName TVarChar,
               CorrespondentBankId Integer, CorrespondentBankName TVarChar,
               BeneficiarysBankId Integer, BeneficiarysBankName TVarChar,
               CorrespondentAccount TVarChar, BeneficiarysBankAccount TVarChar, BeneficiarysAccount TVarChar,
               PaidKindId Integer, PaidKindName TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_BankAccount()) AS Code
           , CAST ('' as TVarChar) AS Name
           , CAST (NULL AS Boolean)AS isErased
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           , CAST (0 as Integer)   AS BankId
           , CAST ('' as TVarChar) AS BankName
           , CAST (0 as Integer)   AS CurrencyId
           , CAST ('' as TVarChar) AS CurrencyName

           , CAST (0 as Integer)   AS AccountId
           , CAST ('' as TVarChar) AS AccountName
           , CAST (0 as Integer)   AS CorrespondentBankId
           , CAST ('' as TVarChar) AS CorrespondentBankName
           , CAST (0 as Integer)   AS BeneficiarysBankId
           , CAST ('' as TVarChar) AS BeneficiarysBankName
           , CAST ('' as TVarChar) AS CorrespondentAccount
           , CAST ('' as TVarChar) AS BeneficiarysBankAccount
           , CAST ('' as TVarChar) AS BeneficiarysAccount
           , CAST (0 as Integer)   AS PaidKindId
           , CAST ('' as TVarChar) AS PaidKindName
           ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id
           , Object.ObjectCode
           , Object.ValueData
           , Object.isErased
           , Juridical.Id        AS JuridicalId
           , Juridical.ValueData AS JuridicalName
           , Bank.Id             AS BankId
           , Bank.ValueData      AS BankName
           , Currency.Id         AS CurrencyId
           , Currency.ValueData  AS CurrencyName
           , Object_Account.Id                                  AS AccountId
           , Object_Account.ValueData                           AS AccountName
           , Object_CorrespondentBank.Id                        AS CorrespondentBankId
           , Object_CorrespondentBank.ValueData                 AS CorrespondentBankName
           , Object_BeneficiarysBank.Id                         AS BeneficiarysBankId
           , Object_BeneficiarysBank.ValueData                  AS BeneficiarysBankName
           , OS_BankAccount_CorrespondentAccount.ValueData      AS CorrespondentAccount
           , OS_BankAccount_BeneficiarysBankAccount.ValueData   AS BeneficiarysBankAccount
           , OS_BankAccount_BeneficiarysAccount.ValueData       AS BeneficiarysAccount
           , Object_PaidKind.Id                                 AS PaidKindId
           , Object_PaidKind.ValueData                          AS PaidKindName
       FROM Object
        LEFT JOIN ObjectLink AS BankAccount_Juridical
                             ON BankAccount_Juridical.ObjectId = Object.Id
                            AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
        LEFT JOIN Object AS Juridical ON Juridical.Id = BankAccount_Juridical.ChildObjectId
        LEFT JOIN ObjectLink AS BankAccount_Bank
                             ON BankAccount_Bank.ObjectId = Object.Id
                            AND BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
        LEFT JOIN Object AS Bank ON Bank.Id = BankAccount_Bank.ChildObjectId
        LEFT JOIN ObjectLink AS BankAccount_Currency
                             ON BankAccount_Currency.ObjectId = Object.Id
                            AND BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
        LEFT JOIN Object AS Currency ON Currency.Id = BankAccount_Currency.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_CorrespondentBank
                             ON ObjectLink_BankAccount_CorrespondentBank.ObjectId = Object.Id
                            AND ObjectLink_BankAccount_CorrespondentBank.DescId = zc_ObjectLink_BankAccount_CorrespondentBank()
        LEFT JOIN Object AS Object_CorrespondentBank ON Object_CorrespondentBank.Id = ObjectLink_BankAccount_CorrespondentBank.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_BeneficiarysBank
                             ON ObjectLink_BankAccount_BeneficiarysBank.ObjectId = Object.Id
                            AND ObjectLink_BankAccount_BeneficiarysBank.DescId = zc_ObjectLink_BankAccount_BeneficiarysBank()
        LEFT JOIN Object AS Object_BeneficiarysBank ON Object_BeneficiarysBank.Id = ObjectLink_BankAccount_BeneficiarysBank.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Account
                             ON ObjectLink_BankAccount_Account.ObjectId = Object.Id
                            AND ObjectLink_BankAccount_Account.DescId = zc_ObjectLink_BankAccount_Account()
        LEFT JOIN Object AS Object_Account ON Object_Account.Id = ObjectLink_BankAccount_Account.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_PaidKind
                             ON ObjectLink_BankAccount_PaidKind.ObjectId = Object.Id
                            AND ObjectLink_BankAccount_PaidKind.DescId = zc_ObjectLink_BankAccount_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_BankAccount_PaidKind.ChildObjectId
        
        LEFT JOIN ObjectString AS OS_BankAccount_CorrespondentAccount
                               ON OS_BankAccount_CorrespondentAccount.ObjectId = Object.Id
                              AND OS_BankAccount_CorrespondentAccount.DescId = zc_ObjectString_BankAccount_CorrespondentAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysBankAccount
                               ON OS_BankAccount_BeneficiarysBankAccount.ObjectId = Object.Id
                              AND OS_BankAccount_BeneficiarysBankAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysBankAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysAccount
                               ON OS_BankAccount_BeneficiarysAccount.ObjectId = Object.Id
                              AND OS_BankAccount_BeneficiarysAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysAccount()

       WHERE Object.Id = inId;
  END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BankAccount(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.12.24         * PaidKind
 10.10.14                                                       *
 10.06.13         *
 05.06.13

*/

-- тест
-- SELECT * FROM gpGet_Object_BankAccount(1,'2')