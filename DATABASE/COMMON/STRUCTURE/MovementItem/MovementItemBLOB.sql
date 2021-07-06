/*
  Создание 
    - таблицы MovementItemBLOB (свойства объектов типа TBLOB)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemBLOB(
   DescId                INTEGER NOT NULL,
   MovementItemId        INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_MovementItemBLOB                 PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemBLOB_DescId          FOREIGN KEY (DescId) REFERENCES MovementItemBLOBDesc(Id),
   CONSTRAINT fk_MovementItemBLOB_MovementItemId  FOREIGN KEY (MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_MovementItemBLOB_MovementItemId_DescId ON MovementItemBLOB (MovementItemId, DescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  Шаблий Щ.В. 
 27.06.13                                         *

*/