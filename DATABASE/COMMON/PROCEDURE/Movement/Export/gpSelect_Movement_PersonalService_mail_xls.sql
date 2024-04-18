-- Function: gpSelect_Movement_PersonalService_mail_xls

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail_xls (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_mail_xls(
    IN inMovementId           Integer,
    IN inParam                Integer,    --XLS  = 3 ДЛЯ CardBankSecond, SummCardSecondRecalc
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (CardBankSecond          TVarChar
             , SummCardSecondRecalc    TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Mail() AND MB.ValueData = TRUE)
        AND vbUserId <> 5
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
        AND vbUserId <>  5 
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


     --EXL  CardBankSecond, SummCardSecondRecalc
     IF inParam = 3
     THEN
         IF vbUserId = 5 AND 1=0
         THEN
             RAISE EXCEPTION 'Ошибка. <%>'
                           , (WITH tmp_all AS (SELECT gpSelect.CardBankSecond
                                                      -- ПЕРЕВОДИМ
                                                    , SUM (COALESCE (gpSelect.SummCardSecondRecalc, 0) + COALESCE (gpSelect.SummAvCardSecondRecalc, 0))  AS SummCardSecondRecalc
                                               FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                               WHERE (gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0)
                                                 AND COALESCE (gpSelect.CardBankSecond,'') <> ''
                                               GROUP BY gpSelect.CardBankSecond
                                               )
                                , tmp AS (SELECT tmp_all.CardBankSecond
                                                 -- % и округлили
                                               , CAST (CASE WHEN tmp_all.SummCardSecondRecalc  <= 29999
                                                            THEN tmp_all.SummCardSecondRecalc 
                                                            ELSE tmp_all.SummCardSecondRecalc  + (tmp_all.SummCardSecondRecalc - 29999) * 0.005
                                                       END AS NUMERIC (16, 0)) AS SummCardSecondRecalc
                                          FROM tmp_all
                                          WHERE 4000 <= tmp_all.SummCardSecondRecalc
                                         )
                        
                             SELECT tmp.SummCardSecondRecalc ::TFloat
                             FROM tmp
                             WHERE tmp.CardBankSecond = '4218550008680591'
                             )
                            ;
    
         END IF;

      -- результат
      RETURN QUERY
      WITH
       tmp_all AS (SELECT gpSelect.CardBankSecond
                          -- ПЕРЕВОДИМ
                        , SUM (COALESCE (gpSelect.SummCardSecondRecalc, 0) + COALESCE (gpSelect.SummAvCardSecondRecalc, 0))  AS SummCardSecondRecalc

                   FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                   WHERE (gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0)
                     AND COALESCE (gpSelect.CardBankSecond,'') <> ''
                   GROUP BY gpSelect.CardBankSecond
                   )
    , tmp AS (SELECT tmp_all.CardBankSecond
                     -- % и округлили
                   , CAST (CASE WHEN tmp_all.SummCardSecondRecalc  <= 29999
                                THEN tmp_all.SummCardSecondRecalc 
                                ELSE tmp_all.SummCardSecondRecalc  + (tmp_all.SummCardSecondRecalc - 29999) * 0.005
                           END AS NUMERIC (16, 0)) AS SummCardSecondRecalc
              FROM tmp_all
              WHERE 4000 <= tmp_all.SummCardSecondRecalc
             )

              SELECT tmp.CardBankSecond   ::TVarChar
               , tmp.SummCardSecondRecalc ::TFloat
              FROM tmp
             UNION ALL
              --пустая строка
              SELECT ''   ::TVarChar
                   , NULL ::TFloat
             UNION ALL
              --итого
              SELECT ''  ::TVarChar
                  , (SUM (tmp.SummCardSecondRecalc)) :: TFloat
              FROM tmp
             ;

     END IF;

     -- !!!нельзя здесь!!! - сохранили свойство <Сформирована Выгрузка (да/нет)>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

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
-- SELECT * FROM gpSelect_Movement_PersonalService_mail_xls (27194351, 3, zfCalc_UserAdmin());
