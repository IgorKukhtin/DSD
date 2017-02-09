-- Function: gpSelect_Object_EmailKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_EmailKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmailKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_EmailKind());

   RETURN QUERY 
   SELECT
        Object_EmailKind.Id           AS Id 
      , Object_EmailKind.ObjectCode   AS Code
      , Object_EmailKind.ValueData    AS Name
      
      , Object_EmailKind.isErased     AS isErased
      
   FROM Object AS Object_EmailKind
                              
   WHERE Object_EmailKind.DescId = zc_Object_EmailKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_EmailKind('2')
