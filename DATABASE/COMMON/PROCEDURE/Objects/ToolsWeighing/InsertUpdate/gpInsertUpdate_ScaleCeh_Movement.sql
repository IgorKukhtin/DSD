-- Function: gpInsertUpdate_ScaleCeh_Movement()

DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleCeh_Movement(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Вид документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inIsProductionIn      Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили
     inId:= gpInsertUpdate_Movement_WeighingProduction (ioId                  := inId
                                                      , inOperDate            := inOperDate
                                                      , inMovementDescId      := inMovementDescId
                                                      , inMovementDescNumber  := inMovementDescNumber
                                                      , inWeighingNumber      := COALESCE ((SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber()), 0) :: Integer
                                                      , inFromId              := inFromId
                                                      , inToId                := inToId
                                                      , inPartionGoods        := (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inId AND MovementString.DescId = zc_MovementString_PartionGoods())
                                                      , inIsProductionIn      := inIsProductionIn
                                                      , inSession             := inSession
                                                       );
     -- Результат
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
       FROM Movement
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ScaleCeh_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
