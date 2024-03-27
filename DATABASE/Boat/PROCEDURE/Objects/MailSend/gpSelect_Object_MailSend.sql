-- Function: gpSelect_Object_MailSend (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MailSend (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MailSend(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , MailKindId Integer, MailKindCode Integer, MailKindName TVarChar
             , UserId Integer, UserCode Integer, UserName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_MailSend());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY

       SELECT
             Object_MailSend.Id              AS Id
           , Object_MailSend.ObjectCode      AS Code
           , Object_MailSend.ValueData       AS Name
           , ObjectString_Comment.ValueData  AS Comment
           , Object_MailKind.Id              AS MailKindId
           , Object_MailKind.ObjectCode      AS MailKindCode
           , Object_MailKind.ValueData       AS MailKindName

           , Object_User.Id                  AS UserId
           , Object_User.ObjectCode          AS UserCode
           , Object_User.ValueData           AS UserName

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate

           , Object_MailSend.isErased        AS isErased

       FROM Object AS Object_MailSend
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_MailSend.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_MailSend_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_MailSend_MailKind
                                 ON ObjectLink_MailSend_MailKind.ObjectId = Object_MailSend.Id
                                AND ObjectLink_MailSend_MailKind.DescId = zc_ObjectLink_MailSend_MailKind()
            LEFT JOIN Object AS Object_MailKind ON Object_MailKind.Id = ObjectLink_MailSend_MailKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_MailSend_User
                                 ON ObjectLink_MailSend_User.ObjectId = Object_MailSend.Id
                                AND ObjectLink_MailSend_User.DescId = zc_ObjectLink_MailSend_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_MailSend_User.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_MailSend.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_MailSend.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_MailSend.DescId = zc_Object_MailSend()
       AND (Object_MailSend.isErased = FALSE OR inIsShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.                                                                     j
26.03.24          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MailSend (TRUE, zfCalc_UserAdmin())