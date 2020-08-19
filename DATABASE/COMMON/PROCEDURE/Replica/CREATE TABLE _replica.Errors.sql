/*
  Создание
    - таблицы _replica.Errors

*/

-- DROP TABLE _replica.Errors;


/*-------------------------------------------------------------------------------*/
CREATE TABLE _replica.Errors
    (
    Id             SERIAL   NOT NULL PRIMARY KEY,
    Start_Id       Integer  NOT NULL, -- начальный ID пакета
    Last_Id        Integer  NOT NULL, -- конечный ID пакета
    Client_Id      Bigint   NOT NULL, -- slave._replica.Settings.Client_Id
    Description    Text,              -- текст ошибки
    InsertDate     TDateTime DEFAULT CLOCK_TIMESTAMP()
);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 17.08.20                                                           *
*/