-- Function: gpSelect_Object_SelectKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_SelectKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SelectKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_SelectKind());

   RETURN QUERY 
   SELECT
        Object_SelectKind.Id           AS Id 
      , Object_SelectKind.ObjectCode   AS Code
      , Object_SelectKind.ValueData    AS NAME
      
      , Object_SelectKind.isErased     AS isErased
      
   FROM OBJECT AS Object_SelectKind
                              
   WHERE Object_SelectKind.DescId = zc_Object_SelectKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_SelectKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_SelectKind('2')
