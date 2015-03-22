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

-- CREATE UNIQUE INDEX idx_MovementItemLinkObject_MovementItemId_DescId_ObjectId ON MovementItemLinkObject(MovementItemId, DescId, ObjectId);
CREATE INDEX idx_MovementItemLinkObject_ObjectId ON MovementItemLinkObject(ObjectId); -- для констрейнта

CREATE UNIQUE INDEX idx_MovementItemLinkObject_MovementItemId_DescId ON MovementItemLinkObject (MovementItemId, DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.03.2015                                       * add idx_MovementItemLinkObject_MovementItemId_DescId
22.03.2015                                       * drop idx_MovementItemLinkObject_MovementItemId_DescId_ObjectId
18.06.2013                                         
*/
