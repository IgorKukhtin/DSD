-- Function: gpSelect_Object_Freight()

DROP FUNCTION IF EXISTS gpSelect_Object_Freight(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Freight(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Freight());

     RETURN QUERY 
       SELECT 
             Object_Freight.Id          AS Id
           , Object_Freight.ObjectCode  AS Code
           , Object_Freight.ValueData   AS Name
           
           , Object_Freight.isErased AS isErased
           
       FROM Object AS Object_Freight
       WHERE Object_Freight.DescId = zc_Object_Freight();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Freight(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Freight('2')