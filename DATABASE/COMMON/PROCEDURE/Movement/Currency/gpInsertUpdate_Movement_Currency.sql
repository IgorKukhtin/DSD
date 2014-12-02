-- Function: gpInsertUpdate_Movement_Currency()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Currency (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Currency(
 INOUT ioId                       Integer   , -- Ключ объекта <Документ Курсовая разница>
    IN inInvNumber                TVarChar  , -- Номер документа
    IN inOperDate                 TDateTime , -- Дата документа
    IN inAmount                   TFloat    , -- курс
    IN inParValue                 TFloat    , -- Номинал валюты для которой вводится курс
    IN inComment                  TVarChar  , -- Комментарий
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Currency());

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
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Currency())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Currency(), inInvNumber, inOperDate, NULL, NULL);

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
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Currency())
     THEN
          PERFORM lpComplete_Movement_Currency (inMovementId := ioId
                                              , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.11.14                                        * add inParValue
 28.07.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Currency (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inCurrencyFromId:= 1, inCurrencyFromBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inCurrencyFromId:= 0, inSession:= '2')
