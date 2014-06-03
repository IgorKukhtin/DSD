-- Function: gpInsertUpdate_Movement_ProductionUnion()

-- DROP FUNCTION gpInsertUpdate_Movement_ProductionUnion();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion()());
   vbUserId := inSession;

   -- сохранили <Документ>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionUnion(), inInvNumber, inOperDate, NULL);

   -- сохранили связь с <От кого (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
   -- сохранили связь с <Кому (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);
   -- сохранили протокол
   -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.06.14                                                        *
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProductionUnion (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
