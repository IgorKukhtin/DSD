-- Function: lpInsertUpdate_MovementItem_PromoPlan_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPlan_Master (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoPlan_Master(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inGoodsKindId           Integer   , -- ИД обьекта <Вид товара>
    IN inOperDate              TDateTime , --
    IN inAmount                TFloat    , -- 
    IN inAmountPartner         TFloat    , -- 
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);

    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.21         *
 */