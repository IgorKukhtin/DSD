-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIComdoc (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIComdoc(
    IN inOrderInvNumber      TVarChar  , -- Номер заявки контрагента
    IN inOrderOperDate       TDateTime , -- Дата заявки контрагента
    IN inPartnerInvNumber    TVarChar  , -- Номер накладной у контрагента
    IN inPartnerOperDate     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberTax        TVarChar  , -- Номер накладной у контрагента
    IN inOperDateTax         TDateTime , -- Дата накладной у контрагента
    IN inOKPO                TVarChar  , -- 
    IN inJurIdicalName       TVarChar  , --
    IN inDesc                TVarChar  , -- тип документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyId Integer) -- Классификатор товаров
AS
$BODY$
   DECLARE vbMovementId      Integer;
   DECLARE vbGoodsPropertyId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
   DECLARE vbDescCode TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDIComdoc());
     vbUserId:= lpGetUserBySession (inSession);

     -- Поиск документа в журнале EDI
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementString AS MovementString_OKPO
                                                    ON MovementString_OKPO.MovementId =  Movement.Id
                                                   AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                   AND MovementString_OKPO.ValueData = inOKPO
                     WHERE Movement.DescId = zc_Movement_EDI() 
                       AND Movement.InvNumber = inOrderInvNumber
                       AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                    );

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementId, 0) = 0;

     IF COALESCE (vbMovementId, 0) = 0
     THEN
          -- сохранили <Документ>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
          -- сохранили <ОКПО>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, inOKPO);

     END IF;

     -- сохранили
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId, inPartnerOperDate);
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), vbMovementId, inPartnerInvNumber);

     -- сохранили
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateTax(), vbMovementId, inOperDateTax);
     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberTax(), vbMovementId, inInvNumberTax);

     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JurIdicalName(), vbMovementId, inJurIdicalName);

     IF inDesc = 'Sale' THEN
        SELECT MovementDesc.Code INTO vbDescCode FROM MovementDesc WHERE Id = zc_Movement_Sale();
     ELSE
        SELECT MovementDesc.Code INTO vbDescCode FROM MovementDesc WHERE Id = zc_Movement_ReturnIn();
     END IF;   

     -- сохранили
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, vbDescCode);

     -- сохранили расчетные параметры
     vbGoodsPropertyId:= lpUpdate_Movement_EDIComdoc_Params (inMovementId    := vbMovementId
                                                           , inSaleOperDate  := inPartnerOperDate
                                                           , inOrderInvNumber:= inOrderInvNumber
                                                           , inOKPO          := inOKPO
                                                           , inUserId        := vbUserId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

     -- сохранили протокол
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId, 'Загрузка COMDOC из EDI', vbUserId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);

     -- Результат
     RETURN QUERY 
     SELECT vbMovementId, vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.14                                        * ALL
 29.05.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
