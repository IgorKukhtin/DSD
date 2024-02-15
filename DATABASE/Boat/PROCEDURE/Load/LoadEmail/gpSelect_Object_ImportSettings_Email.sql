-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inEmailKindDesc    TVarChar ,      --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (EmailKindId      Integer
             , EmailKindName    TVarChar

             , zc_Enum_EmailKind_Mail TVarChar

             , Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar

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

     -- Результат
     -- Invoice
     SELECT
            gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , 'zc_Enum_EmailKind_Mail_InvoiceKredit'::TVarChar   AS zc_Enum_EmailKind_Mail

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailKindId  = gpGet_Host.EmailKindId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailKindId = gpGet_Host.EmailKindId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
     ORDER BY 1
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.24                                                       *
*/

-- тест
SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_Mail_InvoiceKredit', zfCalc_UserAdmin())
