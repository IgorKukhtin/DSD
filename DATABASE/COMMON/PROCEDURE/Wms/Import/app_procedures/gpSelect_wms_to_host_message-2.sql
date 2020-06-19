-- Function: gpSelect_wms_to_host_message()

DROP FUNCTION IF EXISTS gpSelect_wms_to_host_message (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_wms_to_host_message (
    IN inPacketName  TVarChar -- имя пакета импорта, например, 'order_status_changed'
)
RETURNS TABLE (Id               Integer, 
               Header_Id        Integer,  -- шапка в Oracle
               MovementId       TVarChar  -- какой-то наш Id: order_id -> Movement.Id или <receiving_result.inc_id> -> wms_MI_Incoming.Id
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT  DISTINCT Msg.Id, Msg.Header_Id, Msg.MovementId
        FROM  wms_to_host_message AS Msg 
        WHERE Msg.Done  = FALSE
          AND Msg.Error = FALSE
          AND Msg.Type ILIKE inPacketName
        ORDER BY Msg.Id;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 19.06.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_wms_to_host_message (inPacketName:= 'order_status_changed')