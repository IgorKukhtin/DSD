CREATE OR REPLACE FUNCTION gpProcess_ReceivingResult()
RETURNS void
AS
$BODY$ 
BEGIN

  PERFORM lpUpdate_wms_MI_WeighingProd_Statusis_Wms();
  
  PERFORM lpUpdate_MovementItem_amount();
  
  UPDATE wms_to_host_message
  SET    done = TRUE
  WHERE  type = 'receiving_result'
     AND done = FALSE ;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;