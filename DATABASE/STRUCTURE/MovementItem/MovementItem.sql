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
   isErased     TVarChar,

   CONSTRAINT MovementItem_DescId FOREIGN KEY(DescId) REFERENCES MovementDesc(Id),
   CONSTRAINT MovementItem_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT MovementItem_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id)   
)

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */




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
