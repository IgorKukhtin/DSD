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
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


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
    IN inAmountMarket         TFloat    , --Кол-во факт (маркет бюджет)
    IN inSummOutMarket        TFloat    , --Сумма факт кредит(маркет бюджет)
    IN inSummInMarket         TFloat    , --Сумма факт дебет(маркет бюджет) 
 INOUT ioGoodsKindId          Integer   , -- ИД обьекта <Вид товара>
   OUT outGoodsKindName       TVarChar  , -- 
 INOUT ioGoodsKindCompleteId  Integer   , -- ИД обьекта <Вид товара (примечание)>
   OUT outGoodsKindCompleteName TVarChar, -- 
    IN inComment              TVarChar  , -- Комментарий     
    IN inTradeMarkId                    Integer,  --Торговая марка 
    IN inGoodsGroupPropertyId           Integer,
    IN inGoodsGroupDirectionId          Integer,
   OUT outTradeMarkName                 TVarChar, 
   OUT outGoodsGroupPropertyName        TVarChar,     
   OUT outGoodsGroupPropertyName_Parent TVarChar, 
   OUT outGoodsGroupDirectionName       TVarChar, 
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


    -- !!!замена!!! - новая схема
    IF EXISTS (SELECT 1 FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_Insert() AND MovementDate.ValueData >= '25.09.2023')
       -- OR vbUserId = 5
       AND COALESCE (ioGoodsKindId, 0) = 0
    THEN
        ioGoodsKindId:= ioGoodsKindCompleteId;
    END IF;


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
                   AND COALESCE (MI_PromoGoods.GoodsKindId, 0)         = COALESCE (ioGoodsKindId, 0)
                   AND COALESCE (MI_PromoGoods.GoodsKindCompleteId, 0) = COALESCE (ioGoodsKindCompleteId, 0)
                   AND MI_PromoGoods.Id                        <> COALESCE(ioId, 0)
                   AND MI_PromoGoods.isErased                  = FALSE
              )
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже указана скидка для товара = <%> и вид = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (ioGoodsKindId);
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
       OR COALESCE (ioGoodsKindId, 0)         <> COALESCE ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKind()), 0)
       OR COALESCE (ioGoodsKindCompleteId, 0) <> COALESCE ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_GoodsKindComplete()), 0)
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

       ioOperPriceList := COALESCE ((SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId = CASE WHEN ioGoodsKindId > 0 THEN ioGoodsKindId ELSE ioGoodsKindCompleteId END)
                          , (SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId IS NULL)
                          ,0);

    /*IF vbUserId = 5 AND 1=0
    THEN
        RAISE EXCEPTION 'Ошибка. %   %   %'
        , (SELECT Price.ValuePrice
          FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceList
                                                   , inOperDate   := (SELECT OperDate FROM Movement WHERE Id = inMovementId)
                                                    ) AS Price
          WHERE Price.GoodsId = inGoodsId
            AND Price.GoodsKindId = CASE WHEN ioGoodsKindId > 0 THEN ioGoodsKindId ELSE ioGoodsKindCompleteId END)
        , lfGet_Object_ValueData_sh (vbPriceList)
        , lfGet_Object_ValueData_sh (ioGoodsKindCompleteId)
        ;
        
    END IF;*/

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
                                                  , inAmountMarket         := inAmountMarket
                                                  , inSummOutMarket        := inSummOutMarket
                                                  , inSummInMarket         := inSummInMarket
                                                  , inGoodsKindId          := ioGoodsKindId
                                                  , inGoodsKindCompleteId  := ioGoodsKindCompleteId
                                                  , inTradeMarkId          := inTradeMarkId
                                                  , inGoodsGroupPropertyId := inGoodsGroupPropertyId
                                                  , inGoodsGroupDirectionId:= inGoodsGroupDirectionId
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
    outGoodsKindName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsKindId);

    -- вернули данные
    SELECT MILO_GoodsKindComplete.ObjectId    AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ValueData AS GoodsKindCompleteName
           INTO ioGoodsKindCompleteId
              , outGoodsKindCompleteName
    FROM MovementItemLinkObject AS MILO_GoodsKindComplete
         LEFT OUTER JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
    WHERE MILO_GoodsKindComplete.MovementItemId = ioId
      AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete();

    SELECT Object_TradeMark.ValueData                AS TradeMark  
         , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
         , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
         , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
   INTO outTradeMarkName, outGoodsGroupPropertyName, outGoodsGroupPropertyName_Parent, outGoodsGroupDirectionName
    FROM MovementItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_TradeMark
                                              ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                                             AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupProperty
                                              ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()  
                                             AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --                                
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsGroupDirection
                                              ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection() 
                                             AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)

    WHERE MovementItem.Id = ioId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 23.08.24         *
 07.08.24         * 
 24.01.18         * inPriceTender
 28.11.17         * ioGoodsKindCompleteId
 25.11.15                                                                         * Comment
 13.10.15                                                                         *
*/