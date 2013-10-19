-- Function: lpInsertUpdate_Movement_SheetWorkTime(Integer, TVarChar, TDateTime, Integer, TVarChar)

-- DROP FUNCTION lpInsertUpdate_Movement_SheetWorkTime (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SheetWorkTime(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer     -- Подразделения
)                              
RETURNS Integer AS
$BODY$
BEGIN

     IF inInvNumber = '' THEN
        inInvNumber := lfGet_InvNumber (0, zc_Movement_SheetWorkTime())::TVarChar;
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SheetWorkTime(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <Подразделением (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.10.13                        *

*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_SheetWorkTime (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inSession:= '2')
