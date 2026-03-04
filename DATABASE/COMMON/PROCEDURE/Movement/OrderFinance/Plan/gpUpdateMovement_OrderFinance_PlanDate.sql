-- Function: gpUpdateMovement_OrderFinance_PlanDate()

-- DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_PlanDate(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inMovementItemId_child    Integer   , -- Ключ строки
 INOUT ioMovementItemId_detail   Integer   , -- Ключ строки

 INOUT ioDateDay                 TDateTime , -- Дата Согласовано к оплате
 INOUT ioDateDay_old             TDateTime , -- ***Дата Согласовано к оплате
 INOUT ioAmountPlan_day          TFloat    , -- Согласовано к оплате
 INOUT ioAmountPlan_day_old      TFloat    , -- Согласовано к оплате
   OUT outWeekDay                TVarChar  , -- День недели для <Дата оплаты>
 INOUT ioAmountPlan_1            TFloat    , --
 INOUT ioAmountPlan_2            TFloat    , --
 INOUT ioAmountPlan_3            TFloat    , --
 INOUT ioAmountPlan_4            TFloat    , --
 INOUT ioAmountPlan_5            TFloat    , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId          Integer;
    DECLARE vbNumDay          Integer;
    DECLARE vbDay_count       Integer;
    DECLARE vbOperDate_start  TDateTime;
    DECLARE vbIsChild         Boolean;

    DECLARE vbMovementItemId_Detail_1 Integer;
    DECLARE vbMovementItemId_Detail_2 Integer;
    DECLARE vbMovementItemId_Detail_3 Integer;
    DECLARE vbMovementItemId_Detail_4 Integer;
    DECLARE vbMovementItemId_Detail_5 Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     /*IF COALESCE (ioDateDay, zc_DateStart()) = COALESCE (ioDateDay_old, zc_DateStart())
     THEN
         RETURN;
     END IF;
     */


     -- if vbUserId = 5 then update Movement set StatusId = zc_Enum_Status_UnComplete() where Id = inMovementId; end if;


     -- нашли дату начала недели
     vbOperDate_start:= (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
                         FROM Movement
                              LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                      ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                     AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                         WHERE Movement.Id = inMovementId
                        );

     -- Если заменили сумму или дату - Режим 1 день + 1 сумма
     IF COALESCE (ioAmountPlan_day, 0) <> COALESCE (ioAmountPlan_day_old, 0)
     OR COALESCE (ioDateDay, zc_DateStart()) <> COALESCE (ioDateDay_old, zc_DateStart())
     THEN
         -- Всегда
         ioAmountPlan_day:= CASE WHEN ioDateDay IS NULL THEN 0 ELSE ioAmountPlan_day END;
         -- Всегда
         ioDateDay       := CASE WHEN ioAmountPlan_day > 0 THEN ioDateDay ELSE NULL  END;

         -- определяем день недели для предыдущей и текущей даты
         vbNumDay     := zfCalc_DayOfWeekNumber (ioDateDay);

         -- Вернули
         ioAmountPlan_1:= CASE WHEN vbNumDay = 1 THEN ioAmountPlan_day ELSE 0 END;
         ioAmountPlan_2:= CASE WHEN vbNumDay = 2 THEN ioAmountPlan_day ELSE 0 END;
         ioAmountPlan_3:= CASE WHEN vbNumDay = 3 THEN ioAmountPlan_day ELSE 0 END;
         ioAmountPlan_4:= CASE WHEN vbNumDay = 4 THEN ioAmountPlan_day ELSE 0 END;
         ioAmountPlan_5:= CASE WHEN vbNumDay = 5 THEN ioAmountPlan_day ELSE 0 END;

         -- проверка
         IF COALESCE (ioDateDay, zc_DateStart()) NOT BETWEEN vbOperDate_start + INTERVAL '0 DAY' AND vbOperDate_start + INTERVAL '4 DAY'
            AND ioAmountPlan_day <> 0
         THEN
     	   RAISE EXCEPTION 'Ошибка.Дата Согласовано к оплате = <%>%.Должна быть в периоде с <%> по <%>.'
                            , zfConvert_DateToString (ioDateDay)
                            , CHR (13)
                            , zfConvert_DateToString (vbOperDate_start)
                            , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                             ;
         END IF;

     ELSE
         -- сколько заполненных дней
         vbDay_count:= 0;

         --
         IF ioAmountPlan_1 > 0 THEN ioDateDay:= vbOperDate_start + INTERVAL '0 DAY'; vbDay_count:= vbDay_count + 1; END IF;
         IF ioAmountPlan_2 > 0 THEN ioDateDay:= vbOperDate_start + INTERVAL '1 DAY'; vbDay_count:= vbDay_count + 1; END IF;
         IF ioAmountPlan_3 > 0 THEN ioDateDay:= vbOperDate_start + INTERVAL '2 DAY'; vbDay_count:= vbDay_count + 1; END IF;
         IF ioAmountPlan_4 > 0 THEN ioDateDay:= vbOperDate_start + INTERVAL '3 DAY'; vbDay_count:= vbDay_count + 1; END IF;
         IF ioAmountPlan_5 > 0 THEN ioDateDay:= vbOperDate_start + INTERVAL '4 DAY'; vbDay_count:= vbDay_count + 1; END IF;

         -- меняется в гриде на пусто
         IF vbDay_count > 1 THEN ioDateDay:= NULL; END IF;
         -- меняется в гриде на пусто
         IF vbDay_count > 1 THEN ioMovementItemId_detail:= 0; END IF;

     END IF;





     -- !!!ВАЖНО!!!
     vbIsChild:= EXISTS (SELECT 1
                         FROM MovementLinkObject AS MovementLinkObject_OrderFinance
                              INNER JOIN ObjectBoolean AS ObjectBoolean_SB
                                                       ON ObjectBoolean_SB.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                      AND ObjectBoolean_SB.DescId   IN (zc_ObjectBoolean_OrderFinance_InvNumber()
                                                                                      , zc_ObjectBoolean_OrderFinance_InvNumber_Invoice()
                                                                                       )
                                                      AND ObjectBoolean_SB.ValueData = TRUE
                         WHERE MovementLinkObject_OrderFinance.MovementId = inMovementId
                           AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
                        );


     -- проверка
     IF vbIsChild = TRUE AND COALESCE (inMovementItemId_child, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение данных возможно только с учетом № счета.';
     END IF;


     -- RAISE EXCEPTION 'Ошибка.Режим отладки.';


     -- нашли
     vbMovementItemId_Detail_1:= (SELECT MovementItem.Id
                                  FROM MovementItem
                                       INNER JOIN MovementItemDate AS MIDate_Amount
                                                                   ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                                  AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                                                                  AND MIDate_Amount.ValueData      = vbOperDate_start + INTERVAL '0 DAY'

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                    AND MovementItem.isErased   = FALSE
                                 );
     -- нашли
     vbMovementItemId_Detail_2:= (SELECT MovementItem.Id
                                  FROM MovementItem
                                       INNER JOIN MovementItemDate AS MIDate_Amount
                                                                   ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                                  AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                                                                  AND MIDate_Amount.ValueData      = vbOperDate_start + INTERVAL '1 DAY'

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                    AND MovementItem.isErased   = FALSE
                                 );

     -- нашли
     vbMovementItemId_Detail_3:= (SELECT MovementItem.Id
                                  FROM MovementItem
                                       INNER JOIN MovementItemDate AS MIDate_Amount
                                                                   ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                                  AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                                                                  AND MIDate_Amount.ValueData      = vbOperDate_start + INTERVAL '2 DAY'

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                    AND MovementItem.isErased   = FALSE
                                 );
     -- нашли
     vbMovementItemId_Detail_4:= (SELECT MovementItem.Id
                                  FROM MovementItem
                                       INNER JOIN MovementItemDate AS MIDate_Amount
                                                                   ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                                  AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                                                                  AND MIDate_Amount.ValueData      = vbOperDate_start + INTERVAL '3 DAY'

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                    AND MovementItem.isErased   = FALSE
                                 );

     -- нашли
     vbMovementItemId_Detail_5:= (SELECT MovementItem.Id
                                  FROM MovementItem
                                       INNER JOIN MovementItemDate AS MIDate_Amount
                                                                   ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                                  AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                                                                  AND MIDate_Amount.ValueData      = vbOperDate_start + INTERVAL '4 DAY'

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                    AND MovementItem.isErased   = FALSE
                                 );


     -- обновляем данные - Detail - 1
     IF ioAmountPlan_1 > 0 OR (vbMovementItemId_Detail_1 > 0 AND vbMovementItemId_Detail_1 = ioMovementItemId_detail) OR vbDay_count > 1
     THEN
         -- 
         IF vbMovementItemId_Detail_1 <> ioMovementItemId_detail AND ioMovementItemId_detail > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.', zfConvert_DateToString (vbOperDate_start + INTERVAL '0 DAY');
         END IF;
         -- Согласовано к оплате
         vbMovementItemId_Detail_1:= lpInsertUpdate_MovementItem_OrderFinance_detail (ioId             := vbMovementItemId_Detail_1
                                                                , inMovementId     := inMovementId
                                                                , inParentId       := CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                                                , inAmount         := ioAmountPlan_1
                                                                , inOperDate_Amount:= vbOperDate_start + INTERVAL '0 DAY'
                                                                , inUserId         := vbUserId
                                                                 );
     END IF;


     -- обновляем данные - Detail - 2
     IF ioAmountPlan_2 > 0 OR (vbMovementItemId_Detail_2 > 0 AND vbMovementItemId_Detail_2 = ioMovementItemId_detail) OR vbDay_count > 1
     THEN
         -- 
         IF vbMovementItemId_Detail_2 <> ioMovementItemId_detail AND ioMovementItemId_detail > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.', zfConvert_DateToString (vbOperDate_start + INTERVAL '1 DAY');
         END IF;
         -- Согласовано к оплате
         vbMovementItemId_Detail_2:= lpInsertUpdate_MovementItem_OrderFinance_detail (ioId             := vbMovementItemId_Detail_2
                                                                , inMovementId     := inMovementId
                                                                , inParentId       := CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                                                , inAmount         := ioAmountPlan_2
                                                                , inOperDate_Amount:= vbOperDate_start + INTERVAL '1 DAY'
                                                                , inUserId         := vbUserId
                                                                 );
     END IF;

     -- обновляем данные - Detail - 3
     IF ioAmountPlan_3 > 0 OR (vbMovementItemId_Detail_3 > 0 AND vbMovementItemId_Detail_3 = ioMovementItemId_detail) OR vbDay_count > 1
     THEN
         -- 
         IF vbMovementItemId_Detail_3 <> ioMovementItemId_detail AND ioMovementItemId_detail > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.', zfConvert_DateToString (vbOperDate_start + INTERVAL '2 DAY');
         END IF;
         -- Согласовано к оплате
         vbMovementItemId_Detail_3:= lpInsertUpdate_MovementItem_OrderFinance_detail (ioId             := vbMovementItemId_Detail_3
                                                                , inMovementId     := inMovementId
                                                                , inParentId       := CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                                                , inAmount         := ioAmountPlan_3
                                                                , inOperDate_Amount:= vbOperDate_start + INTERVAL '2 DAY'
                                                                , inUserId         := vbUserId
                                                                 );
     END IF;

     -- обновляем данные - Detail - 4
     IF ioAmountPlan_4 > 0 OR (vbMovementItemId_Detail_4 > 0 AND vbMovementItemId_Detail_4 = ioMovementItemId_detail) OR vbDay_count > 1
     THEN
         IF vbMovementItemId_Detail_4 <> ioMovementItemId_detail AND ioMovementItemId_detail > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.', zfConvert_DateToString (vbOperDate_start + INTERVAL '3 DAY');
         END IF;
         -- Согласовано к оплате
         vbMovementItemId_Detail_4:= lpInsertUpdate_MovementItem_OrderFinance_detail (ioId             := vbMovementItemId_Detail_4
                                                                , inMovementId     := inMovementId
                                                                , inParentId       := CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                                                , inAmount         := ioAmountPlan_4
                                                                , inOperDate_Amount:= vbOperDate_start + INTERVAL '3 DAY'
                                                                , inUserId         := vbUserId
                                                                 );
     END IF;

     -- обновляем данные - Detail - 5
     IF ioAmountPlan_5 > 0 OR (vbMovementItemId_Detail_5 > 0 AND vbMovementItemId_Detail_5 = ioMovementItemId_detail) OR vbDay_count > 1
     THEN
         IF vbMovementItemId_Detail_5 <> ioMovementItemId_detail AND ioMovementItemId_detail > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.', zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY');
         END IF;
         -- Согласовано к оплате
         vbMovementItemId_Detail_5:= lpInsertUpdate_MovementItem_OrderFinance_detail (ioId             := vbMovementItemId_Detail_5
                                                                , inMovementId     := inMovementId
                                                                , inParentId       := CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                                                                , inAmount         := ioAmountPlan_5
                                                                , inOperDate_Amount:= vbOperDate_start + INTERVAL '4 DAY'
                                                                , inUserId         := vbUserId
                                                                 );
     END IF;


     -- проверка дублируемости
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemDate AS MIDate_Amount
                                                 ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Detail()
                  AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                  AND MovementItem.isErased   = FALSE
                GROUP BY MIDate_Amount.ValueData
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Нельзя дублировать данные за <%>.'
                        , (SELECT zfConvert_DateToString (MIDate_Amount.ValueData)
                           FROM MovementItem
                                INNER JOIN MovementItemDate AS MIDate_Amount
                                                            ON MIDate_Amount.MovementItemId = MovementItem.Id
                                                           AND MIDate_Amount.DescId         = zc_MIDate_Amount()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Detail()
                             AND MovementItem.ParentId   = CASE WHEN inMovementItemId_child > 0 THEN inMovementItemId_child ELSE inMovementItemId END
                             AND MovementItem.isErased   = FALSE
                           GROUP BY MIDate_Amount.ValueData
                           HAVING COUNT(*) > 1
                           LIMIT 1
                          )
                         ;
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);


     -- вернули
     outWeekDay := (CASE zfCalc_DayOfWeekNumber (ioDateDay)
                         WHEN 1 THEN '1.Пн.'
                         WHEN 2 THEN '2.Вт.'
                         WHEN 3 THEN '3.Ср.'
                         WHEN 4 THEN '4.Чт.'
                         WHEN 5 THEN '5.Пт.'
                         ELSE ''
                    END :: TVarChar);

     -- вернули
     ioDateDay_old:= ioDateDay;
     -- вернули
     ioAmountPlan_day:= COALESCE (ioAmountPlan_1, 0) + COALESCE (ioAmountPlan_2, 0) + COALESCE (ioAmountPlan_3, 0) + COALESCE (ioAmountPlan_4, 0) + COALESCE (ioAmountPlan_5, 0);
     ioAmountPlan_day_old:= ioAmountPlan_day;
     -- вернули
     ioMovementItemId_detail:= CASE WHEN vbDay_count > 1
                                         THEN 0
                                    WHEN zfCalc_DayOfWeekNumber (ioDateDay) = 1
                                         THEN vbMovementItemId_Detail_1
                                    WHEN zfCalc_DayOfWeekNumber (ioDateDay) = 2
                                         THEN vbMovementItemId_Detail_2
                                    WHEN zfCalc_DayOfWeekNumber (ioDateDay) = 3
                                         THEN vbMovementItemId_Detail_3
                                    WHEN zfCalc_DayOfWeekNumber (ioDateDay) = 4
                                         THEN vbMovementItemId_Detail_4
                                    WHEN zfCalc_DayOfWeekNumber (ioDateDay) = 5
                                         THEN vbMovementItemId_Detail_5

                                    ELSE 0
                               END;

     --
     if vbUserId IN (9457, 5) AND 1=0
     then
         RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>'
                        , outWeekDay
                        , COALESCE ((SELECT SUM (MovementItem.Amount) FROM MovementItem WHERE MovementItem.ParentId = inMovementItemId AND MovementItem.DescId = zc_MI_Detail() AND MovementItem.isErased = FALSE), 0)
                         ;
     end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.25         *
*/


-- тест
-- select * from gpUpdateMovement_OrderFinance_PlanDate(inMovementId := 32907603 , inMovementItemId := 341774314 , ioDateDay := ('27.10.2025')::TDateTime , ioDateDay_old := ('27.10.2025')::TDateTime , inAmount := 15000 , ioAmountPlan_day := 23 , inIsAmountPlan_day := 'True' ,  inSession := '9457');
