-- Function: lpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Inventory(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inUnitId               Integer   , -- Магазин
    IN inComment              TVarChar  , -- Примечание
    IN inisList               Boolean   , --Только для выбранных
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Inventory(), inInvNumber, inOperDate, NULL, 0);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     -- 
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inisList);

     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
   
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.22         *
 17.02.22         *
*/

-- тест
--