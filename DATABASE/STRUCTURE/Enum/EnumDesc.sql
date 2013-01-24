/*
  Создание 
    - таблицы EnumDesc (классы перечислимые типы)
    - связи
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE EnumDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar);


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX EnumDesc_Code ON EnumDesc(Code);

CLUSTER EnumDesc_Code ON EnumDesc 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
13.06.02                                              
*/
