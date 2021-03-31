-- Function: gpSelect_Object_ExportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, TVarChar, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, Text, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportSettings_Email(
    IN inObjectId         Integer,       -- ключ объекта
    IN inContactPersonId  Integer,       -- ключ объекта
    IN inByDate           TDateTime,     -- 
    IN inByMail           Text,          -- 
    IN inByFileName       TBlob,         -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (EmailId          Integer
             , EmailName        TVarChar
             , EmailKindId      Integer
             , EmailKindName    TVarChar
             , Host TVarChar, Port TVarChar
             , UserName TVarChar, PasswordValue TVarChar
             , MailFrom TVarChar, MailTo TVarChar
             , Subject TVarChar, Body TBlob
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbIsUkrNet Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- временно
   vbIsUkrNet:= EXISTS (select 1 from Object WHERE Id = vbUserId AND ObjectCode < 0);


   -- Результат
   RETURN QUERY 
     WITH tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder() AND tmp.JuridicalId = 0)
        , tmpFind AS (SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_IncomeMMO', inSession:= inSession) AS tmp
                      WHERE tmp.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                        AND tmp.Id          = inObjectId
                        AND STRPOS (LOWER (inByMail), LOWER (tmp.Mail)) > 0
                     )
        , tmpUkrNet AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession)
                        WHERE JuridicalId = 393054)
     SELECT 
            gpGet_Host.EmailId
          , gpGet_Host.EmailName
          , gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , case when vbIsUkrNet = TRUE THEN gpGet_Host_UkrNet.Value       ELSE gpGet_Host.Value     END :: TVarChar AS Host
          , case when vbIsUkrNet = TRUE THEN gpGet_Port_UkrNet.Value       ELSE gpGet_Port.Value     END :: TVarChar AS Port
          , case when vbIsUkrNet = TRUE THEN gpGet_User_UkrNet.Value       ELSE gpGet_User.Value     END :: TVarChar AS UserName
          , case when vbIsUkrNet = TRUE THEN gpGet_Password_UkrNet.Value   ELSE gpGet_Password.Value END :: TVarChar AS PasswordValue
          , case when vbIsUkrNet = TRUE THEN gpGet_Mail_UkrNet.Value       ELSE gpGet_Mail.Value     END :: TVarChar AS MailFrom
          
          , CASE WHEN tmp.Num = 1 THEN 'ashtu777@ua.fm' WHEN tmp.Num = 2 THEN COALESCE (ObjectString_ErrorTo.ValueData, 'pravda_6@i.ua') ELSE 'price@neboley.dp.ua' END :: TVarChar AS MailTo

          , CASE WHEN gpSelect.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                      THEN 'Ошибка авто - загрузки приход ММО ' || COALESCE (Object_ContactPerson.ValueData, '') || ' - ' || TO_CHAR (CURRENT_TIMESTAMP, 'dd.mm.yyyy hh:mm:ss')
                 ELSE 'Ошибка авто - загрузки прайса поставщика ' || '(' || COALESCE (Object_Juridical.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object_Juridical.ValueData, '') || ' - ' || TO_CHAR (CURRENT_TIMESTAMP, 'dd.mm.yyyy hh:mm:ss')
            END :: TVarChar AS Subject
          , CASE WHEN inByFileName = '-1'
                     THEN 'Ошибка сохранения данных в прайс поставщика "' || COALESCE (inByFileName, '') || '".'
                 WHEN inByFileName = '0'
                     THEN 'Письмо получено "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" с электронного адреса "' || COALESCE (inByMail, '') || '".'
                       || CASE WHEN gpSelect.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                                    THEN 'Не содержит файла *.mmo для загрузки Прихода.Необходимо удалить письмо в ручном режиме.'
                               ELSE 'Не содержит файла *.xls для загрузки Прайса.Необходимо удалить письмо в ручном режиме.'
                          END
                 WHEN inByFileName = '4'
                     THEN 'Письмо получено "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" с электронного адреса "' || COALESCE (inByMail, '') || '". Содержит больше одно файла *.xls для загрузки.Необходимо удалить письмо и загрузить Прайс в ручном режиме.'
                 WHEN inByFileName = '2'
                     THEN 'В папке на сервере "' || COALESCE (inByMail, '') || '" найдено больше одно файла *.xls для загрузки Прайса.Необходимо удалить лишний.'
                 ELSE 'Письмо получено "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" с электронного адреса "' || COALESCE (inByMail, '') || '". Содержит вложение "' || COALESCE (inByFileName, '') || '".'
             END :: TBlob AS Body

     FROM tmpEmail AS gpGet_Host
          LEFT JOIN (SELECT /*1 AS Num UNION ALL SELECT*/ 2 AS Num /*UNION ALL SELECT 3 AS Num*/) AS tmp ON 1 = 1
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()

          LEFT JOIN tmpUkrNet AS gpGet_Host_UkrNet      ON gpGet_Host_UkrNet.EmailToolsId      = zc_Enum_EmailTools_Host()
          LEFT JOIN tmpUkrNet AS gpGet_Port_UkrNet      ON gpGet_Port_UkrNet.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpUkrNet AS gpGet_Mail_UkrNet      ON gpGet_Mail_UkrNet.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpUkrNet AS gpGet_User_UkrNet      ON gpGet_User_UkrNet.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpUkrNet AS gpGet_Password_UkrNet  ON gpGet_Password_UkrNet.EmailToolsId  = zc_Enum_EmailTools_Password()

          LEFT JOIN gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect ON gpSelect.Id = inObjectId
          LEFT JOIN tmpFind ON tmpFind.Id = inObjectId
          LEFT JOIN ObjectString AS ObjectString_ErrorTo
                                 ON ObjectString_ErrorTo.ObjectId = COALESCE (tmpFind.EmailId, gpSelect.EmailId)
                                AND ObjectString_ErrorTo.DescId = zc_ObjectString_Email_ErrorTo()
                                AND ObjectString_ErrorTo.ValueData <> ''

          LEFT JOIN Object AS Object_Juridical     ON Object_Juridical.Id     = gpSelect.JuridicalId
          LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = inContactPersonId

     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2367578, inContactPersonId:= 2324911, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2367552, inContactPersonId:= 2324488, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2357054, inContactPersonId:= 2325575, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3


SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 11465565, inContactPersonId:= 9726226, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'price@bad-altay.dn.ua, Pastuhova_O@bad-altay.dn.ua * shapiro_DOC@ukr.net', inByFileName:= '', inSession:= '1871720') order by 3