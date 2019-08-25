-- Function: lpInsertUpdate_wms_MI_Incoming()

DROP FUNCTION IF EXISTS lpInsertUpdate_wms_MI_Incoming (TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_wms_MI_Incoming(
    IN inOperDate   TDateTime , -- 
    IN inUserId     Integer     -- 
)                              
RETURNS VOID
AS
$BODY$
BEGIN

     INSERT INTO wms_MI_Incoming (OperDate, StatusId, StatusId_wms, GoodsId, GoodsKindId, GoodsTypeKindId, sku_id, sku_code, Amount, RealWeight, PartionDate, InsertDate, UpdateDate)
        WITH tmpGoods_all AS (SELECT tmpGoods.GoodsId, tmpGoods.GoodsKindId, tmpGoods.GoodsTypeKindId, tmpGoods.sku_id, tmpGoods.sku_code
                              FROM lpSelect_wms_Object_SKU() AS tmpGoods
                             )
        SELECT inOperDate                  AS OperDate
             , zc_Enum_Status_UnComplete() AS StatusId
             , NULL                        AS StatusId_wms
             , tmpGoods_all.GoodsId
             , tmpGoods_all.GoodsKindId
             , tmpGoods_all.GoodsTypeKindId
             , tmpGoods_all.sku_id
             , tmpGoods_all.sku_code
             , 1                           AS Amount
             , 1                           AS RealWeight
             , CURRENT_DATE                AS PartionDate
             , CURRENT_TIMESTAMP           AS InsertDate
             , NULL                        AS UpdateDate
        FROM tmpGoods_all
             LEFT JOIN wms_MI_Incoming ON wms_MI_Incoming.OperDate        = inOperDate
                                      AND wms_MI_Incoming.GoodsId         = tmpGoods_all.GoodsId
                                      AND wms_MI_Incoming.GoodsKindId     = tmpGoods_all.GoodsKindId
                                      AND wms_MI_Incoming.GoodsTypeKindId = tmpGoods_all.GoodsTypeKindId
        WHERE wms_MI_Incoming.GoodsId IS NULL
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
              ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.08.19                                       *
*/

-- ÚÂÒÚ
--