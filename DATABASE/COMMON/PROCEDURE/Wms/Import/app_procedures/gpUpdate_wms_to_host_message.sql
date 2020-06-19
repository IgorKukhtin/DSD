-- Function: gpUpdate_wms_to_host_message()

DROP FUNCTION IF EXISTS gpUpdate_wms_to_host_message (Integer);

CREATE OR REPLACE FUNCTION gpUpdate_wms_to_host_message (
    IN inHeader_Id       Integer  -- шапка в Oracle
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    UPDATE wms_to_host_message 
    SET    Error = TRUE 
    WHERE  Header_Id = inHeader_Id;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 19.06.20                                                          *              
*/

-- тест
-- SELECT gpUpdate_wms_to_host_message (inHeader_Id:= 1)