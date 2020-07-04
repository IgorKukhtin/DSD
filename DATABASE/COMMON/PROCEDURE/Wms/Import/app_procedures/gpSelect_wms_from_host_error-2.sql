-- Function: gpSelect_wms_from_host_error()

DROP FUNCTION IF EXISTS gpSelect_wms_from_host_error (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpSelect_wms_from_host_error (
    IN inStartDate  TDateTime, -- левая граница временного интервала
    IN inEndDate    TDateTime  -- правая граница временного интервала
)
RETURNS TABLE (--Site           TVarChar, -- к какой базе данных относится ошибка. Ожидаются значения 'A' или 'W' ('A' -> ALAN    'W' -> WMS)
               Header_id      Integer,  -- шапка в Oracle
               Wms_message_Id Integer,  -- ключ таб. wms_message 
               Type           TVarChar, -- название пакета -> WMS from_host_header_message.Type
               Description    TVarChar, -- текст ошибки
               InsertDate     TDateTime -- дата вставки записи
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Err.Header_id, Err.Wms_message_Id, Err.Type, Err.Description, Err.InsertDate
        FROM   wms_from_host_error AS Err 
        WHERE  Err.Site = 'A' -- берем ошибки только на нашей стороне
          AND  Err.InsertDate BETWEEN inStartDate AND inEndDate
        ORDER BY Err.Id DESC;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 18.06.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_wms_from_host_error (inStartDate:= current_date, inEndDate:= current_timestamp)