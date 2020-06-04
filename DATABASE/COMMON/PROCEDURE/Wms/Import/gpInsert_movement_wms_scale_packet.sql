-- Function: gpInsert_wms_order_status_changed()

DROP FUNCTION IF EXISTS gpInsert_movement_wms_scale_packet (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_wms_order_status_changed (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_wms_order_status_changed (
    IN inOrderId    Integer,  -- Ключ заявки
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
     PERFORM lpInsert_movement_wms_scale_detail (inOrderId    := inOrderId
                                               , inMovementId := vbMovementId
                                               , inSession    := inSession
                                                );
     -- сохранили что данные перенесены
     UPDATE wms_to_host_message SET Done = TRUE WHERE MovementId = inOrderId;

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpInsert_wms_order_status_changed (inOrderId:= 1, inSession:= zfCalc_UserAdmin())
