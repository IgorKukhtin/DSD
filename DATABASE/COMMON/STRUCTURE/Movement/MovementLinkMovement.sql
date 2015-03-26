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

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_MovementLinkMovement_MovementId_DescId ON MovementLinkMovement (MovementId, DescId);
CREATE INDEX idx_MovementLinkMovement_MovementChildId_DescId ON MovementLinkMovement (MovementChildId, DescId);
CREATE INDEX idx_MovementLinkMovement_DescId ON MovementLinkMovement (DescId,MovementId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.03.2015                                       * add idx_MovementItemLinkObject_MovementItemId_DescId
12.02.14                        *           
*/
