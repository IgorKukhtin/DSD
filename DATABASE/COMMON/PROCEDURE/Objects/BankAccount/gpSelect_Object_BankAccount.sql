-- Function: gpSelect_Object_BankAccount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               JuridicalName TVarChar, BankName TVarChar,
               CurrencyId Integer, CurrencyName TVarChar,
               AccountId Integer, AccountName TVarChar,
               CorrespondentBankId Integer, CorrespondentBankName TVarChar,
               BeneficiarysBankId Integer, BeneficiarysBankName TVarChar,
               CorrespondentAccount TVarChar, BeneficiarysBankAccount TVarChar, BeneficiarysAccount TVarChar,
               PaidKindId Integer, PaidKindName TVarChar, 
               isIrna Boolean
               ) AS                                                                                       
               
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

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

           , Object_BankAccount_View.isIrna          :: Boolean AS isIrna

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

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Account
                             ON ObjectLink_BankAccount_Account.ObjectId = Object_BankAccount_View.Id
                            AND ObjectLink_BankAccount_Account.DescId = zc_ObjectLink_BankAccount_Account()
        LEFT JOIN Object AS Object_Account ON Object_Account.Id = ObjectLink_BankAccount_Account.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_PaidKind
                             ON ObjectLink_BankAccount_PaidKind.ObjectId = Object_BankAccount_View.Id
                            AND ObjectLink_BankAccount_PaidKind.DescId = zc_ObjectLink_BankAccount_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_BankAccount_PaidKind.ChildObjectId
        
        LEFT JOIN ObjectString AS OS_BankAccount_CorrespondentAccount
                               ON OS_BankAccount_CorrespondentAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_CorrespondentAccount.DescId = zc_ObjectString_BankAccount_CorrespondentAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysBankAccount
                               ON OS_BankAccount_BeneficiarysBankAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_BeneficiarysBankAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysBankAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysAccount
                               ON OS_BankAccount_BeneficiarysAccount.ObjectId = Object_BankAccount_View.Id
                              AND OS_BankAccount_BeneficiarysAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysAccount()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_BankAccount_View.Id
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

;

END;$BODY$

  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_BankAccount(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/                                                                      Имя поля	Значение
Значение	UA553052990000026006031011656
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.10.14                                                       *
 15.01.14                         *
 10.06.13          *
 05.06.13

*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccount('2')