-- Function: gpSelect_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTag(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTag(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag()());

   RETURN QUERY 
   SELECT Object_GoodsTag.Id         AS Id 
        , Object_GoodsTag.ObjectCode AS Code
        , Object_GoodsTag.ValueData  AS Name
        , Object_GoodsTag.isErased   AS isErased
   
   FROM Object AS Object_GoodsTag
   WHERE Object_GoodsTag.DescId = zc_Object_GoodsTag();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsTag('2')