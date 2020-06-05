CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_amount(
    IN inIncomingId    Integer,  -- номер задания на упаковку
    IN inName          TVarChar, -- имя груза   
    IN inQty           TFloat    -- значение атрибута 'qty' в тэге '<receiving_result_detail>'. Записано в wms_to_host_message.qty 
)
RETURNS VOID
AS
$BODY$ 
BEGIN

    WITH CheckAmount AS (
        -- выбираем записи из таб. MovementItem, которые соответствуют inIncomingId и у которых amount отличается от qty из сообщения 'receiving_result'  
        SELECT MI.Id 

        FROM wms_MI_Incoming AS Incoming

            INNER JOIN wms_Movement_WeighingProduction AS Movement
                                                       ON Movement.OperDate    = Incoming.OperDate
                                                      AND Movement.GoodsId     = Incoming.GoodsId
                                                      AND Movement.GoodsKindId = Incoming.GoodsKindId 
                      
            INNER JOIN wms_MI_WeighingProduction AS MI_WP 
                                                 ON MI_WP.MovementId      = Movement.Id  
                                                AND MI_WP.GoodsTypeKindId = Incoming.GoodsTypeKindId
                      
            INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI_WP.BarCodeBoxId
                      
            INNER JOIN MovementItem AS MI ON MI.MovementId = MI_WP.parentid         

        WHERE  Incoming.Id               = inIncomingId  
         AND Object_BarCodeBox.ValueData = inName 
         AND MI.amount <> inQty    
    )

 -- обновляем MovementItem.amount если найдены несоответствия
 UPDATE MovementItem
 SET    amount = inQty 
 FROM   CheckAmount
 WHERE  MovementItem.Id = CheckAmount.Id;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;