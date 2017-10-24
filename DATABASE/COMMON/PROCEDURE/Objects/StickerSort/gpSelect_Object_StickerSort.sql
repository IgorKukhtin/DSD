-- Function: gpSelect_Object_StickerSort (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerSort (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerSort(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerSort());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerSort.Id          AS Id
           , Object_StickerSort.ObjectCode  AS Code
           , Object_StickerSort.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerSort.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerSort
                              ON Object_StickerSort.isErased = tmpIsErased.isErased 
                             AND Object_StickerSort.DescId = zc_Object_StickerSort()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerSort.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerSort_Comment()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StickerSort (FALSE, zfCalc_UserAdmin())
