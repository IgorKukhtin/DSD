-- Function: gpInsertUpdate_MovementItem_OrderFinanceSB()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinanceSB (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinanceSB(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioId_child              Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inJuridicalId           Integer   , --
    IN inContractId            Integer   , --
    IN inCashId_top            Integer   , --
    IN inCashId                Integer   , --
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
    IN inComment               TVarChar   , --
    -- child
    IN inGoodsName_child          TVarChar  , -- Товары
    IN inInvNumber_child          TVarChar  , --
    IN inInvNumber_Invoice_child  TVarChar  , --
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId                  Integer;
   DECLARE vbOrderFinanceld          Integer;
   DECLARE vbOperDate_start          TDateTime;
           vbGoodsName_child         TVarChar;
           vbInvNumber_child         TVarChar;
           vbInvNumber_Invoice_child TVarChar;
           vbAmount_child            TFloat;
           vbIsInsert_child          Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());


     IF vbUserId <> 5 AND 1=0 THEN RAISE EXCEPTION 'Ошибка.Режим отладки.'; END IF;
     

     vbOrderFinanceld:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_OrderFinance());


     -- Проверка
     IF ioId > 0 AND COALESCE (ioId_child, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Заполнение возможно только в документе <Планирование платежей>.';
     END IF;
     -- если НЕ Заполнено дата предварительный план = ДА
     IF NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceld AND OB.DescId = zc_ObjectBoolean_OrderFinance_OperDate() AND OB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Заполнение возможно только в документе <Планирование платежей>.';
     END IF;


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


     -- если ЗПодтверждение СБ (да/нет) = ДА
     IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId  = vbOrderFinanceld AND OB.DescId = zc_ObjectBoolean_OrderFinance_SB() AND OB.ValueData = TRUE)
     THEN
         ioAmountPlan_next:= 0;

     -- сначала Plan_next
     ELSEIF inAmount <> ioAmount_old AND ioAmount_old = ioAmountPlan_next
     THEN
         -- Переносим
         ioAmountPlan_next:= inAmount;

     END IF;

     -- если не заполнено в стоке берем из шапки документа
     IF COALESCE (inCashId,0) = 0
     THEN
         inCashId := COALESCE (inCashId_top);
     END IF;


     -- 1.сохраняем Master, не ошибка - в Master все суммы = 0 + Примечание в чайлд
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId                   := ioId
                                                  , inMovementId           := inMovementId
                                                  , inJuridicalId          := inJuridicalId
                                                  , inContractId           := inContractId
                                                  , inCashId               := inCashId
                                                  , inAmount               := 0
                                                  , inAmount_next          := 0
                                                  , inOperDate_Amount_next := NULL
                                                  , inAmountPlan_1         := 0
                                                  , inAmountPlan_2         := 0
                                                  , inAmountPlan_3         := 0
                                                  , inAmountPlan_4         := 0
                                                  , inAmountPlan_5         := 0
                                                  , inComment              := ''
                                                  , inComment_Partner      := ''
                                                  , inComment_Contract     := ''
                                                  , inUserId               := vbUserId
                                                   ) AS tmp;


  
     -- 2.сохраняем Child - Первичный план на неделю
     ioId_child := lpInsertUpdate_MovementItem_OrderFinance_child (ioId                    := ioId_child
                                                                 , inMovementId            := inMovementId
                                                                 , inParentId              := ioId
                                                                 , inAmount                := inAmount
                                                                 , inAmount_next           := ioAmountPlan_next
                                                                 , inOperDate_Amount_next  := ioOperDate_Amount
                                                                 , inGoodsName             := inGoodsName_child
                                                                 , inInvNumber             := inInvNumber_child
                                                                 , inInvNumber_Invoice     := inInvNumber_Invoice_child
                                                                 , inComment               := inComment
                                                                 , inUserId                := vbUserId
                                                                  );

    -- вернули
    ioAmountPlan_1:= CASE WHEN zfCalc_DayOfWeekNumber (ioOperDate_Amount) = 1 THEN ioAmountPlan_next ELSE 0 END;
    ioAmountPlan_2:= CASE WHEN zfCalc_DayOfWeekNumber (ioOperDate_Amount) = 2 THEN ioAmountPlan_next ELSE 0 END;
    ioAmountPlan_3:= CASE WHEN zfCalc_DayOfWeekNumber (ioOperDate_Amount) = 3 THEN ioAmountPlan_next ELSE 0 END;
    ioAmountPlan_4:= CASE WHEN zfCalc_DayOfWeekNumber (ioOperDate_Amount) = 4 THEN ioAmountPlan_next ELSE 0 END;
    ioAmountPlan_5:= CASE WHEN zfCalc_DayOfWeekNumber (ioOperDate_Amount) = 5 THEN ioAmountPlan_next ELSE 0 END;

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
    --if vbUserId IN (5, 9457) then RAISE EXCEPTION 'Админ.Test Ok. outAmountPlan_total =  <%>', outAmountPlan_total; end if;

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