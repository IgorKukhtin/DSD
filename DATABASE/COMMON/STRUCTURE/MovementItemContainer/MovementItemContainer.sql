/*
  Создание 
    - таблицы MovementItemContainer (перемещения)
    - связей
    - индексов
*/
/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemContainer(
   Id             SERIAL NOT NULL PRIMARY KEY, 
   DescId         INTEGER,
   MovementId     INTEGER,
   ContainerId    INTEGER,
   Amount         TFloat, 
   OperDate       TDateTime,
   isErased       TVarChar,
   ParentId       Integer,
   MovementItemId Integer,

   CONSTRAINT MovementItemContainer_DescId FOREIGN KEY(DescId) REFERENCES MovementItemContainerDesc(Id),
   CONSTRAINT MovementItemContainer_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT MovementItemContainer_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id),
   CONSTRAINT MovementItemContainer_MovementItemId FOREIGN KEY (MovementItemId) REFERENCES MovementItem(id),
   CONSTRAINT MovementItemContainer_ParentId FOREIGN KEY (ParentId) REFERENCES MovementItemContainer(id)
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
