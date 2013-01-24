/*
  Создание 
    - таблицы ContainerDesc ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ContainerDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX ContainerDesc_Code ON ContainerDesc(Code);
CLUSTER ContainerDesc_Code ON ContainerDesc;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
01.07.02                                         
*/
