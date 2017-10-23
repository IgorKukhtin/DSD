-- Function: gpSelect_Object_StickerType (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerType (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerType(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerType());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerType.Id          AS Id
           , Object_StickerType.ObjectCode  AS Code
           , Object_StickerType.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerType.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerType
                              ON Object_StickerType.isErased = tmpIsErased.isErased 
                             AND Object_StickerType.DescId = zc_Object_StickerType()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerType.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerType_Comment()
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
-- SELECT * FROM gpSelect_Object_StickerType (FALSE, zfCalc_UserAdmin())
