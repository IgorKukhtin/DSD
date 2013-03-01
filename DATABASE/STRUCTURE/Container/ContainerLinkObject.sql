/*
  Создание 
    - таблицы ContainerLinkObject ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerLinkObject(
   DescId                INTEGER NOT NULL,
   ContainerId           INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,

   CONSTRAINT ContainerLinkObject_PK PRIMARY KEY (DescId, ObjectId, ContainerId),
   CONSTRAINT ContainerLinkObject_Container FOREIGN KEY (ContainerId)  REFERENCES Container (Id),
   CONSTRAINT ContainerLinkObject_Object FOREIGN KEY (ObjectId) REFERENCES Object (Id),
   CONSTRAINT ContainerLinkObject_Desc FOREIGN KEY (DescId) REFERENCES ContainerLinkObjectDesc (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CLUSTER ContainerLinkObject_PK ON ContainerLinkObject;
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/