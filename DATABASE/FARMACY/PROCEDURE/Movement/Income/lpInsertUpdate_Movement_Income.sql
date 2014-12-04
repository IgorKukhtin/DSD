-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inContractId          Integer   , -- Договор
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
BEGIN

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Типы НДС>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NDSKind(), ioId, inNDSKindId);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

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
 02.12.14                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
