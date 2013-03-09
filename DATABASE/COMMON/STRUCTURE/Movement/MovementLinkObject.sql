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
  ParentMovementId integer NOT NULL,
  ChildObjectId integer NOT NULL,
  CONSTRAINT MovementLinkObject_PKey PRIMARY KEY (DescId, ParentMovementId),
  CONSTRAINT MovementLinkObject_DescId FOREIGN KEY (DescId)
      REFERENCES MovementLinkObjectDesc (Id),
  CONSTRAINT MovementLinkObject_Movement FOREIGN KEY (ParentMovementId)
      REFERENCES Movement (id),
  CONSTRAINT MovementLinkObject_Object FOREIGN KEY (ChildObjectId)
      REFERENCES Object (Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkObject
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


-- Index: "MovementLinkObject_All"

-- DROP INDEX "MovementLinkObject_All";

CREATE INDEX MovementLinkObject_All
  ON MovementLinkObject
  USING btree
  (DescId, ParentMovementId, ChildObjectId);

CLUSTER MovementLinkObject_All ON MovementLinkObject;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
