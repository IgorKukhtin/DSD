-- Function: gpGet_Object_GoodsGroupDirection (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroupDirection (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroupDirection(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsGroupDirection());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroupDirection()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (FALSE AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsGroupDirection.Id          AS Id
           , Object_GoodsGroupDirection.ObjectCode  AS Code
           , Object_GoodsGroupDirection.ValueData   AS Name
           , Object_GoodsGroupDirection.isErased    AS isErased
       FROM Object AS Object_GoodsGroupDirection
       WHERE Object_GoodsGroupDirection.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsGroupDirection (2, '')
