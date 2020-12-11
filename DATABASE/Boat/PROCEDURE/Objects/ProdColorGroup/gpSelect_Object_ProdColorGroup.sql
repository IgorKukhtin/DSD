-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorGroup (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorGroup(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ProdColorKindId Integer, ProdColorKindName TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColorGroup());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_ProdColorGroup.Id         AS Id
           , Object_ProdColorGroup.ObjectCode AS Code
           , Object_ProdColorGroup.ValueData  AS Name
           , Object_ProdColorKind.Id          AS ProdColorKindId
           , Object_ProdColorKind.ValueData   AS ProdColorKindName
           , ObjectString_Comment.ValueData   AS Comment

           , Object_Insert.ValueData          AS InsertName
           , ObjectDate_Insert.ValueData      AS InsertDate
           , Object_ProdColorGroup.isErased   AS isErased
       FROM Object AS Object_ProdColorGroup
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorGroup.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorGroup_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                               ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                              AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
          LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColorGroup.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColorGroup.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ProdColorGroup.DescId = zc_Object_ProdColorGroup()
         AND (Object_ProdColorGroup.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
11.12.20          * ProdColorKindId
08.10.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorGroup (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())