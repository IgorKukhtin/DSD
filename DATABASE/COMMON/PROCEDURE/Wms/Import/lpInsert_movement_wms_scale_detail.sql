-- Function: lpInsert_wms_order_status_changed_MI()

DROP FUNCTION IF EXISTS lpInsert_movement_wms_scale_detail (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpInsert_wms_order_status_changed_MI (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsert_wms_order_status_changed_MI (
	IN inMovementId     Integer,  -- Ключ Документа
	IN inOrderId	    Integer,  -- Ключ заявки
	IN inSession	    TVarChar  -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbChangePercentAmount TFloat;
   DECLARE vbPrice TFloat;
   DECLARE vbPrice_return TFloat;
   DECLARE vbCountForPrice TFloat;
   DECLARE vbCountForPrice_return TFloat;
   DECLARE vbMovementId_promo Integer;
   DECLARE vbWeight TFloat;
BEGIN
	
     -- Эти поля взяли из Заявки
     SELECT tmp.GoodsId
          , tmp.GoodsKindId
          , tmp.ChangePercentAmount
          , tmp.Price
          , tmp.Price_return
          , tmp.CountForPrice
          , tmp.CountForPrice_return
          , tmp.MovementId_promo
          , tmp2.weight
	INTO  
	      vbGoodsId
	    , vbGoodsKindId
	    , vbChangePercentAmount
	    , vbPrice
	    , vbPrice_return
	    , vbCountForPrice
	    , vbCountForPrice_return
	    , vbMovementId_promo
	    , vbWeight

     FROM gpSelect_Scale_goods (inisgoodscomplete      := TRUE
 		                      , inoperdate             := CURRENT_DATE
 							  , inmovementid           := 0
							  , inorderexternalid      := inOrderId
							  , inPricelistid          := 0
							  , ingoodscode            := 0
							  , inGoodsName            := ''
							  , indayprior_Pricereturn := 0
							  , inbranchcode           := 1
							  , insession              := inSession
							  ) AS tmp 
		  INNER JOIN  
					(SELECT 
							lpGetGoodsId_for_sku_id (wms.sku_id) AS GoodsId
						  , wms.weight 
					FROM 
							wms_to_host_message wms 
					WHERE
							(wms.type = 'order_status_changed') 
							AND wms.done = FALSE
					) AS tmp2 
		  ON tmp.GoodsId = tmp2.GoodsId;	
	

    PERFORM gpinsert_scale_mi (inid                   := 0
	                         , inmovementid           := inNewMovementId
							 , inGoodsId              := COALESCE (vbGoodsId, 0)
							 , inGoodsKindId          := COALESCE (vbGoodsKindId, 0)
							 , inrealweight           := COALESCE (vbWeight, 0)
							 , inChangePercentAmount  := COALESCE (vbChangePercentAmount, 0)
							 , incounttare            := 0
							 , inweighttare           := 0
							 , incounttare1           := 0
							 , inweighttare1          := 0
							 , incounttare2           := 0
							 , inweighttare2          := 0
							 , incounttare3           := 0
							 , inweighttare3          := 0
							 , incounttare4           := 0
							 , inweighttare4          := 0
							 , incounttare5           := 0
							 , inweighttare5          := 0
							 , incounttare6           := 0
							 , inweighttare6          := 0
							 , inPrice                := COALESCE (vbPrice, 0)
							 , inPrice_return         := COALESCE (vbPrice_return, 0)
							 , inCountForPrice        := COALESCE (vbCountForPrice, 0)
							 , inCountForPrice_return := COALESCE (vbCountForPrice_return, 0)
							 , indayprior_Pricereturn := 0
							 , incount                := 0
							 , inheadcount            := 0
							 , inboxcount             := 0
							 , inboxcode              := 0
							 , inpartiongoods         := ''
							 , inPricelistid          := 0
							 , inbranchcode           := 1
							 , inMovementId_promo     := COALESCE (vbMovementId_promo, 0)
							 , inisbarcode            := FALSE
							 , insession              := inSession
							 );
							 

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;
 
 /*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpInsert_wms_order_status_changed_MI (inMovementId:= 0, inOrderId:= 1, inSession:= zfCalc_UserAdmin())
