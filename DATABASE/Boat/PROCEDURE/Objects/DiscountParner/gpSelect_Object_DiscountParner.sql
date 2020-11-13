-- Торговая марка

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountParner (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountParner(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountParner());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY
       -- результат
       SELECT
             Object_DiscountParner.Id             AS Id
           , Object_DiscountParner.ObjectCode     AS Code
           , Object_DiscountParner.ValueData      AS Name
           , ObjectString_Comment.ValueData  AS Comment

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_DiscountParner.isErased       AS isErased
       FROM Object AS Object_DiscountParner
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_DiscountParner.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_DiscountParner_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_DiscountParner.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_DiscountParner.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_DiscountParner.DescId = zc_Object_DiscountParner()
         AND (Object_DiscountParner.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
11.11.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountParner (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())