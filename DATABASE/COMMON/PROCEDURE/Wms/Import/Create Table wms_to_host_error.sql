/*
  Создание
    - таблицы wms_to_host_error

*/

-- DROP TABLE wms_to_host_error;


/*-------------------------------------------------------------------------------*/
CREATE TABLE wms_to_host_error
    (
    Id               SERIAL   NOT NULL PRIMARY KEY,
    Header_Id        Integer  NOT NULL, -- шапка в Oracle
    Site             TVarChar NOT NULL, -- к какой базе данных относится ошибка. Ожидаются значения 'A' или 'W' ('A' -> ALAN    'W' -> WMS)
    Type             TVarChar NOT NULL, -- название пакета -> WMS to_host_header_message.Type
    Description      TVarChar,          -- текст ошибки
    InsertDate       TDateTime DEFAULT CLOCK_TIMESTAMP()
);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 10.06.20                                                           *
*/