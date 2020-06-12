-- Function: gpInsert_wms_order_status_changed()

DROP FUNCTION IF EXISTS lpGetGoodsId_for_sku_id (Integer);
DROP FUNCTION IF EXISTS gpInsert_movement_wms_scale_packet (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_wms_order_status_changed (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_wms_order_status_changed (
    IN inOrderId    Integer,  -- Наш Id заявки -> Movement.Id
    IN inSession    TVarChar  -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DEClARE vbMovementId Integer;
BEGIN
     -- создали Документ
     vbMovementId := lpInsert_wms_order_status_changed_Movement (inMovementId := 0
                                                               , inOrderId    := inOrderId
                                                               , inSession    := inSession
                                                                );
     -- создали Строчную часть
     PERFORM lpInsert_wms_order_status_changed_MI (inMovementId := vbMovementId
                                                 , inOrderId    := inOrderId
                                                 , inSession    := inSession
                                                  );
     -- отметили что сообщения обработаны
     UPDATE wms_to_host_message SET Done = TRUE, UpdateDate = CLOCK_TIMESTAMP() WHERE MovementId = inOrderId :: TVarChar;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpInsert_wms_order_status_changed (inOrderId:= 1, inSession:= zfCalc_UserAdmin())
