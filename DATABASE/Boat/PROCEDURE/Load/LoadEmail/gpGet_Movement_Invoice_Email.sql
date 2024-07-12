-- Function: gpGet_Movement_Invoice_Email (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Invoice_Email (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Invoice_Email(
    IN inMovementId       Integer   ,  --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE ( Subject TVarChar         --имя файла
              , Body TBlob
              , AddressFrom TVarChar
              , AddressTo TVarChar
              , Host TVarChar
              , Port TVarChar
              , UserName TVarChar
              , Password TVarChar
              )
              
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
     WITH tmpEmail AS (SELECT tmp.*
                       FROM gpSelect_Object_EmailSettings (inEmailKindId:= 0, inSession:= inSession) AS tmp
                       WHERE tmp.Value <> '' AND tmp.EmailKindId IN (zc_Enum_EmailKind_Mail_InvoiceKredit())
                      )
        
        , tmpMailSend AS (SELECT STRING_AGG (Object_MailSend.ValueData, ';')::TVarChar AS Name
                          FROM Object AS Object_MailSend
                                INNER JOIN ObjectLink AS ObjectLink_MailSend_User
                                                      ON ObjectLink_MailSend_User.ObjectId = Object_MailSend.Id
                                                     AND ObjectLink_MailSend_User.DescId = zc_ObjectLink_MailSend_User()
                                                     AND ObjectLink_MailSend_User.ChildObjectId = vbUserId
                                INNER JOIN ObjectLink AS ObjectLink_MailSend_MailKind
                                                      ON ObjectLink_MailSend_MailKind.ObjectId = Object_MailSend.Id
                                                     AND ObjectLink_MailSend_MailKind.DescId = zc_ObjectLink_MailSend_MailKind()
                                                     AND ObjectLink_MailSend_MailKind.ChildObjectId = zc_Enum_MailKind_Internal()
                         WHERE Object_MailSend.DescId = zc_Object_MailSend()
                           AND Object_MailSend.isErased = FALSE  
                         --  LIMIT 1
                         ) 
                         
        , tmpObjectMail AS (SELECT COALESCE (ObjectString_Email.ValueData,'')::TVarChar    AS Email
                            FROM MovementLinkObject AS MovementLinkObject_Object
                                INNER JOIN ObjectString AS ObjectString_Email
                                                        ON ObjectString_Email.ObjectId =  MovementLinkObject_Object.ObjectId
                                                       AND ObjectString_Email.DescId IN (zc_ObjectString_Client_Email(), zc_ObjectString_Partner_Email())                           
                            WHERE MovementLinkObject_Object.MovementId = inMovementId
                              AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object() 
                              AND COALESCE (ObjectString_Email.ValueData,'') <> ''
                            )

     -- Результат
     -- Invoice
     SELECT
            '' ::TVarChar  AS Subject    --FileName
          , '' :: TBlob    AS Body

          , gpGet_Mail.Value :: TVarChar AS AddressFrom

          , CASE WHEN vbUserId = 5 AND 1=1 THEN 'ashtu@ukr.net'
                 WHEN vbUserId = 5 AND 1=1 THEN tmpMailSend.Name
                 ELSE CASE WHEN COALESCE (tmpMailSend.Name,'') <> '' THEN tmpMailSend.Name ELSE tmpObjectMail.Email END 
            END :: TVarChar AS AddressTo

          , CASE WHEN vbUserId = 5 AND 1=1 THEN 'smtp.gmail.com'
                 ELSE gpGet_Host.Value 
            END   :: TVarChar   AS Host           --хост и порт  smtp.gmail.com  587

          , CASE WHEN vbUserId = 5 AND 1=1 THEN '587'
                 ELSE gpGet_Port.Value
            END :: TVarChar   AS Port

          , gpGet_User.Value :: TVarChar   AS UserName

          , gpGet_Password.Value :: TVarChar AS Password
     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailKindId  = gpGet_Host.EmailKindId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailKindId = gpGet_Host.EmailKindId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          LEFT JOIN tmpObjectMail ON 1=1
          LEFT JOIN tmpMailSend ON 1 = 1

     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 28.02.24         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Invoice_Email (2742, zfCalc_UserAdmin())