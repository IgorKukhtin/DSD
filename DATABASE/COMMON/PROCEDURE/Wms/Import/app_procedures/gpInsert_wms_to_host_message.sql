-- Function: gpInsert_wms_to_host_message()

DROP FUNCTION IF EXISTS gpInsert_wms_to_host_message (TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_wms_to_host_message (
    IN inType             TVarChar,  -- значение to_host_header_message.Type
    IN inHeader_Id        Integer,   -- шапка в Oracle
    IN inDetail_Id        Integer,   -- строчная часть в Oracle
    IN inMovementId       TVarChar,  -- какой-то наш Id: order_id -> Movement.Id или <receiving_result.inc_id> -> wms_MI_Incoming.Id
    IN inSku_Id           TVarChar,  -- уникальный код товара
    IN inName             TVarChar,  -- имя груза
    IN inQty              TVarChar,  -- Кол-во, используется только когда Шт
    IN inWeight           TVarChar,  -- Вес, используется только когда НЕ Шт
    IN inWeight_biz       TVarChar,  -- Вес с бизербы - подставим в кол-во у Покупателя
    IN inOperDate         TDateTime, -- Дата и время когда документ проведен в WMS, т.е. в Oracle это from_host_header_message.CREATED
    IN inProduction_Date  TVarChar   -- дата партии
)
RETURNS VOID
AS
$BODY$      
BEGIN
    INSERT INTO wms_to_host_message (Type,   Header_id,   Detail_id,   Movementid,   Sku_id,   Name,   Qty,   Weight,   Weight_biz,   OperDate,   Production_Date) 
                             VALUES (inType, inHeader_id, inDetail_id, inMovementid, inSku_id, inName, inQty, inWeight, inWeight_biz, inOperDate, inProduction_Date);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 19.06.20                                                          *              
*/

-- тест
-- SELECT gpInsert_wms_to_host_message (inType:= 'receiving_result'
--                                    , inHeader_id  := 1
--                                    , inDetail_id  := 1
--                                    , inMovementid := '1'
--                                    , inSku_id     := '123'
--                                    , inName       := 'test name'
--                                    , inQty        := '1'
--                                    , inWeight     := '1'
--                                    , inWeight_biz := '1'
--                                    , inOperDate   := '2020-06-19' :: TDateTime
--                                    , inProduction_Date := '2020-06-15')