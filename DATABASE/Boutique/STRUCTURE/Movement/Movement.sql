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
  Id          SERIAL    NOT NULL PRIMARY KEY,
  DescId      Integer   NOT NULL,
  InvNumber   TVarChar  NOT NULL,
  OperDate    TDateTime NOT NULL,
  StatusId    Integer   NOT NULL,
  ParentId    Integer   ,
  AccessKeyId Integer   ,
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

/*                                  Индексы                                      */


CREATE INDEX idx_Movement_OperDate_DescId ON Movement(OperDate, DescId);
CREATE INDEX idx_Movement_ParentId ON Movement(ParentId); 
CREATE INDEX idx_Movement_StatusId ON Movement(StatusId); -- констрейнт
CREATE INDEX idx_Movement_DescId_InvNumber ON Movement(DescId, zfConvert_StringToNumber(InvNumber));


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/
