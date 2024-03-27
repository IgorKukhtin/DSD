-- Function: gpGet_Object_MailSend(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MailSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MailSend(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , MailKindId Integer, MailKindName TVarChar
             , UserId Integer, UserName TVarChar
 ) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MailSend());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer          AS Id
           , lfGet_ObjectCode(0, zc_Object_MailSend())  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Comment
           , CAST (0 as Integer)    AS MailKindId
           , CAST ('' as TVarChar)  AS MailKindName      
           , CAST (0 as Integer)    AS UserId
           , CAST ('' as TVarChar)  AS UserName 
       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_MailSend.Id              AS Id
           , Object_MailSend.ObjectCode      AS Code
           , Object_MailSend.ValueData       AS Name
           , ObjectString_Comment.ValueData  AS Comment

           , Object_MailKind.Id              AS MailKindId
           , Object_MailKind.ValueData       AS MailKindName

           , Object_User.Id                  AS UserId
           , Object_User.ValueData           AS UserName

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

      WHERE Object_MailSend.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
26.03.24          *
*/

-- тест
-- SELECT * FROM gpGet_Object_MailSend(1,'2')