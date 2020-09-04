-- Function: gpSelect_Object_MemberExternal_Juridical()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberExternal_Juridical (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberExternal_Juridical(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar     -- сессия пользователя
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
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name

         , ObjectDesc.ItemName

         , Object_MemberExternal.isErased   AS isErased

     FROM Object AS Object_MemberExternal
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MemberExternal.DescId
     WHERE Object_MemberExternal.DescId = zc_Object_MemberExternal()
       AND (Object_MemberExternal.isErased = FALSE OR inIsShowAll = TRUE)                    
   UNION ALL
     SELECT 
           Object_Juridical.Id         AS Id
         , Object_Juridical.ObjectCode AS Code
         , Object_Juridical.ValueData  AS Name

         , ObjectDesc.ItemName

         , Object_Juridical.isErased   AS isErased

     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND (Object_Juridical.isErased = FALSE OR inIsShowAll = TRUE)
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberExternal_Juridical (FALSE, zfCalc_UserAdmin())
