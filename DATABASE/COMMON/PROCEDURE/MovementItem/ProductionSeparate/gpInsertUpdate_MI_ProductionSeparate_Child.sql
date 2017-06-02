-- Function: gpInsertUpdate_MI_ProductionSeparate_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - разделение>
    IN inParentId            Integer   , -- Главный элемент документа
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
   ioId :=lpInsertUpdate_MI_ProductionSeparate_Child (ioId               := ioId
                                                    , inMovementId       := inMovementId
                                                    , inParentId         := inParentId
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
 11.03.17         *
 11.06.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Child(ioId := 71593051 , inMovementId := 5264082 , inParentId := 0 , inGoodsId := 4261 , inGoodsKindId := 0 , inStorageLineId := 0 , inAmount := 157.6 , inLiveWeight := 0 , inHeadCount := 0 ,  inSession := '5');
