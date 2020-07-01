-- Function: gpSelect_wms_message_err()

DROP FUNCTION IF EXISTS gpSelect_wms_message_err (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpSelect_wms_message_err (
    IN inStartDate  TDateTime, -- левая граница временного интервала
    IN inEndDate    TDateTime  -- правая граница временного интервала
)
RETURNS TABLE (Id               Bigint, 
               Header_Id        Integer,  -- WMS.from_host_header_message.Id
               GUID             TVarChar, -- 
               ProcName         TVarChar, -- имя хр.процедуры
               TagName          TVarChar, -- имя пакета
               ActionName       TVarChar, -- действие (update/insert/delete)
               RowNum           Integer,  -- 
               RowData          Text,     -- 
               ObjectId         Integer,  -- 
               GroupId          Integer,  -- 
               Err_description  TVarChar, -- текст ошибки
               InsertDate       TDateTime -- дата вставки
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Msg.Id, Err.Header_Id, Msg.GUID, Msg.ProcName, Msg.TagName, Msg.ActionName, Msg.RowNum, Msg.RowData, Msg.ObjectId, Msg.GroupId, Err.description AS Err_description, Msg.InsertDate
        FROM  wms_message AS Msg 
            INNER JOIN wms_from_host_error AS Err ON Msg.Id = Err.wms_message_id
        WHERE Msg.InsertDate BETWEEN inStartDate AND inEndDate
        ORDER BY Msg.Id DESC;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 01.07.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_wms_message_err (inStartDate:= current_date, inEndDate:= current_timestamp)
