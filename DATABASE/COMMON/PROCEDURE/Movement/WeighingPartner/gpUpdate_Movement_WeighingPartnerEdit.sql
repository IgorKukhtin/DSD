-- Function: gpUpdate_Movement_WeighingPartnerEdit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, TDateTime, TDateTime, Boolean, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartnerEdit(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inOperDate             TDateTime , -- Дата документа

    IN inStartWeighing        TDateTime , -- Протокол начало взвешивания
    IN inEndWeighing          TDateTime , -- Протокол окончание взвешивания

    IN inPriceWithVAT         Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent           TFloat    , -- % НДС
    IN inChangePercent        TFloat    , -- (-)% Скидки (+)% Наценки

    IN inInvNumberOrder      TVarChar  , -- Номер заявки у контрагента 
    IN inPartionGoods        TVarChar  , -- Партия товара
  --  IN inMovementDescId       Integer   , -- Вид документа
  --  IN inMovementDescNumber   Integer   , -- Код операции (взвешивание)
    IN inWeighingNumber       Integer   , -- Номер взвешивания
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inContractId           Integer   , -- Договора
    IN inPaidKindId           Integer   , -- Форма оплаты
    IN inMovementId_Order     Integer   , -- ключ Документа заявка
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
   DECLARE vbPriceWithVAT  Boolean;
   DECLARE vbVATPercent    TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = inId;

     -- сохранили <Документ>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     -- сохранили свойство <Протокол начало взвешиванияа>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), inId, inStartWeighing);
     -- сохранили свойство <Протокол окончание взвешивания>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndWeighing(), inId, inEndWeighing);
     
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);


/*
     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- сохранили свойство <Код операции (взвешивание)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);
*/
     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inId, inPartionGoods);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);

     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- сохранили связь с <Форма оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), inId, inPaidKindId);

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- сохранили связь с документом <Transport>
     --PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.11.16         *
*/

-- тест
--