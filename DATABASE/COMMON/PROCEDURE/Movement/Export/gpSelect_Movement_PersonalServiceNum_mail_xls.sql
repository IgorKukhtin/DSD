-- Function: gpSelect_Movement_PersonalServiceNum_mail_xls

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalServiceNum_mail_xls (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalServiceNum_mail_xls(
    IN inMovementId           Integer,
    IN inParam                Integer,    --XLS  = 4 ДЛЯ распределение по приоритету
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (CardBankSecond    TVarChar
             , BankSecondName    TVarChar
             , INN               TVarChar
             , PersonalName      TVarChar
             , BankSecond_num    NUMERIC (16,2)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Mail() AND MB.ValueData = TRUE)
        AND vbUserId <> 9457
        AND inMovementId <> 27627805
     THEN
         RAISE EXCEPTION 'Ошибка.<%> № <%> от <%> уже была отправлена.%Для повторной отправки необходимо перепровести документ.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                        ;

     END IF;

     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
        AND vbUserId <>  9457
     THEN
         RAISE EXCEPTION 'Ошибка.<%> № <%> от <%> % в статусе <%>.%Для отправки необходимо установить статус документа в <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , CHR(13)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                       , CHR(13)
                       , (SELECT lfGet_Object_ValueData_sh (zc_Enum_Status_Complete()))
                        ;

     END IF;



     -- Приоритет
     IF inParam = 4
     THEN
      -- результат
      RETURN QUERY
      WITH
            tmpMI AS (SELECT *
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.isErased = FALSE
                        AND MovementItem.DescId = zc_MI_Master()
                      )

          , tmpMember AS (SELECT tmp.ObjectId                                 AS PersonalId
                                , Object_Personal.ValueData                   AS PersonalName
                                , ObjectString_Member_INN.ValueData           AS INN
                                , ObjectString_CardBankSecond.ValueData       AS CardBankSecond
                                , ObjectString_CardBankSecondTwo.ValueData    AS CardBankSecondTwo
                                , ObjectString_CardBankSecondDiff.ValueData   AS CardBankSecondDiff
                          FROM (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI) AS tmp
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmp.ObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                    ON ObjectLink_Personal_Member.ObjectId = tmp.ObjectId
                                                   AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                               LEFT JOIN ObjectString AS ObjectString_Member_INN
                                                      ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_Member_INN.DescId = zc_ObjectString_member_INN()

                               LEFT JOIN ObjectString AS ObjectString_CardBankSecond
                                                      ON ObjectString_CardBankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecond.DescId = zc_ObjectString_Member_CardBankSecond()
                               LEFT JOIN ObjectString AS ObjectString_CardBankSecondTwo
                                                      ON ObjectString_CardBankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecondTwo.DescId = zc_ObjectString_Member_CardBankSecondTwo()
                               LEFT JOIN ObjectString AS ObjectString_CardBankSecondDiff
                                                      ON ObjectString_CardBankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                     AND ObjectString_CardBankSecondDiff.DescId = zc_ObjectString_Member_CardBankSecondDiff()
                          )
           --данные начисления по приоритету
          , tmpAll AS (SELECT tmpMember.PersonalName
                            , tmpMember.INN                    AS INN
                            , tmpMember.CardBankSecond         AS CardBankSecond
                            , Object_BankSecond_num.ValueData  AS BankSecondName
                            , SUM (COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0)) AS BankSecond_num
                       FROM tmpMI AS MovementItem
                            LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                            INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecond_num
                                                         ON MIFloat_Summ_BankSecond_num.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ_BankSecond_num.DescId = zc_MIFloat_Summ_BankSecond_num()
                                                        AND COALESCE (MIFloat_Summ_BankSecond_num.ValueData,0) <> 0

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecond_num
                                                             ON MILinkObject_BankSecond_num.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_BankSecond_num.DescId = zc_MILinkObject_BankSecond_num()
                            LEFT JOIN Object AS Object_BankSecond_num ON Object_BankSecond_num.Id = MILinkObject_BankSecond_num.ObjectId

                        GROUP BY tmpMember.PersonalName
                               , tmpMember.INN
                               , tmpMember.CardBankSecond
                               , Object_BankSecond_num.ValueData
                   UNION
                     SELECT tmpMember.PersonalName             AS PersonalName
                          , tmpMember.INN                      AS INN
                          , tmpMember.CardBankSecondTwo        AS CardBankSecond
                          , Object_BankSecondTwo_num.ValueData AS BankSecondName
                          , SUM (COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0)) AS BankSecond_num
                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                          INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecondTwo_num
                                                       ON MIFloat_Summ_BankSecondTwo_num.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ_BankSecondTwo_num.DescId = zc_MIFloat_Summ_BankSecondTwo_num()
                                                      AND COALESCE (MIFloat_Summ_BankSecondTwo_num.ValueData,0) <> 0

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecondTwo_num
                                             ON MILinkObject_BankSecondTwo_num.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankSecondTwo_num.DescId = zc_MILinkObject_BankSecondTwo_num()
                          LEFT JOIN Object AS Object_BankSecondTwo_num ON Object_BankSecondTwo_num.Id = MILinkObject_BankSecondTwo_num.ObjectId

                      GROUP BY tmpMember.PersonalName
                             , tmpMember.INN
                             , tmpMember.CardBankSecondTwo
                             , Object_BankSecondTwo_num.ValueData
                   UNION
                     SELECT tmpMember.PersonalName              AS PersonalName
                          , tmpMember.INN                       AS INN
                          , tmpMember.CardBankSecondDiff        AS CardBankSecond
                          , Object_BankSecondDiff_num.ValueData AS BankSecondName
                          , SUM (COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0)) AS BankSecond_num
                     FROM tmpMI AS MovementItem
                          LEFT JOIN tmpMember ON tmpMember.PersonalId = MovementItem.ObjectId

                          INNER JOIN MovementItemFloat AS MIFloat_Summ_BankSecondDiff_num
                                                       ON MIFloat_Summ_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Summ_BankSecondDiff_num.DescId = zc_MIFloat_Summ_BankSecondDiff_num()
                                                      AND COALESCE (MIFloat_Summ_BankSecondDiff_num.ValueData,0) <> 0

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_BankSecondDiff_num
                                             ON MILinkObject_BankSecondDiff_num.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BankSecondDiff_num.DescId = zc_MILinkObject_BankSecondDiff_num()
                          LEFT JOIN Object AS Object_BankSecondDiff_num ON Object_BankSecondDiff_num.Id = MILinkObject_BankSecondDiff_num.ObjectId

                      GROUP BY tmpMember.PersonalName
                             , tmpMember.INN
                             , tmpMember.CardBankSecondDiff
                             , Object_BankSecondDiff_num.ValueData
                   )


              SELECT tmpAll.CardBankSecond   ::TVarChar
                   , tmpAll.BankSecondName   ::TVarChar
                   , tmpAll.INN              ::TVarChar
                   , tmpAll.PersonalName     ::TVarChar
                   , CAST (tmpAll.BankSecond_num AS NUMERIC (16, 0))   ::NUMERIC (16,2)
              FROM tmpAll
             UNION ALL
              --итого
              SELECT ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , ''  ::TVarChar
                   , (SUM (CAST (tmpAll.BankSecond_num AS NUMERIC (16, 0)))) :: NUMERIC (16,2)
              FROM tmpAll
             ;

     END IF;


     -- сохранили свойство <Сформирована Выгрузка (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- Результат
    -- RETURN QUERY
     --   SELECT _Result.RowData FROM _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalServiceNum_mail_xls (27680979, 4, '9457');
