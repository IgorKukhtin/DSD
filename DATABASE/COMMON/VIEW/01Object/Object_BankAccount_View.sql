-- View: Object_BankAccount_View
--DROP VIEW CASCADE IF EXISTS Object_Bank_View;

CREATE OR REPLACE VIEW Object_BankAccount_View AS
  SELECT
             Object_BankAccount.Id                              AS Id
           , Object_BankAccount.ObjectCode                      AS Code
           , Object_BankAccount.ValueData                       AS Name
           , BankAccount_Juridical.ChildObjectId                AS JuridicalId
           , Juridical.ValueData                                AS JuridicalName
           , ((ObjectBoolean_isCorporate.ValueData = TRUE) OR (ObjectBoolean_Guide_Irna.ValueData = TRUE) OR ObjectLink_BankAccount_Account.ChildObjectId > 0) :: Boolean AS isCorporate
           , ObjectLink_BankAccount_Bank.ChildObjectId          AS BankId
           , Object_Bank_View.BankName                          AS BankName
           , Object_Bank_View.MFO                               AS MFO
           , Object_Bank_View.SWIFT                             AS SWIFT
           , Object_Bank_View.IBAN                              AS IBAN
           , Object_Bank_View.JuridicalId                       AS BankJuridicalId
           , Object_Bank_View.JuridicalName                     AS BankJuridicalName
           , BankAccount_Currency.ChildObjectId                 AS CurrencyId
           , Currency.ObjectCode                                AS CurrencyCode
           , Currency.ValueData                                 AS CurrencyName
           , ObjectString_Currency_InternalName.ValueData       AS CurrencyInternalName

           , Object_CorrespondentBank.Id                        AS CorrespondentBankId
           , Object_CorrespondentBank.ValueData                 AS CorrespondentBankName
           , Object_BeneficiarysBank.Id                         AS BeneficiarysBankId
           , Object_BeneficiarysBank.ValueData                  AS BeneficiarysBankName
           , OS_BankAccount_CorrespondentAccount.ValueData      AS CorrespondentAccount
           , OS_BankAccount_BeneficiarysBankAccount.ValueData   AS BeneficiarysBankAccount
           , OS_BankAccount_BeneficiarysAccount.ValueData       AS BeneficiarysAccount

           , Object_BankAccount.isErased                        AS isErased

           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna

  FROM Object AS Object_BankAccount
  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
         ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
        AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
  LEFT JOIN Object_Bank_View ON Object_Bank_View.Id = ObjectLink_BankAccount_Bank.ChildObjectId
  LEFT JOIN ObjectLink AS BankAccount_Juridical
         ON BankAccount_Juridical.ObjectId = Object_BankAccount.Id
        AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
  LEFT JOIN Object AS Juridical ON Juridical.Id = BankAccount_Juridical.ChildObjectId
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                ON ObjectBoolean_isCorporate.ObjectId = BankAccount_Juridical.ChildObjectId
                               AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
  LEFT JOIN ObjectLink AS BankAccount_Currency
         ON BankAccount_Currency.ObjectId = Object_BankAccount.Id
        AND BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
  LEFT JOIN Object AS Currency  ON Currency.Id = BankAccount_Currency.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_Currency_InternalName
                             ON ObjectString_Currency_InternalName.ObjectId = Currency.Id
                            AND ObjectString_Currency_InternalName.DescId = zc_ObjectString_Currency_InternalName()

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_CorrespondentBank
                             ON ObjectLink_BankAccount_CorrespondentBank.ObjectId = Object_BankAccount.Id
                            AND ObjectLink_BankAccount_CorrespondentBank.DescId = zc_ObjectLink_BankAccount_CorrespondentBank()

        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Account
                             ON ObjectLink_BankAccount_Account.ObjectId = Object_BankAccount.Id
                            AND ObjectLink_BankAccount_Account.DescId   = zc_ObjectLink_BankAccount_Account()


        LEFT JOIN ObjectLink AS ObjectLink_BankAccount_BeneficiarysBank
                             ON ObjectLink_BankAccount_BeneficiarysBank.ObjectId = Object_BankAccount.Id
                            AND ObjectLink_BankAccount_BeneficiarysBank.DescId = zc_ObjectLink_BankAccount_BeneficiarysBank()
        LEFT JOIN Object AS Object_CorrespondentBank ON Object_CorrespondentBank.Id = ObjectLink_BankAccount_CorrespondentBank.ChildObjectId
        LEFT JOIN Object AS Object_BeneficiarysBank ON Object_BeneficiarysBank.Id = ObjectLink_BankAccount_BeneficiarysBank.ChildObjectId
        LEFT JOIN ObjectString AS OS_BankAccount_CorrespondentAccount
                               ON OS_BankAccount_CorrespondentAccount.ObjectId = Object_BankAccount.Id
                              AND OS_BankAccount_CorrespondentAccount.DescId = zc_ObjectString_BankAccount_CorrespondentAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysBankAccount
                               ON OS_BankAccount_BeneficiarysBankAccount.ObjectId = Object_BankAccount.Id
                              AND OS_BankAccount_BeneficiarysBankAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysBankAccount()
        LEFT JOIN ObjectString AS OS_BankAccount_BeneficiarysAccount
                               ON OS_BankAccount_BeneficiarysAccount.ObjectId = Object_BankAccount.Id
                              AND OS_BankAccount_BeneficiarysAccount.DescId = zc_ObjectString_BankAccount_BeneficiarysAccount()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_BankAccount.Id
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

     WHERE Object_BankAccount.DescId = zc_Object_BankAccount();


ALTER TABLE Object_BankAccount_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.
 16.10.14                                                       *
 15.11.13                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_BankAccount_View
