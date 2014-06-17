-- Function: gpSelect_Object_BankAccount(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccount(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccount(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               JuridicalName TVarChar, BankName TVarChar, CurrencyId Integer, CurrencyName TVarChar) AS
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
     FROM Object_BankAccount_View;
  
END;$BODY$

  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_BankAccount(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.14                         *
 10.06.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_BankAccount('2')