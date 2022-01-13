-- Function: gpSelect_Object_CommentInfoMoney()

DROP FUNCTION IF EXISTS gpSelect_Object_CommentInfoMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentInfoMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CommentInfoMoney());

   RETURN QUERY 
   SELECT Object_CommentInfoMoney.Id          AS Id
        , Object_CommentInfoMoney.ObjectCode  AS Code
        , Object_CommentInfoMoney.ValueData   AS Name
        , Object_CommentInfoMoney.isErased    AS isErased
        
        , Object_InfoMoneyKind.Id         AS InfoMoneyKindId
        , Object_InfoMoneyKind.ValueData  AS InfoMoneyKindName

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate

       FROM Object AS Object_CommentInfoMoney
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                             ON ObjectLink_InfoMoneyKind.ObjectId = Object_CommentInfoMoney.Id
                            AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_CommentInfoMoney_InfoMoneyKind()
        LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_CommentInfoMoney.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_CommentInfoMoney.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_CommentInfoMoney.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_CommentInfoMoney.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
       WHERE Object_CommentInfoMoney.DescId = zc_Object_CommentInfoMoney()
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
-- SELECT * FROM gpSelect_Object_CommentInfoMoney('2')