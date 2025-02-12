-- Function: lpInsertUpdate_MovementItem_PromoGoods()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);


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
    IN inAmountMarket          TFloat    , --Кол-во факт (маркет бюджет)
    IN inSummOutMarket         TFloat    , --Сумма факт кредит(маркет бюджет)
    IN inSummInMarket          TFloat    , --Сумма факт дебет(маркет бюджет)
    IN inGoodsKindId           Integer   , --ИД обьекта <Вид товара>
    IN inGoodsKindCompleteId   Integer   , --ИД обьекта <Вид товара (примечание)>
    IN inTradeMarkId                    Integer,  --Торговая марка
    IN inGoodsGroupPropertyId           Integer,
    IN inGoodsGroupDirectionId          Integer,
    IN inComment               TVarChar  , --Комментарий
    IN inUserId                Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- Проверили
    IF COALESCE (inGoodsKindId, 0) = 0 AND 1=1
       AND 1=0
       AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                               WHERE OL.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                        , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                        , zc_Enum_InfoMoney_30102() -- Тушенка
                                                         )
                              AND OL.DescId = zc_ObjectLink_Goods_InfoMoney()
                              AND OL.ObjectId = inGoodsId
                  )
    THEN
        -- RAISE EXCEPTION 'Ошибка. Необходимо заполнить колонку Вид (примечание), а значение вид товара = <%> должно быть пустым.', lfGet_Object_ValueData (inGoodsKindId);
        RAISE EXCEPTION 'Ошибка.Необходимо заполнить колонку вид товара.';
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

    -- сохранили <Кол-во факт (маркет бюджет)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountMarket(), ioId, inAmountMarket);
    -- сохранили <Сумма факт дебет(маркет бюджет) >
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummInMarket(), ioId, inSummInMarket);
    -- сохранили <Сумма факт кредит(маркет бюджет)>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummOutMarket(), ioId, inSummOutMarket);

    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
    -- сохранили связь с <Вид товара (примечание)> - может быть замена
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, CASE WHEN inGoodsKindId > 0 THEN inGoodsKindId ELSE inGoodsKindCompleteId END);

    --если товар выбран для inGoodsGroupPropertyId, inGoodsGroupDirectionId, inTradeMarkId - сохраняем знач. NULL
    --  а показываем свойства товара

    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_TradeMark(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inTradeMarkId ELSE NULL END ::Integer);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupProperty(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupPropertyId ELSE NULL END ::Integer);
    -- сохранили связь с <Вид товара>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsGroupDirection(), ioId, CASE WHEN COALESCE (inGoodsId,0) = 0 THEN inGoodsGroupDirectionId ELSE NULL END ::Integer);

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
 23.08.24         *
 07.08.24         *
 22.10.20         * inTaxRetIn
 14.07.20         * inOperPriceList
 24.01.18         * inPriceTender
 28.11.17         * inGoodsKindCompleteId
 13.10.15                                                                       *
 */
