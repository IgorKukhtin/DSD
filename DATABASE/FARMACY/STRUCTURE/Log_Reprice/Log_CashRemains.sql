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
  
  CashSessionId     TVarChar, 
  DateStart         TDateTime, 
  FullRemains       Boolean, 
  UserId            Integer, 
  UnitId            Integer, 
  RetailId          Integer,
  OldProgram        Boolean, 
  OldServise        Boolean
 )
;

ALTER TABLE Log_CashRemains
  OWNER TO postgres;
 


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
