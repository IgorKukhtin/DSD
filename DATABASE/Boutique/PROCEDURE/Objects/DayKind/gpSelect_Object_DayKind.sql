-- Function: gpSelect_Object_DayKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DayKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DayKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DayKind());

   RETURN QUERY 
   SELECT
        Object_DayKind.Id           AS Id 
      , Object_DayKind.ObjectCode   AS Code
      , Object_DayKind.ValueData    AS Name

      , Object_DayKind.isErased     AS isErased
      
   FROM Object AS Object_DayKind
   WHERE Object_DayKind.DescId = zc_Object_DayKind();
  
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_DayKind('2')
