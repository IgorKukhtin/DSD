-- Function: gpSelect_Object_TypeCommerc()

DROP FUNCTION IF EXISTS gpSelect_Object_TypeCommerc (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TypeCommerc(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_TypeCommerc());

     RETURN QUERY 
     SELECT 
           Object_TypeCommerc.Id           AS Id
         , Object_TypeCommerc.ObjectCode   AS Code
         , Object_TypeCommerc.ValueData    AS Name
         , ObjectString_Comment.ValueData  AS Comment
         , Object_TypeCommerc.isErased     AS isErased
     FROM Object AS Object_TypeCommerc
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_TypeCommerc.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_TypeCommerc_Comment()  

     WHERE Object_TypeCommerc.DescId = zc_Object_TypeCommerc()
       AND (Object_TypeCommerc.isErased = FALSE OR inIsErased = TRUE)

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
 03.06.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TypeCommerc (FALSE, zfCalc_UserAdmin())