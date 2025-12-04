-- Function: gpGet_Movement_OrderFinance_Email_sendGroup()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_Email_sendGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_Email_sendGroup(
    IN inMovementId           Integer,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port TVarChar, UserName TVarChar, Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     if vbUserId <> 5 AND 1=0
     THEN
        -- RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;

     -- Результат
     RETURN QUERY
     WITH
       tmpImportSettings AS (SELECT ObjectLink_ImportSettings_ContactPerson.ChildObjectId AS ContactPersonId
                                  , ObjectLink_ImportSettings_Email.ChildObjectId         AS EmailId
                             FROM ObjectLink AS ObjectLink_ImportSettings_ContactPerson
                                  INNER JOIN Object AS Object_ImportSettings ON Object_ImportSettings.Id = ObjectLink_ImportSettings_ContactPerson.ObjectId AND Object_ImportSettings.isErased = FALSE
                                  INNER JOIN ObjectLink AS ObjectLink_ImportSettings_Email
                                                        ON ObjectLink_ImportSettings_Email.ObjectId = ObjectLink_ImportSettings_ContactPerson.ObjectId
                                                       AND ObjectLink_ImportSettings_Email.DescId = zc_ObjectLink_ImportSettings_Email()
                             WHERE ObjectLink_ImportSettings_ContactPerson.ChildObjectId > 0
                               AND ObjectLink_ImportSettings_ContactPerson.DescId = zc_ObjectLink_ImportSettings_ContactPerson()
                            )
     , tmpContactPerson AS (SELECT STRING_AGG (ObjectString_Mail.ValueData, '; ')  AS ContactPersonMail 
                            FROM Object AS Object_ContactPerson
                                 INNER JOIN ObjectString AS ObjectString_Mail
                                                        ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                       AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                       AND COALESCE (ObjectString_Mail.ValueData,'') <> ''
                                                                                   
                                 INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                       ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = zc_Enum_ContactPersonKind_Member()
                                 
                            WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                              AND Object_ContactPerson.isErased = FALSE
                            )
       -- ВСЕ параметры - откуда отправлять
     , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= (SELECT DISTINCT ObjectLink_EmailKind.ChildObjectId AS EmailKindId
                                                                                  FROM ObjectLink AS ObjectLink_ExportJuridical_ExportKind           -- формат выгрузки
                                                                                       -- откуда отправлять
                                                                                       INNER JOIN ObjectLink AS ObjectLink_EmailKind
                                                                                                             ON ObjectLink_EmailKind.ObjectId = ObjectLink_ExportJuridical_ExportKind.ObjectId
                                                                                                            AND ObjectLink_EmailKind.DescId = zc_ObjectLink_ExportJuridical_EmailKind()
                                                                                                            AND ObjectLink_EmailKind.ChildObjectId > 0   
                                                                                  WHERE ObjectLink_ExportJuridical_ExportKind.DescId = zc_ObjectLink_ExportJuridical_ExportKind()
                                                                                    AND ObjectLink_ExportJuridical_ExportKind.ChildObjectId = zc_Enum_ExportKind_PersonalService()
                                                                                  )
                                                               , inSession    := inSession)
                    )
                                                                        
     SELECT (tmp.outFileName || '.csv') :: TVarChar AS Subject  

          , ''                       :: TBlob    AS Body
          
          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'test@gmail.com'
                 ELSE gpGet_Mail.Value
            END :: TVarChar                      AS AddressFrom

          , CASE WHEN vbUserId = 5    AND 1=1 THEN 'ashtu@ua.fm'
                 WHEN vbUserId = 9457 AND 1=1 THEN 'innafelon@gmail.com'
                 WHEN COALESCE (tmpContactPerson.ContactPersonMail, '') = '' AND 1=1 THEN 'ashtu@ua.fm;t.hordienko@alan.ua'
                 ELSE tmpContactPerson.ContactPersonMail
            END :: TVarChar AS AddressTo

          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'test-smtp.gmail.com' -- 'smtp.ua.fm' 
                 ELSE gpGet_Host.Value
            END :: TVarChar                       AS Host

          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'test-587' -- 993
                 ELSE gpGet_Port.Value
            END :: TVarChar                       AS Port

          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'test@gmail.com'
                 ELSE gpGet_User.Value
            END :: TVarChar                      AS UserName

          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'test-ufhm' -- 'et' 
                 ELSE gpGet_Password.Value
            END :: TVarChar                      AS Password

     FROM gpGet_Movement_OrderFinance_FileName_group (inMovementId , inSession) AS tmp
          LEFT JOIN tmpContactPerson ON 1= 1 
          LEFT JOIN tmpEmail AS gpGet_Host      ON gpGet_Host.EmailToolsId      = zc_Enum_EmailTools_Host()
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
    ;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.25         *
*/

-- тест
--SELECT * FROM gpGet_Movement_OrderFinance_Email_sendGroup ( inMovementId := 19727298 , inSession:= '9457':: TVarChar) --  zfCalc_UserAdmin()  --zc_Enum_ExportKind_Mida35273055()