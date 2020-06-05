CREATE OR REPLACE FUNCTION gpUpdate_wms_receiving_result (
    IN inId            Integer,  -- wms_to_host_message.Id   
    IN inIncomingId    Integer,  -- номер задания на упаковку
    IN inName          TVarChar, -- имя груза 
    IN inQty           TFloat    -- значение атрибута 'qty' в тэге '<receiving_result_detail>'. Записано в wms_to_host_message.qty   
)
RETURNS VOID    
AS
$BODY$         
BEGIN

  PERFORM lpUpdate_wms_MI_WeighingProd_StatusId_Wms (inIncomingId := inIncomingId
                                                   , inName       := inName   
                                                    );
  
  PERFORM lpUpdate_MovementItem_amount(inIncomingId := inIncomingId
                                     , inName       := inName 
                                     , inQty        := inQty                 
                                      );
  
  UPDATE wms_to_host_message
  SET    Done = TRUE
  WHERE  Id   = inId;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;            