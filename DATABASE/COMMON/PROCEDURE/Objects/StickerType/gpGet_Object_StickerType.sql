-- Function: gpGet_Object_StickerType (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StickerType (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerType(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerType());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerType()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerType.Id          AS Id
           , Object_StickerType.ObjectCode  AS Code
           , Object_StickerType.ValueData   AS Name
           
           , ObjectString_Comment.ValueData AS Comment
           
           , Object_StickerType.isErased    AS isErased
           
       FROM Object AS Object_StickerType
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerType.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerType_Comment()
           
       WHERE Object_StickerType.Id = inId;
      
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
-- SELECT * FROM gpGet_Object_StickerType (2, '')
