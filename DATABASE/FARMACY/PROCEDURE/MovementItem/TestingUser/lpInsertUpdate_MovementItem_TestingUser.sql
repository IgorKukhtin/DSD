-- Function: lpInsertUpdate_MovementItem_TestingUser()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TestingUser (Integer, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TestingUser(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
    IN inResult              Integer   , -- Результат теста
    IN inAttempts            Integer   , -- Количество попыток
    IN inDateTest            TDateTime , -- Дата теста
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
BEGIN

  IF COALESCE (inMovementId, 0) = 0
  THEN
    RAISE EXCEPTION 'Ошибка. Не создан документ за месяц';
  END IF;

  IF COALESCE (inResult, -1) < 0 OR COALESCE (inAttempts, 0) < 1
  THEN
    RAISE EXCEPTION 'Ошибка. Не указано количество ответов или количество попыток';
  END IF;

   -- Проверяем если уже есть по такому сотруднику
  IF COALESCE (ioId, 0) = 0 AND EXISTS(SELECT Id FROM MovementItem WHERE MovementId = inMovementId AND ObjectId = inUserId)
  THEN
    SELECT Id
    INTO ioId
    FROM MovementItem
    WHERE MovementId = inMovementId
      AND ObjectId = inUserId;
  END IF;

   -- сохранили <Элемент документа>
  ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, inMovementId, inResult, NULL);

   -- сохранили свойство <Количество попыток>
  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TestingUser_Attempts(), ioId, inAttempts);

   -- сохранили свойство <Дата теста>
  PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TestingUser(), ioId, inDateTest);

   -- сохранили протокол
  -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.10.18        *
 11.09.18        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_TestingUser (ioId:= 0, inMovementId:= 0, inUserId:= 6002014, inResult:= 102, inDateTest:= '20180901', inSession:= '3')