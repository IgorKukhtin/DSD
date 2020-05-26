CREATE OR REPLACE FUNCTION gpInsert_movement_wms_scale_all (
	IN inSession	    TVarChar  -- сессия пользователя
)
RETURNS void
AS
$BODY$ 
BEGIN

    -- одним запросом обработать все строки в таб. wms_to_host_message где type='order_status_changed'
	PERFORM lpInsert_movement_wms_scale_packet (inOrderId := wms.movement_id
	                                          , inSession := inSession) 
    FROM   wms_to_host_message wms  
	WHERE  wms.type = 'order_status_changed'
	   AND wms.done = FALSE;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE; 