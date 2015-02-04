-- Function: gpInsert_Scale_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (MovementId_begin    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE MovementId_begin Integer;
   DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет данных для документа.';
     END IF;

     -- определили <Тип документа>
     vbMovementDescId:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_MovementDesc()) :: Integer;


     IF vbMovementDescId = zc_Movement_Sale()
     THEN
          -- поиск существующего документа <Продажа покупателю> по Заявке
          MovementId_begin:= (SELECT Movement.Id
                              FROM MovementLinkMovement
                                   INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                   ON MovementLinkMovement_Order.MovementChildId = MovementLinkMovement.MovementChildId
                                                                  AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                   INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                      AND Movement.DescId = zc_Movement_Sale()
                                                      AND Movement.OperDate = inOperDate
                                                      AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                              WHERE MovementLinkMovement.MovementId = inMovementId
                                AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order());

          IF COALESCE (MovementId_begin, 0) = 0
          THEN
              -- сохранили Документ
              MovementId_begin:= (SELECT lpInsertUpdate_Movement_Sale_Value(
                                                    ioId                    := 0
                                                  , inInvNumber             := CAST (NEXTVAL ('movement_sale_seq') AS TVarChar)
                                                  , inInvNumberPartner      := ''
                                                  , inInvNumberOrder        := InvNumberOrder
                                                  , inOperDate              := inOperDate
                                                  , inOperDatePartner       := (inOperDate + (COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime
                                                  , inChecked               := NULL
                                                  , inChangePercent         := ChangePercent
                                                  , inFromId                := FromId
                                                  , inToId                  := ToId
                                                  , inPaidKindId            := PaidKindId
                                                  , inContractId            := ContractId
                                                  , inRouteSortingId        := NULL
                                                  , inCurrencyDocumentId    := NULL
                                                  , inCurrencyPartnerId     := NULL
                                                  , inMovementId_Order      := MovementId_Order
                                                  , ioPriceListId           := NULL
                                                  , ioCurrencyPartnerValue  := NULL
                                                  , ioParPartnerValue       := NULL
                                                  , inUserId                := vbUserId
                                                   )
                                             FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession) AS tmp
                                                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                                                        ON ObjectFloat_Partner_DocumentDayCount.ObjectId = tmp.ToId
                                                                       AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
                                 );
          ELSE
              -- Распроводим Документ !!!существующий!!!
              PERFORM lpUnComplete_Movement (inMovementId := MovementId_begin
                                           , inUserId     := vbUserId);

          END IF;

          -- строчная часть

          -- создаются временные таблицы - для формирование данных для проводок
          PERFORM lpComplete_Movement_Sale_CreateTemp();
          -- Проводим Документ
          PERFORM lpComplete_Movement_Sale (inMovementId     := MovementId_begin
                                          , inUserId         := vbUserId
                                          , inIsLastComplete := NULL);

     ELSE
         RAISE EXCEPTION 'Ошибка.Нельзя сохранить данный тип документа.';
     END IF;


     -- финиш - сохранили <Документ>
     PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, inOperDate, MovementId_begin, Movement.AccessKeyId)
     FROM Movement
     WHERE Id =inMovementId ;

     -- финиш - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_WeighingPartner()
                                , inUserId     := vbUserId
                                 );

     -- Результат
     RETURN QUERY
       SELECT MovementId_begin;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.02.15                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Scale_Movement_all (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
