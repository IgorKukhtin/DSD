-- Function: gpInsertUpdate_Movement_IncomeMemberFuel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IncomeMemberFuel(Integer,TVarChar,TDateTime,TDateTime,TVarChar,Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IncomeMemberFuel(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер чека

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePrice         TFloat    , -- Скидка в цене

   -- IN inStartOdometre       TFloat    , --
   -- IN inEndOdometre         TFloat    , --
    IN inAmountFuel          TFloat    , -- норма авто
    IN inReparation          TFloat    , -- амортизация
    IN inLimit               TFloat    , -- лимит грн
    IN inLimitDistance       TFloat    , -- лимит литры

    IN inLimitChange         TFloat    , -- лимит (по служебке) грн
    IN inLimitDistanceChange TFloat    , -- лимит (по служебке) литры

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
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());

    -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- проверка - связанные документы Изменять нельзя
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= 'изменение');

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioId
                                               , inParentId         := NULL
                                               , inInvNumber        := inInvNumber
                                               , inOperDate         := inOperDate
                                               , inOperDatePartner  := inOperDatePartner
                                               , inInvNumberPartner := inInvNumberPartner
                                               , inPriceWithVAT     := inPriceWithVAT
                                               , inVATPercent       := inVATPercent
                                               , inChangePrice      := inChangePrice
                                               , inFromId           := inFromId
                                               , inToId             := inToId
                                               , inPaidKindId       := inPaidKindId
                                               , inContractId       := inContractId
                                               , inRouteId          := inRouteId
                                               , inPersonalDriverId := inPersonalDriverId
                                               , inAccessKeyId      := vbAccessKeyId 
                                               , inUserId           := vbUserId 
                                                );

     -- сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_StartOdometre(), ioId, inStartOdometre);
     -- сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_EndOdometre(), ioId, inEndOdometre);
  
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_AmountFuel(), ioId, inAmountFuel);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_Reparation(), ioId, inReparation);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_LimitChange(), ioId, inLimitChange);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_LimitDistanceChange(), ioId, inLimitDistanceChange);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_Limit(), ioId, inLimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_LimitDistance(), ioId, inLimitDistance);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.13                                        * add lpGetAccess
 31.10.13                                        * add inOperDatePartner
 19.10.13                                        * add inChangePrice
 07.10.13                                        * add lpCheckRight
 06.10.13                                        * add lfCheck_Movement_Parent
 05.10.13                                        * add inInvNumberPartner
 04.10.13                                        * add lpInsertUpdate_Movement_IncomeFuel
 04.10.13                                        * add Route
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
