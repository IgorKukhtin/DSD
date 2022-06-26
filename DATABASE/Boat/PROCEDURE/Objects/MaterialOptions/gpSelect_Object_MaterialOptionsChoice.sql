--

DROP FUNCTION IF EXISTS gpSelect_Object_MaterialOptionsChoice (Integer,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MaterialOptionsChoice(
    IN inProdOptionsId Integer,
    IN inIsShowAll     Boolean,            -- признак показать удаленные да / нет 
    IN inSession       TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MaterialOptions());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_MaterialOptions.Id              AS Id
           , Object_MaterialOptions.ObjectCode      AS Code
           , Object_MaterialOptions.ValueData       AS Name

           , Object_Insert.ValueData                AS InsertName
           , ObjectDate_Insert.ValueData            AS InsertDate
           , Object_MaterialOptions.isErased        AS isErased
       FROM Object AS Object_MaterialOptions

          LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                ON ObjectLink_MaterialOptions.ChildObjectId = Object_MaterialOptions.Id
                               AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_MaterialOptions.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_MaterialOptions.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_MaterialOptions.DescId = zc_Object_MaterialOptions()
         AND (Object_MaterialOptions.isErased = FALSE OR inIsShowAll = TRUE)
         AND (ObjectLink_MaterialOptions.ObjectId = inProdOptionsId OR inProdOptionsId = 0)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.26.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MaterialOptionsChoice (0,inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())