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
  ParentId   Integer   ,
  CONSTRAINT fk_Movement_MovementDesc FOREIGN KEY (DescId)    REFERENCES MovementDesc (id),
  CONSTRAINT fk_Movement_StatusId FOREIGN KEY (StatusId)      REFERENCES Object (id),
  CONSTRAINT fk_Movement_ParentId FOREIGN KEY (ParentId)      REFERENCES Movement (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE Movement
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
