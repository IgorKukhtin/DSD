-- Function: gpUpdate_MI_GoodsSPSearch_1303_Goods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_Goods (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_Goods(
    IN inId                  Integer   ,    -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   ,    -- Идентификатор документа
    IN inGoodsId             Integer   ,    -- Главный товар
    IN inCol                 Integer   ,    -- Номер п.п.
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';    
    END IF;
    
    -- Провкряем элемент по документу
    IF EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId AND COALESCE (ObjectId, 0) = inGoodsId)
    THEN
        RAISE EXCEPTION 'Связь уже установлена.';
    END IF;    

    -- сохранили <Элемент документа>
    PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, inCol, NULL, zc_Enum_Process_Auto_PartionClose());

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.07.22                                                       *
*/
-- select * from gpUpdate_MI_GoodsSPSearch_1303_Goods(inId := 523696543 , inMovementId := 28341113 , inGoodsID := 12006218 , inCol := 6995 ,  inSession := '3');