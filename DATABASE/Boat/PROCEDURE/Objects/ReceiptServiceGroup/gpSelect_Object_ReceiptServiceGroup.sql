--

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptServiceGroup (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptServiceGroup(
    IN inIsShowAll   Boolean,            --  признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptServiceGroup());


   -- результат
   RETURN QUERY
      SELECT Object_ReceiptServiceGroup.Id               AS Id
           , Object_ReceiptServiceGroup.ObjectCode       AS Code
           , Object_ReceiptServiceGroup.ValueData        AS Name
           , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_ReceiptServiceGroup.isErased         AS isErased
       FROM Object AS Object_ReceiptServiceGroup
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptServiceGroup.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptServiceGroup_Comment()

           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = Object_ReceiptServiceGroup.Id
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                ON ObjectDate_Insert.ObjectId = Object_ReceiptServiceGroup.Id
                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ReceiptServiceGroup.DescId = zc_Object_ReceiptServiceGroup()
         AND (Object_ReceiptServiceGroup.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptServiceGroup (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
