-- Function: gpInsertUpdate_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoGoods(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inGoodsId              Integer   , -- Товары
    IN inAmount               TFloat    , -- % скидки на товар
 INOUT ioPrice                TFloat    , -- Цена в прайсе с учетом скидки по договору
 INOUT ioOperPriceList        TFloat    , -- Цена в прайсе
    IN inPriceSale            TFloat    , -- Цена на полке
   OUT outPriceWithOutVAT     TFloat    , -- Цена отгрузки без учета НДС, с учетом скидки, грн
   OUT outPriceWithVAT        TFloat    , -- Цена отгрузки с учетом НДС, с учетом скидки, грн
    IN inPriceTender          TFloat    , -- Цена Тендер без учета НДС, с учетом скидки, грн
    IN ioCountForPrice        TFloat    , -- относится ко всем ценам
    IN inAmountReal           TFloat    , -- Объем продаж в аналогичный период, кг
   OUT outAmountRealWeight    TFloat    , -- Объем продаж в аналогичный период, кг Вес
    IN inAmountPlanMin        TFloat    , -- Минимум планируемого объема продаж на акционный период (в кг)
   OUT outAmountPlanMinWeight TFloat    , -- Минимум планируемого объема продаж на акционный период (в кг) вес
    IN inAmountPlanMax        TFloat    , -- Максимум планируемого объема продаж на акционный период (в кг)
   OUT outAmountPlanMaxWeight TFloat    , -- Максимум планируемого объема продаж на акционный период (в кг) Вес
 INOUT ioTaxRetIn             TFloat    , -- % возвратa
    IN inGoodsKindId          Integer   , -- ИД обьекта <Вид товара>
 INOUT ioGoodsKindCompleteId  Integer   , -- ИД обьекта <Вид товара (примечание)>
   OUT outGoodsKindCompleteName TVarChar, -- 
    IN inComment              TVarChar  , -- Комментарий
    IN inSession              TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceList Integer;
   DECLARE vbPriceWithWAT Boolean;
   DECLARE vbVAT TFloat;
   DECLARE vbChangePercent TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;


    -- замена
    IF COALESCE (ioCountForPrice, 0) <= 0 THEN ioCountForPrice:= 1; END IF;


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- Проверили inPriceTender
    IF inPriceTender <> 0 AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка. Значение <Цена Тендер> не может быть введено для документа с признаком <Акция>.';
    END IF;


    -- Проверили уникальность товар/вид товара
    IF EXISTS (SELECT 1
               FROM MovementItem_PromoGoods_View AS MI_PromoGoods
               WHERE MI_PromoGoods.MovementId                          = inMovementId
                   AND MI_PromoGoods.GoodsId                           = inGoodsId
                   AND COALESCE (MI_PromoGoods.GoodsKindId, 0)         = COALESCE (inGoodsKindId, 0)
                   AND COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) = COALESCE (ioGoodsKindCompleteId, 0)
                   AND MI_PromoGoods.Id                        <> COALESCE(ioId, 0)
                   AND MI_PromoGoods.isErased                  = FALSE
              )
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже указана скидка для товара = <%> и вид = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
    END IF;

    -- поиск прайс-лист
    SELECT COALESCE (Movement_Promo.PriceListId, zc_PriceList_Basis())
         , COALESCE (Movement_Promo.ChangePercent, 0)
           INTO vbPriceList, vbChangePercent
    FROM Movement_Promo_View AS Movement_Promo
    WHERE Movement_Promo.Id = inMovementId;

    -- получение данных прайс-лист "с НДС" и "значение НДС"
    SELECT PriceList.PriceWithVAT, PriceList.VATPercent
           INTO vbPriceWithWAT, vbVAT
    FROM gpGet_Object_PriceList(vbPriceList,inSession) AS PriceList;

    -- поиск цены по базовому прайсу
    IF COALESCE (ioOperPriceList, 0) = 0 OR COALESCE (ioId, 0) = 0
    THEN
         --
         IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('tmpPriceList'))
         THEN
             DELETE FROM tmpPriceList;
         ELSE
             -- таблица -  Цены из прайса
             CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         END IF;
         --
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList, inOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId)) AS lfSelect;

       ioOperPriceList := COALESCE ((SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId = CASE WHEN inGoodsKindId > 0 THEN inGoodsKindId ELSE ioGoodsKindCompleteId END)
                          , (SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId IS NULL)
                          ,0);

        /*SELECT Price.ValuePrice
               INTO ioOperPriceList
        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList
                                                 , inOperDate   := (SELECT OperDate FROM Movement WHERE Id = inMovementId)
                                                  ) AS Price
        WHERE Price.GoodsId = inGoodsId;
        */

        IF ioCountForPrice > 1
        THEN
            -- Если необходимо - привести цену к цене без НДС
            IF vbPriceWithWAT = TRUE
            THEN
                ioOperPriceList := ROUND (ioOperPriceList / (vbVAT / 100.0 + 1), 4);
            END IF;

            -- цену прайса с учетом скидки по дог.
            ioPrice := ROUND (ioOperPriceList * (1 + vbChangePercent/100.0), 4);

        ELSE
            -- Если необходимо - привести цену к цене без НДС
            IF vbPriceWithWAT = TRUE
            THEN
                ioOperPriceList := ROUND (ioOperPriceList / (vbVAT / 100.0 + 1), 2);
            END IF;

            -- цену прайса с учетом скидки по дог.
            ioPrice := ROUND (ioOperPriceList * (1 + vbChangePercent/100.0), 2);

        END IF;

    END IF;

    -- Так для Тендера
    IF inPriceTender > 0
    THEN
        -- расчитать <Цена отгрузки без учета НДС, с учетом скидки, грн>
        outPriceWithOutVAT := ROUND(inPriceTender, 2) + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_PriceCorr()), 0);
        -- расчитать <Цена отгрузки с учетом НДС, с учетом скидки, грн>
        outPriceWithVAT := ROUND (outPriceWithOutVAT * (1 + vbVAT / 100.0) ,2);
    ELSE
        IF ioCountForPrice > 1
        THEN
            -- расчитать <Цена отгрузки без учета НДС, с учетом скидки, грн>
            outPriceWithOutVAT := ROUND (ioPrice - COALESCE (ioPrice * inAmount / 100.0), 2) + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_PriceCorr()), 0);
            -- расчитать <Цена отгрузки с учетом НДС, с учетом скидки, грн>
            outPriceWithVAT := ROUND (outPriceWithOutVAT * (1 + vbVAT / 100.0), CASE WHEN ioCountForPrice = 10 THEN 1 ELSE 0 END);
            -- еще раз расчитать <Цена отгрузки без учета НДС, с учетом скидки, грн>
            outPriceWithOutVAT := ROUND (outPriceWithOutVAT / (1 + vbVAT / 100.0), 4) + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_PriceCorr()), 0);
        ELSE
            -- расчитать <Цена отгрузки без учета НДС, с учетом скидки, грн>
            outPriceWithOutVAT := ROUND (ioPrice - COALESCE (ioPrice * inAmount / 100.0), 2) + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_PriceCorr()), 0);
            -- расчитать <Цена отгрузки с учетом НДС, с учетом скидки, грн>
            outPriceWithVAT := ROUND (outPriceWithOutVAT * (1 + vbVAT / 100.0), 2);
        END IF;

    END IF;


    -- расчитать весовые показатели
    SELECT inAmountPlanMin * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
         , inAmountPlanMax * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
         , inAmountReal    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
           INTO outAmountPlanMinWeight
              , outAmountPlanMaxWeight
              , outAmountRealWeight
    FROM ObjectLink AS ObjectLink_Goods_Measure
         LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                     ON ObjectFloat_Goods_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                                    AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
    WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure();

    -- Если % Возврата пусто пробуем найти у аналогичного товара
    IF COALESCE (ioTaxRetIn,0) = 0 AND COALESCE (ioId, 0) = 0
    THEN
        ioTaxRetIn := COALESCE ((SELECT COALESCE (MIFloat_TaxRetIn.ValueData,0) ::TFloat AS TaxRetIn
                                 FROM MovementItem
                                      INNER JOIN MovementItemFloat AS MIFloat_TaxRetIn
                                                                   ON MIFloat_TaxRetIn.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_TaxRetIn.DescId         = zc_MIFloat_TaxRetIn()
                                                                  AND MIFloat_TaxRetIn.ValueData      <> 0
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.ObjectId = inGoodsId
                                 LIMIT 1
                                ), 0);
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_PromoGoods (ioId                   := ioId
                                                  , inMovementId           := inMovementId
                                                  , inGoodsId              := inGoodsId
                                                  , inAmount               := inAmount
                                                  , inPrice                := ioPrice
                                                  , inOperPriceList        := ioOperPriceList
                                                  , inPriceSale            := inPriceSale
                                                  , inPriceWithOutVAT      := outPriceWithOutVAT
                                                  , inPriceWithVAT         := outPriceWithVAT
                                                  , inPriceTender          := inPriceTender
                                                  , inCountForPrice        := ioCountForPrice
                                                  , inAmountReal           := inAmountReal
                                                  , inAmountPlanMin        := inAmountPlanMin
                                                  , inAmountPlanMax        := inAmountPlanMax
                                                  , inTaxRetIn             := ioTaxRetIn
                                                  , inGoodsKindId          := inGoodsKindId
                                                  , inGoodsKindCompleteId  := ioGoodsKindCompleteId
                                                  , inComment              := inComment
                                                  , inUserId               := vbUserId
                                                   );

     -- сохранили <Элемент> - Состояние Акции
     IF NOT EXISTS (SELECT 1 FROM MovementItem AS MI JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoStateKind() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message())
     THEN
         PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId               := 0
                                                         , inMovementId       := inMovementId
                                                         , inPromoStateKindId := zc_Enum_PromoStateKind_Start()
                                                         , inIsQuickly        := FALSE
                                                         , inComment          := ''
                                                         , inSession          := inSession
                                                          );
     END IF;

    -- вернули данные
    SELECT MILO_GoodsKindComplete.ObjectId    AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ValueData AS GoodsKindCompleteName
           INTO ioGoodsKindCompleteId
              , outGoodsKindCompleteName
    FROM MovementItemLinkObject AS MILO_GoodsKindComplete
         LEFT OUTER JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
    WHERE MILO_GoodsKindComplete.MovementItemId = ioId
      AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 24.01.18         * inPriceTender
 28.11.17         * ioGoodsKindCompleteId
 25.11.15                                                                         * Comment
 13.10.15                                                                         *
*/