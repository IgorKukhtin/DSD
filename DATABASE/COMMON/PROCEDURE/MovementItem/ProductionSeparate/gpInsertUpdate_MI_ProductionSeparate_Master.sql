-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Master (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inStorageLineId       Integer   , -- линия пр-ва
    IN inAmount              TFloat    , -- Количество
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов	           
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionSeparate());

   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_ProductionSeparate_Master (ioId               := ioId
                                                     , inMovementId       := inMovementId
                                                     , inGoodsId          := inGoodsId
                                                     , inGoodsKindId      := inGoodsKindId
                                                     , inStorageLineId    := inStorageLineId
                                                     , inAmount           := inAmount
                                                     , inLiveWeight       := inLiveWeight
                                                     , inHeadCount        := inHeadCount
                                                     , inUserId           := vbUserId
                                                      );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.17         *
 11.06.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Master(ioId := 71587375 , inMovementId := 5264082 , inGoodsId := 5225 , inGoodsKindId := 8331 , inStorageLineId := 0 , inAmount := 0.2 , inLiveWeight := 0 , inHeadCount := 0 ,  inSession := '5');
