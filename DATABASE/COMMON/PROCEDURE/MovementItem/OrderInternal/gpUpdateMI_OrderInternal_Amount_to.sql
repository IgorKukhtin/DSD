-- Function: gpUpdateMI_OrderInternal_Amount_to()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_to (Integer, Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount_to(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount              TFloat    , -- 
    IN inIsClear             Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    IF inIsClear = TRUE
    THEN
        -- обнулили
        UPDATE MovementItem SET Amount = 0 WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master();

        -- пересчитали Итоговые суммы по накладной
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSEIF inAmount > 0
    THEN

        -- проверка
        IF COALESCE (inGoodsId, 0) = 0
        THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Товар>.';
        END IF;
        -- проверка + временно захардкодил
        IF NOT EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_GoodsKind() AND MovementItemId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)) -- ЦЕХ колбаса+дел-сы
        THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Вид товара>.';
        END IF;

        -- сохранили
        UPDATE MovementItem SET Amount = inAmount WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.Id = inId;

        -- пересчитали Итоговые суммы по накладной
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.17                                        *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_to (inMovementId:= 7343799, inOperDate:= '31.10.2017', inSession:= zfCalc_UserAdmin());
