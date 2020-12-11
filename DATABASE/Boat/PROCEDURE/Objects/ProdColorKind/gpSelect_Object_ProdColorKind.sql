-- Function: gpSelect_Object_ProdColorKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ProdColorKind());

   RETURN QUERY 
   SELECT
        Object_ProdColorKind.Id           AS Id 
      , Object_ProdColorKind.ObjectCode   AS Code
      , Object_ProdColorKind.ValueData    AS Name
      , ObjectString_Enum.ValueData       AS EnumName      
      , Object_ProdColorKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ProdColorKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_ProdColorKind.Id 
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()                               
   WHERE Object_ProdColorKind.DescId = zc_Object_ProdColorKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorKind('2')