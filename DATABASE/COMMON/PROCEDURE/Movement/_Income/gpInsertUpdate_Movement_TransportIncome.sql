-- Function: gpInsertUpdate_Movement_TransportIncome()

-- DROP FUNCTION gpInsertUpdate_Movement_TransportIncome();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportIncome(
    IN inParentId            Integer   , -- Ключ Master <Документ>
 INOUT ioMovementId          Integer   , -- Ключ объекта <Документ>
   OUT outInvNumber          TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
 INOUT ioPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
 INOUT ioPaidKindId          Integer   , -- Виды форм оплаты 
 INOUT ioContractId          Integer   , -- Договора
 INOUT ioRouteId             Integer   , -- Маршрут
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     vbUserId := inSession;



     -- попробуем найти документ
     IF COALESCE (ioMovementId, 0) = 0 


     -- для нового документа надо расчитать и вернуть свойства
     IF COALESCE (ioMovementId, 0) = 0 
     THEN
         -- расчитали свойство <Номер документа>
         outInvNumber := lfGet_InvNumber (0, zc_Movement_Income()
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioMovementId
                                               , inParentId         := inParentId
                                               , inInvNumber        := inInvNumber
                                               , inOperDate         := inOperDate
                                               , inPriceWithVAT     := inPriceWithVAT
                                               , inVATPercent       := inVATPercent
                                               , inFromId           := inFromId
                                               , inToId             := inToId
                                               , inPaidKindId       := inPaidKindId
                                               , inContractId       := inContractId
                                               , inRouteId          := inRouteId
                                               , inPersonalDriverId := inPersonalDriverId
                                               , inUserId           := vbUserId 
                                                );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportIncome (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
