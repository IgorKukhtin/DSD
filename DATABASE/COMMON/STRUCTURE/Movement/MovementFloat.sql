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
  CONSTRAINT MovementFloat_PKey PRIMARY KEY (DescId, MovementId),
  CONSTRAINT MovementFloat_DescId FOREIGN KEY (DescId)
      REFERENCES MovementFloatDesc (Id),
  CONSTRAINT MovementFloat_Movement FOREIGN KEY (MovementId)
      REFERENCES Movement (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementFloat
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


-- Index: "MovementFloat_All"

-- DROP INDEX "MovementFloat_All";

CREATE INDEX MovementFloat_All
  ON MovementFloat
  USING btree
  (DescId, MovementId, Value);

CLUSTER MovementFloat_All ON MovementFloat;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
