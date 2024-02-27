-- Function: lpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата начала периода
    IN inOperDateEnd         TDateTime , -- Дата окончания периода
    IN inTimeClose           TDateTime , -- Время авто закрытия 
    IN inUnitId              Integer   , -- Подразделение(Исключение)
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SheetWorkTimeClose(), inInvNumber, inOperDate, NULL, NULL);

     -- <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
     -- <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_TimeClose(), ioId, inTimeClose);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     IF vbIsInsert = TRUE
     THEN
         -- <>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAuto(), ioId, TRUE);

         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);

     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.21         *
*/

-- тест
-- 