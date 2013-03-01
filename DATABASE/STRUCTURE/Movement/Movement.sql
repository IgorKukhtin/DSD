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
  Id serial NOT NULL,
  DescId integer,
  InvNumber TVarChar,
  OperData TDateTime,
  Status integer,
  isErased boolean,
  CONSTRAINT Movement_PKey PRIMARY KEY (Id),
  CONSTRAINT Movement_MovementDesc FOREIGN KEY (DescId)  REFERENCES MovementDesc (id),
  CONSTRAINT Movement_StatusId FOREIGN KEY (Status)      REFERENCES Enum (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE Movement
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

-- Index: Movement_OperDate_DescId

-- DROP INDEX Movement_OperDate_DescId;

CREATE INDEX Movement_OperDate_DescId
  ON Movement
  USING btree
  (OperData, DescId);

CLUSTER Movement_OperDate_DescId ON Movement;


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
