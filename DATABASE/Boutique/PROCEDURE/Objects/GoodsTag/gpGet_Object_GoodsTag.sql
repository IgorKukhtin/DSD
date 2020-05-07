-- Function: gpGet_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsTag(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsTag(
    IN inId          Integer,       -- ключ объекта <Торговая сеть>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsTag()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsTag.Id         AS Id
           , Object_GoodsTag.ObjectCode AS Code
           , Object_GoodsTag.ValueData  AS Name
           
           , Object_GoodsTag.isErased   AS isErased
           
       FROM Object AS Object_GoodsTag
       WHERE Object_GoodsTag.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsTag (0, '2')