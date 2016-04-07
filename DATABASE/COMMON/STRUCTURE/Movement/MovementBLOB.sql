/*
  Создание 
    - таблицы MovementBLOB (свойства объектов типа TBLOB)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementBLOB(
   DescId                INTEGER NOT NULL,
   MovementId              INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_MovementBLOB           PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementBLOB_DescId    FOREIGN KEY(DescId) REFERENCES MovementBLOBDesc(Id),
   CONSTRAINT fk_MovementBLOB_MovementId  FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_MovementBLOB_MovementId_DescId ON MovementBLOB (MovementId, DescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.


*/