-- Function: gpSelect_Object_RouteTT()

DROP FUNCTION IF EXISTS gpSelect_Object_RouteTT (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteTT(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RouteTT());

     RETURN QUERY 
     SELECT 
           Object_RouteTT.Id           AS Id
         , Object_RouteTT.ObjectCode   AS Code
         , Object_RouteTT.ValueData    AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_RouteTT.isErased     AS isErased
     FROM Object AS Object_RouteTT
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_RouteTT.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_RouteTT_Comment()  
     WHERE Object_RouteTT.DescId = zc_Object_RouteTT()
       AND (Object_RouteTT.isErased = FALSE OR inIsErased = TRUE)

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
 21.05.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RouteTT (FALSE, zfCalc_UserAdmin())