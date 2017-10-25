-- Function: gpSelect_Object_StickerPack (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerPack (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerPack(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerPack());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerPack.Id          AS Id
           , Object_StickerPack.ObjectCode  AS Code
           , Object_StickerPack.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerPack.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerPack
                              ON Object_StickerPack.isErased = tmpIsErased.isErased 
                             AND Object_StickerPack.DescId = zc_Object_StickerPack()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerPack.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerPack_Comment()
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
-- SELECT * FROM gpSelect_Object_StickerPack (FALSE, zfCalc_UserAdmin())
