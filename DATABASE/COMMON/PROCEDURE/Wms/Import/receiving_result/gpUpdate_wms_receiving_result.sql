-- Function: gpUpdate_wms_receiving_result()

DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TFloat);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_wms_receiving_result (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_wms_receiving_result (
    IN inId            Integer,  -- Наш Id сообщения -> wms_to_host_message.Id   
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS VOID    
AS
$BODY$      
  DECLARE vbIncomingId Integer;   
BEGIN
     -- ищем наш Id задания на упаковку, который вернул WMS в пакете <receiving_result> в атрибуте 'inc_id'    
     vbIncomingId:= (SELECT DISTINCT MI_Incoming.Id
                     FROM wms_to_host_message AS wms_message
                          -- наш Id задания на упаковку 
                          INNER JOIN wms_MI_Incoming AS MI_Incoming ON MI_Incoming.Id = wms_message.MovementId :: Integer

                     WHERE wms_message.Id = inId
                    );     
                    
     -- если наш Id задания на упаковку не найден, прекращаем дальнейшую обрабоку пакета
     IF COALESCE (vbIncomingId, 0) = 0
     THEN
         RAISE EXCEPTION 'Site="W" Descr="не найдено значение inc_id = <%>"'
                        , (SELECT wms_message.MovementId FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)
                         ;
     END IF;     
     
     
     -- ищем наш Id задания на упаковку который вернул WMS в пакете <receiving_result> в атрибуте 'inc_id' и который согласуется с именем груза - Ш/К ящика в атрибуте 'name' 
     vbIncomingId:= (SELECT DISTINCT MI_Incoming.Id
                     FROM wms_to_host_message AS wms_message
                          -- наш Id задания на упаковку
                          INNER JOIN wms_MI_Incoming AS MI_Incoming ON MI_Incoming.Id = wms_message.MovementId :: Integer

                          INNER JOIN wms_Movement_WeighingProduction AS Movement_WP
                                                                     ON Movement_WP.OperDate    = MI_Incoming.OperDate
                                                                    AND Movement_WP.GoodsId     = MI_Incoming.GoodsId
                                                                    AND Movement_WP.GoodsKindId = MI_Incoming.GoodsKindId
                          INNER JOIN wms_MI_WeighingProduction AS MI_WP
                                                               ON MI_WP.MovementId      = Movement_WP.Id
                                                              AND MI_WP.GoodsTypeKindId = MI_Incoming.GoodsTypeKindId

                          INNER JOIN Object AS Object_BarCodeBox ON Object_BarCodeBox.Id        = MI_WP.BarCodeBoxId
                                                                -- имя груза - Ш/К ящика
                                                                AND Object_BarCodeBox.ValueData = wms_message.Name
                     WHERE wms_message.Id = inId
                    );   

     -- если наш Id задания на упаковку не найден, прекращаем дальнейшую обрабоку пакета
     IF COALESCE (vbIncomingId, 0) = 0
     THEN
         RAISE EXCEPTION 'Site="W" Descr="не найдено значение inc_id = <%> для груза <%> "'
                        , (SELECT wms_message.MovementId FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)
                        , (SELECT wms_message.Name       FROM wms_to_host_message AS wms_message WHERE wms_message.Id = inId)                        
                         ;
     END IF;                    
     

     -- обновили StatusId_Wms - отметили что наш Груз был принят
     PERFORM lpUpdate_wms_receiving_result_MI (inId      := inId
                                             , inSession := inSession
                                              );
     
     -- обновили наши данные - zc_Movement_WeighingProduction
     PERFORM lpUpdate_wms_receiving_result_Movement (inId      := inId
                                                   , inSession := inSession
                                                    );
     
     -- отметили что сообщение обработано
     UPDATE wms_to_host_message SET Done = TRUE, UpdateDate = CLOCK_TIMESTAMP() WHERE Id = inId;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 10.06.20                                                          *              
 09.06.20                                        *               
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpUpdate_wms_receiving_result (inId:= 1, inSession:= zfCalc_UserAdmin())