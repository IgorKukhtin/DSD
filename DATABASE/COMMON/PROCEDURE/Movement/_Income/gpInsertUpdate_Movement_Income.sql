-- Function: gpInsertUpdate_Movement_Income()

-- DROP FUNCTION gpInsertUpdate_Movement_Income();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа

    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки 

    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты 
    IN inContractId          Integer   , -- Договора
    IN inPersonalPackerId    Integer   , -- Сотрудник (заготовитель)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     -- определяем ключ доступа
     -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Income());

     -- проверка - связанные документы Изменять нельзя
     PERFORM lfCheck_Movement_Parent (inMovementId:= ioId, inComment:= 'изменение');


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Дата накладной у контрагента>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), ioId, inOperDatePartner);
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Сотрудник (заготовитель)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalPacker(), ioId, inPersonalPackerId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.13                                        * add lpGetAccessKey
 07.10.13                                        * add lpCheckRight
 06.10.13                                        * add lfCheck_Movement_Parent
 30.09.13                                        * del zc_MovementLinkObject_PersonalDriver
 27.09.13                                        * del zc_MovementLinkObject_Car
 07.07.13                                        * rename zc_MovementFloat_ChangePercent
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
