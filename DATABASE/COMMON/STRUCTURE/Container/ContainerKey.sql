/*
  Создание 
    - таблицы ContainerKey ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ContainerKey(
   ContainerId           INTEGER NOT NULL, 
   Key                   TVarChar NOT NULL, 

   CONSTRAINT pk_ContainerKey             PRIMARY KEY (ContainerId),
   CONSTRAINT fk_ContainerKey_ContainerId FOREIGN KEY (ContainerId) REFERENCES Container(Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_ContainerKey_Key_ContainerId ON ContainerKey (Key, ContainerId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
07.04.14                              *           
*/
