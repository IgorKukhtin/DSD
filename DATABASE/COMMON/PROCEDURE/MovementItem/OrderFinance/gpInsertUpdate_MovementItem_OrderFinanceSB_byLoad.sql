-- Function: gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinanceSB_byLoad(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , --
    IN inContractId            Integer   , --
    IN inCashId_top            Integer   , --
    IN inCashId                Integer   , --
    IN inAmount                TFloat    , -- *** Предварительный План на неделю
 INOUT ioAmount_old            TFloat    , -- *** Предварительный План на неделю
    IN inOperDate_Amount_top   TDateTime , -- *** Дата предварительный план
 INOUT ioOperDate_Amount       TDateTime , -- *** Дата предварительный план
 INOUT ioOperDate_Amount_old   TDateTime , -- *** Дата предварительный план
 INOUT ioAmountPlan_1          TFloat    , --
 INOUT ioAmountPlan_2          TFloat    , --
 INOUT ioAmountPlan_3          TFloat    , --
 INOUT ioAmountPlan_4          TFloat    , --
 INOUT ioAmountPlan_5          TFloat    , --
   OUT outAmountPlan_total     TFloat    , --
    IN inComment               TVarChar   , --
    IN inComment_Partner       TVarChar  , -- Примечание Контрагента
    IN inComment_Contract      TVarChar  , -- Примечание Договора
    -- child
    --IN inGoodsName_child       TVarChar  , -- Товары
   -- IN inInvNumber_child       TVarChar  , --   
    --IN inInvNumber_Invoice_child  TVarChar  , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbOperDate_start TDateTime;
           --vbGoodsName_child TVarChar;
           --vbInvNumber_child TVarChar;
           --vbInvNumber_Invoice_child TVarChar;
           --vbId_child        Integer;
           --vbAmount_child    TFloat;
           --vbIsInsert_child  Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());
 

     -- Проверка - <Ожидание Согласования-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignWait_1() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Отправлено на Согласование Руководителю>.';
     END IF;
     -- Проверка - <Согласован-1>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign_1() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Согласовано Руководителем>.';
     END IF;
     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
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

         -- если изменили план
         IF COALESCE (inAmount, 0) <> COALESCE (ioAmount_old, 0)
            OR ioOperDate_Amount <> COALESCE (ioOperDate_Amount_old, zc_DateStart())
            -- или Заполнение дата предварительный план = ДА = EXISTS zc_ObjectBoolean_OrderFinance_OperDate
            OR 1=1
         THEN
             -- пн.
             IF ioOperDate_Amount = vbOperDate_start + INTERVAL '0 DAY'
             THEN
                 ioAmountPlan_1:= inAmount;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- вт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '1 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= inAmount;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- ср.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '2 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= inAmount;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= 0;

             -- чт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '3 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= inAmount;
                 ioAmountPlan_5:= 0;

             -- пт.
             ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '4 DAY'
             THEN
                 ioAmountPlan_1:= 0;
                 ioAmountPlan_2:= 0;
                 ioAmountPlan_3:= 0;
                 ioAmountPlan_4:= 0;
                 ioAmountPlan_5:= inAmount;

             ELSE
	         RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                                , zfConvert_DateToString (ioOperDate_Amount)
                                , CHR (13)
                                , zfConvert_DateToString (vbOperDate_start)
                                , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                                 ;
             END IF;

         -- если изменили план
         ELSE
             -- пн.
             IF ioAmountPlan_1 > 0
             THEN
                 ioOperDate_Amount:= vbOperDate_start + INTERVAL '0 DAY';

             -- вт.
             ELSEIF ioAmountPlan_2 > 0
             THEN
                 ioOperDate_Amount:= vbOperDate_start + INTERVAL '1 DAY';

             -- ср.
             ELSEIF ioAmountPlan_3 > 0
             THEN
                 ioOperDate_Amount:= vbOperDate_start + INTERVAL '2 DAY';

             -- чт.
             ELSEIF ioAmountPlan_4 > 0
             THEN
                 ioOperDate_Amount:= vbOperDate_start + INTERVAL '3 DAY';

             -- пт.
             ELSEIF ioAmountPlan_5 > 0
             THEN
                 ioOperDate_Amount:= vbOperDate_start + INTERVAL '4 DAY';

             ELSE
                 -- не меняется значение
	         ioOperDate_Amount:= COALESCE ((SELECT MID.ValueData FROM MovementItemDate AS MID WHERE MID.MovementItemId = ioId AND MID.DescId = zc_MIDate_Amount()), ioOperDate_Amount);

                 -- !!!Еще раз!!!

                 -- пн.
                 IF ioOperDate_Amount = vbOperDate_start + INTERVAL '0 DAY'
                 THEN
                     ioAmountPlan_1:= inAmount;
                     ioAmountPlan_2:= 0;
                     ioAmountPlan_3:= 0;
                     ioAmountPlan_4:= 0;
                     ioAmountPlan_5:= 0;

                 -- вт.
                 ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '1 DAY'
                 THEN
                     ioAmountPlan_1:= 0;
                     ioAmountPlan_2:= inAmount;
                     ioAmountPlan_3:= 0;
                     ioAmountPlan_4:= 0;
                     ioAmountPlan_5:= 0;

                 -- ср.
                 ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '2 DAY'
                 THEN
                     ioAmountPlan_1:= 0;
                     ioAmountPlan_2:= 0;
                     ioAmountPlan_3:= inAmount;
                     ioAmountPlan_4:= 0;
                     ioAmountPlan_5:= 0;

                 -- чт.
                 ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '3 DAY'
                 THEN
                     ioAmountPlan_1:= 0;
                     ioAmountPlan_2:= 0;
                     ioAmountPlan_3:= 0;
                     ioAmountPlan_4:= inAmount;
                     ioAmountPlan_5:= 0;

                 -- пт.
                 ELSEIF ioOperDate_Amount = vbOperDate_start + INTERVAL '4 DAY'
                 THEN
                     ioAmountPlan_1:= 0;
                     ioAmountPlan_2:= 0;
                     ioAmountPlan_3:= 0;
                     ioAmountPlan_4:= 0;
                     ioAmountPlan_5:= inAmount;

                 ELSE
                     RAISE EXCEPTION 'Ошибка.Дата План = <%>%.Должна быть в периоде с <%> по <%>.'
                                    , zfConvert_DateToString (ioOperDate_Amount)
                                    , CHR (13)
                                    , zfConvert_DateToString (vbOperDate_start)
                                    , zfConvert_DateToString (vbOperDate_start + INTERVAL '4 DAY')
                                     ;
                 END IF;

             END IF;


         END IF;

     ELSE
         -- замена
         ioOperDate_Amount:= NULL;
     END IF;

     -- сохранили
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId              := ioId
                                                  , inMovementId      := inMovementId
                                                  , inJuridicalId     := inJuridicalId
                                                  , inContractId      := inContractId
                                                  , inAmount          := inAmount
                                                  , inOperDate_Amount := ioOperDate_Amount
                                                  , inAmountPlan_1    := ioAmountPlan_1
                                                  , inAmountPlan_2    := ioAmountPlan_2
                                                  , inAmountPlan_3    := ioAmountPlan_3
                                                  , inAmountPlan_4    := ioAmountPlan_4
                                                  , inAmountPlan_5    := ioAmountPlan_5
                                                  , inComment         := inComment
                                                  , inUserId          := vbUserId
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


    --если не заполнено в сроке берем из шапки документа
    IF COALESCE (inCashId,0) = 0
    THEN
        inCashId := COALESCE (inCashId_top);
    END IF;

    -- сохранили связь с <касса место выдачи>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), ioId, inCashId);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_Partner(), ioId, inComment_Partner);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_Contract(), ioId, inComment_Contract);



    -- могут внести данные для чайлд


    -- тест
    --if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. outAmountPlan_total =  <%>', outAmountPlan_total; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.01.26         *
 18.02.21         * inAmountStart
 29.07.19         *
*/

-- тест
--