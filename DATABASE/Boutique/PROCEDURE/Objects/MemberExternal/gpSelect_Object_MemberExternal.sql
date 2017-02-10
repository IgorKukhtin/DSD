-- Function: gpSelect_Object_MemberExternal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberExternal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberExternal(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_MemberExternal());
   vbUserId:= lpGetUserBySession (inSession);


   -- Результат
   RETURN QUERY 
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name

         , Object_MemberExternal.isErased                   AS isErased

     FROM Object AS Object_MemberExternal
                                
     WHERE Object_MemberExternal.DescId = zc_Object_MemberExternal()
       AND (Object_MemberExternal.isErased = FALSE
            OR (Object_MemberExternal.isErased = TRUE AND inIsShowAll = TRUE)
           )
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MemberExternal (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.15                                        *
*/
-- тест
-- SELECT * FROM gpSelect_Object_MemberExternal (FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_MemberExternal (TRUE, zfCalc_UserAdmin())
