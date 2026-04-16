-- Function: gpSelect_Object_MemberGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberGoods(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberGoods());

     RETURN QUERY 
     SELECT 
           Object_MemberGoods.Id           AS Id
         , Object_MemberGoods.ObjectCode   AS Code
         , Object_MemberGoods.ValueData    AS Name
         , ObjectString_Comment.ValueData  AS Comment
         , Object_MemberGoods.isErased     AS isErased
     FROM Object AS Object_MemberGoods
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MemberGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_MemberGoods_Comment()  
     WHERE Object_MemberGoods.DescId = zc_Object_MemberGoods()
       AND (Object_MemberGoods.isErased = FALSE OR inIsErased = TRUE)

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<ПУСТО>' :: TVarChar AS Name
         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberGoods (FALSE, zfCalc_UserAdmin())