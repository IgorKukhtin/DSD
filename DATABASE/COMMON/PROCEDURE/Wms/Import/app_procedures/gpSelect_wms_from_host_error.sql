-- Function: gpSelect_wms_from_host_error()

DROP FUNCTION IF EXISTS gpSelect_wms_from_host_error ();

CREATE OR REPLACE FUNCTION gpSelect_wms_from_host_error ()
RETURNS Integer   
AS
$BODY$      
    DECLARE vbHeaderId Integer;
BEGIN
    vbHeaderId:= (SELECT MAX(Header_id) AS Max_Id 
                  FROM   wms_from_host_error
                  WHERE  type ILIKE 'add_user'
                     OR  type ILIKE 'asn_load'  
                     OR  type ILIKE 'client'
                     OR  type ILIKE 'client_address'  
                     OR  type ILIKE 'incoming'  
                     OR  type ILIKE 'incoming_detail'  
                     OR  type ILIKE 'order'  
                     OR  type ILIKE 'order_detail'  
                     OR  type ILIKE 'pack'  
                     OR  type ILIKE 'sku'  
                     OR  type ILIKE 'sku_code'  
                     OR  type ILIKE 'sku_depends'  
                     OR  type ILIKE 'sku_group');
                     
    RETURN vbHeaderId;   
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 29.06.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_wms_from_host_error ()