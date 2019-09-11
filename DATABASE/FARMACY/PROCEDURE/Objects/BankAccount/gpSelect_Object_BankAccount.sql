-- Function: gpSelect_Object_BankAccount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               JuridicalName TVarChar, BankName TVarChar,
               CurrencyId Integer, CurrencyName TVarChar,
               CorrespondentBankId Integer, CorrespondentBankName TVarChar,
               BeneficiarysBankId Integer, BeneficiarysBankName TVarChar,
               CorrespondentAccount TVarChar, BeneficiarysBankAccount TVarChar, BeneficiarysAccount TVarChar,
               CBAccount TVarChar
               ) AS
$BODY$BEGIN

     RETURN QUERY
         SELECT
             Object_BankAccount_View.Id
           , Object_BankAccount_View.Code
           , Object_BankAccount_View.Name
           , Object_BankAccount_View.isErased
           , Object_BankAccount_View.JuridicalName
           , Object_BankAccount_View.BankName
           , Object_BankAccount_View.CurrencyId
           , Object_BankAccount_View.CurrencyName
           , Object_CorrespondentBank.Id                        AS CorrespondentBankId
           , Object_CorrespondentBank.ValueData                 AS CorrespondentBankName
           , Object_BeneficiarysBank.Id                         AS BeneficiarysBankId
           , Object_BeneficiarysBank.ValueData                  AS BeneficiarysBankName
           , OS_BankAccount_CorrespondentAccount.ValueData      AS CorrespondentAccount
           , OS_BankAccount_BeneficiarysBankAccount.ValueData   AS BeneficiarysBankAccount
           , OS_BankAccount_BeneficiarysAccount.ValueData       AS BeneficiarysAccount
           , OS_BankAccount_CBAccount.ValueData                 AS CBAccount

     FROM Object_BankAccount_View
     -- Покажем счета только по внутренним фирмам
        LEFT  JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                             ON ObjectBoolean_isCorporate.ObjectId = Object_BankAccount_View.JuridicalId
                            AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                            AND ObjectBoolean_isCorporate.ValueData = TRUE
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_CorrespondentBank
                             ON ObjectLink_BankAccount_CorrespondentBank.ObjectId = Object_BankAccount_View.Id
                            AND ObjectLink_BankAccount_CorrespondentBank.DescId = zc_ObjectLink_BankAccount_CorrespondentBank()
        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_BeneficiarysBank
                             ON ObjectLink_BankAccount_BeneficiarysBank.ObjectId = Object_BankAccount_View.Id
                            AND ObjectLink_BankAccount_BeneficiarysBank.DescId = zc_ObjectLink_BankAccount_BeneficiarysBank()
        LEFT JOIN Object AS Object_CorrespondentBank ON Object_CorrespondentBank.Id = ObjectLink_BankAccount_CorrespondentBank.ChildObjectId
        LEFT JOIN Object AS Object_BeneficiarysBank ON Object_BeneficiarysBank.Id = ObjectLink_BankAccount_BeneficiarysBank.ChildObjectId
        LEFT JOIN ObjectString AS OS_BankAccount_CorrespondentAccount
                               ON OS_BankAccount_CorrespondentAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_CorrespondentAccount.DescId = zc_ObjectString_BankAccount_CorrespondentAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysBankAccount
                               ON OS_BankAccount_BeneficiarysBankAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_BeneficiarysBankAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysBankAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysAccount
                               ON OS_BankAccount_BeneficiarysAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_BeneficiarysAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_CBAccount
                               ON OS_BankAccount_CBAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_CBAccount.DescId = zc_ObjectString_BankAccount_CBAccount()

;

END;$BODY$

  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_BankAccount(TVarChar)
  OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 10.09.19                                                                    *
 10.10.14                                                       *
 15.01.14                         *
 10.06.13          *
 05.06.13

*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccount('3')