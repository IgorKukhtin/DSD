-- Function: gpSelect_Object_Cash()

--DROP FUNCTION gpSelect_Object_Cash();

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               CurrencyName TVarChar) AS
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
   FROM Object
   JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_Cash_Currency()
   JOIN Object AS Currency
     ON Currency.Id = ObjectLink.ChildObjectId
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