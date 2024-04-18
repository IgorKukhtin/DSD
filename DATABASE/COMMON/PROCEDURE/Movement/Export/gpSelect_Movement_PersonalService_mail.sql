 -- Function: gpSelect_Movement_PersonalService_mail

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, TVarChar, TFloat, TDateTime, TVarChar);
---DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_mail (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_mail(
    IN inMovementId           Integer,
    IN inParam                Integer,    -- = 1  CardSecond, INN, SummCardSecondRecalc, PersonalName
                                          --CSV  = 2 ДЛЯ CardBankSecond, SummCardSecondRecalc

    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbKoeffSummCardSecond NUMERIC (16,10);
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
        AND vbUserId <> 5
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


     -- определили данные из ведомости начисления
     SELECT --ObjectFloat_KoeffSummCardSecond.ValueData AS KoeffSummCardSecond  --Коэфф для выгрузки ведомости Банк 2ф.
            CAST (ObjectFloat_KoeffSummCardSecond.ValueData/ 1000 AS NUMERIC (16,10)) AS KoeffSummCardSecond  --Коэфф для выгрузки ведомости Банк 2ф.
            INTO vbKoeffSummCardSecond
     FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
          LEFT JOIN ObjectFloat AS ObjectFloat_KoeffSummCardSecond
                                ON ObjectFloat_KoeffSummCardSecond.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectFloat_KoeffSummCardSecond.DescId = zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond()
     WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList();

     -- если не внесен коєф. берем по умолчанию = 1.00807
     IF COALESCE (vbKoeffSummCardSecond,0) = 0
     THEN
         vbKoeffSummCardSecond := 1.00807;
     END IF;

     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;
     -- !!!Формат CSV - zc_Enum_ExportKind_PersonalService!!!

     -- CardSecond, INN, SummCardSecondRecalc, PersonalName
     IF inParam = 1
     THEN
         INSERT INTO _Result(RowData)
         WITH
         tmp AS (SELECT COALESCE (gpSelect.CardSecond, '') AS CardSecond
                      , COALESCE (gpSelect.INN, '')  AS INN
                      , SUM (FLOOR (100 * CAST ( ((COALESCE (gpSelect.SummCardSecondRecalc, 0) + COALESCE (gpSelect.SummAvCardSecondRecalc, 0)) * vbKoeffSummCardSecond) AS NUMERIC (16, 0)) ))  AS SummCardSecondRecalc -- добавили % и округлили до 2-х знаков + ПЕРЕВОДИМ в копейки
                      , UPPER (COALESCE (gpSelect.PersonalName, '') )  AS PersonalName
                 FROM gpSelect_MovementItem_PersonalService (inMovementId:= inMovementId  , inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                 WHERE gpSelect.SummCardSecondRecalc <> 0 OR gpSelect.SummAvCardSecondRecalc <> 0
   	      GROUP BY COALESCE (gpSelect.CardSecond, ''), UPPER (COALESCE (gpSelect.PersonalName, '')), COALESCE (gpSelect.INN, '')
   	      )

   	      SELECT tmp.CardSecond
              || ';' || tmp.INN
              || ';' || tmp.SummCardSecondRecalc
              || ';' || REPLACE (tmp.PersonalName, ' ', ';' )
                 FROM tmp
                UNION ALL
                 --пустая строка
                 SELECT ''
                UNION ALL
                 --итого
                 SELECT ''
              || ';' || ''
              || ';' || (SUM (tmp.SummCardSecondRecalc)) :: Integer
                 FROM tmp
                ;
     END IF;


     -- CardBankSecond, SummCardSecondRecalc
     IF inParam = 2
     THEN
      INSERT INTO _Result(RowData)
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
                   , CAST (CASE WHEN tmp_all.SummCardSecondRecalc <= 29999
                                THEN tmp_all.SummCardSecondRecalc
                                ELSE tmp_all.SummCardSecondRecalc + (tmp_all.SummCardSecondRecalc - 29999) * 0.005
                           END AS NUMERIC (16, 0)) AS SummCardSecondRecalc
              FROM tmp_all
              WHERE 4000 <= tmp_all.SummCardSecondRecalc
	     )

	      SELECT tmp.CardBankSecond
           || ';' || tmp.SummCardSecondRecalc
              FROM tmp
             UNION ALL
              --пустая строка
              SELECT ''
             UNION ALL
              --итого
              SELECT ''
           || ';' || (SUM (tmp.SummCardSecondRecalc)) :: TFloat
              FROM tmp
             ;
     END IF;


     -- !!!нельзя здесь!!! - сохранили свойство <Сформирована Выгрузка (да/нет)>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, TRUE);
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- Результат
     RETURN QUERY
        SELECT _Result.RowData FROM _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.24         *
 31.01.24         *
 17.11.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService_mail (27194351, 2, zfCalc_UserAdmin());
