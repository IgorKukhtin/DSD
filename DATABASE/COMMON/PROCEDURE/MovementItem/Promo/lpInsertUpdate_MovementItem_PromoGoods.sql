-- Function: lpInsertUpdate_MovementItem_PromoGoods()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inAmount                TFloat    , -- % скидки на товар
    IN inPrice                 TFloat    , -- Цена в прайсе учетом скидки 
    IN inOperPriceList         TFloat    , -- Цена в прайсе
    IN inPriceSale             TFloat    , -- Цена на полке
    IN inPriceWithOutVAT       TFloat    , -- Цена отгрузки без учета НДС, с учетом скидки, грн
    IN inPriceWithVAT          TFloat    , -- Цена отгрузки с учетом НДС, с учетом скидки, грн
    IN inPriceTender           TFloat    , -- Цена Тендер без учета НДС, с учетом скидки, грн
    IN inCountForPrice         TFloat    , -- относится ко всем ценам
    IN inAmountReal            TFloat    , -- Объем продаж в аналогичный период, кг
    IN inAmountPlanMin         TFloat    , -- Минимум планируемого объема продаж на акционный период (в кг)
    IN inAmountPlanMax         TFloat    , -- Максимум планируемого объема продаж на акционный период (в кг)
    IN inTaxRetIn              TFloat    , -- % возврата
    IN inGoodsKindId           Integer   , --ИД обьекта <Вид товара>
    IN inGoodsKindCompleteId   Integer   , --ИД обьекта <Вид товара (примечание)>
    IN inComment               TVarChar  , --Комментарий
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- Проверили
    IF inGoodsKindId <> 0
    THEN
        RAISE EXCEPTION 'Ошибка. Необходимо заполнить колонку Вид (примечание), а значение вид товара = <%> должно быть пустым.', lfGet_Object_ValueData (inGoodsKindId);
    END IF;


    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL, inUserId);
    
    -- сохранили <цена в прайсе> без учета % скидки (договор)
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, COALESCE(inOperPriceList,0));

    -- сохранили <цена в прайсе> c учетом % скидки (договор)
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE(inPrice,0));

    -- сохранили <цена на полке>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, COALESCE(inPriceSale,0));
    
    -- сохранили <Цена отгрузки без учета НДС, с учетом скидки, грн>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithOutVAT(), ioId, COALESCE(inPriceWithOutVAT,0));
    
    -- сохранили <Цена отгрузки с учетом НДС, с учетом скидки, грн>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceWithVAT(), ioId, COALESCE(inPriceWithVAT,0));
    
    -- сохранили <Цена Тендер без учета НДС, с учетом скидки, грн>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTender(), ioId, COALESCE(inPriceTender,0));
    
    -- сохранили <CountForPrice>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
        
    -- !!теперь будет расчет!!! сохранили <Объем продаж в аналогичный период, кг>
    -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReal(), ioId, COALESCE(inAmountReal,0));
    
    -- сохранили <Минимум планируемого объема продаж на акционный период (в кг)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMin(), ioId, COALESCE(inAmountPlanMin,0));
    
    -- сохранили <Максимум планируемого объема продаж на акционный период (в кг)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPlanMax(), ioId, COALESCE(inAmountPlanMax,0));

    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    -- сохранили связь с <Вид товара (примечание)>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

    -- сохранили <Комментарий>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

    -- сохраняем % Возврат для всех товаров
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxRetIn(), MovementItem.Id, inTaxRetIn)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.ObjectId = inGoodsId;

    -- сохранили протокол
    IF inUserId > 0 THEN 
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
    ELSE
      PERFORM lpInsert_MovementItemProtocol (ioId, zc_Enum_Process_Auto_ReComplete(), vbIsInsert);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.10.20         * inTaxRetIn
 14.07.20         * inOperPriceList
 24.01.18         * inPriceTender
 28.11.17         * inGoodsKindCompleteId
 13.10.15                                                                       *
 */