-- Function: lpInsertUpdate_Movement_SendOnPrice_Value()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SendOnPrice_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SendOnPrice_Value (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SendOnPrice_Value(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inMovementId_Order    Integer    , -- ключ Документа
    IN ioPriceListId         Integer   , -- Прайс лист
    IN inProcessId           Integer   , -- 
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили <Документ>
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_Movement_SendOnPrice (ioId               := ioId
                                             , inInvNumber        := inInvNumber
                                             , inOperDate         := inOperDate
                                             , inOperDatePartner  := inOperDatePartner
                                             , inPriceWithVAT     := inPriceWithVAT
                                             , inVATPercent       := inVATPercent
                                             , inChangePercent    := inChangePercent
                                             , inFromId           := inFromId
                                             , inToId             := inToId
                                             , inRouteSortingId   := inRouteSortingId
                                             , inSubjectDocId     := 0--inSubjectDocId
                                             , inMovementId_Order := inMovementId_Order
                                             , ioPriceListId      := ioPriceListId
                                             , inProcessId        := inProcessId
                                             , inUserId           := inUserId
                                              ) AS tmp);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_SendOnPrice_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
