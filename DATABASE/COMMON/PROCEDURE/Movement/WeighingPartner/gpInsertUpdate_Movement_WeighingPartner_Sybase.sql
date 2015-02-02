-- Function: gpInsertUpdate_Movement_WeighingPartner_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner_Sybase (Integer, Integer, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner_Sybase (Integer, Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingPartner_Sybase(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Документ родитель
    IN inInvNumber           TVarChar  , -- Номер
    IN inOperDate            TDateTime , -- Дата документа

    IN inStartWeighing       TDateTime , -- Протокол начало взвешивания
    IN inEndWeighing         TDateTime , -- Протокол окончание взвешивания

    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки

    IN inMovementDescId      TFloat    , -- Вид документа
    IN inInvNumberTransport  TFloat    , -- Номер путевого листа
    IN inWeighingNumber      TFloat    , -- Номер взвешивания

    IN inInvNumberOrder      TVarChar  , -- Номер заявки у контрагента 
    IN inPartionGoods        TVarChar  , -- Партия товара

    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContractId          Integer   , -- Договора
    IN inPaidKindId          Integer   , -- Форма оплаты
    IN inRouteSortingId      Integer   , -- Сортировки маршрутов
    IN inUserId              Integer   , -- Пользователь

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingPartner());

     -- определяем ключ доступа
     -- vbAccessKeyId:= ...;

     -- Меняем параметр
     IF COALESCE (inWeighingNumber, 0) = 0 THEN inWeighingNumber:= 1; END IF;

     -- определяем 
     IF inParentId < 0
     THEN
         vbInvNumber:= -1 * inParentId;
         inParentId:= 0;
     ELSE
         IF COALESCE (ioId, 0) = 0
         THEN
             vbInvNumber:= inInvNumber; -- CAST (NEXTVAL ('Movement_WeighingPartner_seq') AS TVarChar);
         ELSE
             vbInvNumber:= inInvNumber; -- (SELECT InvNumber FROM Movement WHERE Id = ioId);
         END IF;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- сохранили свойство <Протокол начало взвешиванияа>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, inStartWeighing);
     -- сохранили свойство <Протокол окончание взвешивания>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), ioId, inEndWeighing);
     
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
     -- сохранили свойство <Номер путевого листа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_InvNumberTransport(), ioId, inInvNumberTransport);
     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), ioId, inWeighingNumber);

     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Форма оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- сохранили связь с <Сортировки маршрутов>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RouteSorting(), ioId, inRouteSortingId);
     -- сохранили связь с <Пользователь>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, inUserId);


     -- пересчитали Итоговые суммы по накладной
     -- PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.10.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_WeighingPartner_Sybase (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
