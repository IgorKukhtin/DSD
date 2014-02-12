/*
  Создание 
    - таблицы MovementLinkMovement (связи между перемещениями и объектами)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

-- Table: "MovementLinkMovement"

-- DROP TABLE MovementLinkMovement;

CREATE TABLE MovementLinkMovement
(
  DescId integer NOT NULL,
  MovementId integer NOT NULL,
  MovementChildId integer,
  CONSTRAINT pk_MovementLinkMovement PRIMARY KEY (MovementId, DescId),
  CONSTRAINT fk_MovementLinkMovement_DescId FOREIGN KEY (DescId) REFERENCES MovementLinkMovementDesc (Id),
  CONSTRAINT fk_MovementLinkMovement_Movement FOREIGN KEY (MovementId) REFERENCES Movement (id),
  CONSTRAINT fk_MovementLinkMovement_MovementChild FOREIGN KEY (MovementChildId) REFERENCES Movement (Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkMovement
  OWNER TO postgres;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
12.02.14                              *           
*/
