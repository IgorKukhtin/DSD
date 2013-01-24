/*
  Создание 
    - таблицы ContainerLinkObject ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerLinkObject(
   ContainerId           INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,

   CONSTRAINT ContainerLinkObject_PK PRIMARY KEY (ObjectId, ContainerId),
   CONSTRAINT ContainerLinkObject_Container FOREIGN KEY (ContainerId)  REFERENCES Container (Id),
   CONSTRAINT ContainerLinkObject_Object FOREIGN KEY (ObjectId) REFERENCES Object (Id));


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/