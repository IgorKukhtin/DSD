-- Function: gpInsertUpdate_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendOnPrice (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendOnPrice(
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
    IN inSubjectDocId        Integer   , -- Основание для перемещения
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист
    IN inMovementId_Order    Integer    , -- ключ Документа
    IN inComment             TVarChar   , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendOnPrice());

     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
            INTO ioId, ioPriceListId, outPriceListName
     FROM lpInsertUpdate_Movement_SendOnPrice
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inOperDatePartner  := inOperDatePartner
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inChangePercent    := inChangePercent
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inRouteSortingId   := inRouteSortingId
                                      , inSubjectDocId     := inSubjectDocId
                                      , inMovementId_Order := inMovementId_Order
                                      , ioPriceListId      := ioPriceListId
                                      , inProcessId        := zc_Enum_Process_InsertUpdate_Movement_SendOnPrice()
                                      , inUserId           := vbUserId
                                       ) AS tmp;


    -- Комментарий
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.20         *
 08.06.15         * 
 05.05.14                                                        *   передалал все по новой на базе проц расхода.
 16.07.13                                        * zc_Movement_SendOnPrice
 12.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SendOnPrice (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
