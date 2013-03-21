/*
  Создание 
    - таблицы MovementFloat (свойства перемещений типа TFloat)
    - связи
    - индексов
*/

-- Table: "MovementFloat"

-- DROP TABLE MovementFloat;


/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementFloat(
  DescId integer NOT NULL,
  MovementId integer NOT NULL,
  Value TFloat NOT NULL,
  CONSTRAINT pk_MovementFloat PRIMARY KEY (DescId, MovementId),
  CONSTRAINT fk_MovementFloat_DescId FOREIGN KEY (DescId)
      REFERENCES MovementFloatDesc (Id),
  CONSTRAINT fk_MovementFloat_Movement FOREIGN KEY (MovementId)
      REFERENCES Movement (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementFloat
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


-- Index: "idx_MovementFloat_MovementId_DescId_Value"

-- DROP INDEX "idx_MovementFloat_MovementId_DescId_Value";

CREATE INDEX idx_MovementFloat_MovementId_DescId_Value ON MovementFloat(MovementId, DescId, Value);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
