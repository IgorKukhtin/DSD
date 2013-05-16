/*
  Создание 
    - таблицы MovementItem (перемещения)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItem(
   Id           SERIAL NOT NULL PRIMARY KEY, 
   DescId       INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ObjectId     INTEGER,
   Amount       TFloat, 
   isErased     Boolean NOT NULL DEFAULT false,
   ParentId     Integer,

   CONSTRAINT fk_MovementItem_DescId FOREIGN KEY(DescId) REFERENCES MovementItemDesc(Id),
   CONSTRAINT fk_MovementItem_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItem_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id),
   CONSTRAINT fk_MovementItem_ParentId FOREIGN KEY(ParentId) REFERENCES MovementItem(Id)      
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementItem_MovementId ON MovementItem (MovementId);

CLUSTER idx_MovementItem_MovementId ON MovementItem;



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
