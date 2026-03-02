-- Function: gpInsertUpdate_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , --
    IN inContractId            Integer   , --
  --IN inBankAccountId         Integer   , --
    IN inAmount                TFloat    , -- Первичный план на неделю
 INOUT ioAmount_old            TFloat    , -- ***Первичный план на неделю
 INOUT ioAmountPlan_next       TFloat    , -- Платежный план на неделю
 INOUT ioAmountPlan_next_old   TFloat    , -- *** Платежный план на неделю
    IN inOperDate_Amount_top   TDateTime , -- *** Дата Платежный план на неделю
 INOUT ioOperDate_Amount       TDateTime , -- *** Дата Платежный план на неделю
 INOUT ioOperDate_Amount_old   TDateTime , -- *** Дата Платежный план на неделю
 ---IN inAmountStart           TFloat    , --
 INOUT ioAmountPlan_1          TFloat    , --
 INOUT ioAmountPlan_2          TFloat    , --
 INOUT ioAmountPlan_3          TFloat    , --
 INOUT ioAmountPlan_4          TFloat    , --
 INOUT ioAmountPlan_5          TFloat    , --
   OUT outAmountPlan_total     TFloat    , --
    IN inComment               TVarChar  , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbOperDate_start TDateTime;
   DECLARE vbOrderFinanceId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());


     IF vbUserId <> 5 AND 1=0 THEN RAISE EXCEPTION 'Ошибка.Режим отладки.'; END IF;


     -- нашли
     vbOrderFinanceId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_OrderFinance());

     -- Проверка - <Ожидание Согласования-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignWait_1() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Отправлено на Согласование Руководителю>.';
     END IF;
     -- Проверка - <Согласован-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign_1() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Согласовано Руководителем>.';
     END IF;
     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
        -- НЕ Разрешено изменение плана по дням - в проведенном док. (да/нет)
        AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceId AND OB.DescId = zc_ObjectBoolean_OrderFinance_Status_off() AND OB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
     END IF;

     -- проверка что строки child - нет
     IF (SELECT 1
         FROM MovementItem
         WHERE MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.MovementId = inMovementId
           AND MovementItem.isErased   = FALSE
        )
     THEN
         RAISE EXCEPTION 'Ошибка.Заполнение возможно только в документе <Планирование по Счетам>.';
     END IF;

     -- проверка update Юр.лицо
     IF ioId > 0
        AND NOT EXISTS (SELECT 1
                        FROM MovementItem
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.Id         = ioId
                          AND MovementItem.ObjectId   = inJuridicalId
                          AND MovementItem.isErased   = FALSE
                       )
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав изменять Юр.лицо.';
     END IF;

     -- проверка update Договор
     IF ioId > 0
        AND NOT EXISTS (SELECT 1
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                               ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Contract.DescId         = zc_MILinkObject_Contract()
                                                              AND MILinkObject_Contract.ObjectId       = inContractId               
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.Id         = ioId
                          AND MovementItem.ObjectId   = inJuridicalId
                          AND MovementItem.isErased   = FALSE
                       )
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав изменять Договор.';
     END IF;

     -- замена
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MovementLinkObject_OrderFinance
                     -- если Заполнение дата предварительный план = ДА
                     INNER JOIN ObjectBoolean AS ObjectBoolean_OperDate
                                              ON ObjectBoolean_OperDate.ObjectId  = MovementLinkObject_OrderFinance.ObjectId
                                             AND ObjectBoolean_OperDate.DescId    = zc_ObjectBoolean_OrderFinance_OperDate()
                                             AND ObjectBoolean_OperDate.ValueData = TRUE

                WHERE MovementLinkObject_OrderFinance.MovementId = inMovementId
                  AND MovementLinkObject_OrderFinance.DescId     = zc_MovementLinkObject_OrderFinance()
               )
     THEN
         -- замена
         IF ioOperDate_Amount IS NULL THEN ioOperDate_Amount:= inOperDate_Amount_top; END IF;

         -- нашли дату начала недели
         vbOperDate_start:= (SELECT zfCalc_Week_StartDate (Movement.OperDate, MovementFloat_WeekNumber.ValueData)
                             FROM Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                          ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                         AND MovementFloat_WeekNumber.DescId     = zc_MovementFloat_WeekNumber()
                             WHERE Movement.Id = inMovementId
                            );


         -- сначала Plan_next
         IF inAmount <> ioAmount_old AND ioAmount_old = ioAmountPlan_next
         THEN
             ioAmountPlan_next:= inAmount;
         END IF;



         -- если изменили план - переносится только в ОДИН день
         IF 1=1
         THEN
             -- пн.
             IF ioOperDate_Amount = vbOperDate_start + INTERVAL '0 DAY'
             THEN
                 ioAmountPlan_1:= ioAmountPlan_next;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- вт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '1 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= ioAmountPlan_next;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- ср.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '2 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= ioAmountPlan_next;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- чт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '3 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= ioAmountPlan_next;
                 ioAmountPlan_5:= 0;

             -- пт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '4 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= ioAmountPlan_next;

             ELSE
	         RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                                , zfConvert_DateToString (ioOperDate_Amount)
                                , CHR (13)
                                , zfConvert_DateToString (vbOperDate_start)
                                , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                                 ;
             END IF;

         END IF;

     ELSE
         -- замена
         ioOperDate_Amount:= NULL;
         -- замена
         ioAmountPlan_next:= inAmount;
     END IF;


     -- сохранили Master
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId                   := ioId
                                                  , inMovementId           := inMovementId
                                                  , inJuridicalId          := inJuridicalId
                                                  , inContractId           := inContractId
                                                  , inCashId               := NULL
                                                  , inAmount               := inAmount
                                                  , inAmount_next          := ioAmountPlan_next
                                                  , inOperDate_Amount_next := ioOperDate_Amount
                                                  , inAmountPlan_1         := ioAmountPlan_1
                                                  , inAmountPlan_2         := ioAmountPlan_2
                                                  , inAmountPlan_3         := ioAmountPlan_3
                                                  , inAmountPlan_4         := ioAmountPlan_4
                                                  , inAmountPlan_5         := ioAmountPlan_5
                                                  , inComment              := inComment
                                                  , inComment_Partner      := ''
                                                  , inComment_Contract     := ''
                                                  , inUserId               := vbUserId
                                                   ) AS tmp;

    -- вернули
    outAmountPlan_total:= COALESCE (ioAmountPlan_1, 0)
                        + COALESCE (ioAmountPlan_2, 0)
                        + COALESCE (ioAmountPlan_3, 0)
                        + COALESCE (ioAmountPlan_4, 0)
                        + COALESCE (ioAmountPlan_5, 0)
                       ;
    -- вернули
    ioOperDate_Amount_old:= ioOperDate_Amount;
    -- вернули
    ioAmount_old:= inAmount;
    -- вернули
    ioAmountPlan_next_old:= ioAmountPlan_next;


    -- тест
    if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. outAmountPlan_total =  <%>', outAmountPlan_total; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- тест
--