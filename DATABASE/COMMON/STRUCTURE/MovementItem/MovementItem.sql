/*
  Создание 
    - таблицы MovementItem (перемещения)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItem(
   Id           SERIAL NOT NULL PRIMARY KEY, 
   DescId       INTEGER,
   MovementId   INTEGER,
   ContainerId  INTEGER,
   Amount       TFloat, 
   isErased     Boolean NOT NULL DEFAULT false,

   CONSTRAINT fk_MovementItem_DescId FOREIGN KEY(DescId) REFERENCES MovementDesc(Id),
   CONSTRAINT fk_MovementItem_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItem_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id)   
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementItem_MovementId_DescId_isErased ON MovementItem (MovementId, DescId, isErased);

CLUSTER idx_MovementItem_MovementId_DescId_isErased ON MovementItem;



/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                           
19.09.02                                                       
*/
