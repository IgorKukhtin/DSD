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
CREATE UNIQUE INDEX idx_MovementLinkObject_MovementId_DescId ON MovementLinkObject (MovementId, DescId);
CREATE INDEX idx_MovementLinkObject_ObjectId_DescId ON MovementLinkObject(ObjectId, DescId); -- для констрейнта

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.03.2015                                       * add idx_MovementItemLinkObject_MovementItemId_DescId
18.06.2013                                         
*/
