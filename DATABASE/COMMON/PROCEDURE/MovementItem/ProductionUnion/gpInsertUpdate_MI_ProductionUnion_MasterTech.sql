-- Function: gpInsertUpdate_MI_ProductionUnion_MasterTech()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_MasterTech  (Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_MasterTech  (Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_MasterTech  (Integer, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_MasterTech(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
--    IN inMovementId          Integer   , -- Ключ объекта <Документ>
--    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsId             Integer   , -- Товары
--    IN inAmount              TFloat    , -- Количество
--    IN inPartionClose	     Boolean   , -- партия закрыта (да/нет)
    IN inCount	             TFloat    , -- Количество батонов или упаковок
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inCuterCount          TFloat    , -- Количество кутеров
--    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inComment             TVarChar  , -- Комментарий
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsCompleteKindId Integer   , -- Виды товаров  ГП
    IN inReceiptId           Integer   , -- Рецептуры
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbOperDate TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());
   vbMovementId = COALESCE ((SELECT MovementId FROM MovementItem WHERE MovementItem.Id = ioId), 0);
   vbOperDate   = COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId), inOperDate);
   vbAmount = inCuterCount * 100;
      -- сохранили <Документ>
   vbMovementId := lpInsertUpdate_Movement (ioId               := vbMovementId
                                          , inDescid           := zc_Movement_ProductionUnion()
                                          , inInvNumber        := COALESCE ((SELECT InvNumber FROM Movement WHERE Movement.Id = vbMovementId), '')
                                          , inOperDate         := vbOperDate
                                          , inParentId         := NULL);

   -- сохранили связь с <От кого (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), vbMovementId, inFromId);
   -- сохранили связь с <Кому (в документе)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), vbMovementId, inToId);
   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
   -- сохранили протокол
   -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);


   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := vbMovementId--inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := vbAmount
                                                  , inPartionClose     := COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE MovementItemId = ioId AND DescId = zc_MIBoolean_PartionClose()), False)--inPartionClose
                                                  , inCount            := inCount
                                                  , inRealWeight       := inRealWeight
                                                  , inCuterCount       := inCuterCount
                                                  , inPartionGoods     := COALESCE ((SELECT ValueData FROM MovementItemString WHERE MovementItemId = ioId AND DescId = zc_MIString_PartionGoods()), '')--inPartionGoods
                                                  , inComment          := inComment
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inGoodsCompleteKindId := inGoodsCompleteKindId
                                                  , inReceiptId        := inReceiptId
                                                  , inUserId           := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.12.14                                                       * add zc_MILinkObject_GoodsKindComplete
 12.12.14                                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_MasterTech (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')