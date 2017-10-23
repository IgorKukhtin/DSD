-- Function: gpGet_Object_StickerTag (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StickerTag (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerTag(
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
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerTag());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerTag()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerTag.Id          AS Id
           , Object_StickerTag.ObjectCode  AS Code
           , Object_StickerTag.ValueData   AS Name
           
           , ObjectString_Comment.ValueData AS Comment
           
           , Object_StickerTag.isErased    AS isErased
           
       FROM Object AS Object_StickerTag
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerTag.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerTag_Comment()

       WHERE Object_StickerTag.Id = inId;
      
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
-- SELECT * FROM gpGet_Object_StickerTag (2, '')
