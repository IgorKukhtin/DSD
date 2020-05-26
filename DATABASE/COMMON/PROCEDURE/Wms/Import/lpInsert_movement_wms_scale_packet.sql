CREATE OR REPLACE FUNCTION lpInsert_movement_wms_scale_packet (
	IN inOrderId	    Integer,  -- код заявки
	IN inSession	    TVarChar  -- сессия пользователя
)
RETURNS void
AS
$BODY$
	DEClARE vbNewMovementId Integer;
BEGIN
	vbNewMovementId := (SELECT lpInsert_movement_wms_scale_header (inMovementId := inOrderId
	                                                             , inSession    := inSession
														          )
						);
						
	PERFORM lpInsert_movement_wms_scale_detail (inOrderId       := inOrderId
	                                          , inNewMovementId := vbNewMovementId 
											  , inSession       := inSession  
	                                          ) 
	FROM   wms_to_host_message  
	WHERE  type = 'order_status_changed' 
	   AND done = FALSE;					
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;