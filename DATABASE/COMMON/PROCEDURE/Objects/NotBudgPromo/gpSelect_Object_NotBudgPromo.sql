-- Function: gpSelect_Object_NotBudgPromo()

DROP FUNCTION IF EXISTS gpSelect_Object_NotBudgPromo (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_NotBudgPromo(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_NotBudgPromo());

     RETURN QUERY 
     SELECT 
           Object_NotBudgPromo.Id           AS Id
         , Object_NotBudgPromo.ObjectCode   AS Code
         , Object_NotBudgPromo.ValueData    AS Name
         , ObjectString_Comment.ValueData   AS Comment
         , Object_NotBudgPromo.isErased     AS isErased
     FROM Object AS Object_NotBudgPromo
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_NotBudgPromo.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_NotBudgPromo_Comment()  

     WHERE Object_NotBudgPromo.DescId = zc_Object_NotBudgPromo()
       AND (Object_NotBudgPromo.isErased = FALSE OR inIsErased = TRUE)

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
 11.06.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_NotBudgPromo (FALSE, zfCalc_UserAdmin())