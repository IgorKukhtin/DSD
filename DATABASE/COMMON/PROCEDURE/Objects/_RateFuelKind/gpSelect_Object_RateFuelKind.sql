-- Function: gpSelect_Object_RateFuelKind (TVarChar)

-- DROP FUNCTION gpSelect_Object_RateFuelKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RateFuelKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_RateFuelKind());

   RETURN QUERY 
   SELECT
        Object_RateFuelKind.Id                   AS Id 
      , Object_RateFuelKind.ObjectCode           AS Code
      , Object_RateFuelKind.ValueData            AS NAME
       
      , Object_RateFuelKind.isErased   AS isErased
   FROM OBJECT AS Object_RateFuelKind
   WHERE Object_RateFuelKind.DescId = zc_Object_RateFuelKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RateFuelKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_RateFuelKind('2')
