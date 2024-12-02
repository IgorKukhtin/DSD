-- Function: gpInsertUpdate_Movement_CurrencyList()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CurrencyList (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CurrencyList (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CurrencyList(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ Курсовая разница>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmount                   TFloat    , -- курс
    IN inParValue                 TFloat    , -- Номинал валюты для которой вводится курс
    IN inComment                  TVarChar  , -- Комментарий 
    IN inSiteTagId                Integer   , -- Категория Сайта
    IN inCurrencyFromId           Integer   , -- валюта в которой вводится курc
    IN inCurrencyToId             Integer   , -- валюта для которой вводится курс
    IN inPaidKindId               Integer   , -- Виды форм оплаты 
    IN inSession                  TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CurrencyList());

     -- проверка
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не установлена <Форма оплаты>.';
     END IF;
     -- проверка
     IF COALESCE (inCurrencyFromId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не установлена <Валюта (значение)>.';
     END IF;
     -- проверка
     IF COALESCE (inCurrencyToId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не установлена <Валюта (результат)>.';
     END IF;

     -- проверка
     IF inCurrencyFromId <> zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION 'Ошибка.<Валюта (значение)> должно соответствовать <%>.', lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;


     -- 1. Распроводим Документ
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_CurrencyList())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CurrencyList(), inInvNumber, inOperDate, NULL, NULL);

     -- сохранили связь с <Категория сайта>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SiteTag(), ioId, inSiteTagId);

     -- определяем <Элемент документа>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCurrencyFromId, ioId, inAmount, NULL);
    
     -- Номинал валюты для которой вводится курс
     IF COALESCE (inParValue, 0) = 0 THEN inParValue := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), vbMovementItemId, inParValue);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), vbMovementItemId, inCurrencyToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);


     -- 5.2. создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_CurrencyList())
     THEN
          PERFORM lpComplete_Movement_CurrencyList (inMovementId := ioId
                                                  , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.24         *
 21.02.23         *
*/

-- тест
--