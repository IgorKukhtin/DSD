-- Function: gpGet_Object_Account(Integer,TVarChar)

--DROP FUNCTION gpGet_Object_BankAccount(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankAccount(
    IN inId          Integer,       -- ключ объекта <Счета>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               JuridicalId Integer, JuridicalName TVarChar,
               BankId Integer, BankName TVarChar,
               CurrencyId Integer, CurrencyName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar) AS Name
           , CAST (NULL AS Boolean)AS isErased
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           , CAST (0 as Integer)   AS BankId
           , CAST ('' as TVarChar) AS BankName
           , CAST (0 as Integer)   AS CurrencyId
           , CAST ('' as TVarChar) AS CurrencyName
       FROM Object 
       WHERE Object.DescId = zc_Object_BankAccount();
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
  END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_BankAccount(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 05.06.13          
 
*/

-- тест
-- SELECT * FROM gpGet_Object_BankAccount(1,'2')