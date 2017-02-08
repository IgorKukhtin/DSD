-- Function: gpSelect_Object_MemberPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberPlace (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberPlace(
    IN inIsShowAll        Boolean,       --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     /*SELECT 
           Object_Member.Id
         , Object_Member.Code
         , Object_Member.Name

         , ObjectDesc.ItemName

         , Object_Member.isErased

     FROM gpSelect_Object_Member (inIsShowAll, inSession) AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Member()
                                
   UNION ALL*/
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name

         , ObjectDesc.ItemName

         , Object_MemberExternal.isErased   AS isErased

     FROM Object AS Object_MemberExternal
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_MemberExternal()
                                
     WHERE Object_MemberExternal.DescId = zc_Object_MemberExternal()
       AND (Object_MemberExternal.isErased = FALSE
            OR (Object_MemberExternal.isErased = TRUE AND inIsShowAll = TRUE)
           )
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MemberPlace (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberPlace (FALSE, inSession := zfCalc_UserAdmin())
