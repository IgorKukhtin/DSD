/*
  Создание 
    - таблицы Movement (перемещения)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE Movement;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Movement
(
  Id         serial    NOT NULL PRIMARY KEY,
  DescId     integer   NOT NULL,
  InvNumber  TVarChar          ,
  OperDate   TDateTime NOT NULL,
  StatusId   integer   NOT NULL,
  CONSTRAINT fk_Movement_MovementDesc FOREIGN KEY (DescId)  REFERENCES MovementDesc (id),
  CONSTRAINT fk_Movement_StatusId FOREIGN KEY (StatusId)      REFERENCES Object (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE Movement
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

-- Index: idx_Movement_All

-- DROP INDEX idx_Movement_All;

CREATE INDEX idx_Movement_All ON Movement(OperDate, DescId, StatusId, Id, InvNumber);



/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                           
19.09.02                                                       
*/
