CREATE OR REPLACE FUNCTION lpUpdate_wms_MI_WeighingProd_Statusis_Wms()
RETURNS void
AS
$BODY$ 
BEGIN

	UPDATE wms_MI_WeighingProduction
	SET    statusid_wms = zc_Enum_Status_Complete()
	WHERE  id IN (
		SELECT  MI.id
		FROM    wms_to_host_message AS InMsg
		
				INNER JOIN wms_MI_Incoming AS Incoming ON InMsg.movement_id = Incoming.id 
			   
				INNER JOIN wms_Movement_WeighingProduction AS Movement
												ON Movement.OperDate    = Incoming.OperDate
											   AND Movement.GoodsId     = Incoming.GoodsId
											   AND Movement.GoodsKindId = Incoming.GoodsKindId 
											   
				INNER JOIN wms_MI_WeighingProduction AS MI 
												ON MI.movementid      = Movement.id  
											   AND MI.GoodsTypeKindId = Incoming.GoodsTypeKindId
											   
				INNER JOIN Object AS Object_BarCodeBox 
												ON Object_BarCodeBox.Id        = MI.BarCodeBoxId
											   AND Object_BarCodeBox.ValueData = InMsg.Name
		WHERE  InMsg.type = 'receiving_result' 
			   AND InMsg.done = FALSE
		); 

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE; 