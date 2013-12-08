-- Function: gpSelect_Object_Currency()

--DROP FUNCTION gpSelect_Object_Currency();

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, InternalName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Id
   , Code
   , Name
   , isErased
   , InternalName
   FROM Object_Currency_View;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Currency(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_Currency('2')