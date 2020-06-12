-- Function: lpUpdate_wms_receiving_result_MI()

DROP FUNCTION IF EXISTS lpUpdate_wms_MI_WeighingProd_StatusId_Wms (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpUpdate_wms_receiving_result_MI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate_wms_receiving_result_MI (
    IN inId            Integer,  -- Наш Id сообщения -> wms_to_host_message.Id   
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

  -- обновили StatusId_Wms - отметили что наш Груз был принят
  UPDATE wms_MI_WeighingProduction SET StatusId_Wms = zc_Enum_Status_Complete()

  WHERE wms_MI_WeighingProduction.Id IN (SELECT MI_WP.Id
                                         FROM wms_to_host_message AS wms_message
                                              -- Наш Id задания на упаковку
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
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 09.06.20                                         *
 08.06.20                                                          *
 05.06.20                                                          *
*/

-- тест
-- SELECT * FROM lpUpdate_wms_receiving_result_MI (inId:= 1, inSession:= zfCalc_UserAdmin())