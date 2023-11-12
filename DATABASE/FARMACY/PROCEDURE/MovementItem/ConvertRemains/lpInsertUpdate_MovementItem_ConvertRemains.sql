-- Function: lpInsertUpdate_MovementItem_ConvertRemains()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ConvertRemains (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ConvertRemains(
 INOUT ioId                     Integer   ,    -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   ,    -- Идентификатор документа
    IN inNumber                 Integer   ,    -- № по порядку
    IN inGoodsId                Integer   ,    -- Товар

    IN inAmount                 TFloat    ,    -- Количество

    IN inPriceWithVAT           TFloat    ,    -- Цена с учетом НДС
    IN inVAT                    TFloat    ,    -- НДС

    IN inGoodsName              TVarChar  ,    -- Название товара
    IN inMeasure                TVarChar  ,    -- Единица измерения

    IN inComment                TVarChar  ,    -- Комментарий

    IN inUserId                 Integer        -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Number(), ioId, inNumber);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, inPriceWithVAT);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_VAT(), ioId, inVAT);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Measure(), ioId, inMeasure);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
 */