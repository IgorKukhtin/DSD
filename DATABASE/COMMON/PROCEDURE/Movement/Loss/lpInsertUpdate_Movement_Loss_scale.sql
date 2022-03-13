-- Function: lpInsertUpdate_Movement_Loss_scale() - !!!сделана т.к. для печати из scale нужны цены и суммы!!!

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss_scale (Integer, TVarChar, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loss_scale (Integer, TVarChar, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loss_scale(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inArticleLossId       Integer   , -- Статьи списания
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Loss (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inArticleLossId    := inArticleLossId
                                         , inComment          := inComment
                                         , inUserId           := inUserId
                                          );

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.03.17         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Loss_scale (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
