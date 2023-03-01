-- Function: lpInsertUpdate_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- Товары
    IN inPriceOptSP           TFloat  ,
    IN inPriceSale            TFloat  ,
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inPriceSale, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceOptSP(), ioId, inPriceOptSP);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
 */