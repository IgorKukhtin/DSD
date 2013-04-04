-- Function: gpGet_Object_Account()

--DROP FUNCTION gpGet_Object_Account();

CREATE OR REPLACE FUNCTION gpGet_Object_Account(
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
LEFT JOIN ObjectLink AS Account_Juridical
       ON Account_Juridical.ObjectId = Object.Id AND Account_Juridical.DescId = zc_ObjectLink_Account_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Account_Juridical.ChildObjectId
LEFT JOIN ObjectLink AS Account_Bank
       ON Account_Bank.ObjectId = Object.Id AND Account_Bank.DescId = zc_ObjectLink_Account_Bank()
LEFT JOIN Object AS Bank
       ON Bank.Id = Account_Bank.ChildObjectId
LEFT JOIN ObjectLink AS Account_Currency
       ON Account_Currency.ObjectId = Object.Id AND Account_Currency.DescId = zc_ObjectLink_Account_Currency()
LEFT JOIN Object AS Currency
       ON Currency.Id = Account_Currency.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Account(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')