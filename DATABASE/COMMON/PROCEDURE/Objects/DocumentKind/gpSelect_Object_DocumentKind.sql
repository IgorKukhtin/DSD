-- Function: gpSelect_Object_DocumentKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DocumentKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DocumentKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DocumentKind());

   RETURN QUERY 
   SELECT
        Object_DocumentKind.Id           AS Id 
      , Object_DocumentKind.ObjectCode   AS Code
      , Object_DocumentKind.ValueData    AS Name
      -- , ObjectString_Enum.ValueData      AS EnumName
      , ObjectString_Enum.DescId :: TVarChar
      
      , Object_DocumentKind.isErased     AS isErased
      
   FROM Object AS Object_DocumentKind
        LEFT JOIN ObjectString AS ObjectString_Enum ON ObjectString_Enum.ObjectId = Object_DocumentKind.Id
                                                   AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
   WHERE Object_DocumentKind.DescId = zc_Object_DocumentKind()
     AND ObjectString_Enum.ObjectId IS NULL
  ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_DocumentKind('2')
