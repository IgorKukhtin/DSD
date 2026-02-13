-- Function: gpGet_Movement_OrderFinance_Email_sendSB() - Отправка по почте только Сообщение

-- DROP FUNCTION IF EXISTS gpGet_Movement_OrderFinance_Email_send_msg (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderFinance_Email_send_msg(
    IN inMovementId           Integer,
    IN inParam                Integer,    -- 1 - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port TVarChar, UserName TVarChar, Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbOrderFinanceId    Integer;
   DECLARE vbIsOrderFinance_SB Boolean;
   DECLARE vbMemberId          Integer;
   DECLARE vbMemberId_1        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     if vbUserId <> 5 AND 1=0
     THEN
        -- RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;

     -- нашли
     vbOrderFinanceId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_OrderFinance());
     --
     vbIsOrderFinance_SB := COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_SB()), FALSE);

     -- нашли
     vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                   FROm ObjectLink AS ObjectLink_User_Member
                   WHERE ObjectLink_User_Member.ObjectId = vbUserId
                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  );
     -- нашли
     vbMemberId_1 := (SELECT MovementLinkObject_Member_1.ObjectId AS MemberId
                      FROM MovementLinkObject AS MovementLinkObject_Member_1
                      WHERE MovementLinkObject_Member_1.MovementId = inMovementId
                        AND MovementLinkObject_Member_1.DescId     = zc_MovementLinkObject_Member_1()
                     );

     --
     IF COALESCE (vbMemberId,0) <> COALESCE (vbMemberId_1,0)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав устанавливать <Согласован Руководителем>.', lfGet_Object_ValueData_sh (vbMemberId);
     END IF;


     -- Результат
     RETURN QUERY
     WITH
          -- кому отправка Сообщения
          tmpList_Member AS (-- ФИО - Автор заявки
                             SELECT OL.ChildObjectId AS MemberId
                             FROM ObjectLink AS OL
                             WHERE OL.ObjectId = vbOrderFinanceId
                               AND OL.DescId   IN (zc_ObjectLink_OrderFinance_Member_insert()
                                                 , zc_ObjectLink_OrderFinance_Member_insert_2()
                                                 , zc_ObjectLink_OrderFinance_Member_insert_3()
                                                 , zc_ObjectLink_OrderFinance_Member_insert_4()
                                                 , zc_ObjectLink_OrderFinance_Member_insert_5()
                                                  )
                               AND OL.ChildObjectId > 0
                               -- 1 - руководитель - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
                               AND ((inParam = 1
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = FALSE
                                    )

                                 OR (inParam = 2
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = TRUE
                                    )
                                   )

                            UNION ALL
                             -- ФИО - на контроле-1, Руководитель
                             SELECT OL.ChildObjectId AS MemberId
                             FROM ObjectLink AS OL
                             WHERE OL.ObjectId = vbOrderFinanceId
                               AND OL.DescId   = zc_ObjectLink_OrderFinance_Member_1()
                               -- 1 - руководитель - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
                               AND (inParam = 2
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = TRUE
                                   )

                            UNION ALL
                             -- ФИО - на контроле-2, СБ
                             SELECT OL.ChildObjectId AS MemberId
                             FROM ObjectLink AS OL
                             WHERE OL.ObjectId = vbOrderFinanceId
                               AND OL.DescId   = zc_ObjectLink_OrderFinance_Member_2()
                               -- 1 - руководитель - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
                               AND (inParam = 1
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = TRUE
                                   )

                            UNION ALL
                             -- ФИО - ФИН
                             SELECT Object.Id AS MemberId
                             FROM Object
                             WHERE Object.Id IN (11935982  -- Тіхаєва Ю.В.
                                               , 10352028  -- Павлова О.О.
                                                )
                               AND Object.DescId   = zc_Object_Member()
                               -- 1 - руководитель - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
                               AND ((inParam = 1
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = FALSE
                                    )

                                 OR (inParam = 2
                                 -- если НЕ СБ
                                 AND vbIsOrderFinance_SB = TRUE
                                    )
                                   )

                            UNION ALL
                             -- ФИО - БУХ
                             SELECT Object.Id AS MemberId_buh
                             FROM Object
                             WHERE Object.Id IN (12590   -- Рудик Н.В.
                                               , 12504   -- Гриндак И.А.
                                                )
                               AND Object.DescId   = zc_Object_Member()
                               -- 1 - руководитель - для только СБ или менеджерам + Фин. служба, 2 - после СБ - Фин. служба + руководитель + менеджерам, 3 - после проведения - Бухгалтерия
                               AND inParam = 3
                            )

     , tmpImportSettings AS (SELECT ObjectLink_ImportSettings_ContactPerson.ChildObjectId AS ContactPersonId
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
                       SELECT CASE WHEN inParam = 1 THEN 'Согласовано Начальником отдела снабжения.За '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   WHEN inParam = 2 THEN 'Уведомление от СБ за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   WHEN inParam = 3 THEN 'Уведомление для Бухгалтерии за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                   ELSE ''
                              END ::TVarChar AS Subject

                            , CASE WHEN inParam = 1 AND vbIsOrderFinance_SB = TRUE
                                                    THEN 'От СБ требуется проверка заявок в системе «Project» за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' от отдела снабжения для "'||tmp.OrderFinanceName::TVarChar
                                                       ||'"'

                                   WHEN inParam = 1 THEN 'Заявка "' || tmp.OrderFinanceName || '" за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' успешно согласована руководителем подразделения'

                                   WHEN inParam = 2 THEN 'Завершена проверка заявок департаментом безопасности за '|| zfConvert_FloatToString (tmp.WeekNumber)
                                                       ||' неделю c '|| zfConvert_DateShortToString (tmp.StartDate_WeekNumber)
                                                       ||' по '|| zfConvert_DateShortToString (tmp.EndDate_WeekNumber)
                                                       ||' от отдела снабжения для "'||tmp.OrderFinanceName::TVarChar
                                                       ||'"'

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
          , CASE WHEN vbUserId = 5 AND 1=1
                      THEN tmpMovement.Body || CHR (13) || COALESCE ('ashtu@ua.fm;' || tmpList_Email.Email_to, 'ashtu@ua.fm')
                 ELSE tmpMovement.Body
            END :: TBlob    AS Body

          , gpGet_Mail.Value    :: TVarChar AS AddressFrom

          , CASE WHEN vbUserId = 5    AND 1=1 THEN 'ashtu@ua.fm'
                 WHEN vbUserId = 9457 AND 1=1 THEN 'innafelon@gmail.com'

                 ELSE COALESCE ('ashtu@ua.fm;' || tmpList_Email.Email_to, 'ashtu@ua.fm')

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
 19.01.26         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderFinance_Email_send_msg ( inMovementId := 33230482, inParam:= 1, inSession:= zfCalc_UserAdmin():: TVarChar)
