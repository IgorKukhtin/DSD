-- Function: gpGet_Movement_OrderFinance_Email_send()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_Email_send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_Email_send(
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
          -- кому отправка Сообщения - ФИО - на контроле-1, Руководитель
        , tmpList_Member AS (SELECT OL_Member_1.ChildObjectId AS MemberId
                             FROM MovementLinkObject AS MLO_OrderFinance
                                  INNER JOIN ObjectLink AS OL_Member_1
                                                        ON OL_Member_1.ObjectId = MLO_OrderFinance.ObjectId
                                                       AND OL_Member_1.DescId   = zc_ObjectLink_OrderFinance_Member_1()
                             WHERE MLO_OrderFinance.MovementId = inMovementId
                               AND MLO_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                            )
       -- ВСЕ параметры - откуда отправлять
     , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= (SELECT DISTINCT ObjectLink_EmailKind.ChildObjectId AS EmailKindId
                                                                                  FROM -- формат выгрузки
                                                                                       ObjectLink AS ObjectLink_ExportJuridical_ExportKind
                                                                                       -- откуда отправлять
                                                                                       INNER JOIN ObjectLink AS ObjectLink_EmailKind
                                                                                                             ON ObjectLink_EmailKind.ObjectId = ObjectLink_ExportJuridical_ExportKind.ObjectId
                                                                                                            AND ObjectLink_EmailKind.DescId = zc_ObjectLink_ExportJuridical_EmailKind()
                                                                                                            AND ObjectLink_EmailKind.ChildObjectId > 0
                                                                                  WHERE ObjectLink_ExportJuridical_ExportKind.DescId = zc_ObjectLink_ExportJuridical_ExportKind()
                                                                                    -- этот формат
                                                                                    AND ObjectLink_ExportJuridical_ExportKind.ChildObjectId = zc_Enum_ExportKind_PersonalService()
                                                                                  )
                                                               , inSession    := inSession)
                    )

     SELECT (tmp.outFileName || '.xls') :: TVarChar AS Subject

          , CASE WHEN vbUserId = 5 AND 1=1 THEN 'send to:' || COALESCE (tmpList_Email.Email_to, '') ELSE '' END :: TBlob AS Body
          , gpGet_Mail.Value     :: TVarChar AS AddressFrom

          , CASE WHEN vbUserId = 5    AND 1=1 THEN 'ashtu@ua.fm'
                 WHEN vbUserId = 9457 AND 1=1 THEN 'innafelon@gmail.com'
                 ELSE COALESCE ('ashtu@ua.fm;' || tmpList_Email.Email_to, 'ashtu@ua.fm')
            END :: TVarChar AS AddressTo

          , gpGet_Host.Value     :: TVarChar AS Host
          , gpGet_Port.Value     :: TVarChar AS Port
          , gpGet_User.Value     :: TVarChar AS UserName
          , gpGet_Password.Value :: TVarChar AS Password

     FROM gpGet_Movement_OrderFinance_FileName_xls (inMovementId , inSession) AS tmp
          LEFT JOIN tmpEmail AS gpGet_Host      ON gpGet_Host.EmailToolsId      = zc_Enum_EmailTools_Host()
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          -- кому отправка Сообщения
          LEFT JOIN (SELECT STRING_AGG (DISTINCT ObjectString_User_Email.ValueData, ';') AS Email_to
                     FROM tmpList_Member
                          JOIN ObjectLink AS ObjectLink_User_Member
                                          ON ObjectLink_User_Member.ChildObjectId = tmpList_Member.MemberId
                                         AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                          INNER JOIN ObjectString AS ObjectString_User_Email
                                                  ON ObjectString_User_Email.ObjectId  = ObjectLink_User_Member.ObjectId
                                                 AND ObjectString_User_Email.DescId    = zc_ObjectString_User_Email()
                                                 AND ObjectString_User_Email.ValueData <> ''
                    ) AS tmpList_Email
                      ON TRIM (tmpList_Email.Email_to) <> ''
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance_Email_send ( inMovementId := 32907603  , inSession:= '9457':: TVarChar) --  zfCalc_UserAdmin()  --zc_Enum_ExportKind_Mida35273055()
