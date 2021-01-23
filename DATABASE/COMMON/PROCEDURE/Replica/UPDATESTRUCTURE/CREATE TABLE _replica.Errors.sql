/*
  Создание
    - таблицы _replica.Errors

*/

-- DROP TABLE _replica.Errors;


/*-------------------------------------------------------------------------------*/
CREATE TABLE IF NOT EXISTS _replica.Errors
    (
    Id             BigSerial   NOT NULL PRIMARY KEY,
    Step           Integer  NOT NULL, -- шаг, на котором возникла ошибка (1,2 или 3) 
    Start_Id       BigInt   NOT NULL, -- начальный ID пакета
    Last_Id        BigInt   NOT NULL, -- конечный ID пакета
    Client_Id      Bigint   NOT NULL, -- slave._replica.Settings.Client_Id
    Description    Text,              -- текст ошибки
    InsertDate     TDateTime DEFAULT CLOCK_TIMESTAMP()
);


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 17.08.20                                                           *
*/