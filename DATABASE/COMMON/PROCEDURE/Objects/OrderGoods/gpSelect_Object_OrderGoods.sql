-- Function: gpSelect_Object_OrderGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderGoods (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_OrderGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderGoods(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_OrderGoods());

     RETURN QUERY 
     SELECT 
           Object_OrderGoods.Id           AS Id
         , Object_OrderGoods.ObjectCode   AS Code
         , Object_OrderGoods.ValueData    AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_OrderGoods.isErased     AS isErased
     FROM Object AS Object_OrderGoods
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_OrderGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_OrderGoods_Comment()  
     WHERE Object_OrderGoods.DescId = zc_Object_OrderGoods()
       AND (Object_OrderGoods.isErased = FALSE OR inIsErased = TRUE)

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
 02.01.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderGoods (FALSE, zfCalc_UserAdmin())