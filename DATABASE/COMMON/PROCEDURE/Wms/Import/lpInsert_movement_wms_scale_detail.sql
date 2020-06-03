CREATE OR REPLACE FUNCTION lpInsert_movement_wms_scale_detail (
	IN inOrderId	    Integer,  -- код заявки
	IN inNewMovementId	Integer,  -- код нового документа, созданного на основе заявки
	IN inSession	    TVarChar  -- сессия пользователя
)
RETURNS void
AS
$BODY$
	DECLARE vbGoodsid Integer;
	DECLARE vbGoodskindid Integer;
	DECLARE	vbChangepercentamount TFloat;
	DECLARE vbPrice TFloat;
	DECLARE	vbPrice_return TFloat;
	DECLARE vbCountforprice TFloat;
	DECLARE vbCountforprice_return TFloat;
	DECLARE vbMovementid_promo Integer;
	DECLARE vbWeight TFloat;
BEGIN
	
	SELECT
		  tmp.goodsid
		, tmp.goodskindid
		, tmp.changepercentamount
		, tmp.price
		, tmp.price_return
		, tmp.countforprice
		, tmp.countforprice_return
		, tmp.movementid_promo
		, tmp2.weight
	INTO  
	      vbGoodsid
	    , vbGoodskindid
		, vbChangepercentamount
		, vbPrice
		, vbPrice_return
		, vbCountforprice
		, vbCountforprice_return
		, vbMovementid_promo
		, vbWeight
    FROM 
		  gpselect_scale_goods (inisgoodscomplete      := TRUE
		                      , inoperdate             := CURRENT_DATE
							  , inmovementid           := 0
							  , inorderexternalid      := inOrderId
							  , inpricelistid          := 0
							  , ingoodscode            := 0
							  , inGoodsName            := ''
							  , indayprior_pricereturn := 0
							  , inbranchcode           := 1
							  , insession              := inSession
							  ) AS tmp 
		  INNER JOIN  
					(SELECT 
							lpGetGoodsId_for_sku_id (wms.sku_id) AS goodsid
						  , wms.weight 
					FROM 
							wms_to_host_message wms 
					WHERE
							(wms.type = 'order_status_changed') 
							AND wms.done = FALSE
					) AS tmp2 
		  ON tmp.goodsid = tmp2.goodsid;	
	

    PERFORM gpinsert_scale_mi (inid                   := 0
	                         , inmovementid           := inNewMovementId
							 , ingoodsid              := COALESCE (vbGoodsid, 0)
							 , ingoodskindid          := COALESCE (vbGoodskindid, 0)
							 , inrealweight           := COALESCE (vbWeight, 0)
							 , inchangepercentamount  := COALESCE (vbChangepercentamount, 0)
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
							 , inprice                := COALESCE (vbPrice, 0)
							 , inprice_return         := COALESCE (vbPrice_return, 0)
							 , incountforprice        := COALESCE (vbCountforprice, 0)
							 , incountforprice_return := COALESCE (vbCountforprice_return, 0)
							 , indayprior_pricereturn := 0
							 , incount                := 0
							 , inheadcount            := 0
							 , inboxcount             := 0
							 , inboxcode              := 0
							 , inpartiongoods         := ''
							 , inpricelistid          := 0
							 , inbranchcode           := 1
							 , inmovementid_promo     := COALESCE (vbMovementid_promo, 0)
							 , inisbarcode            := FALSE
							 , insession              := inSession
							 );
							 

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;