-- View: Object_BankAccount_View

-- DROP VIEW IF EXISTS Object_BankAccount_View;

CREATE OR REPLACE VIEW Object_BankAccount_View AS
         SELECT 
             Object_BankAccount.Id           AS Id
           , Object_BankAccount.ObjectCode   AS Code
           , Object_BankAccount.ValueData    AS Name
          
           , ObjectLink_BankAccount_Bank.ChildObjectId   AS BankId  
           , Object_Bank.ValueData                       AS BankName
           , BankAccount_Currency.ChildObjectId          AS CurrencyId
           , Currency.ValueData                          AS CurrencyName


       FROM Object AS Object_BankAccount
  LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
         ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
        AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
  LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
  LEFT JOIN ObjectLink AS BankAccount_Currency
         ON BankAccount_Currency.ObjectId = Object_BankAccount.Id 
        AND BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
  LEFT JOIN Object AS Currency  ON Currency.Id = BankAccount_Currency.ChildObjectId
                               
     WHERE Object_BankAccount.DescId = zc_Object_BankAccount();


ALTER TABLE Object_BankAccount_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.13                         *
*/

-- тест
-- SELECT * FROM Object_BankAccount_View
