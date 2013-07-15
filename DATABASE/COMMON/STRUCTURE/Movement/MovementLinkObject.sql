/*
  Создание 
    - таблицы MovementLinkObject (связи между перемещениями и объектами)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

-- Table: "MovementLinkObject"

-- DROP TABLE MovementLinkObject;

CREATE TABLE MovementLinkObject
(
  DescId integer NOT NULL,
  MovementId integer NOT NULL,
  ObjectId integer,
  CONSTRAINT pk_MovementLinkObject PRIMARY KEY (MovementId, DescId),
  CONSTRAINT fk_MovementLinkObject_DescId FOREIGN KEY (DescId) REFERENCES MovementLinkObjectDesc (Id),
  CONSTRAINT fk_MovementLinkObject_Movement FOREIGN KEY (MovementId) REFERENCES Movement (id),
  CONSTRAINT fk_MovementLinkObject_Object FOREIGN KEY (ObjectId) REFERENCES Object (Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkObject
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


-- Index: "idx_MovementLinkObject_MovementId_DescId_ObjectId"

-- DROP INDEX "idx_MovementLinkObject_MovementId_DescId_ObjectId";

CREATE UNIQUE INDEX idx_MovementLinkObject_MovementId_DescId_ObjectId ON MovementLinkObject(MovementId, DescId, ObjectId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
