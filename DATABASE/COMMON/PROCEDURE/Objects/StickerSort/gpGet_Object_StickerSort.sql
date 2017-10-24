-- Function: gpGet_Object_StickerSort (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StickerSort (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerSort(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerSort());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerSort()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerSort.Id          AS Id
           , Object_StickerSort.ObjectCode  AS Code
           , Object_StickerSort.ValueData   AS Name
           
           , ObjectString_Comment.ValueData AS Comment
           
           , Object_StickerSort.isErased    AS isErased
           
       FROM Object AS Object_StickerSort
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerSort.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerSort_Comment()
           
       WHERE Object_StickerSort.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StickerSort (2, '')
