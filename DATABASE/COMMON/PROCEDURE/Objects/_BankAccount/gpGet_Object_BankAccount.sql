-- Function: gpGet_Object_Account()

--DROP FUNCTION gpGet_Object_BankAccount();

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccount(
IN inId          Integer,       /* Банки */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               JuridicalId Integer, JuridicalName TVarChar,
               BankId Integer, BankName TVarChar,
               CurrencyId Integer, CurrencyName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

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
     FROM Object
LEFT JOIN ObjectLink AS BankAccount_Juridical
       ON BankAccount_Juridical.ObjectId = Object.Id AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = BankAccount_Juridical.ChildObjectId
LEFT JOIN ObjectLink AS BankAccount_Bank
       ON BankAccount_Bank.ObjectId = Object.Id AND BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
LEFT JOIN Object AS Bank
       ON Bank.Id = BankAccount_Bank.ChildObjectId
LEFT JOIN ObjectLink AS BankAccount_Currency
       ON BankAccount_Currency.ObjectId = Object.Id AND BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
LEFT JOIN Object AS Currency
       ON Currency.Id = BankAccount_Currency.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_BankAccount(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')