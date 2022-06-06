/*
  Создание 
    - таблицы Log_CashRemains (промежуточная таблица )
    - связей
    - индексов
*/

-- DROP TABLE Log_CashRemains;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Log_CashRemains
(
  Id                serial    NOT NULL PRIMARY KEY,
  
  CashSessionId     TVarChar,   -- Сессия кассового места
  DateStart         TDateTime,  -- Дата выполнения
  DateEnd           TDateTime,  -- Дата последнего действия
  IP                TVarChar,   -- Внешний IP адрес

  FullRemains       Boolean,    -- Полное обновление остатков
  UserId            Integer,    -- Пользователь
  UnitId            Integer,    -- Подразделение
  RetailId          Integer,    -- Сеть

  OldProgram        Boolean,    -- Вход старой кассой
  OldServise        Boolean     -- Не обновлен сервис
 )
;

ALTER TABLE Log_CashRemains
  OWNER TO postgres;
 
-- ALTER TABLE Log_CashRemains ADD COLUMN IP                TVarChar

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
  20.10.18                                         *
  
                 
select CashSessionId, DateStart, FullRemains,
       OUser.objectcode, OUser.valuedata,
       OUnit.objectcode, OUnit.valuedata
from Log_CashRemains
     inner join Object As OUser on OUser.id = Log_CashRemains.UserId
     inner join Object As OUnit on OUnit.id = Log_CashRemains.UnitId
                 
*/