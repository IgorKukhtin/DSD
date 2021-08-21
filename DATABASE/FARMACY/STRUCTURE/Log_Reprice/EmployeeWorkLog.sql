/*
  Создание 
    - таблицы EmployeeWorkLog 
    - связей
    - индексов
*/

-- DROP TABLE EmployeeWorkLog;

-------------------------------------------------------------------------------
CREATE TABLE EmployeeWorkLog
(
  Id                serial    NOT NULL PRIMARY KEY,
  
  CashSessionId     TVarChar,   -- Сессия кассового места
  CashRegister      TVarChar,   -- Фискальный номер

  UserId            Integer,    -- Пользователь
  UnitId            Integer,    -- Подразделение
  RetailId          Integer,    -- Сеть

  DateLogIn         TDateTime,  -- Дата и время входа
  DateZReport       TDateTime,  -- Дата и время выполнения Z отчета
  DateLogOut        TDateTime,  -- Дата и время выхода

  OldProgram        Boolean,    -- Вход старой кассой
  OldServise        Boolean     -- Не обновлен сервис
 )
;

ALTER TABLE EmployeeWorkLog
  OWNER TO postgres;
 

-------------------------------------------------------------------------------



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
  13.01.19                                         *
  
                 
select CashSessionId, CashRegister, DateLogIn, DateZReport, DateLogOut,
       OUser.objectcode, OUser.valuedata,
       OUnit.objectcode, OUnit.valuedata
from EmployeeWorkLog
     inner join Object As OUser on OUser.id = EmployeeWorkLog.UserId
     inner join Object As OUnit on OUnit.id = EmployeeWorkLog.UnitId
LIMIT 10
                 
*/