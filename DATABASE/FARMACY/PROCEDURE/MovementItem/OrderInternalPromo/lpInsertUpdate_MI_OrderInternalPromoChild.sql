-- Function: lpInsertUpdate_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_OrderInternalPromoChild(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение
    IN inAmount              TFloat    , -- Количество из мастера
    IN inAmountManual        TFloat    , -- Количество, ручной ввод
    IN inAmountOut           TFloat    , -- Факт продаж по аптекам за период с StartSale по Movement.OperDate
    IN inRemains             TFloat    , -- остаток
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Child()
                AND MovementItem.ParentId = inParentId
                AND MovementItem.ObjectId = inUnitId
                AND MovementItem.ID <> COALESCE (ioId, 0))
    THEN
         RAISE EXCEPTION 'Ошибка. Распределение по строке и подразделению уже создано...';
    END IF;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);
    
    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOut(), ioId, inAmountOut);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Remains(), ioId, inRemains);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioId, inAmountManual);
    
    -- сохранили протокол
    --PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.19         *
 */