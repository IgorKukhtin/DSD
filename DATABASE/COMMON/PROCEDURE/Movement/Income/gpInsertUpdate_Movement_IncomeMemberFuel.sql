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
 INOUT ioToId                Integer   , -- Кому (в документе)
   OUT outToName             TVarChar  , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты 
    IN inContractId          Integer   , -- Договора
    IN inRouteId             Integer   , -- Маршрут
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbToId Integer;
   DECLARE vbDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_IncomeFuel());

    -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- проверка - связанные документы Изменять нельзя
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= 'изменение');

     -- проверяем водителя для топливной карты.
     vbDescId := (SELECT Object.DescId FROM Object WHERE Object.Id = inFromId);
     IF vbDescId = zc_Object_CardFuel()
        THEN
             vbToId := (SELECT OL_PersonalDriver.ChildObjectId
                        FROM ObjectLink AS OL_PersonalDriver 
                        WHERE OL_PersonalDriver.ObjectId = inFromId
                        AND OL_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver());
     END IF;
     IF COALESCE (vbToId,0) <> 0 THEN ioToId:= vbToId; END IF;
     outToName := COALESCE((SELECT Object.ValueData FROM Object WHERE Object.Id = ioToId),'') ::TVarChar ;

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
                                               , inToId             := ioToId
                                               , inPaidKindId       := inPaidKindId
                                               , inContractId       := inContractId
                                               , inRouteId          := inRouteId
                                               , inPersonalDriverId := inPersonalDriverId
                                               , inAccessKeyId      := vbAccessKeyId 
                                               , inUserId           := vbUserId 
                                                );

     -- сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartOdometre(), ioId, inStartOdometre);
     -- сохранили свойство <>
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_EndOdometre(), ioId, inEndOdometre);
  
     -- сохранили свойство <норма авто>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountFuel(), ioId, inAmountFuel);
     -- сохранили свойство <амортизация за 1 км., грн.>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Reparation(), ioId, inReparation);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitChange(), ioId, inLimitChange);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitDistanceChange(), ioId, inLimitDistanceChange);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Limit(), ioId, inLimit);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LimitDistance(), ioId, inLimitDistance);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.17         *
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
-- SELECT * FROM gpInsertUpdate_Movement_IncomeFuel (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, ioToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
