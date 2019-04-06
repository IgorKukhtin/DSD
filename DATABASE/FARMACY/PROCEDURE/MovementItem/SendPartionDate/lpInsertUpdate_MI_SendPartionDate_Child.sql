-- Function: gpInsertUpdate_MI_SendPartionDate_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDate_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inExpirationDate      TDateTime ,
    IN inAmount              TFloat    , -- Количество
    IN inContainerId         TFloat    , -- 
    IN inExpired             TFloat    , -- 
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);
    
    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Expired(), ioId, inExpired);

    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    
    -- пересчитали Итоговые суммы по накладной
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- сохранили протокол
    --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/