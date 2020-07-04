-- Function: gpSelect_wms_to_host_error()

DROP FUNCTION IF EXISTS gpSelect_wms_to_host_error (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpSelect_wms_to_host_error (
    IN inStartDate  TDateTime, -- левая граница временного интервала
    IN inEndDate    TDateTime  -- правая граница временного интервала
)
RETURNS TABLE (--Site         TVarChar,  -- к какой базе данных относится ошибка. Ожидаются значения 'A' или 'W' ('A' -> ALAN    'W' -> WMS)
               Header_id    Integer,   -- шапка в Oracle
               Type         TVarChar,  -- название пакета -> WMS to_host_header_message.Type
               Name         TVarChar,  -- имя груза
               Qty          TVarChar,  -- Кол-во, используется только когда Шт
               Weight       TVarChar,  -- Вес, используется только когда НЕ Шт
               Operdate     TDateTime, -- Дата, время когда документ проведен в WMS, т.е. в Oracle это from_host_header_message.CREATED 
               --Done         Boolean,   -- статус "выполнено\невыполнено"
               --Error        Boolean,   -- статус "есть ошибка\ без ошибок"
               Description  TVarChar,  -- текст ошибки
               InsertDate   TDateTime  -- дата вставки записи
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Err.Header_id, Err.Type, Msg.Name, Msg.Qty, Msg.Weight, Msg.Operdate, Err.Description, Err.InsertDate
        FROM wms_to_host_error AS Err 
          LEFT JOIN wms_to_host_message AS Msg ON Err.Header_id = Msg.Header_id
        WHERE Err.Site = 'A' -- берем ошибки только на нашей стороне
          AND Err.InsertDate BETWEEN inStartDate AND inEndDate
          AND (Msg.Done = FALSE OR Msg.Done IS NULL) 
          AND (Msg.Error = TRUE OR Msg.Error IS NULL) 
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
-- SELECT * FROM gpSelect_wms_to_host_error (inStartDate:= current_date, inEndDate:= current_timestamp)