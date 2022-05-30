-- Function: gpSelect_Object_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpSelect_Object_CommentMoveMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentMoveMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isUserAll Boolean
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUser_isAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_CommentMoveMoney());
   vbUserId:= lpGetUserBySession (inSession);

   -- 
   vbUser_isAll:= lpCheckUser_isAll (vbUserId);

   -- Результат
   RETURN QUERY 
   SELECT Object_CommentMoveMoney.Id          AS Id
        , Object_CommentMoveMoney.ObjectCode  AS Code
        , Object_CommentMoveMoney.ValueData   AS Name
        , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll
        , Object_CommentMoveMoney.isErased    AS isErased

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate

       FROM Object AS Object_CommentMoveMoney

        LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                ON ObjectBoolean_UserAll.ObjectId = Object_CommentMoveMoney.Id
                               AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_CommentMoveMoney_UserAll()

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_CommentMoveMoney.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_CommentMoveMoney.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_CommentMoveMoney.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_CommentMoveMoney.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
       WHERE Object_CommentMoveMoney.DescId = zc_Object_CommentMoveMoney()
         AND (vbUser_isAll = TRUE OR ObjectBoolean_UserAll.ValueData = TRUE)
      ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.22          *     
*/

-- тест
-- SELECT * FROM gpSelect_Object_CommentMoveMoney('2')
