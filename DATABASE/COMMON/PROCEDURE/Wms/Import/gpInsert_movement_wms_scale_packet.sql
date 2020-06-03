CREATE OR REPLACE FUNCTION gpInsert_movement_wms_scale_packet (
	IN inOrderId	    Integer,  -- код заявки
	IN inSession	    TVarChar  -- сессия пользователя
)
RETURNS void
AS
$BODY$
	DEClARE vbNewMovementId Integer; -- id нового документа
BEGIN
	
		vbNewMovementId := (SELECT lpInsert_movement_wms_scale_header (inMovementId := inOrderId
																	 , inSession    := inSession
																	  )
							);
							
		PERFORM lpInsert_movement_wms_scale_detail (inOrderId       := inOrderId
												  , inNewMovementId := vbNewMovementId 
												  , inSession       := inSession  
												  ); 
		UPDATE	wms_to_host_message 
		SET     done = TRUE
		WHERE   movement_id = inOrderId; 
		
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;