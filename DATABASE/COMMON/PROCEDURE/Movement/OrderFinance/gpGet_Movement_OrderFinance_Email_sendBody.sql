-- Function: gpGet_Movement_OrderFinance_Email_sendSB()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_Email_sendSB (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_Email_sendBody (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_Email_sendBody(
    IN inMovementId           Integer, 
    IN inParam                Integer,    -- 1 --для СБ, 2 - Фин. служба, 3 - Бузгалтерия
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
     , tmpContactPerson AS (SELECT -- Не НАЗНАЧЕНО
                                   '' :: TVarChar AS ContactPersonMail
                                 --STRING_AGG (ObjectString_Mail.ValueData, '; ')  AS ContactPersonMail
                            FROM Object AS Object_ContactPerson
                                 INNER JOIN ObjectString AS ObjectString_Mail
                                                        ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id
                                                       AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                       AND COALESCE (ObjectString_Mail.ValueData,'') <> ''

                                 INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                       ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = zc_Enum_ContactPersonKind_Member()
                                                      -- Не НАЗНАЧЕНО
                                                      AND 1=0

                            WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                              AND Object_ContactPerson.isErased = FALSE
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
     , tmpMovement AS (
                       SELECT CASE WHEN inParam = 1 THEN 'Уведомление для СБ за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   WHEN inParam = 2 THEN 'Уведомление для Фин.отдела за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   WHEN inParam = 3 THEN 'Уведомление для Бухгалтерии за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   ELSE ''
                              END ::TVarChar AS Subject

                            , CASE WHEN inParam = 1 THEN 'Проверка заявок за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' от отдела снабжения для "'||tmp.OrderFinanceName::TVarChar 
                                                       ||'" требуется в системе «Project»' 
                                   WHEN inParam = 2 THEN 'Проверка заявок за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' от отдела снабжения для "'||tmp.OrderFinanceName::TVarChar 
                                                       ||'" департаментом безопасности завершена' 
                                   WHEN inParam = 3 THEN 'Период планирования за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' закрыт. Данные готовы для формирования оплат и выгрузки в Клиент-Банк.'
                               END 
                                :: TBlob   AS Body
                            , tmp.OrderFinanceName
                            , tmp.WeekNumber
                            , tmp.StartDate_WeekNumber 
                            , tmp.EndDate_WeekNumber

                            , tmp.isSignSB_guide

                       FROM gpGet_Movement_OrderFinance (inMovementId, CURRENT_DATE :: TDateTime, inSession) AS tmp
                      )

     --РЕЗУЛЬТАТ
     SELECT tmpMovement.Subject :: TVarChar AS Subject
          , tmpMovement.Body    :: TBlob    AS Body

          , gpGet_Mail.Value    :: TVarChar AS AddressFrom

          , CASE WHEN vbUserId = 5    AND 1=0 THEN 'ashtu@ua.fm'
                 WHEN vbUserId = 9457 AND 1=1 THEN 'innafelon@gmail.com'

                 -- Для СБ
                 WHEN tmpMovement.isSignSB_guide = TRUE AND inParam = 1
                      THEN 'ashtu@ua.fm'
                    --THEN 'ashtu@ua.fm;o.panasenko@alan.ua'

                 -- такие НИКОМУ
                 WHEN tmpMovement.isSignSB_guide = FALSE AND inParam = 1
                      THEN 'ashtu@ua.fm'

                 -- Для ВСЕХ - после СБ
                 WHEN inParam = 2
                      THEN 'ashtu@ua.fm'
                    --THEN 'ashtu@ua.fm;o.gordienko@alan.ua;o.pavlova@alan.ua;y.tihaeva@alan.ua'


                 WHEN COALESCE (tmpContactPerson.ContactPersonMail, '') = '' AND 1=1 THEN 'ashtu@ua.fm'
                 ELSE tmpContactPerson.ContactPersonMail
            END :: TVarChar AS AddressTo

          , gpGet_Host.Value     :: TVarChar AS Host
          , gpGet_Port.Value     :: TVarChar AS Port
          , gpGet_User.Value     :: TVarChar AS UserName
          , gpGet_Password.Value :: TVarChar AS Password

     FROM tmpMovement
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
 19.01.26         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance_Email_sendBody ( inMovementId := 33230482, inParam:= 1, inSession:= '9457':: TVarChar) --  zfCalc_UserAdmin()  --zc_Enum_ExportKind_Mida35273055()
