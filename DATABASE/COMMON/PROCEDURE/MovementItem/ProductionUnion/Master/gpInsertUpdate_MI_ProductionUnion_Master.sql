-- Function: gpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- Количество
    IN inCount	               TFloat    , -- Количество батонов
    IN inCuterWeight	       TFloat    , -- Фактический вес(куттера)
    IN inPartionGoodsDate      TDateTime , -- Партия товара
    IN inPartionGoods          TVarChar  , -- Партия товара 
 INOUT ioPartNumber            TVarChar  , -- № по тех паспорту 
 INOUT ioModel                 TVarChar  , -- модель
    IN inGoodsKindId           Integer   , -- Виды товаров
    IN inGoodsKindId_Complete  Integer   , -- Виды товаров ГП
    IN inStorageId             Integer   , -- Место хранения
    IN inPersonalId_KVK        Integer   , -- 
    IN inKVK                   TVarChar   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_ProductionUnion_Master (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inGoodsId             := inGoodsId
                                                  , inAmount              := inAmount
                                                  , inCount               := inCount
                                                  , inCuterWeight         := inCuterWeight
                                                  , inPartionGoodsDate    := inPartionGoodsDate
                                                  , inPartionGoods        := inPartionGoods
                                                  , inPartNumber          := ioPartNumber
                                                  , inModel               := ioModel
                                                  , inGoodsKindId         := inGoodsKindId
                                                  , inGoodsKindId_Complete:= inGoodsKindId_Complete
                                                  , inStorageId           := inStorageId
                                                  , inUserId              := vbUserId
                                                   );

     -- сохранили связь с <Оператор КВК(Ф.И.О)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalKVK(), ioId, inPersonalId_KVK);
     -- сохранили свойство <№ КВК>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_KVK(), ioId, inKVK);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.05.23         * inModel
 06.05.23         *
 26.10.20         * add inGoodsKindId_Complete
 29.06.16         * add inCuterWeight
 12.06.15                                        * add inPartionGoodsDate
 21.03.15                                        * all
 19.12.14                                                       * add zc_MILinkObject_???GoodsKindComplete
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Master

 24.07.13                                        * Важен порядок полей
 22.07.13         * add GoodsKind
 17.07.13         *
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
