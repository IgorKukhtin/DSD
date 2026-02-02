-- Function: gpUpdateMovement_OrderFinance_PlanDate()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_PlanDate(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inDateDay                 TDateTime , -- Дата оплаты
 INOUT ioDateDay_old             TDateTime , --
    IN inAmount                  TFloat    , -- Предварительный План на неделю
 INOUT ioAmountPlan_day          TFloat    , -- Сумма План оплат на дату
   OUT outWeekDay                TVarChar  , -- День недели для <Дата оплаты>
   OUT outAmountPlan_1           TFloat    , --
   OUT outAmountPlan_2           TFloat    , --
   OUT outAmountPlan_3           TFloat    , --
   OUT outAmountPlan_4           TFloat    , --
   OUT outAmountPlan_5           TFloat    , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId          Integer;
    DECLARE vbNumDay          Integer;
    DECLARE vbNumDay_old      Integer;
    DECLARE vbOperDate_start  TDateTime;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     /*IF COALESCE (inDateDay, zc_DateStart()) = COALESCE (ioDateDay_old, zc_DateStart())
     THEN
         RETURN;
     END IF;
     */

     -- определяем день недели для предыдущей и текущей даты
     vbNumDay     := zfCalc_DayOfWeekNumber (inDateDay);
     vbNumDay_old := zfCalc_DayOfWeekNumber (ioDateDay_old);

     -- IF COALESCE (inIsAmountPlan_day,TRUE) = TRUE
     -- THEN

     -- Всегда
     ioAmountPlan_day:= (CASE WHEN inDateDay IS NULL THEN 0 WHEN COALESCE (ioAmountPlan_day,0) = 0 THEN inAmount ELSE ioAmountPlan_day END);

     -- Вернули
     outAmountPlan_1:= CASE WHEN vbNumDay = 1 THEN ioAmountPlan_day ELSE 0 END;
     outAmountPlan_2:= CASE WHEN vbNumDay = 2 THEN ioAmountPlan_day ELSE 0 END;
     outAmountPlan_3:= CASE WHEN vbNumDay = 3 THEN ioAmountPlan_day ELSE 0 END;
     outAmountPlan_4:= CASE WHEN vbNumDay = 4 THEN ioAmountPlan_day ELSE 0 END;
     outAmountPlan_5:= CASE WHEN vbNumDay = 5 THEN ioAmountPlan_day ELSE 0 END;


     -- ELSE
     --     ioAmountPlan_day := 0;
     -- END IF;


     IF COALESCE (ioDateDay_old, zc_DateStart()) <> zc_DateStart()
    -- если заменили дату
    AND COALESCE (ioDateDay_old, zc_DateStart()) <> COALESCE (inDateDay, zc_DateStart())
     THEN
         -- обнуляем данные прошлой даты
         PERFORM lpInsertUpdate_MovementItemFloat (CASE vbNumDay_old
                                                        WHEN 1 THEN zc_MIFloat_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIFloat_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIFloat_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIFloat_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIFloat_AmountPlan_5()
                                                   END
                                                 , inMovementItemId, 0);

         -- обнуляем свойство <Дата предварительный план>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount(), inMovementItemId, NULL);

         -- сохранили свойство <Платим (да/нет)>
         /*PERFORM lpInsertUpdate_MovementItemBoolean (CASE vbNumDay_old
                                                        WHEN 1 THEN zc_MIBoolean_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIBoolean_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIBoolean_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIBoolean_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIBoolean_AmountPlan_5()
                                                     END
                                                   , inMovementItemId, FALSE);*/
     END IF;


     IF COALESCE (inDateDay, zc_DateStart()) <> zc_DateStart() -- AND COALESCE (ioDateDay_old, zc_DateStart()) <> COALESCE (inDateDay, zc_DateStart())
     THEN
         -- нашли дату начала недели
         vbOperDate_start:= (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
                             FROM Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                          ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                         AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                             WHERE Movement.Id = inMovementId
                            );
         -- проверка
         IF inDateDay NOT BETWEEN vbOperDate_start AND vbOperDate_start + INTERVAL '4 DAY'
         THEN
             RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                            , zfConvert_DateToString (inDateDay)
                            , CHR (13)
                            , zfConvert_DateToString (vbOperDate_start)
                            , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                             ;
         END IF;

         -- обновляем новые данные
         PERFORM lpInsertUpdate_MovementItemFloat (CASE vbNumDay
                                                        WHEN 1 THEN zc_MIFloat_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIFloat_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIFloat_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIFloat_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIFloat_AmountPlan_5()
                                                   END
                                                 , inMovementItemId, ioAmountPlan_day);

         -- сохранили свойство <Дата предварительный план>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Amount(), inMovementItemId, inDateDay);

         -- сохранили свойство <Платим (да/нет)>
         /*PERFORM lpInsertUpdate_MovementItemBoolean (CASE vbNumDay_old
                                                        WHEN 1 THEN zc_MIBoolean_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIBoolean_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIBoolean_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIBoolean_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIBoolean_AmountPlan_5()
                                                     END
                                                   , inMovementItemId, COALESCE (inIsAmountPlan_day,TRUE));*/
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


     -- вернули
     outWeekDay := (CASE EXTRACT (DOW FROM inDateDay)
                         WHEN 1 THEN '1.Пн.'
                         WHEN 2 THEN '2.Вт.'
                         WHEN 3 THEN '3.Ср.'
                         WHEN 4 THEN '4.Чт.'
                         WHEN 5 THEN '5.Пт.'
                         ELSE ''
                    END :: TVarChar);
     -- вернули
     ioDateDay_old:= inDateDay;

     --
     if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>', outWeekDay, ioAmountPlan_day; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.25         *
*/


-- тест
-- select * from gpUpdateMovement_OrderFinance_PlanDate(inMovementId := 32907603 , inMovementItemId := 341774314 , inDateDay := ('27.10.2025')::TDateTime , ioDateDay_old := ('27.10.2025')::TDateTime , inAmount := 15000 , ioAmountPlan_day := 23 , inIsAmountPlan_day := 'True' ,  inSession := '9457');
