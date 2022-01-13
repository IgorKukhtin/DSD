-- Function: gpSelect_Object_CommentMoveMoney()

DROP FUNCTION IF EXISTS gpSelect_Object_CommentMoveMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentMoveMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CommentMoveMoney());

   RETURN QUERY 
   SELECT Object_CommentMoveMoney.Id          AS Id
        , Object_CommentMoveMoney.ObjectCode  AS Code
        , Object_CommentMoveMoney.ValueData   AS Name
        , Object_CommentMoveMoney.isErased    AS isErased

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate

       FROM Object AS Object_CommentMoveMoney
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