-- Function: gpInsert_Scale_Movement_all()

DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_Movement_all (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_Movement_all(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Вид документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContractId          Integer   , -- Договора
    IN inPaidKindId          Integer   , -- Форма оплаты
    IN inPriceListId         Integer   , -- 
    IN inMovementId_Order    Integer   , -- ключ Документа заявка
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTotalSumm TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили
     inId:= gpInsertUpdate_Movement_WeighingPartner (ioId                  := inId
                                                   , inOperDate            := inOperDate
                                                   , inInvNumberOrder      := CASE WHEN inMovementId_Order <> 0 THEN (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Order) ELSE '' END
                                                   , inMovementDescId      := inMovementDescId
                                                   , inMovementDescNumber  := inMovementDescNumber
                                                   , inWeighingNumber      := CASE WHEN inMovementDescId <> zc_Movement_Sale()
                                                                                        THEN 0
                                                                                   WHEN inId <> 0
                                                                                        THEN (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber())
                                                                                   ELSE 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat_WeighingNumber.ValueData, 0))
                                                                                                       FROM Movement
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                                                                                         AND MovementLinkObject_From.ObjectId = inFromId
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                                                                                         AND MovementLinkObject_To.ObjectId = inToId
                                                                                                            INNER JOIN MovementFloat AS MovementFloat_WeighingNumber
                                                                                                                                     ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                                                                                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                                                                                       WHERE Movement.DescId = zc_Movement_WeighingPartner() AND Movement.OperDate = inOperDate
                                                                                                      ), 0)
                                                                              END :: Integer
                                                   , inFromId              := inFromId
                                                   , inToId                := inToId
                                                   , inContractId          := inContractId
                                                   , inPriceListId         := inPriceListId
                                                   , inPaidKindId          := inPaidKindId
                                                   , inMovementId_Order    := inMovementId_Order
                                                   , inPartionGoods        := '' :: TVarChar
                                                   , inChangePercent       := inChangePercent
                                                   , inSession             := inSession
                                                    );

     -- Результат
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , MovementFloat_TotalSumm.ValueData AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.01.15                                        * all
*/

-- тест
-- SELECT * FROM gpInsert_Scale_Movement_all (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
