/*
  Создание 
    - таблицы MovementItemLinkObject (связи между перемещениями и объектами)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

-- Table: "MovementItemLinkObject"

-- DROP TABLE MovementItemLinkObject;

CREATE TABLE MovementItemLinkObject
(
  DescId integer NOT NULL,
  MovementItemId integer NOT NULL,
  ObjectId integer,
  CONSTRAINT pk_MovementItemLinkObject PRIMARY KEY (MovementItemId, DescId),
  CONSTRAINT fk_MovementItemLinkObject_DescId FOREIGN KEY (DescId) REFERENCES MovementItemLinkObjectDesc (Id),
  CONSTRAINT fk_MovementItemLinkObject_MovementItem FOREIGN KEY (MovementItemId) REFERENCES MovementItem (id),
  CONSTRAINT fk_MovementItemLinkObject_Object FOREIGN KEY (ObjectId) REFERENCES Object (Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementItemLinkObject
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


-- Index: "idx_MovementItemLinkObject_MovementItemId_DescId_ObjectId"

-- DROP INDEX "idx_MovementItemLinkObject_MovementItemId_DescId_ObjectId";

CREATE UNIQUE INDEX idx_MovementItemLinkObject_MovementItemId_DescId_ObjectId ON MovementItemLinkObject(MovementItemId, DescId, ObjectId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
