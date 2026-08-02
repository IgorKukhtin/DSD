-- Function: gpInsertUpdate_MovementItem_PromoSaleGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoSaleGoods (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoSaleGoods(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inGoodsId              Integer   , -- Товары
 INOUT ioPrice                TFloat    , -- Цена в прайсе с учетом скидки по договору
 INOUT ioOperPriceList        TFloat    , -- Цена в прайсе
    IN inPriceSale            TFloat    , -- Цена на полке
   OUT outPriceWithOutVAT     TFloat    , -- Цена отгрузки без учета НДС, с учетом скидки, грн
   OUT outPriceWithVAT        TFloat    , -- Цена отгрузки с учетом НДС, с учетом скидки, грн
    IN ioCountForPrice        TFloat    , -- относится ко всем ценам
    IN inAmountReal           TFloat    , -- Объем продаж в аналогичный период, кг
   OUT outAmountRealWeight    TFloat    , -- Объем продаж в аналогичный период, кг Вес
    IN inAmountPlanMin        TFloat    , -- Минимум планируемого объема продаж на акционный период (в кг)
   OUT outAmountPlanMinWeight TFloat    , -- Минимум планируемого объема продаж на акционный период (в кг) вес
    IN inAmountPlanMax        TFloat    , -- Максимум планируемого объема продаж на акционный период (в кг)
   OUT outAmountPlanMaxWeight TFloat    , -- Максимум планируемого объема продаж на акционный период (в кг) Вес
 INOUT ioGoodsKindId          Integer   , -- ИД обьекта <Вид товара>
   OUT outGoodsKindName       TVarChar  , -- 
 INOUT ioGoodsKindCompleteId  Integer   , -- ИД обьекта <Вид товара (примечание)>
   OUT outGoodsKindCompleteName TVarChar, -- 
   OUT outtrademarkname         TVarChar,--
    IN inComment              TVarChar  , -- Комментарий     
    IN inSession              TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsInsert          Boolean;
   DECLARE vbPriceListId       Integer;
   DECLARE vbPriceWithWAT      Boolean;
   DECLARE vbVAT               TFloat;
   DECLARE vbChangePercent     TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoSale()) END;


    -- !!!замена!!! - новая схема
    IF EXISTS (SELECT 1 FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_Insert() AND MovementDate.ValueData >= '25.09.2023')
       -- OR vbUserId = 5
       AND COALESCE (ioGoodsKindId, 0) = 0
    THEN
        ioGoodsKindId:= ioGoodsKindCompleteId;
    END IF;


    -- замена
    IF COALESCE (ioCountForPrice, 0) <= 0 THEN ioCountForPrice:= 1; END IF;
 
   
    -- Проверили уникальность товар/вид товара
    IF EXISTS (SELECT 1
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                     ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
               WHERE MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.MovementId = inMovementId
                 AND MovementItem.isErased = FALSE 
                 AND MovementItem.ObjectId = inGoodsId
                 AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         = COALESCE (ioGoodsKindId, 0)
                 AND COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) = COALESCE (ioGoodsKindCompleteId, 0)
                 AND MovementItem.Id                        <> COALESCE(ioId, 0)
              )
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже есть товар = <%> и вид = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (ioGoodsKindId);
    END IF;

    -- поиск прайс-лист, параметры
    SELECT COALESCE (MovementLinkObject_PriceList.ObjectId, zc_PriceList_Basis())       AS PriceListId
         , COALESCE (MovementFloat_ChangePercent.ValueData,0)                           AS ChangePercent
  INTO vbPriceListId, vbChangePercent
    FROM Movement AS Movement_PromoSale
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                      ON MovementLinkObject_PriceList.MovementId = Movement_PromoSale.Id
                                     AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId = Movement_PromoSale.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    WHERE Movement_PromoSale.DescId = zc_Movement_PromoSale()
      AND Movement_PromoSale.Id = inMovementId;



    -- получение данных прайс-лист "с НДС" и "значение НДС"
    SELECT PriceList.PriceWithVAT, PriceList.VATPercent
           INTO vbPriceWithWAT, vbVAT
    FROM gpGet_Object_PriceList(vbPriceListId,inSession) AS PriceList;

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
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId)) AS lfSelect;

       ioOperPriceList := COALESCE ((SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId = CASE WHEN ioGoodsKindId > 0 THEN ioGoodsKindId ELSE ioGoodsKindCompleteId END)
                          , (SELECT tmpPriceList.ValuePrice FROM tmpPriceList WHERE tmpPriceList.GoodsId = inGoodsId AND tmpPriceList.GoodsKindId IS NULL)
                          ,0);

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

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_PromoSaleGoods (ioId                   := ioId
                                                      , inMovementId           := inMovementId
                                                      , inGoodsId              := inGoodsId
                                                      , inPrice                := ioPrice
                                                      , inOperPriceList        := ioOperPriceList
                                                      , inPriceSale            := inPriceSale
                                                      , inPriceWithOutVAT      := outPriceWithOutVAT
                                                      , inPriceWithVAT         := outPriceWithVAT
                                                      , inCountForPrice        := ioCountForPrice
                                                      , inAmountReal           := inAmountReal
                                                      , inAmountPlanMin        := inAmountPlanMin
                                                      , inAmountPlanMax        := inAmountPlanMax
                                                      , inGoodsKindId          := ioGoodsKindId
                                                      , inGoodsKindCompleteId  := ioGoodsKindCompleteId
                                                      , inComment              := inComment
                                                      , inUserId               := vbUserId
                                                       );
  

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
           INTO outTradeMarkName
    FROM MovementItem
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
    WHERE MovementItem.Id = ioId;

    --IF  vbUserId = 9457 THEN RAISE EXCEPTION 'Admin - Test = OK'; END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.26         *
*/