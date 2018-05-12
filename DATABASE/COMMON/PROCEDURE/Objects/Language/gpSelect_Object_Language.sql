-- Function: gpSelect_Object_Language (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Language (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Language(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Language());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
       SELECT
             Object_Language.Id          AS Id
           , Object_Language.ObjectCode  AS Code
           , Object_Language.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_Language.isErased    AS isErased

       FROM tmpIsErased
            INNER JOIN Object AS Object_Language
                              ON Object_Language.isErased = tmpIsErased.isErased
                             AND Object_Language.DescId = zc_Object_Language()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Language.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Language_Comment()
       ORDER BY Object_Language.ObjectCode
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
-- SELECT * FROM gpSelect_Object_Language (FALSE, zfCalc_UserAdmin())
