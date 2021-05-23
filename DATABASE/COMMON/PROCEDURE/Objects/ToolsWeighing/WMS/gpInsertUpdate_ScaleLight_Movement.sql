-- Function: gpInsertUpdate_ScaleLight_Movement()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleLight_Movement (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleLight_Movement (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleLight_Movement(
    IN inId                  BigInt    , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Вид документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsTypeKindId_1   Integer   , -- Признак - 1-ая линия
    IN inGoodsTypeKindId_2   Integer   , -- Признак - 2-ая линия
    IN inGoodsTypeKindId_3   Integer   , -- Признак - 3-ья линия
    IN inBarCodeBoxId_1      Integer   , -- Id для Ш/К ящика
    IN inBarCodeBoxId_2      Integer   , -- Id для Ш/К ящика
    IN inBarCodeBoxId_3      Integer   , -- Id для Ш/К ящика
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inGoodsId_sh          Integer   , -- 
    IN inGoodsKindId_sh      Integer   , -- 
    IN inBranchCode          Integer   , -- 
    IN inPlaceNumber         Integer   , -- номер рабочего места
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id        Integer
          -- , Id        BigInt
             , InvNumber TVarChar
             , OperDate  TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDocumentKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);

-- if vbUserId = 5
-- then
-- RAISE EXCEPTION 'Ошибка.ok';
-- end if;

     -- сохранили
     inId:= gpInsertUpdate_wms_Movement_WeighingProduction (ioId                  := inId
                                                       -- , inInvNumber           := inInvNumber
                                                          , inOperDate            := inOperDate - INTERVAL '0 DAY'
                                                       -- , inStartWeighing       := inStartWeighing
                                                       -- , inEndWeighing         := inEndWeighing
                                                          , inMovementDescId      := inMovementDescId
                                                          , inMovementDescNumber  := inMovementDescNumber
                                                          , inPlaceNumber         := inPlaceNumber
                                                          , inFromId              := inFromId
                                                          , inToId                := inToId
                                                          , inGoodsTypeKindId_1   := inGoodsTypeKindId_1
                                                          , inGoodsTypeKindId_2   := inGoodsTypeKindId_2
                                                          , inGoodsTypeKindId_3   := inGoodsTypeKindId_3
                                                          , inBarCodeBoxId_1      := inBarCodeBoxId_1
                                                          , inBarCodeBoxId_2      := inBarCodeBoxId_2
                                                          , inBarCodeBoxId_3      := inBarCodeBoxId_3
                                                          , inGoodsId             := inGoodsId
                                                          , inGoodsKindId         := inGoodsKindId
                                                          , inGoodsId_sh          := inGoodsId_sh
                                                          , inGoodsKindId_sh      := inGoodsKindId_sh
                                                          , inSession             := inSession
                                                           );
     -- Результат
     RETURN QUERY
       SELECT Movement.Id :: Integer
            , Movement.InvNumber
            , Movement.OperDate
       FROM wms_Movement_WeighingProduction AS Movement
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
-- SELECT * FROM gpInsertUpdate_ScaleLight_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
