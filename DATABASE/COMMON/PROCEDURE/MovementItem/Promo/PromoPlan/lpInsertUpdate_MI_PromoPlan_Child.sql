-- Function: lpInsertUpdate_MovementItem_PromoPlan_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPlan_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoPlan_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoPlan_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inParentId              Integer   , -- Главный элемент документа
    IN inGoodsId               Integer   , -- Товары
    IN inGoodsKindId           Integer   , -- ИД обьекта <Вид товара>
    IN inReceiptId             Integer   , --
    IN inReceiptId_parent      Integer   , --
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId, inUserId);

    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

    -- сохранили связь с <рецептуры>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, inReceiptId);
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, inReceiptId_parent);


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
 05.11.21         *
 */