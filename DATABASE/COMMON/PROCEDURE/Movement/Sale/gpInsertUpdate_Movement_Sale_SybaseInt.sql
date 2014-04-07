-- Function: gpInsertUpdate_Movement_Sale_SybaseInt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale_SybaseInt (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale_SybaseInt(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberOrder      TVarChar  , -- Номер заявки контрагента
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inChecked             Boolean   , -- Проверен
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
 INOUT ioPriceListId         Integer   , -- Прайс лист
   OUT outPriceListName      TVarChar  , -- Прайс лист
    IN inIsOnlyUpdateInt     Boolean   , -- !!!!!!
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
BEGIN
     IF inIsOnlyUpdateInt = TRUE AND ioId <> 0
     THEN
          -- сохранили <Документ>
          SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
                 INTO ioId, ioPriceListId, outPriceListName
          FROM gpInsertUpdate_Movement_Sale (ioId               := ioId
                                           , inInvNumber        := inInvNumber
                                           , inInvNumberPartner := (SELECT ValueData FROM MovementString WHERE MovementId = ioId AND DescId = zc_MovementString_InvNumberPartner())
                                           , inInvNumberOrder   := inInvNumberOrder
                                           , inOperDate         := inOperDate
                                           , inOperDatePartner  := (SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner())
                                           , inChecked          := (SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked())
                                           , inPriceWithVAT     := inPriceWithVAT
                                           , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , ioPriceListId      := ioPriceListId
                                           , inSession          := inSession
                                            ) AS tmp;
     ELSE
          -- сохранили <Документ>
          SELECT tmp.ioId, tmp.ioPriceListId, tmp.outPriceListName
                 INTO ioId, ioPriceListId, outPriceListName
          FROM gpInsertUpdate_Movement_Sale (ioId               := ioId
                                           , inInvNumber        := inInvNumber
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inInvNumberOrder   := inInvNumberOrder
                                           , inOperDate         := inOperDate
                                           , inOperDatePartner  := inOperDatePartner
                                           , inChecked          := inChecked
                                           , inPriceWithVAT     := inPriceWithVAT
                                           , inVATPercent       := inVATPercent
                                           , inChangePercent    := inChangePercent
                                           , inFromId           := inFromId
                                           , inToId             := inToId
                                           , inPaidKindId       := inPaidKindId
                                           , inContractId       := inContractId
                                           , inRouteSortingId   := inRouteSortingId
                                           , ioPriceListId      := ioPriceListId
                                           , inSession          := inSession
                                            ) AS tmp;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.04.14                                        *
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Sale_SybaseInt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
