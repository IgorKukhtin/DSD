-- Function: gpInsertUpdate_MI_ProductionSeparate_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionSeparate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - разделение>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inGoodsId             Integer   , -- Товары
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
 11.06.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inHeadCount:= 1, inComment:= '', inSession:= '2')
