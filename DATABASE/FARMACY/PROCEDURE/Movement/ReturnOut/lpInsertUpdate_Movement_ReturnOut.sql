-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ReturnOut
   (Integer, TVarChar, TDateTime, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа
   -- IN inOperDatePartner     TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inParentId            Integer   , -- Приходная накладная
    IN inReturnTypeId        Integer   , -- Тип возврата
    IN inLegalAddressId      Integer   , -- Юридический адрес поставщика
    IN inActualAddressId     Integer   , -- Фактический адрес поставщика
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ReturnOut(), inInvNumber, inOperDate, inParentId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Типы НДС>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NDSKind(), ioId, inNDSKindId);
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, (Select ValueData from ObjectFloat Where ObjectID = inNDSKindId AND DescId = zc_ObjectFloat_NDSKind_NDS()));

     -- сохранили связь с <Типом возврата>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReturnType(), ioId, inReturnTypeId);

     -- сохранили связь с <Юридический адрес поставщика>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_LegalAddress(), ioId, inLegalAddressId);

     -- сохранили связь с <Фактический адрес поставщика>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ActualAddress(), ioId, inActualAddressId);

     -- сохраняется в отдельной процедуре
     --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 28.05.18                                                                     * 
 15.09.16         *
 06.02.15                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
