CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_amount()
RETURNS void
AS
$BODY$ 
BEGIN

	WITH CheckAmount AS (

		SELECT MI.id, InMsg.qty 
		
		FROM wms_to_host_message AS InMsg
		
				INNER JOIN wms_MI_Incoming AS Incoming ON InMsg.movement_id = Incoming.id 
			   
				INNER JOIN wms_Movement_WeighingProduction AS Movement
												ON Movement.OperDate    = Incoming.OperDate
											   AND Movement.GoodsId     = Incoming.GoodsId
											   AND Movement.GoodsKindId = Incoming.GoodsKindId 
											   
				INNER JOIN wms_MI_WeighingProduction AS MI_WP 
												ON MI_WP.movementid      = Movement.id  
											   AND MI_WP.GoodsTypeKindId = Incoming.GoodsTypeKindId
											   
				INNER JOIN Object AS Object_BarCodeBox 
												ON Object_BarCodeBox.Id        = MI_WP.BarCodeBoxId
											   AND Object_BarCodeBox.ValueData = InMsg.Name
											   
				INNER JOIN MovementItem AS MI   ON MI.movementid = MI_WP.parentid 								

		WHERE InMsg.type = 'receiving_result' 
			  AND InMsg.done = FALSE	
			  AND MI.amount <> InMsg.qty		  
	)

	UPDATE MovementItem
	SET    amount = CheckAmount.qty 
	FROM   CheckAmount
	WHERE  MovementItem.id = CheckAmount.id;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;