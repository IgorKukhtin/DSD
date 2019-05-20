-- Function: gpSelect_Object_GoodsTypeKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTypeKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTypeKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsTypeKind());

   RETURN QUERY 
   SELECT
        Object_GoodsTypeKind.Id           AS Id 
      , Object_GoodsTypeKind.ObjectCode   AS Code
      , Object_GoodsTypeKind.ValueData    AS Name
      , ObjectString_ShortName.ValueData :: TVarChar AS ShortName
      , Object_GoodsTypeKind.isErased     AS isErased
      
   FROM Object AS Object_GoodsTypeKind
        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_GoodsTypeKind.Id
                              AND ObjectString_ShortName.DescId = zc_ObjectString_GoodsTypeKind_ShortName() 
   WHERE Object_GoodsTypeKind.DescId = zc_Object_GoodsTypeKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.19         * ShortName
 25.02.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsTypeKind('2')
