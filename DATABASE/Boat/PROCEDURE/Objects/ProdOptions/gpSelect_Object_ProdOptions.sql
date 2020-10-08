-- Function: gpSelect_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptions(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptions());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
     SELECT 
           Object_ProdOptions.Id           AS Id 
         , Object_ProdOptions.ObjectCode   AS Code
         , Object_ProdOptions.ValueData    AS Name

         , ObjectFloat_Level.ValueData     AS Level
         , ObjectString_Comment.ValueData  AS Comment

         , Object_Insert.ValueData         AS InsertName
         , ObjectDate_Insert.ValueData     AS InsertDate
         , Object_ProdOptions.isErased     AS isErased
         
     FROM Object AS Object_ProdOptions
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()  

          LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                ON ObjectFloat_Level.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_Level.DescId = zc_ObjectFloat_ProdOptions_Level()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptions.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptions.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdOptions.DescId = zc_Object_ProdOptions()
      AND (Object_ProdOptions.isErased = FALSE OR inIsShowAll = TRUE);  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdOptions (False, zfCalc_UserAdmin())
