-- Function: lpUpdate_wms_receiving_result_MI()

DROP FUNCTION IF EXISTS lpUpdate_wms_MI_WeighingProd_StatusId_Wms (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_MI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_wms_receiving_result_MI (
    IN inIncomingId    Integer, -- номер задания на упаковку
    IN inName          TVarChar -- имя груза
)
RETURNS Void
AS
$BODY$ 
BEGIN

  UPDATE wms_MI_WeighingProduction 
  SET    StatusId_Wms = zc_Enum_Status_Complete() 
  WHERE  Id IN (
  
        SELECT MI.Id 

        FROM  wms_MI_Incoming AS Incoming  
            
            INNER JOIN wms_Movement_WeighingProduction AS Movement 
                                                       ON Movement.OperDate    = Incoming.OperDate
                                                      AND Movement.GoodsId     = Incoming.GoodsId   
                                                      AND Movement.GoodsKindId = Incoming.GoodsKindId 
                                                       
            INNER JOIN wms_MI_WeighingProduction AS MI 
                                                 ON MI.MovementId      = Movement.Id  
                                                AND MI.GoodsTypeKindId = Incoming.GoodsTypeKindId 
                                                
            INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id = MI.BarCodeBoxId 
                             
        WHERE   Incoming.Id                 = inIncomingId  
            AND Object_BarCodeBox.ValueData = inName     
        ); 
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE; 
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 09.06.20                                                          *              
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpUpdate_wms_receiving_result_MI (inIncomingId:= 1, inName:= 'AHC-00506') 