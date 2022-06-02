-- Function: gpInsertUpdate_Movement_CashSend()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_CashSend (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_CashSend(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCurrencyValue        TFloat    , -- курс
    IN inParValue             TFloat    , -- номинал
    IN inAmountOut            TFloat    , -- Сумма (расход)
    IN inAmountIn             TFloat    , -- Сумма (приход)
    IN inCashId_from          Integer   , -- касса 
    IN inCashId_to            Integer   , -- касса 
    IN inCommentMoveMoneyId   Integer   , -- Примечание
    IN inUserId               Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- !замена!
     IF inAmountIn = 0 THEN inAmountIn:= inAmountOut; END IF;

    -- проверка
     IF COALESCE (inCashId_from, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Касса расход> не введена.';
     END IF;
    -- проверка
     IF COALESCE (inCashId_to, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Касса приход> не введена.';
     END IF;
    -- проверка
     IF COALESCE (inAmountOut, 0) <= 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Сумма расход> не введена.';
     END IF;
    -- проверка
     IF COALESCE (inAmountIn, 0) <= 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Сумма приход> не введена.';
     END IF;
    -- проверка
     IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_from AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Cash_Currency())
     THEN
        RAISE EXCEPTION 'Ошибка.<Валюта Касса расход> не введена = %.', lfGet_Object_ValueData_sh (inCashId_from);
     END IF;
    -- проверка
     IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_to AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Cash_Currency())
     THEN
        RAISE EXCEPTION 'Ошибка.<Валюта Касса приход> не введена = %.', lfGet_Object_ValueData_sh (inCashId_to);
     END IF;
     -- проверка
     IF  (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_from AND OL.DescId = zc_ObjectLink_Cash_Currency())
       = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_to   AND OL.DescId = zc_ObjectLink_Cash_Currency())
       AND COALESCE (inAmountOut, 0) <> COALESCE (inAmountIn, 0)
     THEN
        RAISE EXCEPTION 'Ошибка.Сумма расход = <%> и сумма приход = <%> не могут отличаться.', zfConvert_FloatToString (inAmountOut), zfConvert_FloatToString (inAmountIn);
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CashSend(), inInvNumber, inOperDate, NULL, inUserId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа> - Сумма (расход)
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId_from, ioId, inAmountOut, NULL);

     -- сохранили - Сумма (приход)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount(), vbMovementItemId, inAmountIn);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), vbMovementItemId, inCashId_to);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, inCommentMoveMoneyId);


 
      -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.22         *
 14.01.22         *
 */

-- тест
--