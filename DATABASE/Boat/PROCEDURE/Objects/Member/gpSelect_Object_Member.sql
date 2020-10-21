-- Function: gpSelect_Object_Member()

DROP FUNCTION IF EXISTS gpSelect_Object_Member (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя
   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar
             , Comment TVarChar, EMail TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());


   -- результат
   RETURN QUERY
      SELECT Object_Member.Id                AS Id
           , Object_Member.ObjectCode        AS Code
           , Object_Member.ValueData         AS Name
           , ObjectString_INN.ValueData      AS INN
           , ObjectString_Comment.ValueData  AS Comment
           , ObjectString_EMail.ValueData    AS EMail
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_Member.isErased          AS isErased
       FROM Object AS Object_Member
            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = Object_Member.Id
                                  AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Member.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()

            LEFT JOIN ObjectString AS ObjectString_EMail
                                   ON ObjectString_EMail.ObjectId = Object_Member.Id
                                  AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()
           
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_Member.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_Member.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_Member.DescId = zc_Object_Member()
         AND (Object_Member.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  21.10.20        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Member (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
