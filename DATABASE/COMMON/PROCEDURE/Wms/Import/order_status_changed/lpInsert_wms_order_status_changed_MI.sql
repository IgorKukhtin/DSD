-- Function: lpInsert_wms_order_status_changed_MI()

DROP FUNCTION IF EXISTS lpInsert_movement_wms_scale_detail (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsert_wms_order_status_changed_MI (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_wms_order_status_changed_MI (
    IN inMovementId     Integer,  -- Ключ Документа
    IN inOrderId        Integer,  -- Ключ заявки
    IN inSession        TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- одним запросом - сохранили всю строчную часть
    PERFORM gpInsert_Scale_MI (inId                   := 0
                             , inMovementId           := inMovementId
                             , inGoodsId              := tmpData.GoodsId
                             , inGoodsKindId          := tmpData.GoodsKindId
                             , inRealWeight           := tmpData.Weight :: TFloat
                             , inChangePercentAmount  := tmpData.ChangePercentAmount
                             , inCountTare            := 0
                             , inWeightTare           := 0
                             , inCountTare1           := 0
                             , inWeightTare1          := 0
                             , inCountTare2           := 0
                             , inWeightTare2          := 0
                             , inCountTare3           := 0
                             , inWeightTare3          := 0
                             , inCountTare4           := 0
                             , inWeightTare4          := 0
                             , inCountTare5           := 0
                             , inWeightTare5          := 0
                             , inCountTare6           := 0
                             , inWeightTare6          := 0
                             , inPrice                := tmpData.Price
                             , inPrice_return         := tmpData.Price_return
                             , inCountForPrice        := tmpData.CountForPrice
                             , inCountForPrice_return := tmpData.CountForPrice_return
                             , inDayPrior_PriceReturn := 0
                             , inCount                := 0
                             , inHeadCount            := 0
                             , inBoxCount             := 0
                             , inBoxCode              := 0
                             , inPartionGoods         := ''
                             , inPriceListId          := 0
                             , inBranchcode           := 1
                             , inMovementId_promo     := tmpData.MovementId_promo
                             , inIsBarcode            := FALSE
                             , inSession              := inSession
                              )
    FROM (WITH -- подзапроc - сразу все товары по заявке
               tmpGoods AS (SELECT gpSelect.GoodsId
                                 , gpSelect.GoodsKindId
                                 , gpSelect.ChangePercentAmount
                                 , gpSelect.Price
                                 , gpSelect.Price_return
                                 , gpSelect.CountForPrice
                                 , gpSelect.CountForPrice_return
                                 , gpSelect.MovementId_promo
                            FROM gpSelect_Scale_goods (inIsGoodsComplete      := TRUE
                                                     , inOperDate             := CURRENT_DATE
                                                     , inMovementId           := 0
                                                     , inOrderExternalId      := inOrderId
                                                     , inPriceListId          := 0
                                                     , inGoodsCode            := 0
                                                     , inGoodsName            := ''
                                                     , inDayPrior_PriceReturn := 0
                                                     , inBranchcode           := 1
                                                     , inSession              := inSession
                                                      ) AS gpSelect
                           )
               -- подзапроc - сразу все товары для связи с sku_id
             , tmpSKU AS (SELECT lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.sku_id, lpSelect.MeasureId FROM lpSelect_wms_Object_SKU() AS lpSelect)

          -- Результат - все строки для inOrderId
          SELECT tmpGoods.GoodsId
               , tmpGoods.GoodsKindId
               , tmpGoods.ChangePercentAmount
               , tmpGoods.Price
               , tmpGoods.Price_return
               , tmpGoods.CountForPrice
               , tmpGoods.CountForPrice_return
               , tmpGoods.MovementId_promo
               , CASE WHEN tmpSKU.MeasureId = zc_Measure_Sh() THEN wms_data.QTY ELSE wms_data.Weight END
          FROM wms_to_host_message AS wms_data
               LEFT JOIN tmpSKU   ON tmpSKU.sku_id        = wms_data.sku_id :: Integer
               LEFT JOIN tmpGoods ON tmpGoods.GoodsId     = tmpSKU.GoodsId
                                 AND tmpGoods.GoodsKindId = tmpSKU.GoodsKindId
          WHERE wms_data.MovementId = inOrderId :: TVarChar
            AND wms_data.Type       ILIKE 'order_status_changed'
          --AND wms_data.Done       = FALSE
         ) AS tmpData;


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

 /*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpInsert_wms_order_status_changed_MI (inMovementId:= 18341184, inOrderId:= 1, inSession:= zfCalc_UserAdmin())

