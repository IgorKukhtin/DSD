-- Function: gpSelect_wms_to_host_message()

DROP FUNCTION IF EXISTS gpSelect_wms_to_host_message (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpSelect_wms_to_host_message (
    IN inStartDate  TDateTime, -- левая граница временного интервала
    IN inEndDate    TDateTime, -- правая граница временного интервала
    IN inErrorOnly  Boolean    -- выбирать записи только с ошибками\ выбирать все записи 
)
RETURNS TABLE (Id               Integer, 
               Type             TVarChar, -- значение to_host_header_message.Type
               Header_Id        Integer,  -- шапка в Oracle
               Detail_Id        Integer,  -- строчная часть в Oracle
               MovementId       TVarChar, -- какой-то наш Id: order_id -> Movement.Id или <receiving_result.inc_id> -> wms_MI_Incoming.Id
               Sku_Id           TVarChar, -- уникальный код товара
               Name             TVarChar, -- имя груза
               Qty              TVarChar, -- Кол-во, используется только когда Шт
               Weight           TVarChar, -- Вес, используется только когда НЕ Шт
               Weight_biz       TVarChar, -- Вес с бизербы - подставим в кол-во у Покупателя
               Production_Date  TVarChar, -- дата партии
               OperDate         TDateTime,-- Дата, время когда документ проведен в WMS, т.е. в Oracle это from_host_header_message.CREATED
               UpdateDate       TDateTime,-- Дата, время когда пакет обработан на нашей стороне
               Done             Boolean,  -- статус "выполнено\невыполнено"
               Error            Boolean,  -- статус "есть ошибка\ без ошибок"
               InsertDate       TDateTime -- дата вставки записи
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Msg.Id, Msg.Type, Msg.Header_Id, Msg.Detail_Id, Msg.MovementId, Msg.Sku_Id, Msg.Name, Msg.Qty, Msg.Weight, Msg.Weight_biz, Msg.Production_Date, Msg.OperDate, Msg.UpdateDate, Msg.Done, Msg.Error, Msg.InsertDate
        FROM  wms_to_host_message AS Msg 
        WHERE ((Msg.Error = inErrorOnly) OR (Msg.Error = TRUE))
          AND Msg.InsertDate BETWEEN inStartDate AND inEndDate
      --ORDER BY Msg.Header_id DESC
        ORDER BY Msg.Id DESC
        
        ;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 18.06.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_wms_to_host_message (inStartDate:= current_date, inEndDate:= current_timestamp, inErrorOnly:= FALSE)
