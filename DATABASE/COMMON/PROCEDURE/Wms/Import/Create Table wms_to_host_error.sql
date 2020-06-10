/*
  Создание
    - таблицы wms_to_host_error

*/

-- DROP TABLE wms_to_host_error;


/*-------------------------------------------------------------------------------*/
CREATE TABLE wms_to_host_error
    (
    Id               SERIAL   NOT NULL PRIMARY KEY,
    Site             TVarChar NOT NULL, -- к какой базе данных относится ошибка. Ожидаются значения 'A' или 'W' ('A' -> ALAN    'W' -> WMS)
    ProcName         TVarChar,          -- имя процедуры, в которой возникла ошибка
    Description      TVarChar,          -- текст ошибки
    InsertDate       TDateTime DEFAULT CLOCK_TIMESTAMP()
);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 10.06.20                                                           *
*/