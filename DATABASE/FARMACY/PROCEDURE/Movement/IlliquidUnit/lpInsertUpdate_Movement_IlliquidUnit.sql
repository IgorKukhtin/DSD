-- Function: lpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inFullInvent          Boolean   , -- Полная инвентаризация
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_IlliquidUnit(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили связь с <Подразделение в документе>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили признак <ПОлная инвентаризация>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FullInvent(), ioId, inFullInvent);

     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.12.19                                                       *
 */
