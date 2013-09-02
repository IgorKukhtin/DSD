-- Function: gpSelect_Object_Cash()

--DROP FUNCTION gpSelect_Object_Cash();

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyName TVarChar, BranchName TVarChar, JuridicalName TVarChar, 
               BusinessName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id          AS Id 
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , Currency.ValueData AS CurrencyName
   , Branch.ValueData   AS BranchName
   , MainJuridical.ValueData  AS JuridicalName
   , Business.ValueData AS BusinessName

FROM Object
LEFT JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_Cash_Currency()
LEFT JOIN Object AS Currency
     ON Currency.Id = ObjectLink.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_Branch
                                ON Cash_Branch.ObjectId = Object.Id
                               AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
           LEFT JOIN Object AS Branch ON Branch.Id = Cash_Branch.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_MainJuridical
                                ON Cash_MainJuridical.ObjectId = Object.Id
                               AND Cash_MainJuridical.DescId = zc_ObjectLink_Cash_MainJuridical()
           LEFT JOIN Object AS MainJuridical ON MainJuridical.Id = Cash_MainJuridical.ChildObjectId
           LEFT JOIN ObjectLink AS Cash_Business
                                ON Cash_Business.ObjectId = Object.Id
                               AND Cash_Business.DescId = zc_ObjectLink_Cash_Business()
           LEFT JOIN Object AS Business ON Business.Id = Cash_Business.ChildObjectId


   WHERE Object.DescId = zc_Object_Cash();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Cash(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash('2')