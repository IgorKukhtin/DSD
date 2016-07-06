-- Function: lpInsertUpdate_Movement_Over (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Over (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Over(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделения
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   
   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Документ>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Over(), inInvNumber, inOperDate, NULL);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
   -- сохранили свойство <>
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.07.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Over (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
