-- Function: lpInsertUpdate_MovementItem_PersonalTransport()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalTransport (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalTransport(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники   
    IN inInfoMoneyId           Integer   , -- Статьи назначения
    IN inUnitId                Integer   , -- Подразделение
    IN inPositionId            Integer   , -- Должность
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- пользователь
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <ФИО (сотрудник)> для Сумма начислено = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         IF inAmount = 0 THEN RETURN; END IF;
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <УП статья> для Сумма начислено = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- проверка
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Подразделение> для Сумма начислено = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- проверка
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <Должность> для Сумма начислено = <%>.', zfConvert_FloatToString (inAmount);
     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
-- 