-- Function: gpInsertUpdate_MovementItem_LossAsset()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossAsset(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- Количество
    IN inSumm                  TFloat    , -- сумма услуги
    IN inContainerId           Integer   , -- Партия ОС 
    IN inStorageId           Integer   , -- Место хранения
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossAsset());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_LossAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inSumm        := inSumm
                                                  , inContainerId := inContainerId 
                                                  , inStorageId   := inStorageId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.23         *
 18.06.20         *
*/

-- тест
--