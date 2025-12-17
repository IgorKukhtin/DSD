-- Function: gpUpdateMovement_OrderFinance_PlanDate()
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_PlanDate (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_PlanDate(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId          Integer   , -- Ключ строки
    IN inDateDay                 TDateTime , --
    IN ioDateDay_old             TDateTime , --
    IN inAmount                  TFloat    ,
 INOUT ioAmountPlan_day          TFloat    ,
   OUT outWeekDay                TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId     Integer;
            vbNumDay     Integer;
            vbNumDay_old Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inDateDay, zc_DateStart()) = COALESCE (ioDateDay_old, zc_DateStart())
     THEN
         RETURN;
     END IF;
     
     --определяем день недели для предыдущей и текущей даты
     vbNumDay     := zfCalc_DayOfWeekNumber (inDateDay);
     vbNumDay_old := zfCalc_DayOfWeekNumber (ioDateDay_old);
     ioAmountPlan_day := (CASE WHEN COALESCE (ioAmountPlan_day,0) = 0 THEN inAmount ELSE ioAmountPlan_day END);

     IF COALESCE (ioDateDay_old, zc_DateStart()) <> zc_DateStart()
     THEN
         --обнуляем данные прошлой даты
         PERFORM lpInsertUpdate_MovementItemFloat (CASE vbNumDay_old 
                                                        WHEN 1 THEN zc_MIFloat_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIFloat_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIFloat_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIFloat_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIFloat_AmountPlan_5()
                                                   END                                                  
                                                 , inMovementItemId, 0);
     END IF;

     IF COALESCE (inDateDay, zc_DateStart()) <> zc_DateStart()
     THEN
         --обновляем новые данные
         PERFORM lpInsertUpdate_MovementItemFloat (CASE vbNumDay 
                                                        WHEN 1 THEN zc_MIFloat_AmountPlan_1()
                                                        WHEN 2 THEN zc_MIFloat_AmountPlan_2()
                                                        WHEN 3 THEN zc_MIFloat_AmountPlan_3()
                                                        WHEN 4 THEN zc_MIFloat_AmountPlan_4()
                                                        WHEN 5 THEN zc_MIFloat_AmountPlan_5()
                                                   END                                                  
                                                 , inMovementItemId, ioAmountPlan_day);
     END IF; 

     ioDateDay_old := COALESCE (inDateDay, NULL) ::TDateTime;
     outWeekDay := (CASE EXTRACT (DOW FROM inDateDay)
                         WHEN 1 THEN '1.Пн.'
                         WHEN 2 THEN '2.Вт.'
                         WHEN 3 THEN '3.Ср.'
                         WHEN 4 THEN '4.Чт.'
                         WHEN 5 THEN '5.Пт.'
                         ELSE ''
                    END :: TVarChar);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


     if vbUserId = 9457 then RAISE EXCEPTION 'Админ.Test Ok. <%>  <%>', outWeekDay, ioAmountPlan_day; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.25         *
*/


-- тест