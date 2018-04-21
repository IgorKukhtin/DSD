/*
  Создание 
    - таблицы Log_Reprice (промежуточная таблица )
    - связей
    - индексов
*/

-- DROP TABLE Log_Reprice;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Log_Reprice
(
  Id            serial    NOT NULL PRIMARY KEY,
  InsertDate	TDateTime, -- Дата/время 
  StartDate	TDateTime, -- Дата/время 
  EndDate	TDateTime, -- Дата/время
  MovementId	Integer  , -- 
  UserId	Integer  , -- 
  TextValue	TVarChar   -- 
  
 )
;

ALTER TABLE Log_Reprice
  OWNER TO postgres;
 
CREATE INDEX idx_Log_Reprice_InsertDate ON Log_Reprice (InsertDate); 
CREATE INDEX idx_Log_Reprice_UserId_InsertDate ON Log_Reprice (UserId,InsertDate); 


/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
