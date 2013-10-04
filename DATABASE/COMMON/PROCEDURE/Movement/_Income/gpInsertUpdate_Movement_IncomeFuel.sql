-- Function: gpInsertUpdate_Movement_IncomeFuel()

-- DROP FUNCTION gpInsertUpdate_Movement_IncomeFuel();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeFuel(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС

    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты 
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioId
                                               , inParentId         := NULL
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
 04.10.13                                        * add lpInsertUpdate_Movement_IncomeFuel
 04.10.13                                        * add Route
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
