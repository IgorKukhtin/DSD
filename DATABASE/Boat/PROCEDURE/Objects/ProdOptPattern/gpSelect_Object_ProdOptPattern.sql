-- Function: gpSelect_Object_ProdOptPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptPattern (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptPattern(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptPattern());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY

     SELECT 
           Object_ProdOptPattern.Id         AS Id 
         , Object_ProdOptPattern.ObjectCode AS Code
         , Object_ProdOptPattern.ValueData  AS Name

         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Insert.ValueData          AS InsertName
         , ObjectDate_Insert.ValueData      AS InsertDate
         , Object_ProdOptPattern.isErased   AS isErased
         
     FROM Object AS Object_ProdOptPattern
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptPattern_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptPattern.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptPattern.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdOptPattern.DescId = zc_Object_ProdOptPattern()
      AND (Object_ProdOptPattern.isErased = FALSE OR inIsErased = TRUE) 
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdOptPattern (false,false, zfCalc_UserAdmin())
