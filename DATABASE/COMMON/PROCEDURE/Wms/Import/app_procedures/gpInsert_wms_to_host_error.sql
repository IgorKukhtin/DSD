-- Function: gpInsert_wms_to_host_error()

DROP FUNCTION IF EXISTS gpInsert_wms_to_host_error (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_wms_to_host_error (
    IN inHeader_Id       Integer,  -- шапка в Oracle
    IN inSite            TVarChar, -- к какой базе данных относится ошибка. Ожидаются значения 'A' или 'W' ('A' -> ALAN    'W' -> WMS)
    IN inPacketName      TVarChar, -- имя пакета импорта, например, 'order_status_changed'
    IN inErrDescription  TVarChar  -- текст ошибки
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    INSERT INTO wms_to_host_error
           (Header_Id,   Site,    Type,         Description) 
    VALUES (inHeader_Id, inSite, inPacketName,  inErrDescription);
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 19.06.20                                                          *              
*/

-- тест
-- SELECT gpInsert_wms_to_host_error (inHeader_Id:= 1, inSite:= 'A', inPacketName:= 'order_status_changed', inErrDescription:= 'test error')