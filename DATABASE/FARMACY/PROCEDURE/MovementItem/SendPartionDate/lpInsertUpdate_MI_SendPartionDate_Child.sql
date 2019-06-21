-- Function: gpInsertUpdate_MI_SendPartionDate_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_SendPartionDate_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
   -- IN inPartionDateKindId   Integer   , --
    IN inExpirationDate      TDateTime ,
    IN inPriceWithVAT        TFloat    , -- Цена закупки с НДС
    IN inAmount              TFloat    , -- Количество
    IN inContainerId         TFloat    , --
    IN inMovementId_Income   TFloat    , --
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

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Income);

    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindId);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);

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
 03.06.19         *
 03.04.19         *
*/