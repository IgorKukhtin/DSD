-- Function: gpInsertUpdate_MovementItem_ContractGoods()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ContractGoods (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ContractGoods(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inisBonusNo              Boolean   , -- нет начисления по бонусам
    IN inisSave                 Boolean   , -- cохранить да/нет
    IN inPrice                  TFloat    , --
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbWeight TFloat;
   DECLARE vbMeasureId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ContractGoods());

     --проверка если был сохранен а теперь сняли галку то удаляем, если и не был то пропускаем
     IF COALESCE (inisSave,FALSE) = FALSE
     THEN
         IF COALESCE (ioId,0) = 0 
         THEN 
             RETURN; 
         ELSE
             PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
             RETURN;
         END IF;
     END IF;

     --проверка если хотят удаленному поставить Сохранить Да то снимаем удаление
     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE) AND  COALESCE (inisSave,FALSE) = TRUE
     THEN
         PERFORM lpSetUnErased_MovementItem (inMovementItemId:= ioId, inUserId:= vbUserId);
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_ContractGoods (ioId           := ioId
                                                      , inMovementId   := inMovementId
                                                      , inGoodsId      := inGoodsId
                                                      , inGoodsKindId  := inGoodsKindId
                                                      , inisBonusNo    := inisBonusNo
                                                      , inPrice        := inPrice
                                                      , inComment      := inComment
                                                      , inUserId       := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         *
*/

-- тест
--