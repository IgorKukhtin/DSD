CREATE OR REPLACE FUNCTION lpGetGoodsId_for_sku_id(
	IN inSKU_Id		Integer -- код товара в WMS
)
RETURNS TABLE (Id Integer)
AS
$BODY$
BEGIN

  RETURN QUERY
	SELECT GoodsId AS Id 
	FROM   lpSelect_wms_Object_SKU() 
	WHERE  sku_id = inSKU_Id; 
	
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;