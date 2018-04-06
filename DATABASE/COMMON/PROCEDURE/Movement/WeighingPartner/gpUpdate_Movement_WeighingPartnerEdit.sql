-- Function: gpUpdate_Movement_WeighingPartnerEdit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartnerEdit (Integer, TDateTime, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartnerEdit(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inOperDate             TDateTime , -- Дата документа
    IN inPriceWithVAT         Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent           TFloat    , -- % НДС
    IN inChangePercent        TFloat    , -- (-)% Скидки (+)% Наценки
    IN inInvNumberOrder       TVarChar  , -- Номер заявки у контрагента 
    IN inMovementDescId       Integer   , -- Вид документа
    IN inMovementDescNumber   Integer   , -- Код операции (взвешивание)
    IN inWeighingNumber       Integer   , -- Номер взвешивания
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inContractId           Integer   , -- Договора
    IN inPaidKindId           Integer   , -- Форма оплаты
    IN inMovementId_Order     Integer   , -- ключ Документа заявка
    IN inMovementId_Transport Integer   , -- Документ путевой лист
    IN inParentId             Integer   , -- Главный Документ 
    IN inMemberId             Integer   , -- водитель/экспедитор
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbParentId  Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbStartWeighing TDateTime;
   DECLARE vbPriceWithVAT  Boolean;
   DECLARE vbVATPercent    TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     --vbUserId:= lpGetUserBySession (inSession);

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());

     SELECT InvNumber INTO vbInvNumber FROM Movement WHERE Id = inId;

     -- сохранили <Документ>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);
     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);


     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- сохранили свойство <Код операции (взвешивание)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);

     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);

     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- сохранили связь с <Форма оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), inId, inPaidKindId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), inId, inMemberId);


     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- сохранили связь с документом <Transport>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), inId, inMovementId_Transport);

     -- сохранили свойство <(-)% Скидки (+)% Наценки >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inId, inChangePercent);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);


     -- дописали zc_MovementFloat_GPSN + zc_MovementFloat_GPSE
     vbParentId:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inId);
     IF vbParentId > 0
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSN(), inId, COALESCE ((SELECT EXTRACT (DAY FROM Movement.OperDate) :: TFloat FROM Movement WHERE Movement.Id = vbParentId), 0));
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_GPSE(), inId, COALESCE ((SELECT EXTRACT (DAY FROM MovementDate.ValueData) :: TFloat FROM MovementDate WHERE MovementDate.MovementId = vbParentId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()), 0));
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.03.17         * add Member
 18.11.16         *
*/

-- тест
-- select * from gpUpdate_Movement_WeighingPartnerEdit(inId := 4316459 , inOperDate := ('31.08.2016')::TDateTime , inPriceWithVAT := '' , inVATPercent := 20 , inChangePercent := 0 , inInvNumberOrder := '***261779' , inMovementDescId := 0 , inMovementDescNumber := 16 , inWeighingNumber := 2 , inFromId := 133049 , inToId := 309292 , inContractId := 540132 , inPaidKindId := 3 , inMovementId_Order := 4314361 , inMovementId_Transport := 4297350 , inParentId := 4316461 ,  inSession := '5');
