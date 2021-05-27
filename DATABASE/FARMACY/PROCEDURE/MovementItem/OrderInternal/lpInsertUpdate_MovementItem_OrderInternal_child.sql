-- Function: lpInsertUpdate_MovementItem_OrderInternal_child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal_child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal_child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal_child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal_child(
 INOUT ioId                        Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inParentId                  Integer   , -- 
    IN inGoodsId                   Integer   , -- товар Поставщика
    IN inAmount                    TFloat    , -- 
    IN inPrice                     TFloat    , -- 
    IN inJuridicalPrice            TFloat    , -- 
    IN inDefermentPrice            TFloat    , -- 
    IN inPriceListMovementItemId   Integer   , -- 
    IN inPartionGoods              TDateTime , -- 
    IN inMaker                     TVarChar  , -- 
    IN inGoodsCode                 TVarChar  , -- 
    IN inGoodsName                 TVarChar  , -- 
    IN inJuridicalId               Integer   , --
    IN inContractId                Integer   , --
    IN inUserId                    Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


    -- проверка
    IF COALESCE (inParentId, 0) = 0
    THEN
        -- RETURN;
        RAISE EXCEPTION 'Ошибка. У элемента child значение ParentId не может быть 0.';
    END IF;


    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);

    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(), ioId, inJuridicalPrice);
        -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DefermentPrice(), ioId, inDefermentPrice);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inPriceListMovementItemId);

    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoods);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Maker(), ioId, inMaker);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsCode(), ioId, inGoodsCode);
    -- сохранили свойство
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);

     -- сохранили связь
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.04.19         * inDefermentPrice
 23.10.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_OrderInternal_child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')