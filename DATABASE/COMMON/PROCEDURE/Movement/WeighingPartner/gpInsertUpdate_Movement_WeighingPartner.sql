-- Function: gpInsertUpdate_Movement_WeighingPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, Integer, TDateTime, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingPartner (Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingPartner(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inOperDate             TDateTime , -- Дата документа
    IN inInvNumberOrder       TVarChar  , -- Номер заявки контрагента
    IN inInvNumberPartner     TVarChar  , -- Номер  контрагента
    IN inMovementDescId       Integer   , -- Вид документа
    IN inMovementDescNumber   Integer   , -- Код операции (взвешивание)
    IN inWeighingNumber       Integer   , -- Номер взвешивания
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inContractId           Integer   , -- Договор
    IN inPaidKindId           Integer   , -- Форма оплаты
    IN inPriceListId          Integer   , -- 
    IN inSubjectDocId         Integer   , -- 
    IN inMovementId_Order     Integer   , -- ключ Документа заявка
    IN inMovementId_Transport Integer   , -- ключ Документа
    IN inBranchCode           Integer   , -- 
    IN inPartionGoods         TVarChar  , -- Партия товара
    IN inChangePercent        TFloat    , -- (-)% Скидки (+)% Наценки
--    IN inChangePercentAmount  TFloat    , -- % скидки для кол-ва поставщика
    IN inComment              TVarChar  , --
    IN inIsProtocol           Boolean   , --
--    IN inIsReason1            Boolean   , -- Причина скидки в кол-ве температура 
--    IN inIsReason2            Boolean   , -- Причина скидки в кол-ве качество 
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer
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
     IF vbUserId = 6044123 -- Авто-Загрузка WMS
     THEN 
         vbAccessKeyId:= zc_Enum_Process_AccessKey_DocumentDnepr();
     ELSE
         vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Sale_Partner());
     END IF;

     IF COALESCE (ioId, 0) = 0
     THEN
         vbInvNumber:= CAST (NEXTVAL ('Movement_WeighingPartner_seq') AS TVarChar);
         vbParentId:= NULL;
         vbStartWeighing:= CURRENT_TIMESTAMP;
     ELSE
         SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = ioId;
     END IF;


     SELECT COALESCE (ObjectBoolean_PriceWithVAT.ValueData, FALSE) AS PriceWithVAT
          , ObjectFloat_VATPercent.ValueData                       AS VATPercent
            INTO vbPriceWithVAT, vbVATPercent
     FROM Object AS Object_PriceList
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                  ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                 AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
          LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                               AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
     WHERE Object_PriceList.Id = inPriceListId;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingPartner(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Протокол начало взвешивания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, vbStartWeighing);
     END IF;
     
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, vbPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, vbVATPercent);

     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
     -- сохранили свойство <Код операции (взвешивание)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), ioId, inMovementDescNumber);
     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), ioId, inWeighingNumber);

     -- сохранили свойство <Код Филиала>
     IF NOT EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = ioId AND MF.DescId = zc_MovementFloat_BranchCode())
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BranchCode(), ioId, inBranchCode);
     END IF;


     -- сохранили свойство <Номер контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили свойство <Номер заявки у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);
     -- сохранили свойство <Comment>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Форма оплаты>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     
     -- сохранили связь с <Основание для перемещения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);


     -- !!!только при создании!!!
     IF vbIsInsert = TRUE
     THEN
       -- сохранили связь с <Пользователь>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, vbUserId);
     END IF;

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);

     -- сохранили связь с документом <Transport>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Transport(), ioId, inMovementId_Transport);

     -- сохранили свойство <(-)% Скидки (+)% Наценки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили свойство <% скидки для кол-ва поставщика>
     -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercentAmount(), ioId, inChangePercentAmount);

     -- сохранили свойство <Причина скидки в кол-ве температура>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason1(), ioId, inIsReason1);

     -- сохранили свойство <Причина скидки в кол-ве качество>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Reason2(), ioId, inIsReason2);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     IF inIsProtocol = TRUE
     THEN
         PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.01.15                                        * all
 11.10.14                                        *
*/

-- SELECT lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), 2005096 , 8);
-- SELECT * FROM gpInsertUpdate_Movement_WeighingPartner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
